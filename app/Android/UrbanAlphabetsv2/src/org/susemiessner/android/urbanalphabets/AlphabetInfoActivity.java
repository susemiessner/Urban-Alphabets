package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.util.Arrays;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

public class AlphabetInfoActivity extends Activity {
  private SharedPreferences mSharedPreferences;
  private String mAlphabet;
  private String mLanguage;
  private TextView mTextViewName;
  private TextView mTextViewLanguage;
  private EditText mEditTextName;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_alphabet_info);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    mLanguage = mSharedPreferences.getString("currentLanguage", "");
    mTextViewName = (TextView) findViewById(R.id.textView_alphabet);
    mTextViewLanguage = (TextView) findViewById(R.id.textView_language);
    mEditTextName = (EditText) findViewById(R.id.editText_alphabet);
    mTextViewName.setText(mAlphabet);
    mTextViewLanguage.setText(mLanguage);
    mEditTextName.setOnKeyListener(new View.OnKeyListener() {
      @Override
      public boolean onKey(View v, int keyCode, KeyEvent event) {
        // If the event is a key-down event on the "enter" button
        if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
          // Perform action on key press
          String newName = mEditTextName.getText().toString();
          if (newName != null && !newName.isEmpty()) {
            new RenameLetters().execute(newName);
            mTextViewName.setText(newName);
          }
          mEditTextName.setVisibility(View.GONE);
          mTextViewName.setVisibility(View.VISIBLE);
          return true;
        }
        return false;
      }
    });
  }

  public void changeAlphabet(View view) {
    mTextViewName.setVisibility(View.GONE);
    mEditTextName.setVisibility(View.VISIBLE);
    mEditTextName.setText("");
    InputMethodManager keyboard =
        (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    mEditTextName.requestFocus();
    keyboard.showSoftInput(mEditTextName, 0);
  }

  public void changeLanguage(View view) {
    Intent changeLanguageIntent = new Intent(this, ChangeLanguageActivity.class);
    startActivity(changeLanguageIntent);
    finish();
  }

  public void deleteAlphabet(View view) {
    new Cleanup(true).execute();
  }

  public void resetAlphabet(View view) {
    new Cleanup(false).execute();
  }

  public void showAbc(View view) {
    finish();
  }


  class RenameLetters extends AsyncTask<String, Void, Void> {
    private ProgressDialog mProgressDialog;

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(AlphabetInfoActivity.this);
      mProgressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
      mProgressDialog.setMax(42);
      mProgressDialog.setTitle("Renaming letters.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected Void doInBackground(String... arg0) {
      String newName = arg0[0];
      // Create or open database
      SQLiteDatabase database = null;
      try {
        database =
            getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
      ContentValues replaced = new ContentValues();
      replaced.put("alphabet", newName);
      try {
        database.update("alphabets", replaced, "alphabet=?", new String[] {mAlphabet});
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
      replaced = new ContentValues();
      replaced.put("prefix", newName);
      try {
        database.update("updates", replaced, "prefix=?", new String[] {mAlphabet});
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
      database.close();

      for (int index = 0; index < 42; index++) {
        File f =
            new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets"
                    + File.separator
                    + mAlphabet
                    + "_"
                    + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                        mLanguage)][index] + ".png");
        if (f.exists()) {
          File r =
              new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                  "UrbanAlphabets"
                      + File.separator
                      + newName
                      + "_"
                      + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                          mLanguage)][index] + ".png");
          f.renameTo(r);
          getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
              Images.Media.DATA + " LIKE ?", new String[] {f.getAbsolutePath()});

          ContentValues image = new ContentValues();
          image.put(Images.Media.DATA, r.getAbsolutePath());
          getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
        }
        mProgressDialog.setProgress(index);
      }

      mAlphabet = newName;
      /*
       * Save as preferences
       */
      Editor e = mSharedPreferences.edit();
      e.putString("currentAlphabet", mAlphabet);
      e.commit();
      return null;
    }

    @Override
    protected void onPostExecute(Void arg) {
      mProgressDialog.dismiss();
    }
  }

  class Cleanup extends AsyncTask<Void, Void, Void> {
    private ProgressDialog mProgressDialog;
    private boolean delete;

    public Cleanup(boolean d) {
      delete = d;
    }

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(AlphabetInfoActivity.this);
      mProgressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
      mProgressDialog.setMax(42);
      if (delete)
        mProgressDialog.setTitle("Deleting alphabet.");
      else
        mProgressDialog.setTitle("Resetting alphabet.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected Void doInBackground(Void... arg0) {
      // Delete letters, if present
      for (int index = 0; index < 42; index++) {
        File file =
            new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets"
                    + File.separator
                    + mAlphabet
                    + "_"
                    + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                        mLanguage)][index] + ".png");
        if (file.exists()) {
          file.delete();
          getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
              Images.Media.DATA + " LIKE ?", new String[] {file.getAbsolutePath()});
        }
        mProgressDialog.setProgress(index);
      }
      // Delete letters from to be updates table
      SQLiteDatabase database = null;

      try {
        database =
            getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }

      try {
        database.delete("updates", "prefix=?", new String[] {mAlphabet});
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }

      if (!delete) {
        database.close();
        return null;
      }

      /*
       * Delete alphabet entry from database
       */

      try {
        database.delete("alphabets", "alphabet=?", new String[] {mAlphabet});
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }

      /*
       * Select new alphabet if present
       */
      mAlphabet = "Untitled";
      mLanguage = MainActivity.LANGUAGE[mSharedPreferences.getInt("defaultLang", 0)];
      Cursor cursor = database.rawQuery("SELECT * FROM alphabets", null);
      if (cursor != null && cursor.moveToFirst()) {
        mAlphabet = cursor.getString(cursor.getColumnIndex("alphabet"));
        mLanguage = cursor.getString(cursor.getColumnIndex("language"));
        ContentValues replaced = new ContentValues();
        replaced.put("selected", 1);
        try {
          database.update("alphabets", replaced, "alphabet=?", new String[] {mAlphabet});
        } catch (SQLiteException ex) {
          ex.printStackTrace();
        }
      } else {
        ContentValues alphabet = new ContentValues();
        alphabet.put("alphabet", mAlphabet);
        alphabet.put("language", mLanguage);
        alphabet.put("selected", 1);

        try {
          database.insert("alphabets", null, alphabet);
        } catch (SQLiteException ex) {
          ex.printStackTrace();
        }
      }
      if (cursor != null)
        cursor.close();

      database.close();

      /*
       * Save as preferences
       */
      Editor e = mSharedPreferences.edit();
      e.putString("currentAlphabet", mAlphabet);
      e.putString("currentLanguage", mLanguage);
      e.commit();

      return null;
    }

    @Override
    protected void onPostExecute(Void arg) {
      mProgressDialog.dismiss();
      finish();
    }
  }
}
