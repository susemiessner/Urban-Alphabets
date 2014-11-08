package org.susemiessner.android.urbanalphabets;

import java.util.Arrays;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.AsyncTask;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ListView;


public class ChangeLanguageActivity extends Activity {
  private CustomArrayAdapter mAdapter;
  private String mLanguage;
  private String mAlphabet;
  private ImageButton mImageButton;
  private SharedPreferences mSharedPreferences;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_change_language);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    mLanguage = mSharedPreferences.getString("currentLanguage", "");
    ListView listView = (ListView) findViewById(R.id.listView_change_language);
    mAdapter =
        new CustomArrayAdapter(this, MainActivity.LANGUAGE, Arrays.asList(MainActivity.LANGUAGE)
            .indexOf(mLanguage));
    mImageButton = (ImageButton) findViewById(R.id.imageButton_change_language);
    listView.setAdapter(mAdapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (!mAdapter.isSelected(position)) {
          mAdapter.setSelected(position);
          mAdapter.notifyDataSetChanged();
        }
        if (mImageButton.getVisibility() == View.GONE)
          mImageButton.setVisibility(View.VISIBLE);
      }
    });
  }

  public void changeLanguage(View view) {
    new ChageLanguage().execute(mAdapter.getSelected());
  }

  private class ChageLanguage extends AsyncTask<Integer, Void, Void> {
    private ProgressDialog mProgressDialog;

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(ChangeLanguageActivity.this);
      mProgressDialog.setTitle("Changing language.");
      mProgressDialog.setMessage("Please, wait.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected Void doInBackground(Integer... params) {
      int selection = params[0];
      SQLiteDatabase database = null;
      /*
       * Change language of the alphabet
       */
      try {
        database =
            getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
      ContentValues replaced = new ContentValues();
      replaced.put("language", MainActivity.LANGUAGE[selection]);
      try {
        database.update("alphabets", replaced, "alphabet=?", new String[] {mAlphabet});
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
      database.close();

      /*
       * Save as preferences
       */
      Editor e = mSharedPreferences.edit();
      e.putString("currentLanguage", MainActivity.LANGUAGE[selection]);
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
