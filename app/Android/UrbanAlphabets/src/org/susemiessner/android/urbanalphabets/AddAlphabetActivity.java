package org.susemiessner.android.urbanalphabets;

import java.io.File;

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
	private EditText editText;
	private SharedPreferences mSharedPreferences;
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_add_alphabet);
		mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		ListView listView = (ListView) findViewById(R.id.listview_add_alphabet);
		imageButton = (ImageButton) findViewById(R.id.imagebutton_add_alphabet);
		editText = (EditText) findViewById(R.id.edittext_alphabetname); 
		adapter = new CustomArrayAdapter(this, MainActivity.LANGUAGE, -1);
		listView.setAdapter(adapter);
		listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, final View view,
			          int position, long id) {
				if (TextUtils.isEmpty(editText.getText().toString()))
					return;
				if(!adapter.isSelected(position)) {
					adapter.setSelected(position);
					adapter.notifyDataSetChanged();
				}
				if (imageButton.getVisibility() == View.GONE)
					imageButton.setVisibility(View.VISIBLE);
			}
		});
	}
	
	public void onClick(View v) {
		if (TextUtils.isEmpty(editText.getText().toString()))
			return;
		addAlphabet(editText.getText().toString(), adapter.getSelected());
		finish();
	}
	
	private void addAlphabet(String alphabetName, int lang) {
		SQLiteDatabase mDatabase = null;
		
		File file = new File(getApplicationContext().getFilesDir().getPath() + File.separator
								+ "databases" + File.separator + "db.sqlite");
		// Create or open database
		try{
			mDatabase = SQLiteDatabase.openDatabase(file.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
		} catch (SQLiteException ex) {
		}
		// Clear previous selection if present else do nothing 
		ContentValues replaced = new ContentValues();
		replaced.put("selected", 0);
		try {
			mDatabase.update("alphabets", replaced, "selected=1", null);	
		} catch (SQLiteException ex) {
		}
		// Add new alphabet with selection
		ContentValues alphabet = new ContentValues();
		alphabet.put("alphabet", alphabetName);
		alphabet.put("language", MainActivity.LANGUAGE[lang]);
		alphabet.put("selected", 1);
		try {
			mDatabase.insert("alphabets", null, alphabet);	
		} catch (SQLiteException ex) {
					
		}
		mDatabase.close();
		Editor e = mSharedPreferences.edit();
		e.putString("currentAlphabet", alphabetName);
		e.putString("currentLanguage", MainActivity.LANGUAGE[lang]);
		e.commit();
	}
}
