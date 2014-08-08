package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Bitmap.CompressFormat;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.view.MotionEventCompat;
import android.support.v7.app.ActionBarActivity;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.View.OnTouchListener;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.LinearLayout;

public class CropPhotoActivity extends ActionBarActivity {
	
	private ScaleGestureDetector mScaleDetector;
	private float mScaleFactor;
	private CropView cropView;
	private Bitmap original;
	private int mActivePointerId = -1;
	private float mLastTouchX;
	private float mLastTouchY;
	private float mPosX;
	private float mPosY;
	private int rotation;
	private LinearLayout linearLayout;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_crop_photo);
		rotation = 0;
		cropView = (CropView) findViewById(R.id.imageview_crop_photo);	
		mScaleDetector = new ScaleGestureDetector(getBaseContext(), 
				new ScaleListener());
		original = BitmapFactory.decodeFile(getFilesDir()+File.separator+"photo.png"); 
		Matrix matrix = new Matrix();
		matrix.setRotate(-90);
		original = Bitmap.createBitmap(original, 0, 0, original.getWidth(),
						original.getHeight(), matrix, false);
		cropView.setImageBitmap(original);
		mPosX = 0f;
		mPosY = 0f;
		mScaleFactor = 0.2f;
		cropView.setOnTouchListener( new OnTouchListener() {	
				@Override
				public boolean onTouch(View v, MotionEvent event) {
					mScaleDetector.onTouchEvent(event);
					dragHandler(event);
					return true;
				}
			
		});
		
		linearLayout = (LinearLayout) findViewById
				(R.id.layout_crop_photo);
		ViewTreeObserver vto = linearLayout.getViewTreeObserver();
		vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
			@SuppressWarnings("deprecation")
			@Override
			public void onGlobalLayout() {
				if (Build.VERSION.SDK_INT < 16)
					linearLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				else 
					linearLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				showImage();
			}
		});
	}
	
	private void showImage() {
		Matrix matrix = new Matrix();
		matrix.setScale(mScaleFactor, mScaleFactor);
		mPosX = cropView.getWidth()/2 - original.getWidth() * mScaleFactor * 0.5f;
		mPosY = cropView.getHeight()/2 - original.getHeight() * mScaleFactor * 0.5f;
		matrix.postTranslate(mPosX, mPosY);
		cropView.setImageMatrix(matrix);
	}
	
	public void dragHandler(MotionEvent ev) {
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
	        final int pointerIndex = 
	                MotionEventCompat.findPointerIndex(ev, mActivePointerId);  
	            
	        final float x = MotionEventCompat.getX(ev, pointerIndex);
	        final float y = MotionEventCompat.getY(ev, pointerIndex);
	            
	        // Calculate the distance moved
	        final float dx = x - mLastTouchX;
	        final float dy = y - mLastTouchY;

	        mPosX += dx;
	        mPosY += dy;
	        
	        // Remember this touch position for the next move event
	        mLastTouchX = x;
	        mLastTouchY = y;
	        
	        // Drag image
	        Matrix matrix = new Matrix();
	        matrix.setScale(mScaleFactor, mScaleFactor);
	        matrix.postTranslate(mPosX, mPosY);
	        cropView.setImageMatrix(matrix);
	        cropView.invalidate();
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
	}
	
	public void onClickCW(View v) {
		rotation += 90;
		Matrix matrix = new Matrix();
		matrix.setRotate(rotation);
		Bitmap rotated = Bitmap.createBitmap(original, 0, 0, original.getWidth(),
				original.getHeight(), matrix, false);
		cropView.setImageBitmap(rotated);
	}
	
	public void onClickACW(View v) {
		rotation -= 90;
		Matrix matrix = new Matrix();
		matrix.setRotate(rotation);
		Bitmap rotated = Bitmap.createBitmap(original, 0, 0, original.getWidth(),
				original.getHeight(), matrix, false);
		cropView.setImageBitmap(rotated);
	}
	
	public void onClickCrop(View v) {
		Matrix matrix = new Matrix();
		matrix.setRotate(rotation);
		Bitmap rotated = Bitmap.createBitmap(original, 0, 0, original.getWidth(),
				original.getHeight(), matrix, false);
		
		float currentWidth = rotated.getWidth() * mScaleFactor;
		float currentHeight = rotated.getHeight() * mScaleFactor;
		
		float left;
		float selWidth;
		if(cropView.getLeftRect() > mPosX) {
			left = cropView.getLeftRect() - mPosX;
			if (mPosX + currentWidth  < cropView.getRightRect())
				selWidth = mPosX + currentWidth - cropView.getLeftRect();
			else
				selWidth = cropView.getRightRect() - cropView.getLeftRect();
		}
		else {
			left = 0;
			if(mPosX + currentWidth < cropView.getRightRect())
				selWidth = currentWidth;
			else
				selWidth = cropView.getRightRect() - mPosX;
		}
		
		float top;
		float selHeight;
		
		if(cropView.getTopRect() > mPosY) {
			top = cropView.getTopRect() - mPosY;
			if (mPosY + currentHeight  < cropView.getBottomRect())
				selHeight = mPosY + currentHeight - cropView.getTopRect();
			else
				selHeight = cropView.getBottomRect() - cropView.getTopRect();
		}
		else {
			top = 0;
			if(mPosY + currentHeight < cropView.getBottomRect())
				selHeight = currentHeight;
			else
				selHeight = cropView.getBottomRect() - mPosY;
		}
		
		float rmScaleFactor = (1.00f/mScaleFactor);
		boolean inside = true;
		
		Bitmap cropped = null;
		
		try {
			cropped = Bitmap.createBitmap(rotated, (int)(left * rmScaleFactor),
					(int)(top * rmScaleFactor),(int)(selWidth * rmScaleFactor),
					(int)(selHeight * rmScaleFactor));
		} catch (IllegalArgumentException e) {
			inside = false;
		}
		
		Bitmap b = Bitmap.createBitmap(439, 534, Bitmap.Config.ARGB_8888);
		Canvas c = new Canvas(b);
		if(inside) {
			Matrix resize = new Matrix();
			float rf = 439.0f/((cropView.getRightRect()-cropView.getLeftRect())
					*(rmScaleFactor));
			resize.setScale(rf, rf);
			Bitmap resized = Bitmap.createBitmap(cropped, 0, 0, cropped.getWidth(),
					cropped.getHeight(), resize, false);
			float r = 534.00f/(cropView.getBottomRect() - cropView.getTopRect());
			float leftEnd = ((mPosX - cropView.getLeftRect()) > 0)?
					(mPosX - cropView.getLeftRect()) :0;
			float topEnd = ((mPosY - cropView.getTopRect()) > 0)?
					(mPosY - cropView.getTopRect()) : 0;
			c.drawBitmap(resized, leftEnd * r, topEnd * r, null);
		}
		
		deleteFile ("photo.png");
		try {
			FileOutputStream fos = openFileOutput("photo.png", Context.MODE_PRIVATE);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			b.compress(CompressFormat.PNG, 100, bos);
			bos.flush();
			fos.close();
		} catch (IOException e) {
		}
		
		Intent assignLetterIntent = new Intent(this, AssignLetterActivity.class);
		startActivity(assignLetterIntent);
		finish();
	}
	
	private class ScaleListener extends ScaleGestureDetector.SimpleOnScaleGestureListener {
		@Override
		public boolean onScale(ScaleGestureDetector detector) {
			mScaleFactor *= detector.getScaleFactor();
	        // Don't let the object get too small or too large.
	        mScaleFactor = Math.max(0.2f, Math.min(mScaleFactor, 4.0f));
	        // Magnify image
	        Matrix matrix = new Matrix();
	        matrix.setScale(mScaleFactor, mScaleFactor);
	        matrix.postTranslate(mPosX, mPosY);
	        cropView.setImageMatrix(matrix);
	        cropView.invalidate();
	        return true;
		}
	}
}
