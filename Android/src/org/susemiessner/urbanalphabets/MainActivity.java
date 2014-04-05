package org.susemiessner.urbanalphabets;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.ImageFormat;
import android.hardware.Camera;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageView;
import eu.janmuller.android.simplecropimage.CropImage;

public class MainActivity extends Activity implements SurfaceHolder.Callback {
	private static final int RESULT_LOAD_IMAGE = 1;
	private int PIC_CROP_USING_LIB = 2;
	private Camera camera;
	private SurfaceView surfaceView;
	private SurfaceHolder surfaceHolder;
	private boolean previewing = false;
	private LayoutInflater controlInflater = null;
	private ImageView takeCameraPicture, takeGalleryPicture;
	private Uri croppedPicUri;

	
	/** Called when the activity is first created. */

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.preview);

		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		getWindow().setFormat(ImageFormat.UNKNOWN);
		surfaceView = (SurfaceView) findViewById(R.id.surfaceViewCamera);
		surfaceHolder = surfaceView.getHolder();
		surfaceHolder.addCallback(this);

		controlInflater = LayoutInflater.from(getBaseContext());
		View viewControl = controlInflater
				.inflate(R.layout.activity_main, null);
		LayoutParams layoutParamsControl = new LayoutParams(
				LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
		this.addContentView(viewControl, layoutParamsControl);

		takeCameraPicture = (ImageView) findViewById(R.id.imageButtonTakePhoto);
		takeCameraPicture.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				takePicture();

			}
		});

		takeGalleryPicture = (ImageView) findViewById(R.id.imageButtonPhotoLibrary);
		takeGalleryPicture.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				selectPicture();

			}
		});

	}

	protected void selectPicture() {

		Intent i = new Intent(Intent.ACTION_PICK,
				android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);

		startActivityForResult(i, RESULT_LOAD_IMAGE); // startActivityForResult

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		Log.i("TAG-file uri", requestCode + "" + resultCode + data.toString());

		if (requestCode == RESULT_LOAD_IMAGE && resultCode == RESULT_OK
				&& null != data) {
			// from gallery
			Uri fileUriOfPickedImage = data.getData();
			Log.i("TAG-file uri", fileUriOfPickedImage.toString() + "");

			// start the crop here

		}

		else if (resultCode == RESULT_OK && requestCode == PIC_CROP_USING_LIB) {

			String path = data.getStringExtra(CropImage.IMAGE_PATH);
			Log.i("path", path);
			// File file = new File(path);
			croppedPicUri = Uri.fromFile(new File(path));
			Intent i = new Intent(MainActivity.this, AssignAlphabets.class);
			i.putExtra("fileUri", croppedPicUri.toString());
		
		
			startActivity(i);
		}

		else {
			finish();
			startActivity(getIntent());
		}

	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width,
			int height) {

		if (previewing) {
			camera.stopPreview();
			previewing = false;
		}
		if (camera != null) {
			try {
				camera.setPreviewDisplay(surfaceHolder);
				camera.startPreview();
				previewing = true;
			} catch (IOException e) {

				e.printStackTrace();
			}
		}
	}

	@Override
	public void surfaceCreated(SurfaceHolder holder) {
		camera = Camera.open();

		Camera.Parameters parameters = camera.getParameters();
		parameters.setRotation(90);
		camera.setDisplayOrientation(90);
		camera.setParameters(parameters);

	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder) {
		camera.stopPreview();
		camera.release();
		camera = null;
		previewing = false;
	}

	void takePicture() {

		camera.takePicture(new Camera.ShutterCallback() {

			@Override
			public void onShutter() {

			}
		}, new Camera.PictureCallback() {

			@Override
			public void onPictureTaken(byte[] data, Camera camera) {
				// to do

			}
		}, new Camera.PictureCallback() {

			@Override
			public void onPictureTaken(byte[] data, Camera camera) {

				BitmapFactory.Options options = new BitmapFactory.Options();
				options.inSampleSize = 8;

				options.inPurgeable = true;
				Bitmap bitmapPicture = BitmapFactory.decodeByteArray(data, 0,
						data.length);

				try {
					runCropImage(savePicture(bitmapPicture,
							"phototaken" + Math.random() * 10
									* (Math.random() * 100))); // running the
																// crop from
																// photo just
																// taken
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		});

	}

	private File savePicture(Bitmap image, String fileName) throws IOException {

		OutputStream fOut = null;
		File directory = new File(Environment.getExternalStorageDirectory()
				+ "/Android/data/" + getApplicationContext().getPackageName()
				+ "/Files/Images");

		if (!directory.exists()) {
			directory.mkdirs();
		}
		File file = new File(directory.toString(), fileName);
		fOut = new FileOutputStream(file);

		image.compress(Bitmap.CompressFormat.JPEG, 100, fOut);
		fOut.flush();
		fOut.close();
		return file;
	}

	private void runCropImage(File file) {

		// create explicit intent
		Intent intent = new Intent(this, CropImage.class);

		// tell CropImage activity to look for image to crop
		String filePath = file.toString();
		intent.putExtra(CropImage.IMAGE_PATH, filePath);

		// allow CropImage activity to rescale image
		intent.putExtra(CropImage.SCALE, true);

		// if the aspect ratio is fixed to ratio 3/2
		intent.putExtra(CropImage.ASPECT_X, 2);
		intent.putExtra(CropImage.ASPECT_Y, 3);

		// start activity CropImage with certain request code and listen
		// for result
		startActivityForResult(intent, PIC_CROP_USING_LIB);
	}

}