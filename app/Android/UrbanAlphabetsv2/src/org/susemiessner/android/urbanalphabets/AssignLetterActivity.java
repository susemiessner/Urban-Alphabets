package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TableRow;

public class AssignLetterActivity extends Activity {
  private int mImageViewId[] = {R.id.imageView_assign_letter1, R.id.imageView_assign_letter2,
      R.id.imageView_assign_letter3, R.id.imageView_assign_letter4, R.id.imageView_assign_letter5,
      R.id.imageView_assign_letter6, R.id.imageView_assign_letter7, R.id.imageView_assign_letter8,
      R.id.imageView_assign_letter9, R.id.imageView_assign_letter10,
      R.id.imageView_assign_letter11, R.id.imageView_assign_letter12,
      R.id.imageView_assign_letter13, R.id.imageView_assign_letter14,
      R.id.imageView_assign_letter15, R.id.imageView_assign_letter16,
      R.id.imageView_assign_letter17, R.id.imageView_assign_letter18,
      R.id.imageView_assign_letter19, R.id.imageView_assign_letter20,
      R.id.imageView_assign_letter21, R.id.imageView_assign_letter22,
      R.id.imageView_assign_letter23, R.id.imageView_assign_letter24,
      R.id.imageView_assign_letter25, R.id.imageView_assign_letter26,
      R.id.imageView_assign_letter27, R.id.imageView_assign_letter28,
      R.id.imageView_assign_letter29, R.id.imageView_assign_letter30,
      R.id.imageView_assign_letter31, R.id.imageView_assign_letter32,
      R.id.imageView_assign_letter33, R.id.imageView_assign_letter34,
      R.id.imageView_assign_letter35, R.id.imageView_assign_letter36,
      R.id.imageView_assign_letter37, R.id.imageView_assign_letter38,
      R.id.imageView_assign_letter39, R.id.imageView_assign_letter40,
      R.id.imageView_assign_letter41, R.id.imageView_assign_letter42};
  private List<Integer> mImageViewIdList;
  private int mWidth;
  private int mHeight;
  private int mMargin;
  private String mAlphabet;
  private String mLanguage;
  private SharedPreferences mSharedPreferences;
  private int mSelected;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_assign_letter);
    mImageViewIdList = new ArrayList<Integer>();
    for (int i = 0; i < 42; i++)
      mImageViewIdList.add(mImageViewId[i]);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    mLanguage = mSharedPreferences.getString("currentLanguage", "");
    mWidth = mSharedPreferences.getInt("imageViewWidth", 0);
    mHeight = mSharedPreferences.getInt("imageViewHeight", 0);
    mMargin = mSharedPreferences.getInt("imageViewExtra", 0);
    mSelected = -1;
    setImageViews();
    setImages();
    new DisplayImage((ImageView) findViewById(R.id.imageView_assign_letter)).execute();
  }

  private void setImageViews() {
    for (int i = 0; i < 42; i++) {
      TableRow.LayoutParams parms = new TableRow.LayoutParams(mWidth, mHeight);
      parms.setMargins(mMargin, mMargin, mMargin, mMargin);
      ((ImageView) findViewById(mImageViewId[i])).setLayoutParams(parms);
    }
  }

  private void setImages() {
    for (int index = 0; index < 42; index++) {
      ImageView imageView = (ImageView) findViewById(mImageViewId[index]);
      new BitmapWorkerTask(imageView).execute(index);
    }
  }

  public void selectLetter(View v) {
    ImageButton imageButton = (ImageButton) findViewById(R.id.imageButton_assign_letter);
    if (imageButton.getVisibility() == View.GONE)
      imageButton.setVisibility(View.VISIBLE);
    if (mSelected != -1) {
      ImageView imageView = (ImageView) findViewById(mImageViewId[mSelected]);
      imageView.clearColorFilter();
    }

    mSelected = mImageViewIdList.indexOf(v.getId());
    ImageView imageView = (ImageView) v;
    imageView.setColorFilter(Color.argb(0x80, 0xC2, 0xF7, 0x9E));
  }

  public void assignImage(View view) {
    new AssignAndSchedule().execute();
  }

  class AssignAndSchedule extends AsyncTask<Void, Void, Void> {
    private ProgressDialog mProgressDialog;

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(AssignLetterActivity.this);
      mProgressDialog.setTitle("Assigning photo");
      mProgressDialog.setMessage("Please, wait.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected Void doInBackground(Void... params) {
      FileInputStream inStream = null;
      try {
        inStream = new FileInputStream(new File(getFilesDir() + File.separator + "photo.png"));
      } catch (FileNotFoundException ex) {
        ex.printStackTrace();
      }
      FileOutputStream outStream = null;
      try {
        outStream =
            new FileOutputStream(new File(
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets"
                    + File.separator
                    + mAlphabet
                    + "_"
                    + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                        mLanguage)][mSelected] + ".png"));
      } catch (FileNotFoundException ex) {
        ex.printStackTrace();
      }
      FileChannel inChannel = inStream.getChannel();
      FileChannel outChannel = outStream.getChannel();
      try {
        inChannel.transferTo(0, inChannel.size(), outChannel);
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      try {
        inStream.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      try {
        outStream.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      deleteFile("photo.png");
      return null;
    }

    @Override
    protected void onPostExecute(Void arg) {
      mProgressDialog.dismiss();
      finish();
    }
  }

  class DisplayImage extends AsyncTask<Void, Void, Bitmap> {
    private final WeakReference<ImageView> imageViewReference;
    private int reqHeight;
    private int reqWidth;

    public DisplayImage(ImageView imageView) {
      imageViewReference = new WeakReference<ImageView>(imageView);
    }

    public int calculateInSampleSize(BitmapFactory.Options options) {
      // Raw height and width of image
      final int height = options.outHeight;
      final int width = options.outWidth;
      int inSampleSize = 1;

      if (height > reqHeight || width > reqWidth) {

        final int halfHeight = height / 2;
        final int halfWidth = width / 2;

        // Calculate the largest inSampleSize value that is a power of 2
        // and keeps both
        // height and width larger than the requested height and width.
        while ((halfHeight / inSampleSize) > reqHeight && (halfWidth / inSampleSize) > reqWidth) {
          inSampleSize *= 2;
        }
      }
      return inSampleSize;
    }

    public Bitmap decodeSampledBitmap(String path) {
      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      BitmapFactory.decodeFile(path, options);

      // Calculate inSampleSize
      options.inSampleSize = calculateInSampleSize(options);

      // Decode bitmap with inSampleSize set
      options.inJustDecodeBounds = false;
      return BitmapFactory.decodeFile(path, options);
    }

    @Override
    protected Bitmap doInBackground(Void... params) {
      reqHeight = (int) (45f * getResources().getDisplayMetrics().density);
      reqWidth = (int) (37f * getResources().getDisplayMetrics().density);
      return decodeSampledBitmap(getFilesDir() + File.separator + "photo.png");
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

        // Calculate the largest inSampleSize value that is a power of 2
        // and keeps both
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
          imageView.setImageBitmap(bitmap);
        }
      }
    }
  }
}
