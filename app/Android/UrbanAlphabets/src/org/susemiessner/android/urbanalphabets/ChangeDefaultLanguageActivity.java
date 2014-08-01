package org.susemiessner.android.urbanalphabets;

import org.susemiessner.android.urbanalphabets.ChangeLanguageActivity.CustomArrayAdapter;

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
import android.os.Bundle;
import android.preference.PreferenceManager;


public class ChangeDefaultLanguageActivity extends ActionBarActivity {
	private class CustomArrayAdapter extends ArrayAdapter<String> {
		private final Context context;
		private final String[] options;
		private int selected;
		
		public CustomArrayAdapter(Context context, String[] options, int selected) {
			super(context, R.layout.row, options);
			this.context = context;
			this.options = options;
			this.selected = selected;
		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			LayoutInflater inflater = (LayoutInflater) context
		        .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		    View rowView = inflater.inflate(R.layout.row, parent, false);
		    ImageView imageView = (ImageView) rowView.findViewById(R.id.imageviewRow);
		    TextView textView = (TextView) rowView.findViewById(R.id.textviewRow);
		    if (isSelected(position)) {
		    	rowView.setBackgroundColor(getResources().getColor(R.color.LightGreen));
		    	imageView.setImageResource(R.drawable.icon_checked);
		    }
		    textView.setText(options[position]);
		    return rowView;
		  }
		
		public boolean isSelected(int position) {
			return (selected == position);
		}
		
		public void setSelected(int position) {
			this.selected = position;
		}
		
		public int getSelected() {
			return selected;
		}
	}
	
	private CustomArrayAdapter adapter;
	private ImageButton imageButton;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_change_default_language);
		imageButton = (ImageButton) findViewById(R.id.imagebutton_change_language);
		ListView listView = (ListView) findViewById(R.id.listview_change_language);
		adapter = new CustomArrayAdapter(this, Data.getLanguage(), 
				getDefaultSelectedLanguageIndex());
		
		listView.setAdapter(adapter);
		listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, final View view,
			          int position, long id) {
				if(!adapter.isSelected(position)) {
					adapter.setSelected(position);
					adapter.notifyDataSetChanged();
				}
				if (imageButton.getVisibility() == View.GONE)
					imageButton.setVisibility(View.VISIBLE);
			}
		});
	}
	
	private int getDefaultSelectedLanguageIndex() {
		SharedPreferences mSharedPreferences  = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		return mSharedPreferences.getInt("defaultLang", 0);
		
	}

	public void onClick(View v) {
		// Set Default Language Index 
		finish();
	}
}
