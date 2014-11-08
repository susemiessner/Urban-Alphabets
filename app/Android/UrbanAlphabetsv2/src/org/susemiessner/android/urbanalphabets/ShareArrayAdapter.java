package org.susemiessner.android.urbanalphabets;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ShareArrayAdapter extends ArrayAdapter<ResolveInfo> {
  class ViewHolder {
    public ImageView imageView;
    public TextView textView;
  }

  public ShareArrayAdapter(Context context) {
    super(context, R.layout.row, new ArrayList<ResolveInfo>());
    List<ResolveInfo> items =
        getContext().getPackageManager().queryIntentActivities(getSendIntent("", "", ""), 0);
    Collections
        .sort(items, new ResolveInfo.DisplayNameComparator(getContext().getPackageManager()));
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
      viewHolder.imageView = (ImageView) rowView.findViewById(R.id.imageView_share_row);
      viewHolder.textView = (TextView) rowView.findViewById(R.id.textView_share_row);
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

  public void click(int position, final String subject, final String body, final String path) {
    ResolveInfo launchable = getItem(position);
    ActivityInfo activity = launchable.activityInfo;
    ComponentName name = new ComponentName(activity.applicationInfo.packageName, activity.name);
    Intent actionSendIntent = getSendIntent(subject, body, path);
    actionSendIntent.setComponent(name);
    getContext().startActivity(actionSendIntent);
  }
}
