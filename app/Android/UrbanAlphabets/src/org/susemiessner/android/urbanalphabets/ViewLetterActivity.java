package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.util.Arrays;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.widget.ImageSwitcher;
import android.widget.ImageView;
import android.support.v4.view.GestureDetectorCompat;
import android.support.v7.app.ActionBarActivity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ViewSwitcher.ViewFactory;
import android.view.GestureDetector;

public class ViewLetterActivity extends ActionBarActivity {
	private ImageSwitcher imageSwitcher;
	private GestureDetectorCompat swipeListener;
	private int currentIndex;
	private String currentAlphabet;
	private String currentLanguage;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_view_letter);
		currentIndex = getIntent().getIntExtra("currentIndex", 0);
		currentAlphabet = getIntent().getStringExtra("currentAlphabet");
		currentLanguage = getIntent().getStringExtra("currentLanguage");
		imageSwitcher = (ImageSwitcher) findViewById (R.id.imageswitcher_viewimage);
		imageSwitcher.setFactory(new ViewFactory() {
			@Override
			public View makeView() {
				ImageView imageView = new ImageView(getApplicationContext() );
				imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
				return imageView;
			}
		});
		imageSwitcher.setImageURI(Uri.parse(getResourcePath()));
		swipeListener = new GestureDetectorCompat(this, new CustomGestureListener());
	}
	
	private String getResourcePath() {
		File filename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), Data.TOPLEVELDIR +
				File.separator + currentAlphabet
				+ File.separator + 
				Data.RESOURCERAWNAME[Arrays.asList(Data.LANGUAGE).
				              indexOf(currentLanguage)][currentIndex]
				+ ".png");
		if(filename.exists())
			return filename.getAbsolutePath();
		return "android.resource://" + getPackageName() + "/raw/" + 
				Data.RESOURCERAWNAME[Arrays.asList(Data.LANGUAGE).
				indexOf(currentLanguage)][currentIndex];
	}
	
	private void onNext() {
		currentIndex = (currentIndex + 1 == Data.MAX)?0:currentIndex+1;
		imageSwitcher.setImageURI(Uri.parse(getResourcePath()));
	}
	
	private void onPrevious() {
		currentIndex = (currentIndex == 0)?Data.MAX-1:currentIndex-1;
		imageSwitcher.setImageURI(Uri.parse(getResourcePath()));
	}
	
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		this.swipeListener.onTouchEvent(event);
        return super.onTouchEvent(event);
	}
	
	public void onClickTakePhoto(View v) {
		Intent takePhotoIntent = new Intent(this, TakePhotoActivity.class);
		startActivity(takePhotoIntent);
		finish();
	}
	
	public void onClickAbc(View v) {
		finish();
	}
	
	public void onClickDelete(View v) {
		//Data.deleteLetter(currentIndex);
		File file = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets" + 
				File.separator + Data.getSelectedAlphabetName() +
				File.separator + Data.RESOURCERAWNAME[Arrays.asList
				(Data.LANGUAGE).indexOf(Data.getSelectedAlphabetLanguage())]
				[currentIndex] + ".png");
		
		getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
				Images.Media.DATA + " LIKE ?", new String[]{file.getAbsolutePath()});
		
		if(file.exists())
			file.delete();
		
		finish();
	}
	
	private class CustomGestureListener extends GestureDetector.SimpleOnGestureListener {
		
		@Override
		public boolean onDown(MotionEvent event){
			return true;
		}
		
		@Override
		public boolean onFling(MotionEvent event1, MotionEvent event2,
				float velocityX, float velocityY){
			try {
                float diffY = event2.getY() - event1.getY();
                float diffX = event2.getX() - event1.getX();
                if (Math.abs(diffX) > Math.abs(diffY)) {
                    if (Math.abs(diffX) > 100 && Math.abs(velocityX) > 100) {
                        if (diffX > 0) {
                            onPrevious();
                        } else {
                            onNext();
                        }
                    }
                }
            } catch (Exception exception) {
                exception.printStackTrace();
            }
			return true;
		}
	}	
}
