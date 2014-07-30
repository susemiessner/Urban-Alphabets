package org.susemiessner.android.urbanalphabets;

import android.support.v7.app.ActionBarActivity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.ToggleButton;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.preference.PreferenceManager;

public class SettingsActivity extends ActionBarActivity {

	private TextView textViewUsername;
	private TextView textViewDefaultLang;
	private ToggleButton toggleButtonGeoLocation;
	private EditText editTextUsername;
	private SharedPreferences mSharedPreferences;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_settings);
		textViewUsername = (TextView)findViewById(R.id.textview_username);
		textViewDefaultLang = (TextView)findViewById(R.id.textview_default_language);
		toggleButtonGeoLocation = (ToggleButton)findViewById(R.id.togglebutton_geolocation);
		editTextUsername = (EditText)findViewById(R.id.edittext_username);
		mSharedPreferences  = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());;
		
		textViewUsername.setText(mSharedPreferences.getString("username", "username"));
		textViewDefaultLang.setText(mSharedPreferences.getString("defaultLang", "Finnish/Swedish"));
		toggleButtonGeoLocation.setChecked(mSharedPreferences.getBoolean("geolocation", false));
		
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
		      		textViewUsername.setText(mSharedPreferences.getString("username", "username"));
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
		editTextUsername.requestFocus();
	}
	
	public void onClickToggleButton(View view) {
	    boolean on = ((ToggleButton) view).isChecked();
	    Editor e = mSharedPreferences.edit();
		e.putBoolean("geolocation", on);
		e.commit();
	}

}
