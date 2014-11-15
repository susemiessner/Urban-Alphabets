package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.nio.channels.FileChannel;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.ImageView;

public class SplashActivity extends Activity {
  private SharedPreferences mSharedPreferences;
  private ImageView mImageView;
  private int reqHeight;
  private int reqWidth;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_splash);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mImageView = (ImageView) findViewById(R.id.imageView_splash);
    ViewTreeObserver vto = mImageView.getViewTreeObserver();
    File file =
        new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
            "UrbanAlphabets");
    if (!file.exists())
      file.mkdirs();
    String versionCode = mSharedPreferences.getString("versionCode", "");
    int version = 0;
    try {
      if (versionCode != null)
        version = Integer.parseInt(versionCode);
    } catch (NumberFormatException ex) {
      version = 0;
    }
    if (version < 7) {
      clearPreferences();
    }
    if(version < 8) {
      Editor e = mSharedPreferences.edit();
      e.putString("versionCode", "8");
      e.commit();
    }
    vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
      @Override
      public void onGlobalLayout() {
        try {
          mImageView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
        } catch (IllegalStateException ex) {
          ex.printStackTrace();
        }
        reqHeight = mImageView.getHeight();
        reqWidth = mImageView.getWidth();
        new DisplayImage(mImageView).execute();
      }
    });
    new Handler().postDelayed(new Runnable() {
      @Override
      public void run() {
        if (mSharedPreferences.getBoolean("isFirstRun", true)) {
          setIsFirstRun();
          Intent welcomeIntent = new Intent(SplashActivity.this, WelcomeActivity.class);
          startActivity(welcomeIntent);
        } else {
          Intent mainIntent = new Intent(SplashActivity.this, MainActivity.class);
          startActivity(mainIntent);
        }
        finish();
      }
    }, 2 * 1000); // Two seconds
  }

  private void clearPreferences() {
    boolean isFirstRun = mSharedPreferences.getBoolean("isFirstRun", true);
    Editor e = mSharedPreferences.edit();
    e.clear();
    e.putString("versionCode", "8");
    e.putBoolean("isFirstRun", isFirstRun);
    e.commit();
    // Copy database to correct location
    // Correcting error in previous version
    copyDatabase();
  }

  private void copyDatabase() {
    File src =
        new File(getFilesDir().getPath() + File.separator + "databases" + File.separator
            + "db.sqlite");
    if (!src.exists())
      return;
    File dir =
        new File(File.separator + "data" + File.separator + "data" + File.separator
            + getPackageName() + File.separator + "databases");
    if (!dir.exists()) {
      dir.mkdir();
    }
    File dst =
        new File(File.separator + "data" + File.separator + "data" + File.separator
            + getPackageName() + File.separator + "databases" + File.separator + "db.sqlite");
    copyFile(src, dst);
  }

  private void copyFile(File src, File dst) {
    FileChannel inChannel = null;
    FileChannel outChannel = null;
    try {
      inChannel = new FileInputStream(src).getChannel();
    } catch (FileNotFoundException ex) {
      ex.printStackTrace();
    }
    try {
      outChannel = new FileOutputStream(dst).getChannel();
    } catch (FileNotFoundException ex) {
      ex.printStackTrace();
    }
    try {
      inChannel.transferTo(0, inChannel.size(), outChannel);
    } catch (IOException ex) {
      ex.printStackTrace();
    }
    try {
      inChannel.close();
    } catch (IOException ex) {
      ex.printStackTrace();
    }
    try {
      outChannel.close();
    } catch (IOException ex) {
      ex.printStackTrace();
    }
    src.delete();
  }

  private void setIsFirstRun() {
    Editor e = mSharedPreferences.edit();
    e.putBoolean("isFirstRun", false);
    e.commit();
  }

  @Override
  protected void onStop() {
    mImageView.setImageBitmap(null);
    super.onStop();
  }

  class DisplayImage extends AsyncTask<Void, Void, Bitmap> {
    private final WeakReference<ImageView> imageViewReference;

    public DisplayImage(ImageView imageView) {
      imageViewReference = new WeakReference<ImageView>(imageView);
    }

    public int calculateInSampleSize(BitmapFactory.Options options) {

      int inSampleSize = 1;
      float scale =
          Math.min((float) options.outHeight / reqHeight, (float) options.outWidth / reqWidth);
      if (scale <= 1) {
        return inSampleSize;
      }

      // Calculate nearest power of 2
      int x = 0;

      while (true) {
        float min = (float) Math.pow(2, x);
        float max = (float) Math.pow(2, x + 1);
        if (scale > min && scale <= max) {
          inSampleSize = (int) ((scale - min) <= (max - scale) ? min : max);
          break;
        }
        x++;
      }

      return inSampleSize;
    }

    public Bitmap decodeSampledBitmap() {
      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      BitmapFactory.decodeResource(getResources(), R.raw.loading_screen, options);

      // Calculate inSampleSize
      options.inSampleSize = calculateInSampleSize(options);

      // Decode bitmap with inSampleSize set
      options.inJustDecodeBounds = false;
      return BitmapFactory.decodeResource(getResources(), R.raw.loading_screen, options);
    }

    @Override
    protected Bitmap doInBackground(Void... params) {
      return decodeSampledBitmap();
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
