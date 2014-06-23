package org.susemiessner.android.urbanalphabets;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.widget.ImageView;

public class CropView extends ImageView {
	private float left;
	private float right;
	private float top;
	private float bottom;
	
	Paint paint;
	public CropView(Context context) {
		super(context);
		initPaint();
	}
	
	public CropView(Context context, AttributeSet attrs) {
		super(context, attrs);
		initPaint();
	}
	
	public CropView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		initPaint();
	}
	
	private void initPaint() {
		paint = new Paint();
		paint.setColor(getResources().getColor(R.color.TransparentGrey));
		paint.setStyle(Paint.Style.FILL);
	}
	
	@Override
	public void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		left = (float)getWidth() * 0.25f;
		right = (float)getWidth() * 0.75f;
		top = (float)getHeight() * 0.50f - (float)getWidth() * 0.50f * 0.50f * (534.00f/439.00f);
		bottom = top + (float)getWidth() * 0.50f * (534.00f/439.00f);
		canvas.drawRect(0, 0, getWidth(), top, paint);
		canvas.drawRect(0, bottom, getWidth(), getHeight(), paint);
		canvas.drawRect(0, top, left, bottom, paint);
		canvas.drawRect(right, top, getWidth(), bottom, paint);
	}
	
	public float getLeftRect() {
		return left;
	}
	
	public float getRightRect() {
		return right;
	}

	public float getTopRect() {
		return top;
	}

	public float getBottomRect() {
		return bottom;
	}
}
