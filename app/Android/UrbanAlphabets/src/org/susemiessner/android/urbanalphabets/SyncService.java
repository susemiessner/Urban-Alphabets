package org.susemiessner.android.urbanalphabets;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Bitmap.CompressFormat;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.util.Base64;
import android.util.Log;

public class SyncService extends IntentService {

  private String username;

  public SyncService() {
    super("SyncService");
    /*
     * SharedPreferences sharedPreferences; try { sharedPreferences = PreferenceManager.
     * getDefaultSharedPreferences(this); } catch (NullPointerException ex) { sharedPreferences =
     * null; Log.d("Error",ex.getMessage()); } catch (RuntimeException ex ) { sharedPreferences =
     * null; Log.d("Error",ex.getMessage()); } username = sharedPreferences.getString("username",
     * "");
     */
    username = "user";
  }

  @Override
  protected void onHandleIntent(Intent intent) {
    Log.d("Error", "***");
    if (username == null)
      return;
    if (username.equals(""))
      return;

    SQLiteDatabase database = null;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      Log.d("Error", "****");
      return;
    }

    try {
      database.execSQL("CREATE TABLE IF NOT EXISTS updates(lng TEXT, "
          + "lat TEXT, letter TEXT, postcard TEXT, alphabet TEXT, "
          + "pText TEXT, lang TEXT, path TEXT )");
    } catch (SQLiteException ex) {
      Log.d("Error", ex.getMessage());
      database.close();
      return;
    }

    Cursor cursor = database.rawQuery("select * from updates", null);
    Log.d("Error", "####");
    boolean b = cursor.moveToFirst();
    if (cursor != null && b) {
      Log.d("Error", "*****");
      do {
        String lng = cursor.getString(cursor.getColumnIndex("lng"));
        String lat = cursor.getString(cursor.getColumnIndex("lat"));
        String letter = cursor.getString(cursor.getColumnIndex("letter"));
        String postcard = cursor.getString(cursor.getColumnIndex("postcard"));
        String alphabet = cursor.getString(cursor.getColumnIndex("alphabet"));
        String pText = cursor.getString(cursor.getColumnIndex("pText"));
        String lang = cursor.getString(cursor.getColumnIndex("lang"));
        String filename = cursor.getString(cursor.getColumnIndex("path"));
        File file =
            new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets" + File.separator + filename + ".png");
        if (file.exists())
          sync(lng, lat, letter, postcard, alphabet, pText, lang, file.getAbsolutePath());
      } while (cursor.moveToNext());
    }
    if (cursor != null)
      cursor.close();
    database.close();
  }

  private void sync(String lng, String lat, String letter, String postcard, String alphabet,
      String pText, String lang, String path) {
    Log.d("Error", "******");
    try {
      DefaultHttpClient httpClient = new DefaultHttpClient();
      HttpPost httpPost = new HttpPost("http://www.ualphabets.com/add_android.php");
      List<NameValuePair> nvps = new ArrayList<NameValuePair>();
      nvps.add(new BasicNameValuePair("longitude", lng));
      nvps.add(new BasicNameValuePair("latitude", lat));
      nvps.add(new BasicNameValuePair("owner", username));
      nvps.add(new BasicNameValuePair("letter", letter));
      nvps.add(new BasicNameValuePair("postcard", postcard));
      nvps.add(new BasicNameValuePair("alphabet", alphabet));
      nvps.add(new BasicNameValuePair("image", getImageAsString(path)));
      nvps.add(new BasicNameValuePair("language", lang));
      nvps.add(new BasicNameValuePair("postcardText", pText));
      httpPost.setEntity(new UrlEncodedFormEntity(nvps, "US-ASCII"));
      HttpResponse httpResponse = httpClient.execute(httpPost);
      // Check returned code
      httpResponse.getStatusLine().getStatusCode();
    } catch (Exception e) {

    }
  }

  private String getImageAsString(String path) {
    Bitmap bitmap = BitmapFactory.decodeFile(path);
    ByteArrayOutputStream stream = new ByteArrayOutputStream();
    bitmap.compress(CompressFormat.PNG, 100, stream);
    byte[] byteArrayImage = stream.toByteArray();
    String encodedImage = Base64.encodeToString(byteArrayImage, Base64.DEFAULT);
    return encodedImage;
  }

}
