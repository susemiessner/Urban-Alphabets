package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.BitmapRegionDecoder;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.RectF;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.view.MotionEventCompat;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.LinearLayout;

public class CropPhotoActivity extends Activity implements ViewTreeObserver.OnGlobalLayoutListener,
    View.OnTouchListener {
  private final static int ASSIGN_LETTER_ACTIVITY = 8000;
  private String mPath;
  private CropView mCropView;
  private ScaleGestureDetector mScaleGestureDetector;
  private Matrix matrix;
  private int mActivePointerId = -1;
  private float mLastTouchX;
  private float mLastTouchY;
  private RectF mRectF;
  private int mScale;
  private int mRotation;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_crop_photo);
    mPath = getIntent().getStringExtra("path");
    mCropView = (CropView) findViewById(R.id.cropView_crop_photo);
    matrix = new Matrix();
    ViewTreeObserver vto =
        ((LinearLayout) findViewById(R.id.layout_crop_photo)).getViewTreeObserver();
    vto.addOnGlobalLayoutListener(this);
    mScaleGestureDetector = new ScaleGestureDetector(this, new ScaleListener());
    mCropView.setOnTouchListener(this);
    mRotation = 0;
  }

  @Override
  public void onGlobalLayout() {
    try {
      ((LinearLayout) findViewById(R.id.layout_crop_photo)).getViewTreeObserver()
          .removeOnGlobalLayoutListener(this);
    } catch (IllegalStateException ex) {
      ex.printStackTrace();
    }
    setImage();
  }

  private int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
    // Raw height and width of image
    final int height = options.outHeight;
    final int width = options.outWidth;
    int inSampleSize = 1;

    if (height > reqHeight || width > reqWidth) {

      final int halfHeight = height / 2;
      final int halfWidth = width / 2;

      /*
       * Calculate the largest inSampleSize value that is a power of 2 and keeps both height and
       * width larger than the requested height and width.
       */
      while ((halfHeight / inSampleSize) > reqHeight && (halfWidth / inSampleSize) > reqWidth) {
        inSampleSize *= 2;
      }
    }
    return inSampleSize;
  }


  private void setImage() {
    final BitmapFactory.Options options = new BitmapFactory.Options();
    options.inJustDecodeBounds = true;
    BitmapFactory.decodeFile(mPath, options);
    float scaleFactor =
        Math.min((float) mCropView.getWidth() / options.outWidth, (float) mCropView.getHeight()
            / options.outHeight);

    final int width = (int) (scaleFactor * options.outWidth);
    final int height = (int) (scaleFactor * options.outHeight);
    options.inSampleSize = calculateInSampleSize(options, width, height);
    mScale = options.inSampleSize;
    options.inJustDecodeBounds = false;
    Bitmap bitmap = BitmapFactory.decodeFile(mPath, options);
    mCropView.setImageBitmap(bitmap);
    mRectF = new RectF(mCropView.getDrawable().getBounds());
    matrix.setScale(scaleFactor * options.inSampleSize, scaleFactor * options.inSampleSize);
    matrix
        .postTranslate((mCropView.getWidth() - width) / 2f, (mCropView.getHeight() - height) / 2f);
    mCropView.setImageMatrix(matrix);
  }

  @Override
  public boolean onTouch(View view, MotionEvent ev) {
    // Let the ScaleGestureDetector inspect all events.
    mScaleGestureDetector.onTouchEvent(ev);

    final int action = MotionEventCompat.getActionMasked(ev);

    switch (action) {
      case MotionEvent.ACTION_DOWN: {
        final int pointerIndex = MotionEventCompat.getActionIndex(ev);
        final float x = MotionEventCompat.getX(ev, pointerIndex);
        final float y = MotionEventCompat.getY(ev, pointerIndex);

        // Remember where we started (for dragging)
        mLastTouchX = x;
        mLastTouchY = y;
        // Save the ID of this pointer (for dragging)
        mActivePointerId = MotionEventCompat.getPointerId(ev, 0);
        break;
      }

      case MotionEvent.ACTION_MOVE: {
        // Find the index of the active pointer and fetch its position
        final int pointerIndex = MotionEventCompat.findPointerIndex(ev, mActivePointerId);

        final float x = MotionEventCompat.getX(ev, pointerIndex);
        final float y = MotionEventCompat.getY(ev, pointerIndex);

        // Calculate the distance moved
        final float dx = x - mLastTouchX;
        final float dy = y - mLastTouchY;

        mCropView.post(new TranslateRunnable(dx, dy));

        // Remember this touch position for the next move event
        mLastTouchX = x;
        mLastTouchY = y;

        break;
      }

      case MotionEvent.ACTION_UP: {
        mActivePointerId = -1;
        break;
      }

      case MotionEvent.ACTION_CANCEL: {
        mActivePointerId = -1;
        break;
      }

      case MotionEvent.ACTION_POINTER_UP: {

        final int pointerIndex = MotionEventCompat.getActionIndex(ev);
        final int pointerId = MotionEventCompat.getPointerId(ev, pointerIndex);

        if (pointerId == mActivePointerId) {
          // This was our active pointer going up. Choose a new
          // active pointer and adjust accordingly.
          final int newPointerIndex = pointerIndex == 0 ? 1 : 0;
          mLastTouchX = MotionEventCompat.getX(ev, newPointerIndex);
          mLastTouchY = MotionEventCompat.getY(ev, newPointerIndex);
          mActivePointerId = MotionEventCompat.getPointerId(ev, newPointerIndex);
        }
        break;
      }
    }
    return true;
  }

  public void cropPhoto(View view) {
    mCropView.setImageBitmap(null);
    new CropPhoto().execute();
  }


  public void rotateCW(View view) {
    mRotation += 90;
    int rotation = 90;
    RectF rectF = new RectF();
    matrix.mapRect(rectF, mRectF);
    mCropView.post(new RotateRunnable(rotation, rectF.left + (rectF.right - rectF.left) / 2,
        rectF.top + (rectF.bottom - rectF.top) / 2));
  }

  public void rotateACW(View view) {
    mRotation -= 90;
    int rotation = -90;
    RectF rectF = new RectF();
    matrix.mapRect(rectF, mRectF);
    mCropView.post(new RotateRunnable(rotation, rectF.left + (rectF.right - rectF.left) / 2,
        rectF.top + (rectF.bottom - rectF.top) / 2));
  }

  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == ASSIGN_LETTER_ACTIVITY && resultCode == 2) {
      finish();
    }
  }

  private class CropPhoto extends AsyncTask<Void, Void, Void> {
    private ProgressDialog mProgressDialog;

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(CropPhotoActivity.this);
      mProgressDialog.setTitle("Cropping photo");
      mProgressDialog.setMessage("Please wait.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected Void doInBackground(Void... params) {
      Matrix inverse = new Matrix();
      matrix.invert(inverse);
      RectF cropRect =
          new RectF(mCropView.getLeftRect(), mCropView.getTopRect(), mCropView.getRightRect(),
              mCropView.getBottomRect());
      inverse.mapRect(cropRect);
      BitmapFactory.Options options = new BitmapFactory.Options();
      options.outHeight = (int) (cropRect.bottom - cropRect.top) * mScale;
      options.outWidth = (int) (cropRect.right - cropRect.left) * mScale;
      options.inSampleSize =
          calculateInSampleSize(options, (options.outHeight > options.outWidth) ? 439 : 534,
              (options.outHeight > options.outWidth) ? 534 : 439);
      BitmapRegionDecoder bitmapRegionDecoder = null;
      try {
        bitmapRegionDecoder = BitmapRegionDecoder.newInstance(mPath, true);
      } catch (IOException ex) {
        ex.printStackTrace();
      }

      Bitmap bitmap =
          bitmapRegionDecoder.decodeRegion(new Rect((int) cropRect.left * mScale,
              (int) cropRect.top * mScale, (int) cropRect.right * mScale, (int) cropRect.bottom
                  * mScale), options);
      bitmapRegionDecoder.recycle();

      // Rotate Image
      Matrix rotate = new Matrix();
      rotate.postRotate(mRotation % 360);
      bitmap =
          Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), rotate, false);
      // Scale
      try {
        bitmap = Bitmap.createScaledBitmap(bitmap, 439, 534, false);
      } catch (IllegalArgumentException ex) {
        ex.printStackTrace();
      }
      deleteFile("photo.png");
      try {
        FileOutputStream fos = openFileOutput("photo.png", Context.MODE_PRIVATE);
        BufferedOutputStream bos = new BufferedOutputStream(fos);
        bitmap.compress(CompressFormat.PNG, 100, bos);
        bos.flush();
        fos.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      Intent assignLetter = new Intent(CropPhotoActivity.this, AssignLetterActivity.class);
      startActivityForResult(assignLetter, ASSIGN_LETTER_ACTIVITY);
      return null;
    }

    @Override
    protected void onPostExecute(Void arg) {
      mProgressDialog.dismiss();
    }
  }

  private class ScaleListener implements ScaleGestureDetector.OnScaleGestureListener {

    @Override
    public boolean onScale(ScaleGestureDetector detector) {
      mCropView.post(new ZoomRunnable(detector.getScaleFactor(), detector.getFocusX(), detector
          .getFocusY()));
      return true;
    }

    @Override
    public boolean onScaleBegin(ScaleGestureDetector detector) {
      return true;
    }

    @Override
    public void onScaleEnd(ScaleGestureDetector detector) {}
  }

  private class ZoomRunnable implements Runnable {
    private float mScale;
    private float mFocalX;
    private float mFocalY;

    public ZoomRunnable(final float scale, final float focalX, final float focalY) {
      mScale = scale;
      mFocalX = focalX;
      mFocalY = focalY;
    }

    @Override
    public void run() {
      matrix.postScale(mScale, mScale, mFocalX, mFocalY);
      mCropView.setImageMatrix(matrix);
    }
  }

  private class RotateRunnable implements Runnable {
    private float mRotation;
    private float mFocalX;
    private float mFocalY;

    public RotateRunnable(final float rotation, final float focalX, final float focalY) {
      mRotation = rotation;
      mFocalX = focalX;
      mFocalY = focalY;
    }

    @Override
    public void run() {
      matrix.postRotate(mRotation, mFocalX, mFocalY);
      mCropView.setImageMatrix(matrix);
    }
  }

  private class TranslateRunnable implements Runnable {
    private float mTranslateX;
    private float mTranslateY;

    public TranslateRunnable(final float translateX, final float translateY) {
      mTranslateX = translateX;
      mTranslateY = translateY;
    }

    @Override
    public void run() {
      matrix.postTranslate(mTranslateX, mTranslateY);
      mCropView.setImageMatrix(matrix);
    }
  }
}
