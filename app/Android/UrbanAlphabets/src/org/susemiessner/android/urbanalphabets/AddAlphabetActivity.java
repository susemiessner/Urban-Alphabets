package org.susemiessner.android.urbanalphabets;

import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBarActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class AddAlphabetActivity extends ActionBarActivity {

  private class CustomArrayAdapter extends ArrayAdapter<String> {
    private int selection;
    
    class ViewHolder {
      public ImageView imageView;
      public TextView textView;
    }

    public CustomArrayAdapter(Context context, String[] languages, int selection) {
      super(context, R.layout.row, languages);
      this.selection = selection;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      View rowView = convertView;
      // Reuse views
      if (rowView == null) {
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

    public int getSelected() {
      return selection;
    }
  }

  private CustomArrayAdapter adapter;
  private ImageButton imageButton;
  private EditText editText;
  private SharedPreferences mSharedPreferences;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_add_alphabet);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    ListView listView = (ListView) findViewById(R.id.listview_add_alphabet);
    imageButton = (ImageButton) findViewById(R.id.imagebutton_add_alphabet);
    editText = (EditText) findViewById(R.id.edittext_alphabetname);
    adapter = new CustomArrayAdapter(this, MainActivity.LANGUAGE, -1);
    listView.setAdapter(adapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (TextUtils.isEmpty(editText.getText().toString()))
          return;
        if (!adapter.isSelected(position)) {
          adapter.setSelected(position);
          adapter.notifyDataSetChanged();
        }
        if (imageButton.getVisibility() == View.GONE)
          imageButton.setVisibility(View.VISIBLE);
      }
    });
  }

  public void addAlphabet(View v) {
    if (TextUtils.isEmpty(editText.getText().toString()))
      return;
    addAlphabet(editText.getText().toString(), adapter.getSelected());
    finish();
  }

  private void addAlphabet(String name, int lang) {
    SQLiteDatabase database = null;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      Log.d("AddAlphabetActivity", ex.getMessage());
    }

    /*
     * Clear previous selection if present, else do nothing
     */
    ContentValues replaced = new ContentValues();
    replaced.put("selected", 0);
    try {
      database.update("alphabets", replaced, "selected=1", null);
    } catch (SQLiteException ex) {
      Log.d("AddAlphabetActivity", ex.getMessage());
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
      Log.d("AddAlphabetActivity", ex.getMessage());
    }

    database.close();
    /*
     * Save as preferences
     */
    Editor e = mSharedPreferences.edit();
    e.putString("currentAlphabet", name);
    e.putString("currentLanguage", MainActivity.LANGUAGE[lang]);
    e.commit();
  }
}
