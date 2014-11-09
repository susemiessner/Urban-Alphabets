package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.Arrays;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.drawable.ColorDrawable;
import android.inputmethodservice.Keyboard;
import android.inputmethodservice.KeyboardView;
import android.inputmethodservice.KeyboardView.OnKeyboardActionListener;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

public class WritePostcardActivity extends Activity {

  private int[] mImageViewId = {R.id.imageView_write_postcard1, R.id.imageView_write_postcard2,
      R.id.imageView_write_postcard3, R.id.imageView_write_postcard4,
      R.id.imageView_write_postcard5, R.id.imageView_write_postcard6,
      R.id.imageView_write_postcard7, R.id.imageView_write_postcard8,
      R.id.imageView_write_postcard9, R.id.imageView_write_postcard10,
      R.id.imageView_write_postcard11, R.id.imageView_write_postcard12,
      R.id.imageView_write_postcard13, R.id.imageView_write_postcard14,
      R.id.imageView_write_postcard15, R.id.imageView_write_postcard16,
      R.id.imageView_write_postcard17, R.id.imageView_write_postcard18,
      R.id.imageView_write_postcard19, R.id.imageView_write_postcard20,
      R.id.imageView_write_postcard21, R.id.imageView_write_postcard22,
      R.id.imageView_write_postcard23, R.id.imageView_write_postcard24,
      R.id.imageView_write_postcard25, R.id.imageView_write_postcard26,
      R.id.imageView_write_postcard27, R.id.imageView_write_postcard28,
      R.id.imageView_write_postcard29, R.id.imageView_write_postcard30,
      R.id.imageView_write_postcard31, R.id.imageView_write_postcard32,
      R.id.imageView_write_postcard33, R.id.imageView_write_postcard34,
      R.id.imageView_write_postcard35, R.id.imageView_write_postcard36,
      R.id.imageView_write_postcard37, R.id.imageView_write_postcard38,
      R.id.imageView_write_postcard39, R.id.imageView_write_postcard40,
      R.id.imageView_write_postcard41, R.id.imageView_write_postcard42};
  private static final int[] mCustomKeyboard = {R.xml.finnish_swedish, R.xml.danish_norwegian,
      R.xml.english_portugese, R.xml.german, R.xml.spanish, R.xml.russian, R.xml.latvian};
  private int mIndex;
  private char[] mPostcardText;
  private KeyboardView mKeyboardView;
  private SharedPreferences mSharedPreferences;
  private String mAlphabet;
  private String mLanguage;
  private int mWidth;
  private int mHeight;
  private int mPadding;
  private boolean mBottom = true;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_write_postcard);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    mLanguage = mSharedPreferences.getString("currentLanguage", "");
    mWidth = mSharedPreferences.getInt("imageViewWidth", 0);
    mHeight = mSharedPreferences.getInt("imageViewHeight", 0);
    mPadding = mSharedPreferences.getInt("imageViewExtra", 0);
    mPostcardText = new char[42];
    // Create the Keyboard
    Keyboard keyboard =
        new Keyboard(WritePostcardActivity.this, mCustomKeyboard[Arrays.asList(
            MainActivity.LANGUAGE).indexOf(mLanguage)]);
    // Lookup the KeyboardView
    mKeyboardView = (KeyboardView) findViewById(R.id.keyboardView);
    // Attach the keyboard to the view
    mKeyboardView.setKeyboard(keyboard);
    // Do not show the preview balloons
    mKeyboardView.setPreviewEnabled(false);
    mKeyboardView.setOnKeyboardActionListener(onKeyboardActionListener);
    // Set ImageView dimensions
    // Set ImageView dimensions
    setImageViews();
    resetPostcard();
  }

  private void setImageViews() {
    for (int i = 0; i < 42; i++) {
      ImageView iv = (ImageView) findViewById(mImageViewId[i]);
      TableRow.LayoutParams parms =
          new TableRow.LayoutParams(mWidth + 2 * mPadding, mHeight + 2 * mPadding);
      iv.setLayoutParams(parms);
      iv.setPadding(mPadding, mPadding, mPadding, mPadding);
    }
  }

  private void hideCustomKeyboard() {
    mKeyboardView.setVisibility(View.GONE);
    mKeyboardView.setEnabled(false);
  }

  public void showCustomKeyboard() {
    mKeyboardView.setVisibility(View.VISIBLE);
    mKeyboardView.setEnabled(true);
  }

  private void showLetter(int key) {
    ImageView imageView = (ImageView) findViewById(mImageViewId[mIndex]);
    new BitmapWorkerTask(imageView).execute(key);
    mIndex++;
  }

  private void showBlank(boolean bkspace) {
    if (bkspace && mIndex == 0)
      return;
    else if (bkspace)
      mIndex--;
    ImageView imageView = (ImageView) findViewById(mImageViewId[mIndex]);
    imageView.setBackgroundColor(0x000000);
    imageView.setImageDrawable(new ColorDrawable(0x000000));
    if (!bkspace)
      mIndex++;
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.write_postcard, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.item_wp_share_postcard:
        new SharePostcard().execute();
        return true;
      case R.id.item_wp_save_postcard:
        new SaveAndSchedule().execute();
        return true;
      case R.id.item_wp_write_postcard:
        resetPostcard();
        return true;
      case R.id.item_wp_my_alphabets:
        Intent myAlphabetsIntent = new Intent(this, MyAlphabetsActivity.class);
        startActivity(myAlphabetsIntent);
        finish();
        return true;
      default:
        return super.onContextItemSelected(item);
    }
  }

  private void resetPostcard() {
    mIndex = 0;
    setBlank();
    showCustomKeyboard();
  }

  private void setBlank() {
    for (int i = 0; i < 42; i++) {
      ImageView imageView = (ImageView) findViewById(mImageViewId[i]);
      imageView.setBackgroundColor(0x000000);
      imageView.setImageDrawable(new ColorDrawable(0x000000));
    }
  }

  public void showMenu(View v) {
    openOptionsMenu();
  }

  public void takePhoto(View v) {
    Intent takePhotoIntent = new Intent(this, TakePhotoActivity.class);
    startActivity(takePhotoIntent);
    finish();
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
    return mKeyboardView.getVisibility() == View.VISIBLE;
  }

  private void shiftKeyboard(int verb) {
    RelativeLayout.LayoutParams params =
        new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.WRAP_CONTENT);
    params.addRule(verb);
    mKeyboardView.setLayoutParams(params);
  }

  private OnKeyboardActionListener onKeyboardActionListener = new OnKeyboardActionListener() {
    @Override
    public void onKey(int primaryCode, int[] keyCodes) {
      if (mIndex < 24 && !mBottom) {
        mBottom = true;
        shiftKeyboard(RelativeLayout.ALIGN_PARENT_BOTTOM);
      } else if (mIndex >= 24 && mBottom) {
        mBottom = false;
        shiftKeyboard(RelativeLayout.ALIGN_PARENT_TOP);
      }
      if (primaryCode == -1)
        return;
      else if (primaryCode == 42 && mIndex < 42) {
        mPostcardText[mIndex] = ' ';
        showBlank(false);
      } else if (primaryCode == 43)
        showBlank(true);
      else if (primaryCode == 44)
        hideCustomKeyboard();
      else if (primaryCode == 315 && mIndex < 42) {
        showLetter(18); // LatvL
        mPostcardText[mIndex] =
            MainActivity.LETTER[Arrays.asList(MainActivity.LANGUAGE).indexOf(mLanguage)][18];
      } else if (mIndex < 42) {
        mPostcardText[mIndex] =
            MainActivity.LETTER[Arrays.asList(MainActivity.LANGUAGE).indexOf(mLanguage)][primaryCode];
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

  class SharePostcard extends AsyncTask<Void, Void, String> {
    private ProgressDialog mProgressDialog;

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(WritePostcardActivity.this);
      mProgressDialog.setTitle("Sharing Postcard.");
      mProgressDialog.setMessage("Please, wait.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected String doInBackground(Void... params) {
      /*
       * Copy table layout to bitmap
       */
      TableLayout tableLayout = (TableLayout) findViewById(R.id.tableLayout_write_postcard);
      Bitmap alphabet =
          Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
              Bitmap.Config.ARGB_8888);
      Canvas canvas = new Canvas(alphabet);
      tableLayout.draw(canvas);
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
        ex.printStackTrace();
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      alphabet.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      try {
        fos.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      alphabet = null;
      // Adding to gallery
      ContentValues image = new ContentValues();
      image.put(Images.Media.DATA, file.getAbsolutePath());
      getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
      return file.getAbsolutePath();
    }

    @Override
    protected void onPostExecute(String path) {
      mProgressDialog.dismiss();
      Intent share = new Intent(WritePostcardActivity.this, ShareActivity.class);
      share.putExtra("sharingWhat", "Alphabet");
      share.putExtra("sharePath", path);
      startActivity(share);
    }
  }

  class SaveAndSchedule extends AsyncTask<Void, Void, Void> {
    @Override
    protected Void doInBackground(Void... params) {
      /*
       * Copy table layout to bitmap
       */
      TableLayout tableLayout = (TableLayout) findViewById(R.id.tableLayout_write_postcard);
      Bitmap postcard =
          Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
              Bitmap.Config.ARGB_8888);
      Canvas canvas = new Canvas(postcard);
      tableLayout.draw(canvas);
      /*
       * Save
       */
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
        ex.printStackTrace();
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      postcard.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      try {
        fos.close();
      } catch (IOException ex) {
        ex.printStackTrace();
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
        ex.printStackTrace();
      }
      ContentValues entry = new ContentValues();
      entry.put("lng", mSharedPreferences.getString("longitude", "0"));
      entry.put("lat", mSharedPreferences.getString("latitude", "0"));
      entry.put("letter", "no");
      entry.put("postcard", "yes");
      entry.put("alphabet", "no");
      entry.put("pText", new String(mPostcardText, 0, mIndex));
      entry.put("lang", mLanguage);
      entry.put("prefix", "");
      entry.put("suffix", filename);

      try {
        database.insert("updates", null, entry);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
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
      return inSampleSize;
    }

    public Bitmap decodeSampledBitmapFromResource(Resources res, int index, int reqWidth,
        int reqHeight) {
      String path = null;
      int resId =
          MainActivity.RESOURCE_INDEX[Arrays.asList(MainActivity.LANGUAGE).indexOf(mLanguage)][index];
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets"
                  + File.separator
                  + mAlphabet
                  + "_"
                  + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                      mLanguage)][index] + ".png");
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
      return decodeSampledBitmapFromResource(getResources(), data, mWidth, mHeight);
    }

    @Override
    protected void onPostExecute(Bitmap bitmap) {
      if (imageViewReference != null && bitmap != null) {
        final ImageView imageView = imageViewReference.get();
        if (imageView != null) {
          // imageView.setBackgroundResource(R.color.LightGrey);
          imageView.setImageBitmap(bitmap);
        }
      }
    }
  }

}
