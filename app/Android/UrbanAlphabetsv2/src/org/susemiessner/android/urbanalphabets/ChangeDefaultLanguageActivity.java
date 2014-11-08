package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.ListView;

public class ChangeDefaultLanguageActivity extends Activity {
  private CustomArrayAdapter mAdapter;
  private ImageButton mImageButton;
  private SharedPreferences mSharedPreferences;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_change_default_language);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mImageButton = (ImageButton) findViewById(R.id.imageButton_change_default_language);
    ListView listView = (ListView) findViewById(R.id.listView_change_default_language);
    mAdapter =
        new CustomArrayAdapter(this, MainActivity.LANGUAGE, mSharedPreferences.getInt(
            "defaultLang", 0));

    listView.setAdapter(mAdapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        if (!mAdapter.isSelected(position)) {
          mAdapter.setSelected(position);
          mAdapter.notifyDataSetChanged();
        }
        if (mImageButton.getVisibility() == View.GONE)
          mImageButton.setVisibility(View.VISIBLE);
      }
    });
  }

  public void changeDefaultLanguage(View view) {
    Editor e = mSharedPreferences.edit();
    e.putInt("defaultLang", mAdapter.getSelected());
    e.commit();
    finish();
  }

}
