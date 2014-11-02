package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import android.content.ContentValues;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Bitmap.CompressFormat;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TableRow;

public class AssignLetterActivity extends ActionBarActivity {
  private int imageViewId[] = {R.id.imageview_assign_letter1, R.id.imageview_assign_letter2,
      R.id.imageview_assign_letter3, R.id.imageview_assign_letter4, R.id.imageview_assign_letter5,
      R.id.imageview_assign_letter6, R.id.imageview_assign_letter7, R.id.imageview_assign_letter8,
      R.id.imageview_assign_letter9, R.id.imageview_assign_letter10,
      R.id.imageview_assign_letter11, R.id.imageview_assign_letter12,
      R.id.imageview_assign_letter13, R.id.imageview_assign_letter14,
      R.id.imageview_assign_letter15, R.id.imageview_assign_letter16,
      R.id.imageview_assign_letter17, R.id.imageview_assign_letter18,
      R.id.imageview_assign_letter19, R.id.imageview_assign_letter20,
      R.id.imageview_assign_letter21, R.id.imageview_assign_letter22,
      R.id.imageview_assign_letter23, R.id.imageview_assign_letter24,
      R.id.imageview_assign_letter25, R.id.imageview_assign_letter26,
      R.id.imageview_assign_letter27, R.id.imageview_assign_letter28,
      R.id.imageview_assign_letter29, R.id.imageview_assign_letter30,
      R.id.imageview_assign_letter31, R.id.imageview_assign_letter32,
      R.id.imageview_assign_letter33, R.id.imageview_assign_letter34,
      R.id.imageview_assign_letter35, R.id.imageview_assign_letter36,
      R.id.imageview_assign_letter37, R.id.imageview_assign_letter38,
      R.id.imageview_assign_letter39, R.id.imageview_assign_letter40,
      R.id.imageview_assign_letter41, R.id.imageview_assign_letter42};
  private List<Integer> imageViewIdList;
  private int selected;
  private SharedPreferences mSharedPreferences;
  private View saved;
  private String currentAlphabet;
  private String currentLanguage;
  private ImageButton imageButton;
  private int width;
  private int height;
  private int margin;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_assign_letter);
    imageViewIdList = new ArrayList<Integer>();
    for (int i = 0; i < 42; i++)
      imageViewIdList.add(imageViewId[i]);
    ImageView imageView = (ImageView) findViewById(R.id.imageview_assign_letter);
    imageView
        .setImageBitmap(BitmapFactory.decodeFile(getFilesDir() + File.separator + "photo.png"));
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    currentLanguage = mSharedPreferences.getString("currentLanguage", "");
    selected = mSharedPreferences.getInt("assignLetter", -1);
    width = mSharedPreferences.getInt("imageViewWidth", 0);
    height = mSharedPreferences.getInt("imageViewHeight", 0);
    margin = mSharedPreferences.getInt("imageViewExtra", 0);
    saved = null;
    // Reset assignLetter to -1
    Editor e = mSharedPreferences.edit();
    e.putInt("assignLetter", -1);
    e.commit();
    imageButton = (ImageButton) findViewById(R.id.imagebutton_assign_letter);
    setImageViewDimensions();
    setImages();
    if (selected != -1) {
      imageButton.setVisibility(View.VISIBLE);
      ImageView iv = (ImageView) findViewById(imageViewId[selected]);
      iv.setColorFilter(Color.argb(0x80, 0xC2, 0xF7, 0x9E));
    }
  }

  private void setImageViewDimensions() {
    for (int i = 0; i < 42; i++) {
      ImageView iv = (ImageView) findViewById(imageViewId[i]);
      TableRow.LayoutParams parms = new TableRow.LayoutParams(width, height);
      parms.setMargins(margin, margin, margin, margin);
      iv.setLayoutParams(parms);
    }
  }

  public void selectLetter(View v) {
    if (imageButton.getVisibility() == View.GONE)
      imageButton.setVisibility(View.VISIBLE);
    if (selected != -1) {
      ImageView imageView = (ImageView) findViewById(imageViewId[selected]);
      imageView.clearColorFilter();
    }

    selected = imageViewIdList.indexOf(v.getId());
    ImageView imageView = (ImageView) v;
    imageView.setColorFilter(Color.argb(0x80, 0xC2, 0xF7, 0x9E));
  }

  public void assignImage(View v) {
    boolean save = mSharedPreferences.getBoolean("save", true);
    if (save)
      assignPhoto();
    String username = mSharedPreferences.getString("username", "");
    if (username.equals("")) {
      saved = v;
      Intent setUsername = new Intent(this, SetUsernameActivity.class);
      startActivity(setUsername);
      return;
    }
    update();
  }

  private void assignPhoto() {
    File file =
        new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
            "UrbanAlphabets"
                + File.separator
                + currentAlphabet
                + "_"
                + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                    currentLanguage)][selected] + ".png");
    try {
      FileOutputStream fos = new FileOutputStream(file);
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      BitmapFactory.decodeFile(getFilesDir() + File.separator + "photo.png").compress(
          CompressFormat.PNG, 100, bos);
      bos.flush();
      fos.close();
    } catch (Exception ex) {
      Log.d("AssignLetterActivity", ex.getMessage());
    }

    ContentValues image = new ContentValues();
    image.put(Images.Media.DATA, file.getAbsolutePath());
    getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
  }

  private void update() {
    String username = mSharedPreferences.getString("username", "");
    String longitude = mSharedPreferences.getString("longitude", "0");
    String latitude = mSharedPreferences.getString("latitude", "0");
    UpdateDatabase update =
        new UpdateDatabase(this, longitude, latitude, username,
            String.valueOf(MainActivity.LETTERNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                currentLanguage)][selected]), "no", "no", BitmapFactory.decodeFile(getFilesDir()
                + File.separator + "photo.png"), currentLanguage, "");
    update.execute();
    try {
      update.get();
    } catch (CancellationException e) {

    } catch (ExecutionException e) {

    } catch (InterruptedException e) {

    }
    setResult(2);
    finish();
  }

  public void onResume() {
    super.onResume();
    String username = mSharedPreferences.getString("username", "");
    if (saved != null && !username.equals("")) {
      update();
      saved = null;
    }
  }

  private void setImages() {
    for (int index = 0; index < 42; index++) {
      ImageView imageView = (ImageView) findViewById(imageViewId[index]);
      new BitmapWorkerTask(imageView).execute(index);
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
          imageView.setImageBitmap(bitmap);
        }
      }
    }
  }
}
