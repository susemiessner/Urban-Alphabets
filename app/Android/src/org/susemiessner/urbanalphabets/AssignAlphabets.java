package org.susemiessner.urbanalphabets;

import java.util.HashMap;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.util.SparseIntArray;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TableLayout;
import android.widget.TableRow;

public class AssignAlphabets extends Activity implements OnClickListener {

	private Uri croppedPicUri;
	private static boolean firstTimeClicked = true;
	private static int previousImageViewId;
	private Button assignAlpha;
SparseIntArray imageSetTracker = new SparseIntArray(); 


	public Uri getCroppedPicUri() {
	return croppedPicUri;
}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.alphabets_assign);

		assignAlpha = ((Button) findViewById(R.id.AssignButtonOk));
		assignAlpha.setOnClickListener(this);
		assignAlpha.setVisibility(View.INVISIBLE);
		
		Intent intent = getIntent();
		croppedPicUri = Uri.parse(intent.getExtras().getString("fileUri"));
		ImageView alphabetImage = (ImageView) findViewById(R.id.ImageViewAssignScreenPhotoJustCropped);
		alphabetImage.setImageURI(croppedPicUri);
		fillAlphaGrid();
	

	}

	@Override
	public void onClick(View v) {
		assignAlpha.setVisibility(View.VISIBLE);

		Log.i("viewID", v.getId() + "");

		if (AssignAlphabets.firstTimeClicked) {
			ImageView imageViewCurrent = (ImageView) findViewById(v.getId());
			imageViewCurrent.setBackgroundColor(Color.GREEN);
			AssignAlphabets.previousImageViewId = v.getId();
			AssignAlphabets.firstTimeClicked = false;

		}

		else if (!AssignAlphabets.firstTimeClicked && v.getId() != R.id.AssignButtonOk) {

			ImageView previous = (ImageView) findViewById(AssignAlphabets.previousImageViewId);
			ImageView imageViewCurrent = (ImageView) findViewById(v.getId());
			imageViewCurrent.setBackgroundColor(Color.GREEN);
			previous.setBackgroundResource(R.drawable.cell_border);
			AssignAlphabets.previousImageViewId = v.getId();

		}

		else if (v.getId() == R.id.AssignButtonOk) {
			
			int index = imageSetTracker.get(AssignAlphabets.previousImageViewId);
			Languages.getCurrentSet().set(index,getCroppedPicUri().toString());
			Log.i("new alphabet is set mother fucker ",Languages.getCurrentSet().get(index) );
			
			//empty the stack and start the home activity again
			
		
			startActivity(new Intent (AssignAlphabets.this, HomeActivity.class).setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK));
		}

	}

	private void fillAlphaGrid() {

		int assignAlphabetId = 0;
		TableLayout yourRootLayout = (TableLayout) findViewById(R.id.tableAssignScreenLayoutAlphaGrid);// inflate
		// table
		// layout

		int count = yourRootLayout.getChildCount(); // gives the number of rows
		// in the tablelayout
		Log.i("childs", count + "");
		for (int i = 0; i < count; i++) {

			View v = yourRootLayout.getChildAt(i);

			if (v instanceof TableRow) {

				TableRow row = (TableRow) v;
				int rowCount = row.getChildCount();

				for (int r = 0; r < rowCount; r++) {
				
					View v2 = row.getChildAt(r);
					if (v2 instanceof ImageView) {

						ImageView clickedImage = (ImageView) v2;
						clickedImage.setOnClickListener(this);
					    imageSetTracker.put(clickedImage.getId(), assignAlphabetId);
						setImageView(clickedImage.getId(), assignAlphabetId);
						assignAlphabetId++;
					}
				}
			}
		}

	}

	private void setImageView(int id, int assignAlphabetId) {
		ImageView alpha = (ImageView) findViewById(id);
		alpha.setImageURI(Uri.parse(Languages.getCurrentSet().get(assignAlphabetId)));

	}

}
