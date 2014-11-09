package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.util.Arrays;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v4.view.GestureDetectorCompat;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.widget.ImageSwitcher;
import android.widget.ImageView;
import android.widget.ViewSwitcher.ViewFactory;

public class ViewLetterActivity extends Activity {
  private ImageSwitcher mImageSwitcher;
  private GestureDetectorCompat mSwipeListener;
  private int mIndex;
  private String mAlphabet;
  private String mLanguage;
  private SharedPreferences mSharedPreferences;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_view_letter);
    mIndex = getIntent().getIntExtra("currentIndex", 0);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mAlphabet = getIntent().getStringExtra("currentAlphabet");
    mLanguage = getIntent().getStringExtra("currentLanguage");
    mImageSwitcher = (ImageSwitcher) findViewById(R.id.imageSwitcher_viewimage);
    mImageSwitcher.setFactory(new ViewFactory() {
      @Override
      public View makeView() {
        ImageView imageView = new ImageView(getApplicationContext());
        imageView.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        // No idea, need to check
        LayoutParams params =
            new ImageSwitcher.LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

        imageView.setLayoutParams(params);
        return imageView;
      }
    });
    mImageSwitcher.setImageURI(Uri.parse(getResourcePath()));
    mSwipeListener = new GestureDetectorCompat(this, new CustomGestureListener());
  }
  
  @Override
  public boolean onTouchEvent(MotionEvent event) {
    mSwipeListener.onTouchEvent(event);
    return super.onTouchEvent(event);
  }

  private String getResourcePath() {
    File filename =
        new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
            "UrbanAlphabets"
                + File.separator
                + mAlphabet
                + "_"
                + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE)
                    .indexOf(mLanguage)][mIndex] + ".png");
    if (filename.exists())
      return filename.getAbsolutePath();
    return "android.resource://"
        + getPackageName()
        + "/raw/"
        + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(mLanguage)][mIndex];
  }

  public void takePhoto(View v) {
    Editor e = mSharedPreferences.edit();
    e.putInt("assignLetter", mIndex);
    e.commit();
    Intent takePhotoIntent = new Intent(this, TakePhotoActivity.class);
    startActivity(takePhotoIntent);
    finish();
  }

  public void showAbc(View v) {
    finish();
  }

  public void deleteLetter(View v) {
    File file =
        new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
            "UrbanAlphabets"
                + File.separator
                + mAlphabet
                + "_"
                + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE)
                    .indexOf(mLanguage)][mIndex] + ".png");

    if (file.exists())
      file.delete();

    getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
        Images.Media.DATA + " LIKE ?", new String[] {file.getAbsolutePath()});

    finish();
  }
  
  private void onNext() {
    mIndex = (mIndex + 1 == 42) ? 0 : mIndex + 1;
    mImageSwitcher.setImageURI(Uri.parse(getResourcePath()));
  }

  private void onPrevious() {
    mIndex = (mIndex == 0) ? 42 - 1 : mIndex - 1;
    mImageSwitcher.setImageURI(Uri.parse(getResourcePath()));
  }
  
  private class CustomGestureListener extends GestureDetector.SimpleOnGestureListener {

    @Override
    public boolean onDown(MotionEvent event) {
      return true;
    }

    @Override
    public boolean onFling(MotionEvent event1, MotionEvent event2, float velocityX, float velocityY) {
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
