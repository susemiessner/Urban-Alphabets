package org.susemiessner.android.urbanalphabets;

import java.io.ByteArrayOutputStream;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.os.AsyncTask;
import android.util.Base64;

public class UpdateDatabase extends AsyncTask<Void, Void, Void> {
	private ProgressDialog pDialog;
	private Context context;
	private String longitude;
	private String latitude;
	private String userName;
	private String letter;
	private String postcard;
	private String alphabet;
	private Bitmap bitmap;
	private String language;
	private String postcardText;
	
	public UpdateDatabase(Context context, String longitude, String latitude,
			String userName, String letter, String postcard, String alphabet,
			Bitmap bitmap, String language, String postcardText) {
		super();
		this.context = context;
		this.longitude = longitude;
		this.latitude = latitude;
		this.userName = userName;
		this.letter = letter;
		this.postcard = postcard;
		this.alphabet = alphabet;
		this.bitmap = bitmap;
		this.language = language;
		this.postcardText = postcardText;
	}
	
	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		pDialog = new ProgressDialog(context);
        pDialog.setMessage("Updating to Database.");
        pDialog.setIndeterminate(false);
        pDialog.setCancelable(false);
        pDialog.show();
	}
	@Override
	protected Void doInBackground(Void... params) {
		try {
			DefaultHttpClient httpClient = new DefaultHttpClient();
			HttpPost httpPost = new HttpPost("http://www.ualphabets.com/add_android.php");
			List <NameValuePair> nvps = new ArrayList <NameValuePair>();
			nvps.add(new BasicNameValuePair("longitude", longitude));
			nvps.add(new BasicNameValuePair("latitude", latitude));
			nvps.add(new BasicNameValuePair("owner", userName));
			nvps.add(new BasicNameValuePair("letter", letter));
			nvps.add(new BasicNameValuePair("postcard", postcard));
			nvps.add(new BasicNameValuePair("alphabet",alphabet));
			nvps.add(new BasicNameValuePair("image", getImageAsString()));
			nvps.add(new BasicNameValuePair("language", language));
			nvps.add(new BasicNameValuePair("postcardText", postcardText));
			httpPost.setEntity(new UrlEncodedFormEntity(nvps,"US-ASCII"));
			HttpResponse httpResponse = httpClient.execute(httpPost);
			// Check returned code 
			httpResponse.getStatusLine().getStatusCode();
		} catch (Exception e){
			
		}
		return null;
	}
	@Override
	protected void onPostExecute(Void arg){
		pDialog.dismiss();
	}
	
	private String getImageAsString() {
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		bitmap.compress(CompressFormat.PNG, 100, stream);
		byte [] byteArrayImage = stream.toByteArray();
		String encodedImage = Base64.encodeToString(byteArrayImage, Base64.DEFAULT);
		return encodedImage;
	}
}
