package org.susemiessner.android.urbanalphabets;

import java.util.ArrayList;
import java.util.List;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Matrix;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;

public class AssignLetterActivity extends ActionBarActivity {
	private int imageViewId [] = {
			R.id.imageview_assign_letter_1, R.id.imageview_assign_letter_2,
			R.id.imageview_assign_letter_3, R.id.imageview_assign_letter_4,
			R.id.imageview_assign_letter_5, R.id.imageview_assign_letter_6, 
			R.id.imageview_assign_letter_7, R.id.imageview_assign_letter_8,
			R.id.imageview_assign_letter_9, R.id.imageview_assign_letter_10,
			R.id.imageview_assign_letter_11, R.id.imageview_assign_letter_12,
			R.id.imageview_assign_letter_13, R.id.imageview_assign_letter_14,
			R.id.imageview_assign_letter_15, R.id.imageview_assign_letter_16,
			R.id.imageview_assign_letter_17, R.id.imageview_assign_letter_18,
			R.id.imageview_assign_letter_19, R.id.imageview_assign_letter_20,
			R.id.imageview_assign_letter_21, R.id.imageview_assign_letter_22,
			R.id.imageview_assign_letter_23, R.id.imageview_assign_letter_24,
			R.id.imageview_assign_letter_25, R.id.imageview_assign_letter_26,
			R.id.imageview_assign_letter_27, R.id.imageview_assign_letter_28,
			R.id.imageview_assign_letter_29, R.id.imageview_assign_letter_30,
			R.id.imageview_assign_letter_31, R.id.imageview_assign_letter_32,
			R.id.imageview_assign_letter_33, R.id.imageview_assign_letter_34,
			R.id.imageview_assign_letter_35, R.id.imageview_assign_letter_36, 
			R.id.imageview_assign_letter_37, R.id.imageview_assign_letter_38,
			R.id.imageview_assign_letter_39, R.id.imageview_assign_letter_40,
			R.id.imageview_assign_letter_41, R.id.imageview_assign_letter_42
			};
	private List<Integer> imageViewIdList;
	private int selected;
	private LinearLayout linearLayout;
	private boolean[] havePhoto;
	private int height;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_assign_letter);
		havePhoto = new boolean[42];
		imageViewIdList = new ArrayList<>();
		for(int i = 0; i < 42; i++)
			imageViewIdList.add(imageViewId[i]);
		ImageView imageView = (ImageView) findViewById (R.id.imageview_assign_letter);
		imageView.setImageBitmap(Data.getCroppedBitmap());
		selected = -1;
		linearLayout = (LinearLayout) findViewById
				(R.id.layout_assign_letter);
		ViewTreeObserver vto = linearLayout.getViewTreeObserver();
		vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
			@SuppressWarnings("deprecation")
			@Override
			public void onGlobalLayout() { 
				if (Build.VERSION.SDK_INT < 16)
					linearLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
				else 
					linearLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
				ImageView imageView = (ImageView) 
						findViewById(R.id.imageview_assign_letter_1);
				height = imageView.getHeight();
				new FillTableLayout().execute();
			}
		});
	}
	
	public void onClick(View v) {
		if(havePhoto[imageViewIdList.indexOf(v.getId())])
			return;
		ImageButton imageButton = (ImageButton) findViewById(R.id.imagebutton_assign_letter);
		if(imageButton.getVisibility() == View.GONE)
			imageButton.setVisibility(View.VISIBLE);
		if(selected != -1 ){
			ImageView imageView = (ImageView) findViewById (imageViewId[selected]);
			imageView.clearColorFilter();
		}
			
		selected = imageViewIdList.indexOf(v.getId());
		ImageView imageView = (ImageView)v;
		imageView.setColorFilter(Color.argb(0x80, 0xC2, 0xF7, 0x9E));
	}
	
	public void onClickAssign(View v) {
		Data.assignPhotoToSelectedLetter(selected);
		finish();
	}

    public class FillTableLayout extends AsyncTask<Void, Void, Void> {

    	ProgressDialog pDialog;
    	
    	@Override
    	protected void onPreExecute() {
    		super.onPreExecute();
    		pDialog = new ProgressDialog(AssignLetterActivity.this);
            pDialog.setMessage("Loading Letters.");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
    	}
    	
		@Override
		protected Void doInBackground(Void... params) {
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					for (int index = 0; index < Data.MAX; index++) {
						ImageView imageView = (ImageView) findViewById
								(imageViewId[index]);
						Bitmap bitmap;
						String path = Data.getLetterPath(index);
						if (path == null) {
							bitmap = BitmapFactory.decodeResource(getResources(),
									Data.getRawResourceId(index));
							havePhoto[index] = false;
						}
						else {
							bitmap = BitmapFactory.decodeFile(path);
							havePhoto[index] = true;
						}
						Matrix matrix = new Matrix();
						float scale = (float)((float)height/(float)(bitmap.getHeight()));
						matrix.setScale(scale, scale);
						Bitmap resized = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(),
								bitmap.getHeight(), matrix, false);
						imageView.setImageBitmap(resized);
					}
				}
			});
			return null;
		}
    	
		@Override
		protected void onPostExecute(Void arg){
			pDialog.dismiss();
		}
    }
}
