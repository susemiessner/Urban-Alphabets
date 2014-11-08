package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;
import android.preference.PreferenceManager;

public class SplashActivity extends Activity {
  private SharedPreferences mSharedPreferences;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_splash);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    new Handler().postDelayed(new Runnable() {
      @Override
      public void run() {
        if (mSharedPreferences.getBoolean("isFirstRun", true)) {
          setIsFirstRun();
          Intent welcomeIntent = new Intent(SplashActivity.this, WelcomeActivity.class);
          startActivity(welcomeIntent);
        } else {
          Intent mainIntent = new Intent(SplashActivity.this, MainActivity.class);
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

}
