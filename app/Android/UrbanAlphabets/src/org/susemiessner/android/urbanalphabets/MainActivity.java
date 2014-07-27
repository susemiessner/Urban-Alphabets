package org.susemiessner.android.urbanalphabets;

import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TableLayout;

public class MainActivity extends ActionBarActivity {
	private int imageViewId [] = {R.id.imageview_main_1, R.id.imageview_main_2,
			R.id.imageview_main_3, R.id.imageview_main_4, R.id.imageview_main_5,
			R.id.imageview_main_6, R.id.imageview_main_7, R.id.imageview_main_8,
			R.id.imageview_main_9, R.id.imageview_main_10, R.id.imageview_main_11, 
			R.id.imageview_main_12, R.id.imageview_main_13, R.id.imageview_main_14,
			R.id.imageview_main_15, R.id.imageview_main_16, R.id.imageview_main_17,
			R.id.imageview_main_18, R.id.imageview_main_19, R.id.imageview_main_20,
			R.id.imageview_main_21, R.id.imageview_main_22, R.id.imageview_main_23,
			R.id.imageview_main_24, R.id.imageview_main_25, R.id.imageview_main_26,
			R.id.imageview_main_27, R.id.imageview_main_28, R.id.imageview_main_29,
			R.id.imageview_main_30, R.id.imageview_main_31, R.id.imageview_main_32,
			R.id.imageview_main_33, R.id.imageview_main_34, R.id.imageview_main_35,
			R.id.imageview_main_36, R.id.imageview_main_37, R.id.imageview_main_38,
			R.id.imageview_main_39, R.id.imageview_main_40, R.id.imageview_main_41,
			R.id.imageview_main_42};
	
	private ActionBar actionBar;
	private int height;
	private List<Integer> imageViewIdList;
	private LinearLayout linearLayout;
	private TableLayout tableLayout;
	private LocationManager mlocManager;
	private LocationListener mlocListener;
	private String username;
	
	@SuppressLint("NewApi")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		Intent intent = getIntent();
		username = intent.getStringExtra("Username");
		if(username.equals("None")) {
			username = getUsername();
		} else {
			setUsername(username);
		}
		Data.init(getApplicationContext());
		actionBar = getSupportActionBar();
		actionBar.setTitle(Data.getSelectedAlphabetName());
		imageViewIdList = new ArrayList<>();
		for(int i = 0; i < 42; i++)
			imageViewIdList.add(imageViewId[i]);
		linearLayout= (LinearLayout) findViewById
				(R.id.layout_main);
		tableLayout = (TableLayout) findViewById(R.id.tableview_main);
		mlocManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
		mlocListener = new MyLocationListener();
		
