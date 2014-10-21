package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;

import android.content.ContentValues;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.inputmethodservice.Keyboard;
import android.inputmethodservice.KeyboardView;
import android.inputmethodservice.KeyboardView.OnKeyboardActionListener;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TableLayout;

public class WritePostcardActivity extends ActionBarActivity {
	private int[] imageViewId = {
			R.id.imageview_write_postcard_1, R.id.imageview_write_postcard_2,
			R.id.imageview_write_postcard_3, R.id.imageview_write_postcard_4,
			R.id.imageview_write_postcard_5, R.id.imageview_write_postcard_6,
			R.id.imageview_write_postcard_7, R.id.imageview_write_postcard_8,
			R.id.imageview_write_postcard_9, R.id.imageview_write_postcard_10,
			R.id.imageview_write_postcard_11, R.id.imageview_write_postcard_12,
			R.id.imageview_write_postcard_13, R.id.imageview_write_postcard_14,
			R.id.imageview_write_postcard_15, R.id.imageview_write_postcard_16,
			R.id.imageview_write_postcard_17, R.id.imageview_write_postcard_18,
			R.id.imageview_write_postcard_19, R.id.imageview_write_postcard_20,
			R.id.imageview_write_postcard_21, R.id.imageview_write_postcard_22,
			R.id.imageview_write_postcard_23, R.id.imageview_write_postcard_24,
			R.id.imageview_write_postcard_25, R.id.imageview_write_postcard_26,
			R.id.imageview_write_postcard_27, R.id.imageview_write_postcard_28,
			R.id.imageview_write_postcard_29, R.id.imageview_write_postcard_30,
			R.id.imageview_write_postcard_31, R.id.imageview_write_postcard_32,
			R.id.imageview_write_postcard_33, R.id.imageview_write_postcard_34,
			R.id.imageview_write_postcard_35, R.id.imageview_write_postcard_36,
			R.id.imageview_write_postcard_37, R.id.imageview_write_postcard_38,
			R.id.imageview_write_postcard_39, R.id.imageview_write_postcard_40,
			R.id.imageview_write_postcard_41, R.id.imageview_write_postcard_42,
	};
	private int index;
	private int width;
	private int height;
	private RelativeLayout relativeLayout;
	private TableLayout tableLayout;
	private char[] postcardText;
	private KeyboardView keyboardView;
	private MenuItem saved;
	private SharedPreferences mSharedPreferences;
	private String currentAlphabet;
	private String currentLanguage;
	
