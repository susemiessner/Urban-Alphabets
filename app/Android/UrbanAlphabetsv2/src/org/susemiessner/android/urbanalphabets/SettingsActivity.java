package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;

public class SettingsActivity extends Activity {
  private TextView mTextViewUsername;
  private TextView mTextViewDefaultLang;
  private EditText mEditTextUsername;
  private SharedPreferences mSharedPreferences;
  private CheckBox mCheckBoxLocation;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_settings);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mTextViewUsername = (TextView) findViewById(R.id.textView_username);
    mTextViewDefaultLang = (TextView) findViewById(R.id.textView_default_language);
    mEditTextUsername = (EditText) findViewById(R.id.editText_username);
    mCheckBoxLocation = (CheckBox) findViewById(R.id.checkBox_location);
    mTextViewUsername.setText(mSharedPreferences.getString("username", "none"));
    mTextViewDefaultLang
        .setText(MainActivity.LANGUAGE[mSharedPreferences.getInt("defaultLang", 0)]);
    mCheckBoxLocation.setChecked(mSharedPreferences.getBoolean("enableLocation", true));
    mEditTextUsername.setOnKeyListener(new View.OnKeyListener() {
      @Override
      public boolean onKey(View v, int keyCode, KeyEvent event) {
        // If the event is a key-down event on the "enter" button
        if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
          // Perform action on key press
          String username = mEditTextUsername.getText().toString();
          if (username != null && !username.isEmpty()) {
            mTextViewUsername.setText(username);
            Editor e = mSharedPreferences.edit();
            e.putString("username", username);
            e.commit();
          }
          mEditTextUsername.setVisibility(View.GONE);
          mTextViewUsername.setVisibility(View.VISIBLE);
          return true;
        }
        return false;
      }
    });
  }

  public void changeUsername(View view) {
    mTextViewUsername.setVisibility(View.GONE);
    mEditTextUsername.setVisibility(View.VISIBLE);
    mEditTextUsername.setText("");
    InputMethodManager keyboard =
        (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    mEditTextUsername.requestFocus();
    keyboard.showSoftInput(mEditTextUsername, 0);
  }

  public void changeDefaultLanguage(View view) {
    Intent changeDefaultLanguageIntent = new Intent(this, ChangeDefaultLanguageActivity.class);
    startActivity(changeDefaultLanguageIntent);
    finish();
  }

  public void enableLocation(View view) {
    boolean value = mCheckBoxLocation.isChecked();
    Editor e = mSharedPreferences.edit();
    e.putBoolean("enableLocation", value);
    if (!value) {
      e.putString("longitude", "0");
      e.putString("latitude", "0");
    }
    e.commit();
  }

  public void onOk(View view) {
    finish();
  }

}
