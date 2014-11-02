package org.susemiessner.android.urbanalphabets;

import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.preference.PreferenceManager;


public class ChangeDefaultLanguageActivity extends ActionBarActivity {
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
  private ListView listView;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_change_default_language);
    imageButton = (ImageButton) findViewById(R.id.imagebutton_change_default_language);
    listView = (ListView) findViewById(R.id.listview_change_default_language);
    adapter =
        new CustomArrayAdapter(this, MainActivity.LANGUAGE, getDefaultSelectedLanguageIndex());

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

  private int getDefaultSelectedLanguageIndex() {
    SharedPreferences mSharedPreferences =
        PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    return mSharedPreferences.getInt("defaultLang", 0);
  }

  public void onClick(View v) {
    SharedPreferences mSharedPreferences =
        PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    Editor e = mSharedPreferences.edit();
    e.putInt("defaultLang", adapter.getSelected());
    e.commit();
    finish();
  }
}
