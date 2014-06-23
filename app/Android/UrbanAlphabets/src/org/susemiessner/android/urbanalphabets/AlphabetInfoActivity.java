package org.susemiessner.android.urbanalphabets;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

public class AlphabetInfoActivity extends ActionBarActivity {
	private TextView textViewName;
	private TextView textViewLanguage;
	private EditText editTextName;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_alphabet_info);
		textViewName = (TextView) findViewById(R.id.textview_alphabet_info_name);
		textViewLanguage = (TextView) findViewById(R.id.textview_alphabet_info_language);
		editTextName = (EditText) findViewById (R.id.edittext_alphabet_info_name);
		textViewName.setText(Data.getSelectedAlphabetName());
		textViewLanguage.setText(Data.getSelectedAlphabetLanguage());
		editTextName.setOnKeyListener(new View.OnKeyListener() {
			@Override
		    public boolean onKey(View v, int keyCode, KeyEvent event) {
		        // If the event is a key-down event on the "enter" button
		        if ((event.getAction() == KeyEvent.ACTION_DOWN) &&
		            (keyCode == KeyEvent.KEYCODE_ENTER)) {
		          // Perform action on key press
		        	String newName = editTextName.getText().toString();
		        	if (newName != null && !newName.isEmpty()) { 
		        		Data.changeAlphabetName(newName);
		        	}
		        	editTextName.setVisibility(View.GONE);
		      		textViewName.setVisibility(View.VISIBLE);
		      		textViewName.setText(Data.getSelectedAlphabetName());
		      		return true;
		        }
		        return false;
		    }
		});
	}
	
	public void onClickHint1(View v) {
		textViewName.setVisibility(View.GONE);
		editTextName.setVisibility(View.VISIBLE);
		editTextName.setText("");
		editTextName.requestFocus();
	}
	
	public void onClickHint2(View v) {
		Intent addAlphabetIntent = new Intent(this, ChangeLanguageActivity.class);
		startActivity(addAlphabetIntent);
		finish();
	}
	
	public void onClickReset(View v) {
		Data.resetAlphabet();
		finish();
	}
	
	public void onClickDelete(View v) {
		Data.deleteAlphabet();
		finish();
	}
}
