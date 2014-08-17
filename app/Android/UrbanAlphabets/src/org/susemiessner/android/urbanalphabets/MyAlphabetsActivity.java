package org.susemiessner.android.urbanalphabets;

import java.io.File;
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
	}

	private CustomArrayAdapter adapter;
	private List<Alphabet> listAlphabet;
	private int selected;
	private SharedPreferences mSharedPreferences;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_my_alphabets);	
		mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		ListView listview = (ListView) findViewById(R.id.listview_my_alphabets);
		View footerView =  ((LayoutInflater)this.getSystemService
	 			(Context.LAYOUT_INFLATER_SERVICE)).inflate(R.layout.footer, null, false);
		listview.addFooterView(footerView);
		init();
		adapter = new CustomArrayAdapter(this, toArray(), selected);
		listview.setAdapter(adapter);
		listview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, final View view,
			          int position, long id) {
				if (position == listAlphabet.size()) {
					addAlphabet();
				} 
				else if(!adapter.isSelected(position)) {
					adapter.setSelected(position);
					adapter.notifyDataSetChanged();
					changeSelectedAlphabet(position);
					finish();
				}
			}
		});
	}
	
	private void changeSelectedAlphabet(int pos) {
		SQLiteDatabase mDatabase = null;
		
		File file = new File(getApplicationContext().getFilesDir().getPath() + File.separator
								+ "databases" + File.separator + "db.sqlite");
		// Create or open database
		try{
			mDatabase = SQLiteDatabase.openDatabase(file.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
		} catch (SQLiteException ex) {
		}
		ContentValues replaced = new ContentValues();
		replaced.put("selected", 0);
		try {
			mDatabase.update("alphabets", replaced, "selected=1", null);	
		} catch (SQLiteException ex) {
		}
		replaced = new ContentValues();
		replaced.put("selected", 1);
		try {
			mDatabase.update("alphabets", replaced, "alphabet=?", new String[]{listAlphabet.get(pos).getName()});	
		} catch (SQLiteException ex) {
		}
		mDatabase.close();
		Editor e = mSharedPreferences.edit();
		e.putString("currentAlphabet", listAlphabet.get(pos).getName());
		e.putString("currentLanguage", listAlphabet.get(pos).getLang());
		e.commit();
		
	}
	
	private void init() {
		SQLiteDatabase mDatabase = null;
		
		File file = new File(getApplicationContext().getFilesDir().getPath() + File.separator
								+ "databases" + File.separator + "db.sqlite");
		// Create or open database
		try{
			mDatabase = SQLiteDatabase.openDatabase(file.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
		} catch (SQLiteException ex) {
		}
		listAlphabet = new ArrayList<Alphabet>();
		Cursor  cursor = mDatabase.rawQuery("select * from alphabets", null);
		if (cursor.moveToFirst()) {
            while (cursor.isAfterLast() == false) {
                listAlphabet.add(new Alphabet(cursor.getString(cursor
                        .getColumnIndex("alphabet")), cursor.getString(cursor
    	                        .getColumnIndex("language"))));
                if(cursor.getInt(cursor.getColumnIndex("selected")) == 1) {
                	selected = cursor.getPosition();
                }
                cursor.moveToNext();
            }
        }
		mDatabase.close();
	}
	
	private String[] toArray() {
		String[] alphabetName = new String[listAlphabet.size()];
		int i = 0;
		for (Alphabet alphabet: listAlphabet)
			alphabetName[i++] = alphabet.getName();
		return alphabetName;
	}
	
	
	private void addAlphabet() {
		Intent addAlphabetIntent = new Intent(this, AddAlphabetActivity.class);
		startActivity(addAlphabetIntent);
		finish();
	}	
}
