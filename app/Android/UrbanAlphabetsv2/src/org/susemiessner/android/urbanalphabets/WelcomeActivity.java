package org.susemiessner.android.urbanalphabets;

import java.lang.ref.WeakReference;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.ImageView;

public class WelcomeActivity extends Activity {
  private int mClick;
  private ImageView mImageView;
  private int reqHeight;
  private int reqWidth;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_welcome);
    mImageView = (ImageView) findViewById(R.id.imageView_welcome);
    ViewTreeObserver vto = mImageView.getViewTreeObserver();
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
        new DisplayImage(mImageView).execute(R.raw.intro_1);
      }
    });
    mClick = 0;
  }

  public void showNext(View v) {
    mClick++;
    if (mClick == 1) {
      new DisplayImage(mImageView).execute(R.raw.intro_2);
      return;
    } else if (mClick == 2) {
      new DisplayImage(mImageView).execute(R.raw.intro_3);
      return;
    }

    Intent mainIntent = new Intent(this, MainActivity.class);
    startActivity(mainIntent);
    finish();
  }

  @Override
  protected void onStop() {
    mImageView.setImageBitmap(null);
    super.onStop();
  }

  class DisplayImage extends AsyncTask<Integer, Void, Bitmap> {
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

    public Bitmap decodeSampledBitmap(int resId) {
      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      BitmapFactory.decodeResource(getResources(), resId, options);

      // Calculate inSampleSize
      options.inSampleSize = calculateInSampleSize(options);

      // Decode bitmap with inSampleSize set
      options.inJustDecodeBounds = false;
      return BitmapFactory.decodeResource(getResources(), resId, options);
    }

    @Override
    protected Bitmap doInBackground(Integer... params) {
      int resId = params[0];
      return decodeSampledBitmap(resId);
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
