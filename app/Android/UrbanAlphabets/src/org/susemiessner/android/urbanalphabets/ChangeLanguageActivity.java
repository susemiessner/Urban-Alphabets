package org.susemiessner.android.urbanalphabets;

import java.util.Arrays;

import android.content.ContentValues;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
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
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class ChangeLanguageActivity extends ActionBarActivity {

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
        // Configure view holder
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
  private String currentAlphabet;
  private String currentLanguage;
  private SharedPreferences mSharedPreferences;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_change_language);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    currentLanguage = mSharedPreferences.getString("currentLanguage", "");
    imageButton = (ImageButton) findViewById(R.id.imagebutton_change_language);
    ListView listView = (ListView) findViewById(R.id.listview_change_language);
    adapter =
        new CustomArrayAdapter(this, MainActivity.LANGUAGE, Arrays.asList(MainActivity.LANGUAGE)
            .indexOf(currentLanguage));

    listView.setAdapter(adapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (!adapter.isSelected(position)) {
          adapter.setSelected(position);
          adapter.notifyDataSetChanged();
        }
        if (imageButton.getVisibility() == View.GONE)
          imageButton.setVisibility(View.VISIBLE);
      }
    });
  }

  public void changeLanguage(View v) {
    changeAlphabetLanguage(adapter.getSelected());
    finish();
  }

  private void changeAlphabetLanguage(int lang) {
    SQLiteDatabase database = null;
    /*
     * Change language of the alphabet
     */
    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      Log.d("ChangeLanguageActivity", ex.getMessage());
    }
    ContentValues replaced = new ContentValues();
    replaced.put("language", MainActivity.LANGUAGE[lang]);
    try {
      database.update("alphabets", replaced, "alphabet=?", new String[] {currentAlphabet});
    } catch (SQLiteException ex) {
      Log.d("ChangeLangugaeActivity", ex.getMessage());
    }
    database.close();

    /*
     * Save as preferences
     */
    Editor e = mSharedPreferences.edit();
    e.putString("currentLanguage", MainActivity.LANGUAGE[lang]);
    e.commit();
  }
}
