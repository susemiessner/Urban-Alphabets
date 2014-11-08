package org.susemiessner.android.urbanalphabets;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.widget.ImageView;

public class CropView extends ImageView {
  private int left;
  private int right;
  private int top;
  private int bottom;

  Paint paint;

  public CropView(Context context) {
    super(context);
    paint();
  }

  public CropView(Context context, AttributeSet attrs) {
    super(context, attrs);
    paint();
  }

  public CropView(Context context, AttributeSet attrs, int defStyle) {
    super(context, attrs, defStyle);
    paint();
  }

  private void paint() {
    paint = new Paint();
    paint.setColor(getResources().getColor(R.color.TransparentGrey));
    paint.setStyle(Paint.Style.FILL);
  }

  @Override
  public void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    int width = 439;
    int height = 534;
    left = (getWidth() - width) / 2;
    right = left + width;
    top = (getHeight() - height) / 2;
    bottom = top + height;
    canvas.drawRect(0, 0, getWidth(), top, paint);
    canvas.drawRect(0, bottom, getWidth(), getHeight(), paint);
    canvas.drawRect(0, top, left, bottom, paint);
    canvas.drawRect(right, top, getWidth(), bottom, paint);
  }

  public float getLeftRect() {
    return (float) left;
  }

  public float getRightRect() {
    return (float) right;
  }

  public float getTopRect() {
    return (float) top;
  }

  public float getBottomRect() {
    return (float) bottom;
  }
}
