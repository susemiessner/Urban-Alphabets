package org.susemiessner.urbanalphabets;



import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore.Video;
import android.util.Log;
import android.util.SparseIntArray;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.TableLayout;
import android.widget.TableRow;


public class HomeActivity extends Activity implements OnClickListener {

	public static   String PACKAGE_NAME;
	SparseIntArray imageSetTracker = new SparseIntArray(); 
	private static Context mContext;
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_homescreen);
		  PACKAGE_NAME = getApplicationContext().getPackageName();
		Log.i("TAG","HERE");
		
		
		mContext  = getApplicationContext();
		

		// check if different language folders exists... if not exist create folder for each language and store location in a key-pair value 
		//language - location (language is key )
		// use something to know what is the last alhabet you are working on.
		//If there does not exist any last then render the default set of alphabets which is finnish / swedish or 
		// let the fucking user chose which alphabet to fuck with
		// at this moment finnish/swedish is the the one that user like to play around.... wowow  ahhh ahhh ahhaha i am cumming alphagasm
		

	
	
	//alphabetsCollection consist of all the letters from all the alphabets stored in raw folder

		
		
	if (Languages.getCurrentSet().isEmpty()){

		try {
			Languages.setCurrentSet(Languages.getDefaultSet());
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		fillAlphaGrid();
	
	}
	else {
		
		fillAlphaGrid();
	}
	
	}


	private void fillAlphaGrid() {
		TableLayout yourRootLayout = (TableLayout) findViewById(R.id.tableLayoutAlphaGrid);// inflate
		// table
		// layout
		
		int assignAlphabetId=0;
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
						setImageView(clickedImage.getId(),assignAlphabetId);
						   imageSetTracker.put(clickedImage.getId(), assignAlphabetId);
						assignAlphabetId++;
					}
				}
			}
		}

			
		
	}






	private void setImageView(int id, int letterUri) {
		ImageView alpha = (ImageView) findViewById(id);
	
		alpha.setImageURI( Uri.parse(Languages.getCurrentSet().get(letterUri)));
	
		
	}


	@Override
	public void onClick(View v) {
		
		int viewId= v.getId();
	if (viewId==R.id.imageViewHomeFetchPhoto){

	
		startActivity(new Intent (HomeActivity.this, MainActivity.class));
		}
		else if (viewId== R.id.imageViewOptions){
			
			startDialogActivity();
			
			//startActivity(new Intent (HomeActivity.this,DisplayMenu.class));
			
		}else
		{
		
	
startActivity(new Intent(HomeActivity.this,DisplayAlphabet.class )
.putExtra("startIndex", imageSetTracker.get(viewId)));
Log.i("TAG-key", imageSetTracker.get(viewId)+"");

		
		
		
		}
	
	
		
	}






	




	private void startDialogActivity() {
		final Dialog dialog = new Dialog(HomeActivity.this);
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);// remove the title of the pop up
		dialog.setContentView(R.layout.display_menu_options);
		dialog.setTitle("Alphabets Options");
		
		Window window = dialog.getWindow();
		WindowManager.LayoutParams wlp = window.getAttributes();

		wlp.gravity = Gravity.BOTTOM;
		wlp.width= LayoutParams.MATCH_PARENT;
	
		window.setAttributes(wlp);
		dialog.show();
		
	}


	public static Context resourceForApplication() {
		// TODO Auto-generated method stub
		return mContext;
	}
}

