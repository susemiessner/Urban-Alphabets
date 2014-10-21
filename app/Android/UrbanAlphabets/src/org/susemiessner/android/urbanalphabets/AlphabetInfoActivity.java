package org.susemiessner.android.urbanalphabets;

import java.io.File;

import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v7.app.ActionBarActivity;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

public class AlphabetInfoActivity extends ActionBarActivity {
	private TextView textViewName;
	private TextView textViewLanguage;
	private EditText editTextName;
	private String currentAlphabet;
	private String currentLanguage;
	private SharedPreferences mSharedPreferences;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_alphabet_info);
		mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
		currentLanguage = mSharedPreferences.getString("currentLanguage", "");
		textViewName = (TextView) findViewById(R.id.textview_alphabet);
		textViewLanguage = (TextView) findViewById(R.id.textview_language);
		editTextName = (EditText) findViewById (R.id.edittext_alphabet);
		textViewName.setText(currentAlphabet);
		textViewLanguage.setText(currentLanguage);
		editTextName.setOnKeyListener(new View.OnKeyListener() {
			@Override
		    public boolean onKey(View v, int keyCode, KeyEvent event) {
		        // If the event is a key-down event on the "enter" button
		        if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
		            (keyCode == KeyEvent.KEYCODE_ENTER)) {
		          // Perform action on key press
		        	String newName = editTextName.getText().toString();
		        	if (newName != null && !newName.isEmpty()) { 
		        		changeAlphabetName(newName);
		        	}
		        	editTextName.setVisibility(View.GONE);
		      		textViewName.setVisibility(View.VISIBLE);
		      		textViewName.setText(currentAlphabet);
		      		return true;
		        }
		        return false;
		    }
		});
	}
	
	private void changeAlphabetName(String newName) {
		SQLiteDatabase mDatabase = null;
		
		File file = new File(getApplicationContext().getFilesDir().getPath() + File.separator
								+ "databases" + File.separator + "db.sqlite");
		// Create or open database
		try{
			mDatabase = SQLiteDatabase.openDatabase(file.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
		} catch (SQLiteException ex) {
		}
		ContentValues replaced = new ContentValues();
		replaced.put("alphabet", newName);
		try {
			mDatabase.update("alphabets", replaced, "alphabet=?", 
					new String[]{currentAlphabet});	
		} catch (SQLiteException ex) {
		}
		mDatabase.close();
		
		File folder =  new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets");
		File files[] = folder.listFiles(); 
		for(File f : files) {
			// locale
			if(f.isFile() && f.getName().toLowerCase().contains(currentAlphabet.toLowerCase())) {				
				File r = new File(Environment.getExternalStoragePublicDirectory
						(Environment.DIRECTORY_DCIM), "UrbanAlphabets" + File.separator +
				f.getName().replace(currentAlphabet, newName));
				
				f.renameTo(r);

				getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
						Images.Media.DATA + " LIKE ?", new String[]{f.getAbsolutePath()});
				
				ContentValues image = new ContentValues();
				image.put(Images.Media.DATA, r.getAbsolutePath());
				getContentResolver().
					insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
				
			}
		}
		
		currentAlphabet = newName;
		Editor e = mSharedPreferences.edit();
		e.putString("currentAlphabet", currentAlphabet);
		e.commit();
	}
	
	public void onClickChangeAlphabet(View v) {
		textViewName.setVisibility(View.GONE);
		editTextName.setVisibility(View.VISIBLE);
		editTextName.setText("");
		InputMethodManager keyboard = (InputMethodManager)
                getSystemService(Context.INPUT_METHOD_SERVICE);
		editTextName.requestFocus();
		keyboard.showSoftInput(editTextName, 0);
	}
	
	public void onClickChangeLanguage(View v) {
		Intent changeLanguageIntent = new Intent(this, ChangeLanguageActivity.class);
		startActivity(changeLanguageIntent);
		finish();
	}
	
	public void onClickReset(View v) {	
		delete();
		finish();
	}
	
	public void onClickDelete(View v) {
		delete();
		SQLiteDatabase mDatabase = null;
		
		File file = new File(getApplicationContext().getFilesDir().getPath() + File.separator
								+ "databases" + File.separator + "db.sqlite");
		// Create or open database
		try{
			mDatabase = SQLiteDatabase.openDatabase(file.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
		} catch (SQLiteException ex) {
		}
		// Delete alphabet 
		try {
			mDatabase.delete("alphabets","alphabet=?", new String[]{currentAlphabet});	
		} catch (SQLiteException ex) {
		}
		Cursor  cursor = mDatabase.rawQuery("select * from alphabets", null);
		if (cursor.moveToFirst()) {
			currentAlphabet = cursor.getString(cursor
                        .getColumnIndex("alphabet"));
			currentLanguage = cursor.getString(cursor
						.getColumnIndex("language"));
				
			// Set new selection if present else do nothing 
			ContentValues replaced = new ContentValues();
			replaced.put("selected", 1);
			try {
				mDatabase.update("alphabets", replaced, "alphabet=?", new String[]{currentAlphabet});	
			} catch (SQLiteException ex) {
			}
		}
		else {
			currentAlphabet = "";
			currentLanguage = "";
		}
		mDatabase.close();
		
		Editor e = mSharedPreferences.edit();
		e.putString("currentAlphabet", currentAlphabet);
		e.putString("currentLangauge", currentLanguage);
		e.commit();
		
		finish();
	}
	
	private void delete() {
		File folder =  new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets");
		File files[] = folder.listFiles();
		for(File file : files) {
			// locale
			if(file.isFile() && file.getName().toLowerCase().contains(currentAlphabet.toLowerCase())) {							
				file.delete();
				getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
						Images.Media.DATA + " LIKE ?", new String[]{file.getAbsolutePath()});
			}
		}
	}
}
