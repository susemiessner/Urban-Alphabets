package org.susemiessner.android.urbanalphabets;

import android.support.v7.app.ActionBarActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

public class WelcomeActivity extends ActionBarActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_welcome);
	}
	
	public void onClick(View v) {
		EditText editText = (EditText) findViewById (R.id.edittext_user_name);
		String username = editText.getText().toString();
		if (username != null && !username.isEmpty()) {
			Intent mainIntent = new Intent(this, MainActivity.class);
			mainIntent.putExtra("Username", username);
    		startActivity(mainIntent);
			finish();
		}	
	}
}
