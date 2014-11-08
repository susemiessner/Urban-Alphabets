package org.susemiessner.android.urbanalphabets;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class MyAlphabetsActivity extends Activity {
  private CustomArrayAdapter mAdapter;
  private List<Alphabet> mListAlphabet;
  private int mSelection;
  private SharedPreferences mSharedPreferences;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_my_alphabets);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    ListView listView = (ListView) findViewById(R.id.listView_my_alphabets);
    View footerView =
        ((LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(
            R.layout.footer, (ListView) findViewById(R.id.listView_my_alphabets), false);
    listView.addFooterView(footerView);
    initialize();
    mAdapter = new CustomArrayAdapter(this, toArray(), mSelection);
    listView.setAdapter(mAdapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (position == mListAlphabet.size()) {
          addAlphabet();
        } else if (!mAdapter.isSelected(position)) {
          mAdapter.setSelected(position);
          mAdapter.notifyDataSetChanged();
          changeSelectedAlphabet(position);
          finish();
        }
      }
    });
  }

  private void changeSelectedAlphabet(int pos) {
    SQLiteDatabase database = null;
    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    ContentValues replaced = new ContentValues();
    replaced.put("selected", 0);
    try {
      database.update("alphabets", replaced, "selected=1", null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    replaced = new ContentValues();
    replaced.put("selected", 1);
    try {
      database.update("alphabets", replaced, "alphabet=?", new String[] {mListAlphabet.get(pos)
          .getName()});
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    database.close();

    /*
     * Save as preferences
     */
    Editor e = mSharedPreferences.edit();
    e.putString("currentAlphabet", mListAlphabet.get(pos).getName());
    e.putString("currentLanguage", mListAlphabet.get(pos).getLang());
    e.commit();
  }

  private void initialize() {
    SQLiteDatabase database = null;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    mListAlphabet = new ArrayList<Alphabet>();
    Cursor cursor = database.rawQuery("SELECT * FROM alphabets", null);
    if (cursor != null && cursor.moveToFirst()) {
      do {
        mListAlphabet.add(new Alphabet(cursor.getString(cursor.getColumnIndex("alphabet")), cursor
            .getString(cursor.getColumnIndex("language"))));
        if (cursor.getInt(cursor.getColumnIndex("selected")) == 1) {
          mSelection = cursor.getPosition();
        }
      } while (cursor.moveToNext());
    }
    database.close();
  }

  private void addAlphabet() {
    Intent addAlphabet = new Intent(this, AddAlphabetActivity.class);
    startActivity(addAlphabet);
    finish();
  }

  private String[] toArray() {
    String[] alphabetName = new String[mListAlphabet.size()];
    int i = 0;
    for (Alphabet alphabet : mListAlphabet)
      alphabetName[i++] = alphabet.getName();
    return alphabetName;
  }

}
