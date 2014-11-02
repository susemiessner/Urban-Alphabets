package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.util.Arrays;
import android.annotation.SuppressLint;
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
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.TextView;

public class AlphabetInfoActivity extends ActionBarActivity {
  private TextView textViewName;
  private TextView textViewLanguage;
  private EditText editTextName;
  private String currentAlphabet;
  private String currentLanguage;
  private SharedPreferences mSharedPreferences;

  @SuppressLint("NewApi")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_alphabet_info);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    currentLanguage = mSharedPreferences.getString("currentLanguage", "");
    textViewName = (TextView) findViewById(R.id.textview_alphabet);
    textViewLanguage = (TextView) findViewById(R.id.textview_language);
    editTextName = (EditText) findViewById(R.id.edittext_alphabet);
    textViewName.setText(currentAlphabet);
    textViewLanguage.setText(currentLanguage);
    editTextName.setOnKeyListener(new View.OnKeyListener() {
      @Override
      public boolean onKey(View v, int keyCode, KeyEvent event) {
        // If the event is a key-down event on the "enter" button
        if ((event.getAction() == KeyEvent.ACTION_DOWN) && (keyCode == KeyEvent.KEYCODE_ENTER)) {
          // Perform action on key press
          String newName = editTextName.getText().toString();
          if (newName != null && !newName.isEmpty()) {
            new RenameLetters().execute(newName);
            textViewName.setText(newName);
          }
          editTextName.setVisibility(View.GONE);
          textViewName.setVisibility(View.VISIBLE);
          return true;
        }
        return false;
      }
    });
  }

  public void changeAlphabet(View v) {
    textViewName.setVisibility(View.GONE);
    editTextName.setVisibility(View.VISIBLE);
    editTextName.setText("");
    InputMethodManager keyboard =
        (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    editTextName.requestFocus();
    keyboard.showSoftInput(editTextName, 0);
  }

  public void changeLanguage(View v) {
    Intent changeLanguageIntent = new Intent(this, ChangeLanguageActivity.class);
    startActivity(changeLanguageIntent);
    finish();
  }

  public void resetAlphabet(View v) {
    new Cleanup(false).execute();
  }

  public void deleteAlphabet(View v) {
    new Cleanup(true).execute();
  }

  class RenameLetters extends AsyncTask<String, Void, Void> {
    private ProgressDialog progress;

    @Override
    protected void onPreExecute() {
      progress = new ProgressDialog(AlphabetInfoActivity.this);
      progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
      progress.setMax(42);
      progress.setMessage("Renaming letters.");
      progress.setIndeterminate(false);
      progress.setCancelable(false);
      progress.show();
    }

    @Override
    protected Void doInBackground(String... arg0) {
      String newName = arg0[0];
      File file =
          new File(getApplicationContext().getFilesDir().getPath() + File.separator + "databases"
              + File.separator + "db.sqlite");
      // Create or open database
      SQLiteDatabase database = null;
      try {
        database =
            SQLiteDatabase.openDatabase(file.getAbsolutePath(), null,
                SQLiteDatabase.CREATE_IF_NECESSARY);
      } catch (SQLiteException ex) {
      }
      ContentValues replaced = new ContentValues();
      replaced.put("alphabet", newName);
      try {
        database.update("alphabets", replaced, "alphabet=?", new String[] {currentAlphabet});
      } catch (SQLiteException ex) {
      }
      database.close();

      for (int index = 0; index < 42; index++) {
        File f =
            new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets"
                    + File.separator
                    + currentAlphabet
                    + "_"
                    + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                        currentLanguage)][index] + ".png");
        if (f.exists()) {
          File r =
              new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                  "UrbanAlphabets"
                      + File.separator
                      + newName
                      + "_"
                      + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                          currentLanguage)][index] + ".png");
          f.renameTo(r);
          getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
              Images.Media.DATA + " LIKE ?", new String[] {f.getAbsolutePath()});

          ContentValues image = new ContentValues();
          image.put(Images.Media.DATA, r.getAbsolutePath());
          getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
        }
        progress.setProgress(index);
      }

      currentAlphabet = newName;
      /*
       * Save as preferences
       */
      Editor e = mSharedPreferences.edit();
      e.putString("currentAlphabet", currentAlphabet);
      e.commit();
      return null;
    }

    @Override
    protected void onPostExecute(Void arg) {
      progress.dismiss();
    }
  }

  class Cleanup extends AsyncTask<Void, Void, Void> {
    private ProgressDialog progress;
    private boolean delete;

    public Cleanup(boolean d) {
      delete = d;
    }

    @Override
    protected void onPreExecute() {
      progress = new ProgressDialog(AlphabetInfoActivity.this);
      progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
      progress.setMax(42);
      if (delete)
        progress.setMessage("Deleting alphabet.");
      else
        progress.setMessage("Resetting alphabet.");
      progress.setIndeterminate(false);
      progress.setCancelable(false);
      progress.show();
    }

    @Override
    protected Void doInBackground(Void... arg0) {
      // Delete letters, if present
      for (int index = 0; index < 42; index++) {
        File file =
            new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets"
                    + File.separator
                    + currentAlphabet
                    + "_"
                    + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                        currentLanguage)][index] + ".png");
        if (file.exists()) {
          file.delete();
          getContentResolver().delete(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
              Images.Media.DATA + " LIKE ?", new String[] {file.getAbsolutePath()});
        }
        progress.setProgress(index);
      }

      if (!delete)
        return null;

      /*
       * Delete alphabet entry from database
       */
      SQLiteDatabase database = null;

      try {
        database =
            getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
      } catch (SQLiteException ex) {
        Log.d("AlphabetInfoActivity", ex.getMessage());
      }

      try {
        database.delete("alphabets", "alphabet=?", new String[] {currentAlphabet});
      } catch (SQLiteException ex) {
        Log.d("AlphabetInfoActivity", ex.getMessage());
      }

      /*
       * Select new alphabet if present
       */
      currentAlphabet = "";
      currentLanguage = "";
      Cursor cursor = database.rawQuery("SELECT * FROM alphabets", null);
      if (cursor != null && cursor.moveToFirst()) {
        currentAlphabet = cursor.getString(cursor.getColumnIndex("alphabet"));
        currentLanguage = cursor.getString(cursor.getColumnIndex("language"));
        ContentValues replaced = new ContentValues();
        replaced.put("selected", 1);
        try {
          database.update("alphabets", replaced, "alphabet=?", new String[] {currentAlphabet});
        } catch (SQLiteException ex) {
          Log.d("AlphabetInfoActivity", ex.getMessage());
        }
      }
      if (cursor != null)
        cursor.close();

      database.close();

      /*
       * Save as preferences
       */
      Editor e = mSharedPreferences.edit();
      e.putString("currentAlphabet", currentAlphabet);
      e.putString("currentLangauge", currentLanguage);
      e.commit();

      return null;
    }

    @Override
    protected void onPostExecute(Void arg) {
      progress.dismiss();
      finish();
    }
  }
}
