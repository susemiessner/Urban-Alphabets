package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
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

  private class CustomArrayAdapter extends ArrayAdapter<ResolveInfo> {

    class ViewHolder {
      public ImageView imageView;
      public TextView textView;
    }

    public CustomArrayAdapter(Context context) {
      super(context, R.layout.row, new ArrayList<ResolveInfo>());
      List<ResolveInfo> items =
          getContext().getPackageManager().queryIntentActivities(getSendIntent("", "", ""), 0);
      Collections.sort(items, new ResolveInfo.DisplayNameComparator(getContext()
          .getPackageManager()));
      for (ResolveInfo item : items) {
        add(item);
      }
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
      View rowView = convertView;
      // Reuse views
      if (rowView == null) {
        LayoutInflater inflater =
            (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        rowView = inflater.inflate(R.layout.share_row, parent, false);
        // Configure view Holder ViewHolder
        ViewHolder viewHolder = new ViewHolder();
        viewHolder.imageView = (ImageView) rowView.findViewById(R.id.imageview_share_row);
        viewHolder.textView = (TextView) rowView.findViewById(R.id.textview_share_row);
        rowView.setTag(viewHolder);
      }
      // Set views
      PackageManager packageManager = getContext().getPackageManager();
      ResolveInfo item = getItem(position);
      ViewHolder viewHolder = (ViewHolder) rowView.getTag();
      viewHolder.imageView.setImageDrawable(item.loadIcon(packageManager));
      viewHolder.textView.setText(item.loadLabel(packageManager));
      return rowView;
    }

    private Intent getSendIntent(String subject, String text, String path) {
      Intent intent = new Intent(android.content.Intent.ACTION_SEND);
      intent.setType("image/png");
      intent.putExtra(android.content.Intent.EXTRA_SUBJECT, "");
      intent.putExtra(android.content.Intent.EXTRA_TEXT, "");
      intent.putExtra(Intent.EXTRA_STREAM, Uri.parse("file://" + path));
      return intent;
    }

    public void onClick(int position, final String subject, final String body, final String path) {
      ResolveInfo launchable = getItem(position);
      ActivityInfo activity = launchable.activityInfo;
      ComponentName name = new ComponentName(activity.applicationInfo.packageName, activity.name);
      Intent actionSendIntent = getSendIntent(subject, body, path);
      actionSendIntent.setComponent(name);
      getContext().startActivity(actionSendIntent);
    }
  }

  private CustomArrayAdapter adapter;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_share);
    ActionBar actionBar = getSupportActionBar();
    actionBar.setTitle("Share " + getIntent().getStringExtra("sharingWhat"));
    ListView listView = (ListView) findViewById(R.id.listview_share);
    adapter = new CustomArrayAdapter(this);
    listView.setAdapter(adapter);
    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
      @Override
      public void onItemClick(AdapterView<?> parent, final View view, int position, long id) {
        adapter.onClick(position, "Sharing UrbanAlphabets",
            ((EditText) findViewById(R.id.edittext_share_message)).getText().toString(),
            getFileToShare().getAbsolutePath());
        finish();
      }
    });
    ImageView imageView = (ImageView) findViewById(R.id.imageview_share_image);
    new DisplayImage(imageView).execute();
  }

  private File getFileToShare() {
    String filename = "share";
    File file =
        new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
            "UrbanAlphabets" + File.separator + filename + ".png");
    return file;
  }

  class DisplayImage extends AsyncTask<Void, Void, Bitmap> {
    private final WeakReference<ImageView> imageViewReference;
    private int reqHeight;
    private int reqWidth;

    public DisplayImage(ImageView imageView) {
      imageViewReference = new WeakReference<ImageView>(imageView);
    }

    public int calculateInSampleSize(BitmapFactory.Options options) {
      // Raw height and width of image
      final int height = options.outHeight;
      final int width = options.outWidth;
      int inSampleSize = 1;

      if (height > reqHeight || width > reqWidth) {

        final int halfHeight = height / 2;
        final int halfWidth = width / 2;

        // Calculate the largest inSampleSize value that is a power of 2
        // and keeps both
        // height and width larger than the requested height and width.
        while ((halfHeight / inSampleSize) > reqHeight && (halfWidth / inSampleSize) > reqWidth) {
          inSampleSize *= 2;
        }
      }
      return inSampleSize;
    }

    public Bitmap decodeSampledBitmap(File file) {
      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      BitmapFactory.decodeFile(file.getAbsolutePath(), options);

      // Calculate inSampleSize
      options.inSampleSize = calculateInSampleSize(options);

      // Decode bitmap with inSampleSize set
      options.inJustDecodeBounds = false;
      return BitmapFactory.decodeFile(file.getAbsolutePath(), options);
    }

    @Override
    protected Bitmap doInBackground(Void... params) {
      File file = getFileToShare();
      final ImageView imageView = imageViewReference.get();
      if (imageView == null)
        return null;
      reqHeight = imageView.getHeight();
      reqWidth = imageView.getWidth();
      // Is this efficient way.
      do {
        try {
          Thread.sleep(500);
        } catch (InterruptedException ex) {
          Log.d("ShareActivity", ex.getMessage());
        }
      } while (!file.exists());

      return decodeSampledBitmap(file);
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
