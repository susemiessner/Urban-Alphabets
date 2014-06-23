package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;

public class SplashActivity extends Activity {
	private static SharedPreferences  mSharedPreferences;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_splash);
		mSharedPreferences = getPreferences(MODE_PRIVATE);
		Data.createStorageDir();
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
            	if(mSharedPreferences.getBoolean("isFirstRun", true)) {
            		setIsFirstRun(false);
        			Intent welcomeIntent = new Intent(SplashActivity.this,
        					WelcomeActivity.class);
        			startActivity(welcomeIntent);
        		}
            	else {
            		Intent mainIntent = new Intent(SplashActivity.this,
            				MainActivity.class);
            		mainIntent.putExtra("Username", "None");
            		startActivity(mainIntent);
            	}
                finish();
            }
        }, 2 * 1000); // Two seconds 
	}
	
	private void setIsFirstRun(boolean state) {
		Editor e = mSharedPreferences.edit();
		e.putBoolean("isFirstRun", state);
		e.commit();
	}
}