		ViewTreeObserver vto = linearLayout.getViewTreeObserver();
		vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
			@SuppressWarnings("deprecation")
			@Override
			public void onGlobalLayout() {
				if (Build.VERSION.SDK_INT < 16)
					linearLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				else 
					linearLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				ImageView imageView = (ImageView) findViewById(R.id.imageview_main_1);
				height = imageView.getHeight();
				new FillTableLayout().execute();
			}
		});
	}
	
	@Override
	protected void onRestart() {
		super.onRestart();
		Data.init(getApplicationContext());
		actionBar.setTitle(Data.getSelectedAlphabetName());
		new FillTableLayout().execute();
		//if(Data.updatePending()) {
		//	new UpdateDatabase(this, getLongitude(),
		//		getLatitude(),
		//		username,
		//		Data.getLetterName(),
		//		"no", "no", BitmapFactory.decodeFile
		//		(Data.getPathToRecentlyAssigned()),
		//		Data.getSelectedAlphabetLanguage(), "").execute();
		//}
	}
		
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.main, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    switch (item.getItemId()) {
	    	case R.id.item_alphabet_info: {
	    		Intent alphabetInfoIntent = new Intent(this, AlphabetInfoActivity.class);
	    		startActivity(alphabetInfoIntent);
	    		return true;
	    	}
	    	case R.id.item_share_alphabet: {
	    		Bitmap bitmapAlphabet = Bitmap.createBitmap(tableLayout.getWidth(), 
	    				tableLayout.getHeight(), Bitmap.Config.ARGB_8888);
	    		Canvas canvas = new Canvas(bitmapAlphabet);
	    		tableLayout.draw(canvas);
	    		Data.saveBitmapAsPNG(bitmapAlphabet);
	    		Intent shareIntent = new Intent(this, ShareActivity.class);
	    		shareIntent.putExtra("sharingWhat", "Alphabet");
	    		startActivity(shareIntent);
	    		return true;
	    	}
	    	case R.id.item_save_alphabet: {
	    		Bitmap bitmapAlphabet = Bitmap.createBitmap(tableLayout.getWidth(), 
	    				tableLayout.getHeight(), Bitmap.Config.ARGB_8888);
	    		Canvas canvas = new Canvas(bitmapAlphabet);
	    		tableLayout.draw(canvas);
	    		new UpdateDatabase(this, getLongitude(),
	    				getLatitude(),
	    				username,
	    				"no", "no", "yes", bitmapAlphabet,
	    				Data.getSelectedAlphabetLanguage(), "").execute();
	    		return true;
	    	}
	    	case R.id.item_write_postcard:{
	    		Intent writePostcardIntent = new Intent(this, WritePostcardActivity.class);
	    		writePostcardIntent.putExtra("username", getUsername());
	    		writePostcardIntent.putExtra("longitude", getLongitude());
	    		writePostcardIntent.putExtra("latitude", getLatitude());
	    		startActivity(writePostcardIntent);
	    		return true;
	    	}
	    	case R.id.item_my_alphabets: {
	    		Intent myAlphabetsIntent = new Intent(this, MyAlphabetsActivity.class);
	    		startActivity(myAlphabetsIntent);
	    		return true;
	    	}
	        default:
	            return super.onContextItemSelected(item);
	    }
	}
	
	public void onClick(View v) {
		Intent viewLetterIntent = new Intent(this, ViewLetterActivity.class);
		viewLetterIntent.putExtra("currentAlphabet", 
				Data.getSelectedAlphabetName());
		viewLetterIntent.putExtra("currentLanguage", 
				Data.getSelectedAlphabetLanguage());
		viewLetterIntent.putExtra("currentIndex", imageViewIdList.indexOf(v.getId()));
		startActivity(viewLetterIntent);
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
	
	private void setLocation(String longitude, String latitude) {
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		Editor e = mSharedPreferences.edit();
		e.putString("longitude",longitude);
		e.putString("latitude", latitude);
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
	
	public void onClickMenu(View v) {
		openOptionsMenu();
	}
	
	public void onClickTakePhoto(View v) {
		Intent takePhotoIntent = new Intent(this, TakePhotoActivity.class);
		startActivity(takePhotoIntent);
	}

	public void onResume() {
		super.onResume();
		mlocManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000,
				0, mlocListener);
		mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 
					0, mlocListener);
	}
	
	public void onPause() {
		super.onPause();
		mlocManager.removeUpdates(mlocListener);
	}
	
	/* Class My Location Listener */
    public class MyLocationListener implements LocationListener {
    	@Override
    	public void onLocationChanged(Location loc) {
    		Double latitude = loc.getLatitude();
    		Double longitude = loc.getLongitude();
    		setLocation(Double.toString(longitude), Double.toString(latitude));
    	}
    	
    	@Override
    	public void onProviderDisabled(String provider) {
    		runOnUiThread(new Runnable() {
    			@Override
    			public void run() {
    				AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
    				builder.setPositiveButton("Share location", 
    						new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog, int id) {
    						// User clicked OK button
    						MainActivity.this.startActivity(new Intent
    								(android.provider.Settings.ACTION_LOCATION_SOURCE_SETTINGS));
    						dialog.dismiss();
    					}
    				});
    				builder.setNegativeButton("Decline",
    						new DialogInterface.OnClickListener() {
    					public void onClick(DialogInterface dialog, int id) {
    						dialog.cancel();
    						// User cancelled the dialog
    					}
    				});
    				AlertDialog dialog = builder.create();
    				dialog.setMessage("UrbanAlphabets wants to know your location.");
    				Window window = dialog.getWindow();
    			    window.setGravity(Gravity.BOTTOM);
    				dialog.show();
    			}
    		});
    	}

    	@Override
    	public void onProviderEnabled(String provider) {
    	}

    	@Override
    	public void onStatusChanged(String provider, int status, Bundle extras) {

    	}
    }
    
    public class FillTableLayout extends AsyncTask<Void, Void, Void> {

    	ProgressDialog pDialog;
    	
    	@Override
    	protected void onPreExecute() {
    		super.onPreExecute();
    		pDialog = new ProgressDialog(MainActivity.this);
            pDialog.setMessage("Loading Letters.");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
    	}
    	
		@Override
		protected Void doInBackground(Void... params) {
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					for (int index = 0; index < Data.MAX; index++) {
						ImageView imageView = (ImageView) findViewById
								(imageViewId[index]);
						Bitmap bitmap;
						String path = Data.getLetterPath(index);
						if (path == null) {
							bitmap = BitmapFactory.decodeResource(getResources(),
									Data.getRawResourceId(index));
						}
						else {
							bitmap = BitmapFactory.decodeFile(path);
						}
						Matrix matrix = new Matrix();
						float scale = (float)((float)height/(float)(bitmap.getHeight()));
						matrix.setScale(scale, scale);
						Bitmap resized = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(),
								bitmap.getHeight(), matrix, false);
						imageView.setImageBitmap(resized);
					}
				}
			});
			return null;
		}
    	
		@Override
		protected void onPostExecute(Void arg){
			pDialog.dismiss();
		}
    }
}
