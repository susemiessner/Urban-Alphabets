package org.susemiessner.android.urbanalphabets;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.View;

public class WelcomeActivity extends ActionBarActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_welcome);
	}
	
	public void onClick(View v) {
		finish();
	}
}
