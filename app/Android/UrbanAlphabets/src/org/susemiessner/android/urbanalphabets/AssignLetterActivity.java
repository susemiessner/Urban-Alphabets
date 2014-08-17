package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;

import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Bitmap.CompressFormat;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class AssignLetterActivity extends ActionBarActivity {
	private int imageViewId [] = {
			R.id.imageview_assign_letter_1, R.id.imageview_assign_letter_2,
			R.id.imageview_assign_letter_3, R.id.imageview_assign_letter_4,
			R.id.imageview_assign_letter_5, R.id.imageview_assign_letter_6, 
			R.id.imageview_assign_letter_7, R.id.imageview_assign_letter_8,
			R.id.imageview_assign_letter_9, R.id.imageview_assign_letter_10,
			R.id.imageview_assign_letter_11, R.id.imageview_assign_letter_12,
			R.id.imageview_assign_letter_13, R.id.imageview_assign_letter_14,
			R.id.imageview_assign_letter_15, R.id.imageview_assign_letter_16,
			R.id.imageview_assign_letter_17, R.id.imageview_assign_letter_18,
			R.id.imageview_assign_letter_19, R.id.imageview_assign_letter_20,
			R.id.imageview_assign_letter_21, R.id.imageview_assign_letter_22,
			R.id.imageview_assign_letter_23, R.id.imageview_assign_letter_24,
			R.id.imageview_assign_letter_25, R.id.imageview_assign_letter_26,
			R.id.imageview_assign_letter_27, R.id.imageview_assign_letter_28,
			R.id.imageview_assign_letter_29, R.id.imageview_assign_letter_30,
			R.id.imageview_assign_letter_31, R.id.imageview_assign_letter_32,
			R.id.imageview_assign_letter_33, R.id.imageview_assign_letter_34,
			R.id.imageview_assign_letter_35, R.id.imageview_assign_letter_36, 
			R.id.imageview_assign_letter_37, R.id.imageview_assign_letter_38,
			R.id.imageview_assign_letter_39, R.id.imageview_assign_letter_40,
			R.id.imageview_assign_letter_41, R.id.imageview_assign_letter_42
			};
	private List<Integer> imageViewIdList;
	private int selected;
	private LinearLayout linearLayout;
	private int height;
	private SharedPreferences mSharedPreferences;
	private View saved;
	private String currentAlphabet;
	private String currentLanguage;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_assign_letter);
		imageViewIdList = new ArrayList<>();
		for(int i = 0; i < 42; i++)
			imageViewIdList.add(imageViewId[i]);
		saved = null;
		ImageView imageView = (ImageView) findViewById (R.id.imageview_assign_letter);
		imageView.setImageBitmap(BitmapFactory.decodeFile(getFilesDir()+File.separator+"photo.png"));
		mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
		currentLanguage = mSharedPreferences.getString("currentLanguage", "");
		selected = -1;
		linearLayout = (LinearLayout) findViewById
				(R.id.layout_assign_letter);
		ViewTreeObserver vto = linearLayout.getViewTreeObserver();
		vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
			@SuppressWarnings("deprecation")
			@Override
			public void onGlobalLayout() { 
				if (Build.VERSION.SDK_INT < 16)
					linearLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				else 
					linearLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				ImageView imageView = (ImageView) 
						findViewById(R.id.imageview_assign_letter_1);
				height = imageView.getHeight();
				new FillTableLayout().execute();
			}
		});
	}
	
	public void onClick(View v) {
		ImageButton imageButton = (ImageButton) findViewById(R.id.imagebutton_assign_letter);
		if(imageButton.getVisibility() == View.GONE)
			imageButton.setVisibility(View.VISIBLE);
		if(selected != -1 ){
			ImageView imageView = (ImageView) findViewById (imageViewId[selected]);
			imageView.clearColorFilter();
		}
			
		selected = imageViewIdList.indexOf(v.getId());
		ImageView imageView = (ImageView)v;
		imageView.setColorFilter(Color.argb(0x80, 0xC2, 0xF7, 0x9E));
	}
	
	public void onClickAssign(View v) {
		boolean save = mSharedPreferences.getBoolean("save", true);
		if (save)
			assignPhoto();
		String username = mSharedPreferences.getString("username", "");
		if (username.isEmpty()) {
			saved = v;
			Intent setUsernameIntent = new Intent(this, SetUsernameActivity.class);
    		startActivity(setUsernameIntent);
    		return;
		}
		update();
	}
	
	private void assignPhoto() {
		File file = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets" +
				File.separator + currentAlphabet + "_" + Data.RESOURCERAWNAME[Arrays.asList
				(Data.LANGUAGE).indexOf(currentLanguage)]
				[selected] + ".png");
		try {
			FileOutputStream fos = new FileOutputStream(file);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
			BitmapFactory.decodeFile(getFilesDir()+File.separator+"photo.png").compress(CompressFormat.PNG, 100, bos);
	        bos.flush();
			fos.close();
		} catch(Exception e) {
		}
		
		ContentValues image = new ContentValues();
		image.put(Images.Media.DATA, file.getAbsolutePath());
		getContentResolver().
			insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);		
	}
	
	private void update() {
		String username = mSharedPreferences.getString("username", "");
		String longitude = mSharedPreferences.getString("longitude", "0");
		String latitude = mSharedPreferences.getString("latitude", "0");
		UpdateDatabase update = new UpdateDatabase(this, longitude,
				latitude,
				username,
				String.valueOf(Data.LETTER[Arrays.asList(Data.LANGUAGE).indexOf(currentLanguage)][selected]),
				"no", "no", BitmapFactory.decodeFile
				(getFilesDir()+File.separator+"photo.png"),
				currentLanguage, "");
		update.execute();
		try {
		update.get();
		} catch (CancellationException e) {
			
		} catch (ExecutionException e) {
			
		} catch (InterruptedException e) {
			
		}
		setResult(2);
		finish();
	}
	
	public void onResume() {
		super.onResume();
		if(saved != null) {
			update();
			saved = null;
		}
	}

    public class FillTableLayout extends AsyncTask<Void, Void, Void> {

    	ProgressDialog pDialog;
    	
    	@Override
    	protected void onPreExecute() {
    		super.onPreExecute();
    		pDialog = new ProgressDialog(AssignLetterActivity.this);
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
						String path;
						File file = new File(Environment.getExternalStoragePublicDirectory
								(Environment.DIRECTORY_DCIM), "UrbanAlphabets" +
								File.separator + currentAlphabet + "_" + Data.RESOURCERAWNAME[Arrays.asList(Data.LANGUAGE).
								              indexOf(currentLanguage)][index]
								+ ".png");
						if(file.exists())
							path = file.getAbsolutePath();
						else
							path = null;
						if (path == null) {
							bitmap = BitmapFactory.decodeResource(getResources(),
									Data.RESOURCERAWINDEX[Arrays.asList(Data.LANGUAGE).
											              indexOf(currentLanguage)][index]);
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
