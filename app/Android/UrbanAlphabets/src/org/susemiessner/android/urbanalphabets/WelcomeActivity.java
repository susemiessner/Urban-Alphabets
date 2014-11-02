package org.susemiessner.android.urbanalphabets;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

public class WelcomeActivity extends Activity {
  private int click;
  private ImageView imageView;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_welcome);
    imageView = (ImageView) findViewById(R.id.imageview_welcome);
    imageView.setImageResource(R.drawable.intro_1);
    click = 0;
  }

  public void showNext(View v) {
    click++;
    if (click == 1) {
      imageView.setImageResource(R.drawable.intro_2);
      return;
    } else if (click == 2) {
      imageView.setImageResource(R.drawable.intro_4);
      return;
    }
    Intent mainIntent = new Intent(this, MainActivity.class);
    startActivity(mainIntent);
    finish();
  }
}
