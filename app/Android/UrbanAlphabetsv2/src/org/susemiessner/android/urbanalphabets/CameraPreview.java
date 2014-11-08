package org.susemiessner.android.urbanalphabets;

import java.io.IOException;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.hardware.Camera;
import android.hardware.Camera.Size;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

public class CameraPreview extends SurfaceView implements SurfaceHolder.Callback {
  private SurfaceHolder mHolder;
  private Camera mCamera;

  public CameraPreview(Context context, Camera camera) {
    super(context);
    mCamera = camera;
    setConfigs();
    mHolder = getHolder();
    mHolder.addCallback(this);
  }

  private void setConfigs() {
    setCameraDisplayOrientation(0);
    if(mCamera == null)
      return;
    Camera.Parameters parameters = mCamera.getParameters();
    List<Size> previewSizes = parameters.getSupportedPreviewSizes();
    List<Size> pictureSizes = parameters.getSupportedPictureSizes();
    boolean exit = false;
    for (Size pic : pictureSizes) {
      for (Size pre : previewSizes) {
        if ((double) pic.height / pic.width == (double) pre.height / pre.width) {
          parameters.setPictureSize(pic.width, pic.height);
          parameters.setPreviewSize(pre.width, pre.height);
          exit = true;
          break;
        }
      }
      if (exit)
        break;
    }
    mCamera.setParameters(parameters);
  }

  public void setCameraDisplayOrientation(int cameraId) {
    android.hardware.Camera.CameraInfo info = new android.hardware.Camera.CameraInfo();
    android.hardware.Camera.getCameraInfo(cameraId, info);
    int rotation = ((Activity) getContext()).getWindowManager().getDefaultDisplay().getRotation();
    int degrees = 0;
    switch (rotation) {
      case Surface.ROTATION_0:
        degrees = 0;
        break;
      case Surface.ROTATION_90:
        degrees = 90;
        break;
      case Surface.ROTATION_180:
        degrees = 180;
        break;
      case Surface.ROTATION_270:
        degrees = 270;
        break;
    }

    int result;
    if (info.facing == Camera.CameraInfo.CAMERA_FACING_FRONT) {
      result = (info.orientation + degrees) % 360;
      result = (360 - result) % 360; // compensate the mirror
    } else { // back-facing
      result = (info.orientation - degrees + 360) % 360;
    }
    mCamera.setDisplayOrientation(result);
  }

  public void surfaceCreated(SurfaceHolder holder) {
    // The Surface has been created, now tell the camera where to draw the preview.
    try {
      mCamera.setPreviewDisplay(holder);
      mCamera.startPreview();
    } catch (IOException ex) {
      Log.d("CameraPreview", ex.getMessage());
    }
  }

  public void surfaceDestroyed(SurfaceHolder holder) {
    // Surface will be destroyed when we return, so stop the preview.
    if (mCamera != null) {
      // Call stopPreview() to stop updating the preview surface.
      mCamera.stopPreview();
      mCamera.release();
    }
  }

  public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {
    if (mHolder.getSurface() == null) {
      return;
    }

    try {
      mCamera.stopPreview();
    } catch (Exception ex) {
      Log.d("CameraPreview", ex.getMessage());
    }

    setConfigs();

    try {
      mCamera.setPreviewDisplay(mHolder);
      mCamera.startPreview();
    } catch (Exception ex) {
      Log.d("CameraPreview", ex.getMessage());
    }
  }
}
