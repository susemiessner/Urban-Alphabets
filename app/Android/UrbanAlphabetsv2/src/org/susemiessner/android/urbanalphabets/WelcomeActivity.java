package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class WelcomeActivity extends Activity {
  private int mClick;
  //private ImageView mImageView;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_welcome);
    //mImageView = (ImageView) findViewById(R.id.imageView_welcome);
    //mImageView.setImageResource(R.drawable.intro_1);
    mClick = 0;
  }

  public void showNext(View v) {
    mClick++;
    if (mClick == 1) {
      //mImageView.setImageResource(R.drawable.intro_2);
      return;
    } else if (mClick == 2) {
      //mImageView.setImageResource(R.drawable.intro_4);
      return;
    }
    Intent mainIntent = new Intent(this, MainActivity.class);
    startActivity(mainIntent);
    finish();
  }
}
