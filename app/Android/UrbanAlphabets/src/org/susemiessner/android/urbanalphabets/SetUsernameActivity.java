package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.EditText;

public class SetUsernameActivity extends Activity {
	private EditText editTextUsername;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_set_username);
		editTextUsername = (EditText)findViewById(R.id.edittext_set_username);
	}
	
	public void onClickOk(View v) {
		String username = editTextUsername.getText().toString();
		if(username != null && !username.isEmpty()) {
			SharedPreferences mSharedPreferences = PreferenceManager.
					getDefaultSharedPreferences(getApplicationContext());
			Editor e = mSharedPreferences.edit();
			e.putString("username", username);
			e.commit();
		}
		finish();
	}
}
