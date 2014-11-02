package org.susemiessner.android.urbanalphabets;

import java.util.ArrayList;
import java.util.List;

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
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class MyAlphabetsActivity extends ActionBarActivity {

  private class CustomArrayAdapter extends ArrayAdapter<String> {
    private int selection;
    
    class ViewHolder {
      public ImageView imageView;
      public TextView textView;
    }

    public CustomArrayAdapter(Context context, String[] alphabets, int selection) {
      super(context, R.layout.row, alphabets);
      this.selection = selection;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      View rowView = convertView;
      // Reuse views
      if(rowView == null) {
        LayoutInflater inflater =
            (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        rowView = inflater.inflate(R.layout.row, parent, false);
        // Configure view Holder
        ViewHolder viewHolder = new ViewHolder();
        viewHolder.imageView = (ImageView) rowView.findViewById(R.id.imageview_row);
        viewHolder.textView = (TextView) rowView.findViewById(R.id.textview_row);
        rowView.setTag(viewHolder);
      }
      // Set views
      ViewHolder viewHolder = (ViewHolder) rowView.getTag();
      if (isSelected(position)) {
        rowView.setBackgroundColor(getResources().getColor(R.color.LightGreen));
        viewHolder.imageView.setImageResource(R.drawable.icon_checked);
      } else {
        rowView.setBackgroundColor(getResources().getColor(R.color.White));
        viewHolder.imageView.setImageResource(R.color.White);
      }
      viewHolder.textView.setText(getItem(position));
      return rowView;
    }

    public boolean isSelected(int position) {
      return (selection == position);
    }

    public void setSelected(int position) {
      selection = position;
    }
  }

  private CustomArrayAdapter adapter;
  private List<Alphabet> listAlphabet;
  private int selected;
  private SharedPreferences mSharedPreferences;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_my_alphabets);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    ListView listview = (ListView) findViewById(R.id.listview_my_alphabets);
    View footerView =
        ((LayoutInflater) this.getSystemService(Context.LAYOUT_INFLATER_SERVICE)).inflate(
            R.layout.footer, (ListView) findViewById(R.id.listview_my_alphabets), false);
    listview.addFooterView(footerView);
    initialize();
    adapter = new CustomArrayAdapter(this, toArray(), selected);
    listview.setAdapter(adapter);
    listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (position == listAlphabet.size()) {
          addAlphabet();
        } else if (!adapter.isSelected(position)) {
          adapter.setSelected(position);
          adapter.notifyDataSetChanged();
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
      Log.d("MyAlphabetsActivity", ex.getMessage());
    }

    ContentValues replaced = new ContentValues();
    replaced.put("selected", 0);
    try {
      database.update("alphabets", replaced, "selected=1", null);
    } catch (SQLiteException ex) {
      Log.d("MyAlphabetsActivity", ex.getMessage());
    }

    replaced = new ContentValues();
    replaced.put("selected", 1);
    try {
      database.update("alphabets", replaced, "alphabet=?", new String[] {listAlphabet.get(pos)
          .getName()});
    } catch (SQLiteException ex) {
      Log.d("MyAlphabetsActivity", ex.getMessage());
    }

    database.close();

    /*
     * Save as preferences
     */
    Editor e = mSharedPreferences.edit();
    e.putString("currentAlphabet", listAlphabet.get(pos).getName());
    e.putString("currentLanguage", listAlphabet.get(pos).getLang());
    e.commit();
  }

  private void initialize() {
    SQLiteDatabase database = null;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      Log.d("MyAlphabetsActivity", ex.getMessage());
    }

    listAlphabet = new ArrayList<Alphabet>();
    Cursor cursor = database.rawQuery("SELECT * FROM alphabets", null);
    if (cursor != null && cursor.moveToFirst()) {
      do {
        listAlphabet.add(new Alphabet(cursor.getString(cursor.getColumnIndex("alphabet")), cursor
            .getString(cursor.getColumnIndex("language"))));
        if (cursor.getInt(cursor.getColumnIndex("selected")) == 1) {
          selected = cursor.getPosition();
        }
      } while (cursor.moveToNext());
    }
    Log.d("Debug",Integer.toString(listAlphabet.size()));
    database.close();
  }

  private String[] toArray() {
    String[] alphabetName = new String[listAlphabet.size()];
    int i = 0;
    for (Alphabet alphabet : listAlphabet)
      alphabetName[i++] = alphabet.getName();
    return alphabetName;
  }


  private void addAlphabet() {
    Intent addAlphabet = new Intent(this, AddAlphabetActivity.class);
    startActivity(addAlphabet);
    finish();
  }
}