	private static final int[] customKeyboard = {
		R.xml.finnish_swedish,
		R.xml.danish_norwegian,
		R.xml.english_portugese,
		R.xml.german,
		R.xml.spanish,
		R.xml.russian,
		R.xml.latvian
		};
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_write_postcard);
		mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
		currentLanguage = mSharedPreferences.getString("currentLanguage", "");
		saved = null;
		index = 0;
		postcardText = new char[42];
		tableLayout = (TableLayout) findViewById
				(R.id.tableview_write_postcard);
		// Create the Keyboard
	    Keyboard keyboard= new Keyboard(WritePostcardActivity.this, 
	    		customKeyboard[Arrays.asList(MainActivity.LANGUAGE).indexOf(currentLanguage)]);

	    // Lookup the KeyboardView
	    keyboardView= (KeyboardView)findViewById(R.id.keyboardview);
	    // Attach the keyboard to the view
	    keyboardView.setKeyboard( keyboard );
	    // Do not show the preview balloons
	    keyboardView.setPreviewEnabled(false);
		relativeLayout= (RelativeLayout) findViewById
				(R.id.layout_write_postcard);
		ViewTreeObserver vto = relativeLayout.getViewTreeObserver();
		vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
			@SuppressWarnings("deprecation")
			@Override
			public void onGlobalLayout() {
				if (Build.VERSION.SDK_INT < 16)
					relativeLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				else 
					relativeLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				ImageView imageView = (ImageView) findViewById
						(R.id.imageview_write_postcard_1);
				width = imageView.getWidth();
				height = imageView.getHeight();
				setBlank();
			}
		});
		keyboardView.setOnKeyboardActionListener(onKeyboardActionListener);
		showCustomKeyboard();
	}
		
	private void hideCustomKeyboard() {
	    keyboardView.setVisibility(View.GONE);
	    keyboardView.setEnabled(false);
	}

	public void showCustomKeyboard() {
	    keyboardView.setVisibility(View.VISIBLE);
	    keyboardView.setEnabled(true);
	}
	
	private void showLetter(int key) {
		ImageView imageView = (ImageView) findViewById(imageViewId[index]);
		Bitmap bitmap;
		String path;
		File file = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets" +
				File.separator + currentAlphabet + "_" + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).
				              indexOf(currentLanguage)][key]
				+ ".png");
		if(file.exists())
			path = file.getAbsolutePath();
		else
			path = null;
		if (path == null)
			bitmap = BitmapFactory.decodeResource(getResources(),
					MainActivity.RESOURCERAWINDEX[Arrays.asList(MainActivity.LANGUAGE).
							              indexOf(currentLanguage)][key]);
		else
			bitmap = BitmapFactory.decodeFile(path);
		 	
		Matrix matrix = new Matrix();
		float scale =  (float)height/bitmap.getHeight();
		matrix.setScale(scale, scale);
		Bitmap resized = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(),
				bitmap.getHeight(), matrix, false);
		imageView.setImageBitmap(resized);
		index++;
	}
	
	private void showBlank(boolean bkspace) {
		if(bkspace && index == 0)
			return;
		else if (bkspace)
			index--;
		//Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		Bitmap bitmap = BitmapFactory.decodeResource(getResources(), getBlank());
		Matrix matrix = new Matrix();
		float scale =  (float)height/bitmap.getHeight();
		matrix.setScale(scale, scale);
		Bitmap resized = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(),
				bitmap.getHeight(), matrix, false);
		ImageView imageView = (ImageView) findViewById
					(imageViewId[index]);
			imageView.setImageBitmap(resized);
		if(!bkspace) index++;
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu){
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.write_postcard, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
	    	case R.id.item_wp_share_postcard: {
	    		Bitmap bitmapPostcard = Bitmap.createBitmap(tableLayout.getWidth(), 
	    				tableLayout.getHeight(), Bitmap.Config.ARGB_8888);
	    		Canvas canvas = new Canvas(bitmapPostcard);
	    		tableLayout.draw(canvas);
	    		saveBitmap(bitmapPostcard);
	    		Intent intent = new Intent(this, ShareActivity.class);
	    		intent.putExtra("sharingWhat", "Postcard");
	    		startActivity(intent);
	    		return true;
	    	}
	    	case R.id.item_wp_save_postcard: {
	    		String username = mSharedPreferences.
	    				getString("username", "");
	    		if(username.isEmpty()) {
	    			saved = item;
	    			Intent setUsernameIntent = new Intent(this, SetUsernameActivity.class);
		    		startActivity(setUsernameIntent);
	    			return true;
	    		}
	    		String longitude = mSharedPreferences.
	    				getString("longitude", "0");
	    		String latitude = mSharedPreferences.
	    				getString("latitude", "0");
	    		Bitmap bitmapPostcard = Bitmap.createBitmap(tableLayout.getWidth(), 
	    				tableLayout.getHeight(), Bitmap.Config.ARGB_8888);
	    		Canvas canvas = new Canvas(bitmapPostcard);
	    		tableLayout.draw(canvas);
	    		if(mSharedPreferences.getBoolean("save", true))
	    			saveBitmap(bitmapPostcard);
	    		new UpdateDatabase(this, longitude, latitude,
	    				username, "no", "yes", "no", bitmapPostcard,
	    				currentLanguage, 
	    		new String(postcardText, 0, index)).execute();
	    		return true;
	    	}
	    	case R.id.item_wp_write_postcard: {
	    		resetPostcard();
	    		return true;
	    	}
	     	case R.id.item_wp_my_alphabets: {
	    		Intent myAlphabetsIntent = new Intent(this, MyAlphabetsActivity.class);
	    		startActivity(myAlphabetsIntent);
	    		finish();
	    		return true;
	     	}
	    	default:
	            return super.onContextItemSelected(item);
	    }
	}
	
	private void saveBitmap(Bitmap bitmap) {
		
		String filename = (String) android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss", new java.util.Date());
		File file = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets" + 
				File.separator + filename + ".png");
		try {
			FileOutputStream fos = new FileOutputStream(file);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			bitmap.compress(CompressFormat.PNG, 100, bos);
			bos.flush();
			fos.close();
		} catch (IOException e) {
		}
		
		Editor e = mSharedPreferences.edit();
		e.putString("lastShare", filename);
		e.commit();
		
		// Adding to gallery
		ContentValues image = new ContentValues();
		image.put(Images.Media.DATA, file.getAbsolutePath());
		getContentResolver().
			insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
		
	}
	
	public void onResume() {
		super.onResume();
		if (saved != null) {
			onOptionsItemSelected(saved);
			saved = null;
		}
	}
	
	
	private int getBlank() {
		return R.raw.letter_empty;
	}
	
	private void resetPostcard() {
		index = 0;
		setBlank();
		showCustomKeyboard();
	}
	
	private void setBlank() {
		Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		for (int i = 0; i< 42; i++){
			ImageView imageView = (ImageView) findViewById(imageViewId[i]);
			imageView.setImageBitmap(bitmap);
		}
	}
	
	public void onClickMenu(View v) {
		openOptionsMenu();
	}
	
	public void onClickTakePhoto(View v) {
		Intent takePhotoIntent = new Intent(this, TakePhotoActivity.class);
		startActivity(takePhotoIntent);
	}
	
	public void onClickAbc(View v) {
		finish();
	}
	
	@Override 
	public void onBackPressed() {
	    if( isCustomKeyboardVisible() )
	    	hideCustomKeyboard();
	    else
	    	super.onBackPressed();
	}
	
	private boolean isCustomKeyboardVisible() {
		   return keyboardView.getVisibility() == View.VISIBLE;
	}
	
	private OnKeyboardActionListener onKeyboardActionListener = new OnKeyboardActionListener() {
	    @Override 
	    public void onKey(int primaryCode, int[] keyCodes) {
	
	    	if (primaryCode == -1)
	    		return;
	    	else if(primaryCode == 42 ) { 
	    		postcardText[index] = ' ';
	    		showBlank(false);
	    	}
	    	else if(primaryCode == 43)
	    		showBlank(true);
	    	else if(primaryCode == 44)
	    		hideCustomKeyboard();
	    	else if(primaryCode == 315) {
	    		showLetter(18); // LatvL
	    		postcardText[index] = MainActivity.LETTER[Arrays.
	    		                      asList(MainActivity.LANGUAGE).indexOf(currentLanguage)][18];
	    	}
	    	else {
	    		postcardText[index] = MainActivity.LETTER[Arrays.
	    		                      asList(MainActivity.LANGUAGE).indexOf(currentLanguage)][primaryCode];
	    		showLetter(primaryCode);
	    	}
	    }

	    @Override 
	    public void onPress(int arg0) {
	    }

	    @Override 
	    public void onRelease(int primaryCode) {
	    }

	    @Override 
	    public void onText(CharSequence text) {
	    }

	    @Override 
	    public void swipeDown() {
	    }

	    @Override 
	    public void swipeLeft() {
	    }

	    @Override 
	    public void swipeRight() {
	    }

	    @Override 
	    public void swipeUp() {
	    }
	};
}