package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;

public class SplashActivity extends Activity {
	private SharedPreferences  mSharedPreferences;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);
		mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		// Create UrbanAlphabets directory in external storage
		File file = new File(Environment.getExternalStoragePublicDirectory
						(Environment.DIRECTORY_DCIM), "UrbanAlphabets");
		if(!file.exists())
			file.mkdirs();
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
            	if(mSharedPreferences.getBoolean("isFirstRun", true)) {
            		setIsFirstRun();
        			Intent welcomeIntent = new Intent(SplashActivity.this,
        					WelcomeActivity.class);
        			startActivity(welcomeIntent);
        		}
            	else {
            		upgrade();
            		Intent mainIntent = new Intent(SplashActivity.this,
            				MainActivity.class);
            		startActivity(mainIntent);
            	}
                finish();
            }
        }, 2 * 1000); // Two seconds 
	}
	
	private void setIsFirstRun() {
		Editor e = mSharedPreferences.edit();
		e.putBoolean("isFirstRun", false);
		e.commit();
	}
	
	private void upgrade() {
		if(mSharedPreferences.getBoolean("upgrade", true)) {
			// Set upgrade false
			Editor e = mSharedPreferences.edit();
			e.putBoolean("upgrade", false);
			e.commit();
			// Get alphabets list
			SQLiteDatabase mDatabase = null;
			List<Alphabet> listAlphabet = new ArrayList<Alphabet>();
		
			File file = new File(getApplicationContext().getFilesDir().getPath() + File.separator
								+ "databases" + File.separator + "db.sqlite");
			// Create or open database
			try{
				mDatabase = SQLiteDatabase.openDatabase(file.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
			} catch (SQLiteException ex) {
			}
			
			Cursor  cursor = mDatabase.rawQuery("select * from alphabets", null);
			if (cursor.moveToFirst()) {
				while (cursor.isAfterLast() == false) {
					listAlphabet.add(new Alphabet(cursor.getString(cursor
							.getColumnIndex("alphabet")), cursor.getString(cursor
									.getColumnIndex("language"))));
                cursor.moveToNext();
				}
			}
			mDatabase.close();
			// Copying photos to new storage format
			for(Alphabet alphabet: listAlphabet) {
				File f = new File(Environment.getExternalStoragePublicDirectory
						(Environment.DIRECTORY_DCIM), "UrbanAlphabets" +
						File.separator + alphabet.getName());
				if(f.exists() && f.isDirectory()) {
					File files[] = f.listFiles();
					for(File gf : files) {
						if(gf.isFile()) {
							File newgf = new File(Environment.getExternalStoragePublicDirectory
									(Environment.DIRECTORY_DCIM), "UrbanAlphabets" +
											File.separator + alphabet.getName() + "_" + gf.getName());
							gf.renameTo(newgf);
							getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
									Images.Media.DATA + " LIKE ?", new String[]{gf.getAbsolutePath()});
							ContentValues image = new ContentValues();
							image.put(Images.Media.DATA, newgf.getAbsolutePath());
							getContentResolver().
								insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
						}
					}
					f.delete();
				}
			}
		}
	}
}
