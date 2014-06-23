package org.susemiessner.android.urbanalphabets;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.inputmethodservice.Keyboard;
import android.inputmethodservice.KeyboardView;
import android.inputmethodservice.KeyboardView.OnKeyboardActionListener;
import android.os.Build;
import android.os.Bundle;
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
		Intent intent = getIntent();
		String username = intent.getStringExtra("username");
		String longitude = intent.getStringExtra("longitude");
		String latitude = intent.getStringExtra("latitude");
		if(username != null && !username.isEmpty())
			setUsername(username);
		if(longitude != null && latitude != null 
				&& !longitude.isEmpty() && !latitude.isEmpty())
			setLocation(longitude, latitude);
		
		
		index = 0;
		postcardText = new char[42];
		tableLayout = (TableLayout) findViewById
				(R.id.tableview_write_postcard);
		// Create the Keyboard
	    Keyboard keyboard= new Keyboard(WritePostcardActivity.this, 
	    		customKeyboard[Data.getCurrentLanguageIndex()]);

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
	
	private void setLocation(String longitude, String latitude) {
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		Editor e = mSharedPreferences.edit();
		e.putString("longitude",longitude);
		e.putString("latitude", latitude);
		e.commit();
	}
	
	private String getUsername() {
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		return mSharedPreferences.getString("username", "");
	}
	
	private void setUsername(String username) {
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		Editor e = mSharedPreferences.edit();
		e.putString("username", username);
		e.commit();
	}
	
	private String getLongitude() {
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		return mSharedPreferences.getString("longitude", "0");
	}
	
	private String getLatitude() {
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		return mSharedPreferences.getString("latitude", "0");
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
		String path = Data.getLetterPath(key);
		if (path == null)
			bitmap = BitmapFactory.decodeResource(getResources(),
					Data.getRawResourceId(key));
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
		Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		ImageView imageView = (ImageView) findViewById
					(imageViewId[index]);
			imageView.setImageBitmap(bitmap);
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
	    		Data.saveBitmapAsPNG(bitmapPostcard);
	    		Intent intent = new Intent(this, ShareActivity.class);
	    		intent.putExtra("sharingWhat", "Postcard");
	    		startActivity(intent);
	    		return true;
	    	}
	    	case R.id.item_wp_save_postcard: {
	    		Bitmap bitmapPostcard = Bitmap.createBitmap(tableLayout.getWidth(), 
	    				tableLayout.getHeight(), Bitmap.Config.ARGB_8888);
	    		Canvas canvas = new Canvas(bitmapPostcard);
	    		tableLayout.draw(canvas);
	    		new UpdateDatabase(this, getLongitude(), getLatitude(),
	    				getUsername(), "no", "yes", "no", bitmapPostcard,
	    				Data.getSelectedAlphabetLanguage(), 
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
	    		return true;
	     	}
	    	default:
	            return super.onContextItemSelected(item);
	    }
	}
	
	private void resetPostcard() {
		index = 0;
		setBlank();
		showCustomKeyboard();
	}
	
	private void setBlank() {
		Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		for (int i = 0; i< Data.MAX; i++){
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
	    		postcardText[index] = Data.LETTER[Data. getSelectedLanguageIndex()][18];
	    	}
	    	else {
	    		postcardText[index] = Data.LETTER[Data. getSelectedLanguageIndex()][primaryCode];
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