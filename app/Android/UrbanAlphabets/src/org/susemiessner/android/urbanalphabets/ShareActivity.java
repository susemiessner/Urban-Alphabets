package org.susemiessner.android.urbanalphabets;

import java.io.File;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class ShareActivity extends ActionBarActivity {
	/* ArrayAdapter for ListView */
	private class ShareArray extends ArrayAdapter<String> {
		private final Context context;
		private final String[] items;
		private int[] icon = { 
				R.drawable.icon_twitter, 
				R.drawable.icon_fb, 
				R.drawable.icon_mail
			};
		
		public ShareArray(Context context, String[] items) {
			super(context, R.layout.share_row, items);
			this.context = context;
			this.items = items;
		}
		
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			LayoutInflater inflater = (LayoutInflater) context
					.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			View rowView = inflater.inflate(R.layout.share_row, parent, false);
			ImageView imageView = (ImageView) rowView.findViewById(R.id.imageview_share_row);
			TextView textView = (TextView) rowView.findViewById(R.id.textview_share_row);
			textView.setText(items[position]);
			imageView.setImageResource(icon[position]);
			return rowView;
		}
	}
	
	private EditText editText;
	private String sharingWhat;
	private ActionBar actionBar;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_share);
		actionBar = getSupportActionBar();
		sharingWhat = getIntent().getStringExtra("sharingWhat");	
		
		ListView listView = (ListView) findViewById(R.id.listview_share);
		
		/* Social Networks */
		String[] socialNetworks = {"Twitter", "Facebook", "Email"};
		ShareArray adapter = new ShareArray(this, socialNetworks);
		listView.setAdapter(adapter);
		
		editText = (EditText) findViewById(R.id.edittext_share_message);
		
		ImageView imageView = (ImageView) findViewById(R.id.imageview_share_image);
		imageView.setImageURI(Uri.parse(getSharePath()));
		
		listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, final View view,
			          int position, long id) {
				if(position == 0) {
					share("Twitter");
				} 
				else if (position == 1) {
					share("Facebook");
				} 
				else if (position == 2) {
					share("Email");
				}
			}
		});
	}
	
	@Override
	protected void onStart() {
		super.onStart();
		actionBar.setTitle("Share " + sharingWhat);
	}
	
	@Override
	protected void onRestart() {
		super.onRestart();
	}
	
	private void share(String with) {
		Intent intent = new Intent(android.content.Intent.ACTION_SEND);
		intent.setType("image/png");
		intent.putExtra(android.content.Intent.EXTRA_SUBJECT,
				"Sharing UrbanAlphabets");
		intent.putExtra(android.content.Intent.EXTRA_TEXT, 
				editText.getText().toString());
		intent.putExtra(Intent.EXTRA_STREAM, Uri.parse("file://" + getSharePath()));
		startActivity(Intent.createChooser(intent, with));
	}
	
	private String getSharePath() {
		SharedPreferences mSharedPreferences = PreferenceManager.
				getDefaultSharedPreferences(getApplicationContext());
		String filename = mSharedPreferences.getString("lastShare", "");
		File file = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), "UrbanAlphabets" +
				File.separator + filename + ".png");
		
		return file.getAbsolutePath();
	}
}
