package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.Arrays;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.inputmethodservice.Keyboard;
import android.inputmethodservice.KeyboardView;
import android.inputmethodservice.KeyboardView.OnKeyboardActionListener;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TableLayout;
import android.widget.TableRow;

public class WritePostcardActivity extends ActionBarActivity {
  private int[] imageViewId = {R.id.imageview_write_postcard1, R.id.imageview_write_postcard2,
      R.id.imageview_write_postcard3, R.id.imageview_write_postcard4,
      R.id.imageview_write_postcard5, R.id.imageview_write_postcard6,
      R.id.imageview_write_postcard7, R.id.imageview_write_postcard8,
      R.id.imageview_write_postcard9, R.id.imageview_write_postcard10,
      R.id.imageview_write_postcard11, R.id.imageview_write_postcard12,
      R.id.imageview_write_postcard13, R.id.imageview_write_postcard14,
      R.id.imageview_write_postcard15, R.id.imageview_write_postcard16,
      R.id.imageview_write_postcard17, R.id.imageview_write_postcard18,
      R.id.imageview_write_postcard19, R.id.imageview_write_postcard20,
      R.id.imageview_write_postcard21, R.id.imageview_write_postcard22,
      R.id.imageview_write_postcard23, R.id.imageview_write_postcard24,
      R.id.imageview_write_postcard25, R.id.imageview_write_postcard26,
      R.id.imageview_write_postcard27, R.id.imageview_write_postcard28,
      R.id.imageview_write_postcard29, R.id.imageview_write_postcard30,
      R.id.imageview_write_postcard31, R.id.imageview_write_postcard32,
      R.id.imageview_write_postcard33, R.id.imageview_write_postcard34,
      R.id.imageview_write_postcard35, R.id.imageview_write_postcard36,
      R.id.imageview_write_postcard37, R.id.imageview_write_postcard38,
      R.id.imageview_write_postcard39, R.id.imageview_write_postcard40,
      R.id.imageview_write_postcard41, R.id.imageview_write_postcard42,};
  private static final int[] customKeyboard = {R.xml.finnish_swedish, R.xml.danish_norwegian,
      R.xml.english_portugese, R.xml.german, R.xml.spanish, R.xml.russian, R.xml.latvian};
  private int index;
  private char[] postcardText;
  private KeyboardView keyboardView;
  private MenuItem saved;
  private SharedPreferences mSharedPreferences;
  private String currentAlphabet;
  private String currentLanguage;
  private int width;
  private int height;
  private int padding;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_write_postcard);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    currentLanguage = mSharedPreferences.getString("currentLanguage", "");
    width = mSharedPreferences.getInt("imageViewWidth", 0);
    height = mSharedPreferences.getInt("imageViewHeight", 0);
    padding = mSharedPreferences.getInt("imageViewExtra", 0);
    saved = null;
    postcardText = new char[42];
    // Create the Keyboard
    Keyboard keyboard =
        new Keyboard(WritePostcardActivity.this, customKeyboard[Arrays
            .asList(MainActivity.LANGUAGE).indexOf(currentLanguage)]);
    // Lookup the KeyboardView
    keyboardView = (KeyboardView) findViewById(R.id.keyboardview);
    // Attach the keyboard to the view
    keyboardView.setKeyboard(keyboard);
    // Do not show the preview balloons
    keyboardView.setPreviewEnabled(false);
    keyboardView.setOnKeyboardActionListener(onKeyboardActionListener);
    // Set ImageView dimensions
    setImageViewDimensions();
    resetPostcard();
  }

  private void setImageViewDimensions() {
    for (int i = 0; i < 42; i++) {
      ImageView iv = (ImageView) findViewById(imageViewId[i]);
      TableRow.LayoutParams parms =
          new TableRow.LayoutParams(width + 2 * padding, height + 2 * padding);
      iv.setLayoutParams(parms);
      iv.setPadding(padding, padding, padding, padding);
    }
  }

  private void hideCustomKeyboard() {
    keyboardView.setVisibility(View.GONE);
    keyboardView.setEnabled(false);
  }

  public void showCustomKeyboard() {
    keyboardView.setVisibility(View.VISIBLE);
    keyboardView.setEnabled(true);
  }

  private void showLetter(int key) {
    ImageView imageView = (ImageView) findViewById(imageViewId[index]);
    new BitmapWorkerTask(imageView).execute(key);
    index++;
  }

  private void showBlank(boolean bkspace) {
    if (bkspace && index == 0)
      return;
    else if (bkspace)
      index--;
    ImageView imageView = (ImageView) findViewById(imageViewId[index]);
    imageView.setBackgroundResource(R.color.White);
    imageView.setImageResource(R.color.White);
    if (!bkspace)
      index++;
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.write_postcard, menu);
    return true;
  }

  @SuppressLint("NewApi")
  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.item_wp_share_postcard: {
        /*
         * Copy table layout to bitmap
         */
        TableLayout tableLayout = (TableLayout) findViewById(R.id.tablelayout_write_postcard);
        Bitmap postcard =
            Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(postcard);
        tableLayout.draw(canvas);
        new SaveBitmap().execute(postcard);
        Intent share = new Intent(this, ShareActivity.class);
        share.putExtra("sharingWhat", "Postcard");
        startActivity(share);
        return true;
      }
      case R.id.item_wp_save_postcard: {
        /*
         * Copy table layout to bitmap
         */
        TableLayout tableLayout = (TableLayout) findViewById(R.id.tablelayout_write_postcard);
        Bitmap postcard =
            Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(postcard);
        tableLayout.draw(canvas);
        new SaveAndSchedule().execute(postcard);
        return true;
      }
      case R.id.item_wp_write_postcard: {
        resetPostcard();
        return true;
      }
      case R.id.item_wp_my_alphabets: {
        Intent myAlphabetsIntent = new Intent(this, MyAlphabetsActivity.class);
        startActivity(myAlphabetsIntent);
        finish();
        return true;
      }
      default:
        return super.onContextItemSelected(item);
    }
  }

  public void onResume() {
    super.onResume();
    String username = mSharedPreferences.getString("username", "");
    if (saved != null && username.equals("")) {
      saved = null;
      onOptionsItemSelected(saved);
    } else
      saved = null;
  }

  private void resetPostcard() {
    index = 0;
    setBlank();
    showCustomKeyboard();
  }

  private void setBlank() {
    for (int i = 0; i < 42; i++) {
      ImageView imageView = (ImageView) findViewById(imageViewId[i]);
      imageView.setBackgroundResource(R.color.White);
      imageView.setImageResource(R.color.White);
    }
  }

  public void showMenu(View v) {
    openOptionsMenu();
  }

  public void takePhoto(View v) {
    Intent takePhotoIntent = new Intent(this, TakePhotoActivity.class);
    startActivity(takePhotoIntent);
  }

  public void showAbc(View v) {
    finish();
  }

  @Override
  public void onBackPressed() {
    if (isCustomKeyboardVisible())
      hideCustomKeyboard();
    else
      super.onBackPressed();
  }

  private boolean isCustomKeyboardVisible() {
    return keyboardView.getVisibility() == View.VISIBLE;
  }

  private OnKeyboardActionListener onKeyboardActionListener = new OnKeyboardActionListener() {
    @Override
    public void onKey(int primaryCode, int[] keyCodes) {

      if (primaryCode == -1)
        return;
      else if (primaryCode == 42) {
        postcardText[index] = ' ';
        showBlank(false);
      } else if (primaryCode == 43)
        showBlank(true);
      else if (primaryCode == 44)
        hideCustomKeyboard();
      else if (primaryCode == 315) {
        showLetter(18); // LatvL
        postcardText[index] =
            MainActivity.LETTER[Arrays.asList(MainActivity.LANGUAGE).indexOf(currentLanguage)][18];
      } else {
        postcardText[index] =
            MainActivity.LETTER[Arrays.asList(MainActivity.LANGUAGE).indexOf(currentLanguage)][primaryCode];
        showLetter(primaryCode);
      }
    }

    @Override
    public void onPress(int arg0) {}

    @Override
    public void onRelease(int primaryCode) {}

    @Override
    public void onText(CharSequence text) {}

    @Override
    public void swipeDown() {}

    @Override
    public void swipeLeft() {}

    @Override
    public void swipeRight() {}

    @Override
    public void swipeUp() {}
  };

  class SaveBitmap extends AsyncTask<Bitmap, Void, Void> {

    @Override
    protected Void doInBackground(Bitmap... params) {
      Bitmap bitmap = (Bitmap) params[0];
      String filename =
          (String) android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss",
              new java.util.Date());
      filename = "share";
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets" + File.separator + filename + ".png");
      FileOutputStream fos = null;
      try {
        fos = new FileOutputStream(file);
      } catch (FileNotFoundException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      bitmap.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      try {
        fos.close();
      } catch (IOException ex) {
        Log.d("MainActivty", ex.getMessage());
      }

      // Adding to gallery
      ContentValues image = new ContentValues();
      image.put(Images.Media.DATA, file.getAbsolutePath());
      getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
      return null;
    }
  }

  class SaveAndSchedule extends AsyncTask<Bitmap, Void, Void> {
    @Override
    protected Void doInBackground(Bitmap... params) {
      /*
       * Save
       */
      Bitmap bitmap = (Bitmap) params[0];
      String filename =
          (String) android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss",
              new java.util.Date());
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets" + File.separator + filename + ".png");
      FileOutputStream fos = null;
      try {
        fos = new FileOutputStream(file);
      } catch (FileNotFoundException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      bitmap.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      try {
        fos.close();
      } catch (IOException ex) {
        Log.d("MainActivty", ex.getMessage());
      }

      // Adding to gallery
      ContentValues image = new ContentValues();
      image.put(Images.Media.DATA, file.getAbsolutePath());
      getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);

      /*
       * Schedule
       */
      SQLiteDatabase database = null;
      try {
        database =
            getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
      } catch (SQLiteException ex) {
        Log.d("MainActivity", ex.getMessage());
      }

      ContentValues entry = new ContentValues();
      entry.put("lng", mSharedPreferences.getString("longitude", ""));
      entry.put("lat", mSharedPreferences.getString("latitude", ""));
      entry.put("letter", "no");
      entry.put("postcard", "yes");
      entry.put("alphabet", "no");
      entry.put("pText", new String(postcardText, 0, index));
      entry.put("lang", currentLanguage);
      entry.put("path", filename);

      try {
        database.insert("updates", null, entry);
      } catch (SQLiteException ex) {
        Log.d("MainActivity", ex.getMessage());
      }

      database.close();
      return null;
    }
  }

  class BitmapWorkerTask extends AsyncTask<Integer, Void, Bitmap> {
    private final WeakReference<ImageView> imageViewReference;

    public BitmapWorkerTask(ImageView imageView) {
      imageViewReference = new WeakReference<ImageView>(imageView);
    }

    public int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
      // Raw height and width of image
      final int height = options.outHeight;
      final int width = options.outWidth;
      int inSampleSize = 1;

      if (height > reqHeight || width > reqWidth) {

        final int halfHeight = height / 2;
        final int halfWidth = width / 2;

        // Calculate the largest inSampleSize value that is a power of 2 and keeps both
        // height and width larger than the requested height and width.
        while ((halfHeight / inSampleSize) > reqHeight && (halfWidth / inSampleSize) > reqWidth) {
          inSampleSize *= 2;
        }
      }
      Log.d("Dim", Integer.toString(inSampleSize));
      return inSampleSize;
    }

    public Bitmap decodeSampledBitmapFromResource(Resources res, int index, int reqWidth,
        int reqHeight) {
      String path = null;
      int resId =
          MainActivity.RESOURCERAWINDEX[Arrays.asList(MainActivity.LANGUAGE).indexOf(
              currentLanguage)][index];
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets"
                  + File.separator
                  + currentAlphabet
                  + "_"
                  + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                      currentLanguage)][index] + ".png");
      if (file.exists())
        path = file.getAbsolutePath();

      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      if (path != null)
        BitmapFactory.decodeFile(path, options);
      else
        BitmapFactory.decodeResource(res, resId, options);

      // Calculate inSampleSize
      options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);

      // Decode bitmap with inSampleSize set
      options.inJustDecodeBounds = false;
      if (path != null)
        return BitmapFactory.decodeFile(path, options);
      return BitmapFactory.decodeResource(res, resId, options);
    }

    @Override
    protected Bitmap doInBackground(Integer... params) {
      int data = params[0];
      return decodeSampledBitmapFromResource(getResources(), data, width, height);
    }

    @Override
    protected void onPostExecute(Bitmap bitmap) {
      if (imageViewReference != null && bitmap != null) {
        final ImageView imageView = imageViewReference.get();
        if (imageView != null) {
          imageView.setBackgroundResource(R.color.LightGrey);
          imageView.setImageBitmap(bitmap);
        }
      }
    }
  }
}
