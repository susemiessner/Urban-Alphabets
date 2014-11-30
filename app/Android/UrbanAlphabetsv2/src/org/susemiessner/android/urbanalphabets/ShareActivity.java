package org.susemiessner.android.urbanalphabets;


import java.lang.ref.WeakReference;

import android.app.ActionBar;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;

public class ShareActivity extends Activity {
  private ShareArrayAdapter mAdapter;
  private String mPath;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_share);
    ActionBar actionBar = getActionBar();
    actionBar.setTitle("Share " + getIntent().getStringExtra("sharingWhat"));
    mPath = getIntent().getStringExtra("sharePath");
    ImageView imageView = (ImageView) findViewById(R.id.imageView_share_image);
    new DisplayImage(imageView).execute();
    ListView listView = (ListView) findViewById(R.id.listView_share);
    mAdapter = new ShareArrayAdapter(this);
    listView.setAdapter(mAdapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        mAdapter.click(position, "Sharing UrbanAlphabets",
            ((EditText) findViewById(R.id.editText_share_message)).getText().toString(), mPath);
        finish();
      }
    });
  }

  class DisplayImage extends AsyncTask<Void, Void, Bitmap> {
    private final WeakReference<ImageView> imageViewReference;
    private int reqHeight;
    // private int reqWidth;
    private DisplayMetrics metrics;

    public DisplayImage(ImageView imageView) {
      imageViewReference = new WeakReference<ImageView>(imageView);
      metrics = new DisplayMetrics();
      getWindowManager().getDefaultDisplay().getMetrics(metrics);
    }

    public Bitmap decodeSampledBitmap() {
      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      BitmapFactory.decodeFile(mPath, options);

      // Calculate density of image w/o scaling for this image view
      if (options.inTargetDensity == 0)
        options.inTargetDensity = metrics.densityDpi;
      float height = (float) reqHeight / options.inTargetDensity;
      options.inDensity = (int) (options.outHeight / height);
      options.inSampleSize = 1;
      options.inJustDecodeBounds = false;

      return BitmapFactory.decodeFile(mPath, options);
    }

    @Override
    protected Bitmap doInBackground(Void... params) {
      reqHeight = (int) (100f * getResources().getDisplayMetrics().density);
      // reqWidth = (int) (100f * getResources().getDisplayMetrics().density);
      return decodeSampledBitmap();
    }

    @Override
    protected void onPostExecute(Bitmap bitmap) {
      if (imageViewReference != null && bitmap != null) {
        final ImageView imageView = imageViewReference.get();
        if (imageView != null) {
          imageView.setImageBitmap(bitmap);
        }
      }
    }
  }
}
