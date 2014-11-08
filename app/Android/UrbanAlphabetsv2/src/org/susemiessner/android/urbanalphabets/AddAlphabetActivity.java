package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;

public class AddAlphabetActivity extends Activity {
  private CustomArrayAdapter mAdapter;
  private ImageButton mImageButton;
  private EditText mEditText;


  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_add_alphabet);
    mImageButton = (ImageButton) findViewById(R.id.imageButton_add_alphabet);
    mEditText = (EditText) findViewById(R.id.editText_alphabet_name);
    ListView listView = (ListView) findViewById(R.id.listView_add_alphabet);
    mAdapter = new CustomArrayAdapter(this, MainActivity.LANGUAGE, -1);
    listView.setAdapter(mAdapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (TextUtils.isEmpty(mEditText.getText().toString()))
          return;
        if (!mAdapter.isSelected(position)) {
          mAdapter.setSelected(position);
          mAdapter.notifyDataSetChanged();
        }
        if (mImageButton.getVisibility() == View.GONE)
          mImageButton.setVisibility(View.VISIBLE);
      }
    });
  }

  public void addAlphabet(View view) {
    if (TextUtils.isEmpty(mEditText.getText().toString()))
      return;
    addAlphabet(mEditText.getText().toString(), mAdapter.getSelected());
    finish();
  }

  private void addAlphabet(String name, int lang) {
    SQLiteDatabase database = null;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    /*
     * Clear previous selection if present, else do nothing
     */
    ContentValues replaced = new ContentValues();
    replaced.put("selected", 0);
    try {
      database.update("alphabets", replaced, "selected=1", null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    /*
     * Add new alphabet
     */
    ContentValues alphabet = new ContentValues();
    alphabet.put("alphabet", name);
    alphabet.put("language", MainActivity.LANGUAGE[lang]);
    alphabet.put("selected", 1);
    try {
      database.insert("alphabets", null, alphabet);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    database.close();
    /*
     * Save as preferences
     */
    SharedPreferences sharedPreferences =
        PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    Editor e = sharedPreferences.edit();
    e.putString("currentAlphabet", name);
    e.putString("currentLanguage", MainActivity.LANGUAGE[lang]);
    e.commit();
  }
}
