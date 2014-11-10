package org.susemiessner.android.urbanalphabets;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class CustomArrayAdapter extends ArrayAdapter<String> {
  private int mSelection;

  class ViewHolder {
    public ImageView imageView;
    public TextView textView;
  }

  public CustomArrayAdapter(Context context, String[] options, int selection) {
    super(context, R.layout.row, options);
    mSelection = selection;
  }

  @Override
  public View getView(int position, View convertView, ViewGroup parent) {
    View rowView = convertView;
    // Reuse views
    if (rowView == null) {
      LayoutInflater inflater =
          (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
      rowView = inflater.inflate(R.layout.row, parent, false);
      // Configure view holder
      ViewHolder viewHolder = new ViewHolder();
      viewHolder.imageView = (ImageView) rowView.findViewById(R.id.imageView_row);
      viewHolder.textView = (TextView) rowView.findViewById(R.id.textView_row);
      rowView.setTag(viewHolder);
    }
    // Set views
    ViewHolder viewHolder = (ViewHolder) rowView.getTag();
    if (isSelected(position)) {
      rowView.setFocusableInTouchMode(true);
      rowView.requestFocus();
      viewHolder.imageView.setImageResource(R.drawable.icon_checked);
    } else {
      rowView.setFocusableInTouchMode(false);
      viewHolder.imageView.setImageResource(0xFFFFFF);
    }
    viewHolder.textView.setText(getItem(position));
    return rowView;
  }

  public boolean isSelected(int position) {
    return (mSelection == position);
  }

  public void setSelected(int position) {
    mSelection = position;
  }

  public int getSelected() {
    return mSelection;
  }
}
