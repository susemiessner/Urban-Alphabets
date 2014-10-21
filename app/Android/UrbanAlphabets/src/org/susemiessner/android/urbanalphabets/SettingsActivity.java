package org.susemiessner.android.urbanalphabets;

import android.support.v7.app.ActionBarActivity;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.preference.PreferenceManager;

public class SettingsActivity extends ActionBarActivity {

	private TextView textViewUsername;
	private TextView textViewDefaultLang;
	private EditText editTextUsername;
	private SharedPreferences mSharedPreferences;
	private CheckBox checkBoxSave;
	private CheckBox checkBoxLocation;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_settings);
		textViewUsername = (TextView)findViewById(R.id.textview_username);
		textViewDefaultLang = (TextView)findViewById(R.id.textview_default_language);
		editTextUsername = (EditText)findViewById(R.id.edittext_username);
		checkBoxSave = (CheckBox)findViewById(R.id.checkbox_save_on_device);
		checkBoxLocation = (CheckBox)findViewById(R.id.checkbox_location);
		mSharedPreferences  = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		textViewUsername.setText(mSharedPreferences.getString("username", "none"));
		textViewDefaultLang.setText(MainActivity.LANGUAGE[mSharedPreferences.getInt("defaultLang", 0)]);
		checkBoxLocation.setChecked(mSharedPreferences.getBoolean("enableLocation", true));
		checkBoxSave.setChecked(mSharedPreferences.getBoolean("save", true));
		editTextUsername.setOnKeyListener(new View.OnKeyListener() {
			@Override
		    public boolean onKey(View v, int keyCode, KeyEvent event) {
		        // If the event is a key-down event on the "enter" button
		        if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
		            (keyCode == KeyEvent.KEYCODE_ENTER)) {
		        	// Perform action on key press
		        	String username = editTextUsername.getText().toString();
		        	if (username != null && !username.isEmpty()) { 
		        		Editor e = mSharedPreferences.edit();
		        		e.putString("username",username);
		        		e.commit();
		        	}
		        	editTextUsername.setVisibility(View.GONE);
		      		textViewUsername.setVisibility(View.VISIBLE);
		      		textViewUsername.setText(mSharedPreferences.
		      				getString("username", "defaultUser"));
		      		return true;
		        }
		        return false;
		    }
		});
	}
	
	public void onClickChangeUsername(View v) {
		textViewUsername.setVisibility(View.GONE);
		editTextUsername.setVisibility(View.VISIBLE);
		editTextUsername.setText("");
		InputMethodManager keyboard = (InputMethodManager)
                getSystemService(Context.INPUT_METHOD_SERVICE);
		editTextUsername.requestFocus();
        keyboard.showSoftInput(editTextUsername, 0);
	}
	
	public void onClickChangeDefaultLanguage(View v) {
		Intent changeDefaultLanguageIntent = new Intent(this, 
				ChangeDefaultLanguageActivity.class);
		startActivity(changeDefaultLanguageIntent);
		finish();
	}
	
	public void onClickEnableLocation(View v) {
		boolean value = checkBoxLocation.isChecked();
		Editor e = mSharedPreferences.edit();
		e.putBoolean("enableLocation", value);
		if(!value) {
			e.putString("longitude", "0");
    		e.putString("latitude", "0");
		}
		e.commit();
	}
	
	public void onClickSave(View v) {
		boolean value = checkBoxSave.isChecked();
		Editor e = mSharedPreferences.edit();
		e.putBoolean("save", value);
		e.commit();
	}
	
	public void onClickOk(View v) {
		finish();
	}
}
