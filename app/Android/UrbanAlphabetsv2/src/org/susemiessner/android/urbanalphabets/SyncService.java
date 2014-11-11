package org.susemiessner.android.urbanalphabets;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
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
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.util.Base64;

public class SyncService extends IntentService {

  private String username;

  public SyncService() {
    super("SyncService");
    username = null;
  }

  @Override
  protected void onHandleIntent(Intent intent) {

    username =
        PreferenceManager.getDefaultSharedPreferences(getApplicationContext()).getString(
            "username", "");
    if (username == null || username.isEmpty())
      return;

    SQLiteDatabase database = null;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    try {
      database.execSQL("CREATE TABLE IF NOT EXISTS updates(lng TEXT, "
          + "lat TEXT, letter TEXT, postcard TEXT, alphabet TEXT, "
          + "pText TEXT, lang TEXT, prefix TEXT, suffix TEXT  )");
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    Cursor cursor = database.rawQuery("select * from updates", null);
    if (cursor != null && cursor.moveToFirst()) {
      do {
        String lng = cursor.getString(cursor.getColumnIndex("lng"));
        String lat = cursor.getString(cursor.getColumnIndex("lat"));
        String letter = cursor.getString(cursor.getColumnIndex("letter"));
        String postcard = cursor.getString(cursor.getColumnIndex("postcard"));
        String alphabet = cursor.getString(cursor.getColumnIndex("alphabet"));
        String pText = cursor.getString(cursor.getColumnIndex("pText"));
        String lang = cursor.getString(cursor.getColumnIndex("lang"));
        String prefix = cursor.getString(cursor.getColumnIndex("prefix"));
        String suffix = cursor.getString(cursor.getColumnIndex("suffix"));
        File file =
            new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
                "UrbanAlphabets" + File.separator + prefix + suffix + ".png");
        if (file.exists())
          sync(lng, lat, letter, postcard, alphabet, pText, lang, file.getAbsolutePath());
        try {
          database.delete("updates", "prefix=? and suffix=?", new String[] {prefix, suffix});
        } catch (SQLiteException ex) {
          ex.printStackTrace();
        }
      } while (cursor.moveToNext());
    }
    if (cursor != null)
      cursor.close();
    database.close();
  }

  private void sync(String lng, String lat, String letter, String postcard, String alphabet,
      String pText, String lang, String path) {
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
    } catch (Exception ex) {
      ex.printStackTrace();
    }
  }

  private String getImageAsString(String path) {
    File file = new File(path);
    byte[] byteArrayImage = new byte[(int) file.length()];
    FileInputStream input = null;
    try {
      input = new FileInputStream(file);
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    try {
      input.read(byteArrayImage);
    } catch (IOException e) {
      e.printStackTrace();
    }
    try {
      input.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
    String encodedImage = Base64.encodeToString(byteArrayImage, Base64.DEFAULT);
    return encodedImage;
  }

}
