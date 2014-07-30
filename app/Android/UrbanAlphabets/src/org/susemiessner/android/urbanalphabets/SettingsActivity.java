package org.susemiessner.android.urbanalphabets;

import android.support.v7.app.ActionBarActivity;
import android.widget.TextView;
import android.content.SharedPreferences;
import android.os.Bundle;

public class SettingsActivity extends ActionBarActivity {

	private TextView textViewUsername;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_settings);
		textViewUsername = (TextView)findViewById(R.id.textview_username);
		SharedPreferences mSharedPreferences = getPreferences(MODE_PRIVATE);
		
		textViewUsername.setText(mSharedPreferences.getString("username", "defvalue"));
	}


}
