package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.hardware.Camera;
import android.hardware.Camera.PictureCallback;
import android.hardware.Camera.Size;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.widget.FrameLayout;

public class TakePhotoActivity extends ActionBarActivity {
	private Camera mCamera;
	private CameraPreview mPreview;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_take_photo);
		// Create an instance of Camera
				try {
					mCamera = Camera.open();
				} catch (Exception e) {
					mCamera = null;
				}
				Camera.Parameters parameters = mCamera.getParameters();
				List<Size> sizes = parameters.getSupportedPictureSizes();
				Size mSize = null;
				// Best size
				for (Size size : sizes) {
					mSize = size;
				    break;
				}
				parameters.setPictureSize(mSize.width, mSize.height);
				parameters.setRotation(90);
				mCamera.setDisplayOrientation(90);
				mCamera.setParameters(parameters);
				
				// create view
				mPreview = new CameraPreview(this, mCamera);
				FrameLayout preview = (FrameLayout) findViewById (R.id.cameraPreview);
				preview.addView(mPreview);
	}
	
	public void onClickTakePhoto(View v) {
		mCamera.takePicture(null, null, mPicture);
	}
	
	public void onClickOpenGallery(View v) {
		Intent openGalleryIntent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
		startActivityForResult(openGalleryIntent, Data.OPEN_GALLERY);
	}
	
	private PictureCallback mPicture = new PictureCallback() {
		@Override
		public void onPictureTaken(byte[] data, Camera camera) {
			try {
				FileOutputStream fos = openFileOutput("photo.png", Context.MODE_PRIVATE);
				//BufferedOutputStream bos = new BufferedOutputStream(fos);
				//((BitmapFactory.decodeByteArray(data, 0, data.length).
				//	compress(CompressFormat.PNG, 100, bos);
				//bos.flush();
				fos.write(data);
				fos.close();
			} catch (IOException e) {
			}	
			cropPhoto();
		}
	};
	
	private void cropPhoto(){
		Intent cropPhotoIntent = new Intent(this, CropPhotoActivity.class);
		startActivity(cropPhotoIntent);
		finish();
	}
	
	private String getRealPathFromUri(Uri uri) {
		Cursor cursor = null;
		try { 
			String[] proj = { MediaStore.Images.Media.DATA };
		    cursor = this.getContentResolver().query(uri,  proj, null, null, null);
		    int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
		    cursor.moveToFirst();
		    return cursor.getString(column_index);
		} finally {
			if (cursor != null) {
				cursor.close();
		    }
		}
	}
	
	protected void onActivityResult(int requestCode, int resultCode,
			Intent data){
		if(requestCode == Data.OPEN_GALLERY && 
				resultCode == RESULT_OK) {
			Uri uri = data.getData();
			if (uri != null){
				Bitmap bitmap = BitmapFactory.decodeFile(getRealPathFromUri(uri));
				try {

					FileOutputStream fos = openFileOutput("photo.png", Context.MODE_PRIVATE);
					BufferedOutputStream bos = new BufferedOutputStream(fos);
					bitmap.compress(CompressFormat.PNG, 100, bos);
					bos.flush();
					fos.close();
				} catch (IOException  e) {
				}
				Intent cropPhotoIntent = new Intent(this, CropPhotoActivity.class);
				startActivity(cropPhotoIntent);
			}
		}
		finish();
	}
}
