package org.susemiessner.urbanalphabets;

import java.util.ArrayList;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.FrameLayout;
import android.widget.ImageView;

public class DisplayAlphabet extends Activity implements OnClickListener {
	ArrayList<String> setOnDisplay = new ArrayList<String>();
	private static int index = 0;
	ImageView backButton, forewardButton, homeButton, displayImageView;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_display_alphabet);

		setOnDisplay = Languages.getCurrentSet();

		displayImageView = (ImageView) findViewById(R.id.DisplayAlphabetsPreview);
		index = getIntent().getExtras().getInt("startIndex");
		displayImage();

		ImageView backButton, forewardButton, homeButton;
		backButton = (ImageView) findViewById(R.id.imageViewBackWard);
		backButton.setOnClickListener(this);
		forewardButton = (ImageView) findViewById(R.id.imageViewForeward);
		forewardButton.setOnClickListener(this);
		homeButton = (ImageView) findViewById(R.id.imageViewGoToAlphabetsScreen);
		homeButton.setOnClickListener(this);

		// displayalphabet.setBackgroundResource();
	}

	@Override
	public void onClick(View v) {
		int viewId = v.getId();

		if (viewId == R.id.imageViewBackWard) {
			
			

			if (index <= 0){
				index=42;
			}
			DisplayAlphabet.index--;
			displayImage();
		} else if (viewId == R.id.imageViewForeward) {
if (index >= 41) index=-1;
			DisplayAlphabet.index++;
			displayImage();
		} else {
			startActivity(new Intent(DisplayAlphabet.this, HomeActivity.class)
					.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
							| Intent.FLAG_ACTIVITY_CLEAR_TASK));
		}

	}

	private void displayImage() {
	
		displayImageView.setImageURI(Uri.parse(setOnDisplay
				.get(DisplayAlphabet.index)));

	}

}
