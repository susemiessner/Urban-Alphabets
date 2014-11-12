package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.hardware.Camera;
import android.hardware.Camera.CameraInfo;
import android.hardware.Camera.PictureCallback;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.OrientationEventListener;
import android.view.View;
import android.widget.FrameLayout;

public class TakePhotoActivity extends Activity {
  private final static int OPEN_GALLERY = 7000;
  private Camera mCamera;
  private CameraPreview mCameraPreview;
  private OrientationEventListener mOrientationEventListener;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_take_photo);
    mCamera = getCameraInstance();
    mCameraPreview = new CameraPreview(this, mCamera);
    FrameLayout frameLayout = (FrameLayout) findViewById(R.id.frameLayout_take_photo);
    frameLayout.addView(mCameraPreview);
    mOrientationEventListener = new OrientationEventListener(this) {
      @Override
      public void onOrientationChanged(int orientation) {
        if (mCamera == null) {
          return;
        }

        Camera.Parameters parameters = mCamera.getParameters();
        if (orientation == ORIENTATION_UNKNOWN)
          return;
        // cameraId = 0
        android.hardware.Camera.CameraInfo info = new android.hardware.Camera.CameraInfo();
        android.hardware.Camera.getCameraInfo(0, info);
        orientation = (orientation + 45) / 90 * 90;
        int rotation = 0;
        if (info.facing == CameraInfo.CAMERA_FACING_FRONT) {
          rotation = (info.orientation - orientation + 360) % 360;
        } else { // back-facing camera
          rotation = (info.orientation + orientation) % 360;
        }
        parameters.setRotation(rotation);
        mCamera.setParameters(parameters);
      }
    };
  }

  public static Camera getCameraInstance() {
    Camera c = null;
    try {
      c = Camera.open(); // attempt to get a Camera instance
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return c; // returns null if camera is unavailable
  }

  public void takePhoto(View v) {
    mCamera.takePicture(null, null, mPicture);
  }

  public void openGallery(View v) {
    Intent openGallery =
        new Intent(Intent.ACTION_PICK,
            android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
    startActivityForResult(openGallery, OPEN_GALLERY);
  }

  private PictureCallback mPicture = new PictureCallback() {
    @Override
    public void onPictureTaken(byte[] data, Camera camera) {
      new SaveImage().execute(data);
      Intent cropPhoto = new Intent(TakePhotoActivity.this, CropPhotoActivity.class);
      cropPhoto.putExtra("path", getFilesDir() + File.separator + "photo.png");
      startActivity(cropPhoto);
      finish();
    }
  };

  private String getRealPath(Uri uri) {
    Cursor cursor = null;
    try {
      String[] proj = {MediaStore.Images.Media.DATA};
      cursor = this.getContentResolver().query(uri, proj, null, null, null);
      int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
      cursor.moveToFirst();
      return cursor.getString(column_index);
    } finally {
      if (cursor != null) {
        cursor.close();
      }
    }
  }

  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == OPEN_GALLERY && resultCode == RESULT_OK) {
      Uri uri = data.getData();
      if (uri != null) {
        Intent cropPhoto = new Intent(this, CropPhotoActivity.class);
        cropPhoto.putExtra("path", getRealPath(uri));
        startActivity(cropPhoto);
      }
    }
    finish();
  }

  public void onResume() {
    super.onResume();
    mOrientationEventListener.enable();
  }

  public void onPause() {
    super.onPause();
    mOrientationEventListener.disable();
  }

  class SaveImage extends AsyncTask<byte[], Void, Void> {

    @Override
    protected Void doInBackground(byte[]... params) {
      byte[] data = params[0];
      try {
        FileOutputStream fos = openFileOutput("photo.png", Context.MODE_PRIVATE);
        fos.write(data);
        fos.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      return null;
    }
  }

}
