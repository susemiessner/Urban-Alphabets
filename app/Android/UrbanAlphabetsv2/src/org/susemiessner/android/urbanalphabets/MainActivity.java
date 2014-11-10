package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.Resources;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Bitmap.CompressFormat;
import android.location.Location;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;


public class MainActivity extends Activity implements GooglePlayServicesClient.ConnectionCallbacks,
    GooglePlayServicesClient.OnConnectionFailedListener, LocationListener {
  /*
   * Languages: Finnish/Swedish Danish/Norwegian English/Portugese German Spanish Russian Latvian
   */

  public static final String RESOURCE_NAME[][] = {
      {"letter_a", "letter_b", "letter_c", "letter_d", "letter_e", "letter_f", "letter_g",
          "letter_h", "letter_i", "letter_j", "letter_k", "letter_l", "letter_m", "letter_n",
          "letter_o", "letter_p", "letter_q", "letter_r", "letter_s", "letter_t", "letter_u",
          "letter_v", "letter_w", "letter_x", "letter_y", "letter_z", "letter_aa", "letter_oo",
          "letter_adot", "letter_dot", "letter_exclaim", "letter_question", "letter_0", "letter_1",
          "letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7", "letter_8",
          "letter_9"},
      {"letter_a", "letter_b", "letter_c", "letter_d", "letter_e", "letter_f", "letter_g",
          "letter_h", "letter_i", "letter_j", "letter_k", "letter_l", "letter_m", "letter_n",
          "letter_o", "letter_p", "letter_q", "letter_r", "letter_s", "letter_t", "letter_u",
          "letter_v", "letter_w", "letter_x", "letter_y", "letter_z", "letter_ae",
          "letter_danisho", "letter_adot", "letter_dot", "letter_exclaim", "letter_question",
          "letter_0", "letter" + "_1", "letter_2", "letter_3", "letter_4", "letter_5", "letter_6",
          "let" + "ter_7", "letter_8", "letter_9"},
      {"letter_a", "letter_b", "letter_c", "letter_d", "letter_e", "letter_f", "letter_g",
          "letter_h", "letter_i", "letter_j", "letter_k", "letter_l", "letter_m", "letter_n",
          "letter_o", "letter_p", "letter_q", "letter_r", "letter_s", "letter_t", "letter_u",
          "letter_v", "letter_w", "letter_x", "letter_y", "letter_z", "letter_plus",
          "letter_dollar", "letter_comma", "letter_dot", "letter_exclaim", "letter_question",
          "letter_0", "letter_1", "letter_2", "letter_3", "letter_4", "letter_5", "letter_6",
          "let" + "ter_7", "letter_8", "letter_9"},
      {"letter_a", "letter_b", "letter_c", "letter_d", "letter_e", "letter_f", "letter_g",
          "letter_h", "letter_i", "letter_j", "letter_k", "letter_l", "letter_m", "letter_n",
          "letter_o", "letter_p", "letter_q", "letter_r", "letter_s", "letter_t", "letter_u",
          "letter_v", "letter_w", "letter_x", "letter_y", "letter_z", "letter_aa", "letter_oo",
          "letter_uu", "letter_dot", "letter_exclaim", "letter_question", "letter_0", "letter_1",
          "letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7", "letter_8",
          "letter_9"},
      {"letter_a", "letter_b", "letter_c", "letter_d", "letter_e", "letter_f", "letter_g",
          "letter_h", "letter_i", "letter_j", "letter_k", "letter_l", "letter_m", "letter_n",
          "letter_o", "letter_p", "letter_q", "letter_r", "letter_s", "letter_t", "letter_u",
          "letter_v", "letter_w", "letter_x", "letter_y", "letter_z", "letter_spanishn",
          "letter_plus", "letter_comma", "letter_dot", "letter_exclaim", "letter_question",
          "letter_0", "letter_1", "letter_2", "letter_3", "letter_4", "letter_5", "letter_6",
          "letter_7", "letter_8", "letter_9"},
      {"letter_a", "letter_rusb", "letter_b", "letter_rusg", "letter_rusd", "letter_e",
          "letter_rusjo", "letter_russche", "letter_russe", "letter_rusi", "letter_rusikratkoje",
          "letter_k", "letter_rusl", "letter_m", "letter_rusn", "letter_o", "letter_rusp",
          "letter_p", "letter_c", "letter_t", "letter_y", "letter_rusf", "letter_x", "letter_rusz",
          "letter_rustsche", "letter_russcha", "letter_rustschescha", "letter_rusmjachkisnak",
          "letter_rusui", "letter_ruse", "letter_rusju", "letter_rusja", "letter_0", "letter_1",
          "letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7", "letter_8",
          "letter_9"},
      {"letter_a", "letter_latva", "letter_b", "letter_c", "letter_latvc", "letter_d", "letter_e",
          "letter_latve", "letter_f", "letter_g", "letter_latvg", "letter_h", "letter_i",
          "letter_latvi", "letter_j", "letter_k", "letter_latvk", "letter_l", "letter_latvl",
          "letter_m", "letter_n", "letter_latvn", "letter_o", "letter_p", "letter_r", "letter_s",
          "letter_latvs", "letter_t", "letter_u", "letter_latvu", "letter_v", "letter_z",
          "letter_latvz", "letter_1", "letter_2", "letter_3", "letter_4", "letter_5", "letter_6",
          "letter_7", "letter_8", "letter_9"}};
  public static final int RESOURCE_INDEX[][] = {
      {R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d, R.raw.letter_e,
          R.raw.letter_f, R.raw.letter_g, R.raw.letter_h, R.raw.letter_i, R.raw.letter_j,
          R.raw.letter_k, R.raw.letter_l, R.raw.letter_m, R.raw.letter_n, R.raw.letter_o,
          R.raw.letter_p, R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
          R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, R.raw.letter_y,
          R.raw.letter_z, R.raw.letter_aa, R.raw.letter_oo, R.raw.letter_adot, R.raw.letter_dot,
          R.raw.letter_exclaim, R.raw.letter_question, R.raw.letter_0, R.raw.letter_1,
          R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5, R.raw.letter_6,
          R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
      {R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d, R.raw.letter_e,
          R.raw.letter_f, R.raw.letter_g, R.raw.letter_h, R.raw.letter_i, R.raw.letter_j,
          R.raw.letter_k, R.raw.letter_l, R.raw.letter_m, R.raw.letter_n, R.raw.letter_o,
          R.raw.letter_p, R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
          R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, R.raw.letter_y,
          R.raw.letter_z, R.raw.letter_ae, R.raw.letter_danisho, R.raw.letter_adot,
          R.raw.letter_dot, R.raw.letter_exclaim, R.raw.letter_question, R.raw.letter_0,
          R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5,
          R.raw.letter_6, R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
      {R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d, R.raw.letter_e,
          R.raw.letter_f, R.raw.letter_g, R.raw.letter_h, R.raw.letter_i, R.raw.letter_j,
          R.raw.letter_k, R.raw.letter_l, R.raw.letter_m, R.raw.letter_n, R.raw.letter_o,
          R.raw.letter_p, R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
          R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, R.raw.letter_y,
          R.raw.letter_z, R.raw.letter_plus, R.raw.letter_dollar, R.raw.letter_comma,
          R.raw.letter_dot, R.raw.letter_exclaim, R.raw.letter_question, R.raw.letter_0,
          R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5,
          R.raw.letter_6, R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
      {R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d, R.raw.letter_e,
          R.raw.letter_f, R.raw.letter_g, R.raw.letter_h, R.raw.letter_i, R.raw.letter_j,
          R.raw.letter_k, R.raw.letter_l, R.raw.letter_m, R.raw.letter_n, R.raw.letter_o,
          R.raw.letter_p, R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
          R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, R.raw.letter_y,
          R.raw.letter_z, R.raw.letter_aa, R.raw.letter_oo, R.raw.letter_uu, R.raw.letter_dot,
          R.raw.letter_exclaim, R.raw.letter_question, R.raw.letter_0, R.raw.letter_1,
          R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5, R.raw.letter_6,
          R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
      {R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d, R.raw.letter_e,
          R.raw.letter_f, R.raw.letter_g, R.raw.letter_h, R.raw.letter_i, R.raw.letter_j,
          R.raw.letter_k, R.raw.letter_l, R.raw.letter_m, R.raw.letter_n, R.raw.letter_o,
          R.raw.letter_p, R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
          R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, R.raw.letter_y,
          R.raw.letter_z, R.raw.letter_spanishn, R.raw.letter_plus, R.raw.letter_comma,
          R.raw.letter_dot, R.raw.letter_exclaim, R.raw.letter_question, R.raw.letter_0,
          R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5,
          R.raw.letter_6, R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
      {R.raw.letter_a, R.raw.letter_rusb, R.raw.letter_b, R.raw.letter_rusg, R.raw.letter_rusd,
          R.raw.letter_e, R.raw.letter_rusjo, R.raw.letter_russche, R.raw.letter_russe,
          R.raw.letter_rusi, R.raw.letter_rusikratkoje, R.raw.letter_k, R.raw.letter_rusl,
          R.raw.letter_m, R.raw.letter_rusn, R.raw.letter_o, R.raw.letter_rusp, R.raw.letter_p,
          R.raw.letter_c, R.raw.letter_t, R.raw.letter_y, R.raw.letter_rusf, R.raw.letter_x,
          R.raw.letter_rusz, R.raw.letter_rustsche, R.raw.letter_russcha,
          R.raw.letter_rustschescha, R.raw.letter_rusmjachkisnak, R.raw.letter_rusui,
          R.raw.letter_ruse, R.raw.letter_rusju, R.raw.letter_rusja, R.raw.letter_0,
          R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5,
          R.raw.letter_6, R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
      {R.raw.letter_a, R.raw.letter_latva, R.raw.letter_b, R.raw.letter_c, R.raw.letter_latvc,
          R.raw.letter_d, R.raw.letter_e, R.raw.letter_latve, R.raw.letter_f, R.raw.letter_g,
          R.raw.letter_latvg, R.raw.letter_h, R.raw.letter_i, R.raw.letter_latvi, R.raw.letter_j,
          R.raw.letter_k, R.raw.letter_latvk, R.raw.letter_l, R.raw.letter_latvl, R.raw.letter_m,
          R.raw.letter_n, R.raw.letter_latvn, R.raw.letter_o, R.raw.letter_p, R.raw.letter_r,
          R.raw.letter_s, R.raw.letter_latvs, R.raw.letter_t, R.raw.letter_u, R.raw.letter_latvu,
          R.raw.letter_v, R.raw.letter_z, R.raw.letter_latvz, R.raw.letter_1, R.raw.letter_2,
          R.raw.letter_3, R.raw.letter_4, R.raw.letter_5, R.raw.letter_6, R.raw.letter_7,
          R.raw.letter_8, R.raw.letter_9}};
  public static final char LETTER[][] = {
      {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
          'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Ä', 'Ö', 'Å', '.', '!', '?', '0', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'},
      {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
          'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Æ', 'Ø', 'Å', '.', '!', '?', '0', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'},
      {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
          'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '+', '$', ',', '.', '!', '?', '0', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'},
      {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
          'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Ä', 'Ö', 'Ü', '.', '!', '?', '0', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'},
      {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
          'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Ñ', '+', ',', '.', '!', '?', '0', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'},
      {'A', 'Б', 'B', 'Г', 'Д', 'E', 'Ё', 'Ж', 'З', 'И', 'Й', 'K', 'Л', 'M', 'Н', 'O', 'П', 'P',
          'C', 'T', 'Y', 'Ф', 'X', 'Ц', 'Ч', 'Ш', 'Щ', 'Ь', 'Ы', 'Э', 'Ю', 'Я', '0', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'},
      {'A', 'Ā', 'B', 'C', 'Č', 'D', 'E', 'Ē', 'F', 'G', 'Ģ', 'H', 'I', 'Ī', 'J', 'K', 'Ķ', 'L',
          'Ļ', 'M', 'N', 'Ņ', 'O', 'P', 'R', 'S', 'Š', 'T', 'U', 'Ū', 'V', 'Z', 'Ž', '1', '2', '3',
          '4', '5', '6', '7', '8', '9'}};
  public static final String LETTER_NAME[][] = {
      {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "OO", "AAA", ".", "!", "?", "0", "1", "2",
          "3", "4", "5", "6", "7", "8", "9"},
      {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z", "AE", "OO", "AAA", ".", "!", "?", "0", "1", "2",
          "3", "4", "5", "6", "7", "8", "9"},
      {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z", "+", "$", ",", ".", "!", "?", "0", "1", "2", "3",
          "4", "5", "6", "7", "8", "9"},
      {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z", "AA", "OO", "UU", ".", "!", "?", "0", "1", "2",
          "3", "4", "5", "6", "7", "8", "9"},
      {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
          "S", "T", "U", "V", "W", "X", "Y", "Z", "NN", "+", ",", ".", "!", "?", "0", "1", "2",
          "3", "4", "5", "6", "7", "8", "9"},
      {"A", "RusB", "B", "RusG", "RusD", "E", "RusJo", "RusSche", "RrusSe", "RusI", "RusIkratkoje",
          "K", "RusL", "M", "RusN", "O", "RusP", "P", "C", "T", "Y", "RusF", "X", "RusZ",
          "RusTsche", "RusScha", "RusTschescha", "RusMjachkiSnak", "RusUi", "RusE", "RusJu",
          "RusJa", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"},
      {"A", "LatvA", "B", "C", "LatvC", "D", "E", "LatvE", "F", "G", "LatvG", "H", "I", "LatvI",
          "J", "K", "LatvK", "L", "LatvL", "M", "N", "LatvN", "O", "P", "R", "S", "LatvS", "T",
          "U", "LatvU", "V", "Z", "LatvZ", "1", "2", "3", "4", "5", "6", "7", "8", "9"}};
  public static final String[] LANGUAGE = {"Finnish/Swedish", "Danish/Norwegian",
      "English/Portugese", "German", "Spanish", "Russian", "Latvian"};
  private final static int CONNECTION_FAILURE_RESOLUTION_REQUEST = 9000;
  private int mImageViewId[] = {R.id.imageView_main1, R.id.imageView_main2, R.id.imageView_main3,
      R.id.imageView_main4, R.id.imageView_main5, R.id.imageView_main6, R.id.imageView_main7,
      R.id.imageView_main8, R.id.imageView_main9, R.id.imageView_main10, R.id.imageView_main11,
      R.id.imageView_main12, R.id.imageView_main13, R.id.imageView_main14, R.id.imageView_main15,
      R.id.imageView_main16, R.id.imageView_main17, R.id.imageView_main18, R.id.imageView_main19,
      R.id.imageView_main20, R.id.imageView_main21, R.id.imageView_main22, R.id.imageView_main23,
      R.id.imageView_main24, R.id.imageView_main25, R.id.imageView_main26, R.id.imageView_main27,
      R.id.imageView_main28, R.id.imageView_main29, R.id.imageView_main30, R.id.imageView_main31,
      R.id.imageView_main32, R.id.imageView_main33, R.id.imageView_main34, R.id.imageView_main35,
      R.id.imageView_main36, R.id.imageView_main37, R.id.imageView_main38, R.id.imageView_main39,
      R.id.imageView_main40, R.id.imageView_main41, R.id.imageView_main42};
  private int mMargin;
  private int mHeight;
  private int mWidth;
  private String mLanguage;
  private String mAlphabet;
  private LinearLayout mLinearLayout;
  private SharedPreferences mSharedPreferences;
  private List<Integer> mImageViewIdList;
  private LocationClient mLocationClient;
  private LocationRequest mLocationRequest;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    mAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    mLanguage = mSharedPreferences.getString("currentLanguage", "");
    if (mAlphabet.isEmpty() || mLanguage.isEmpty())
      initialize();
    getActionBar().setTitle(mAlphabet);
    mLinearLayout = (LinearLayout) findViewById(R.id.layout_main);

    mImageViewIdList = new ArrayList<Integer>();
    for (int i = 0; i < 42; i++)
      mImageViewIdList.add(mImageViewId[i]);
    mLocationClient = new LocationClient(this, this, this);
    // Create the LocationRequest object
    mLocationRequest = LocationRequest.create();
    // Use high accuracy
    mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
    // Set the update interval to 5 seconds
    mLocationRequest.setInterval(5000);
    // Set the fastest update interval to 1 second
    mLocationRequest.setFastestInterval(1000);
    ViewTreeObserver vto = mLinearLayout.getViewTreeObserver();
    vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
      @Override
      public void onGlobalLayout() {
        try {
          mLinearLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
        } catch (IllegalStateException ex) {
          ex.printStackTrace();
        }
        RelativeLayout relativeLayout = (RelativeLayout) findViewById(R.id.relativeLayout_main);
        int height = mLinearLayout.getHeight() - relativeLayout.getHeight();
        mMargin = (height * 2) / 1000;
        if (mMargin < 1)
          mMargin = 1;
        mHeight = (height - mMargin * 2 * 7) / 7;
        mWidth = (mHeight * 439) / 534;
        // Set image views width and height
        setImageViews();
        setImages();
        /*
         * Saving as preferences.
         */
        Editor e = mSharedPreferences.edit();
        e.putInt("imageViewWidth", mWidth);
        e.putInt("imageViewHeight", mHeight);
        e.putInt("imageViewExtra", mMargin);
        e.commit();
      }
    });
  }

  @Override
  protected void onRestart() {
    super.onRestart();
    // Connect the client.
    mLocationClient.connect();
    mAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    mLanguage = mSharedPreferences.getString("currentLanguage", "");
    if (mAlphabet.isEmpty() || mLanguage.isEmpty())
      initialize();
    getActionBar().setTitle(mAlphabet);
    setImages();
  }

  @Override
  protected void onStop() {
    // If the client is connected
    if (mLocationClient.isConnected() && mSharedPreferences.getBoolean("enableLocation", true)) {
      /*
       * Remove location updates for a listener. The current Activity is the listener, so the
       * argument is "this".
       */
      mLocationClient.removeLocationUpdates(this);
    }
    mLocationClient.disconnect();
    for (int i = 0; i < 42; i++) {
      ((ImageView) findViewById(mImageViewId[i])).setImageBitmap(null);
    }
    super.onStop();
  }

  public void onResume() {
    super.onResume();
  }

  public void onPause() {
    super.onPause();
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.item_alphabet_info:
        Intent alphabetInfo = new Intent(this, AlphabetInfoActivity.class);
        startActivity(alphabetInfo);
        return true;
      case R.id.item_share_alphabet:
        new ShareAlphabet().execute();
        return true;
      case R.id.item_save_alphabet:
        new SaveAndSchedule().execute();
        return true;
      case R.id.item_write_postcard:
        Intent writePostcard = new Intent(this, WritePostcardActivity.class);
        startActivity(writePostcard);
        return true;
      case R.id.item_my_alphabets:
        Intent myAlphabets = new Intent(this, MyAlphabetsActivity.class);
        startActivity(myAlphabets);
        return true;
      case R.id.item_settings:
        Intent settings = new Intent(this, SettingsActivity.class);
        startActivity(settings);
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  private void setImageViews() {
    for (int i = 0; i < 42; i++) {
      TableRow.LayoutParams parms = new TableRow.LayoutParams(mWidth, mHeight);
      parms.setMargins(mMargin, mMargin, mMargin, mMargin);
      ((ImageView) findViewById(mImageViewId[i])).setLayoutParams(parms);
    }
  }

  private void setImages() {
    for (int index = 0; index < 42; index++) {
      ImageView imageView = (ImageView) findViewById(mImageViewId[index]);
      new BitmapWorkerTask(imageView).execute(index);
    }
  }

  public void takePhoto(View v) {
    Editor e = mSharedPreferences.edit();
    e.putInt("assignLetter", -1);
    e.commit();
    if (Build.VERSION.SDK_INT < 21) {
      Intent takePhoto = new Intent(this, TakePhotoActivity.class);
      startActivity(takePhoto);
    } else {

    }
  }

  public void showMenu(View view) {
    openOptionsMenu();
  }

  public void viewLetter(View view) {
    Intent viewLetter = new Intent(this, ViewLetterActivity.class);
    viewLetter.putExtra("currentAlphabet", mAlphabet);
    viewLetter.putExtra("currentLanguage", mLanguage);
    viewLetter.putExtra("currentIndex", mImageViewIdList.indexOf(view.getId()));
    startActivity(viewLetter);

  }

  private void initialize() {
    SQLiteDatabase database = null;
    boolean empty = false;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    try {
      database.execSQL("CREATE TABLE IF NOT EXISTS alphabets(alphabet TEXT, language TEXT, "
          + "selected INTEGER)");
      database.execSQL("CREATE TABLE IF NOT EXISTS updates(lng TEXT, lat TEXT, letter TEXT, "
          + "postcard TEXT, alphabet TEXT, pText TEXT, lang TEXT, prefix TEXT, suffix TEXT )");
    } catch (SQLiteException ex) {
      ex.printStackTrace();
    }

    /*
     * Check if table "alphabets" is empty
     */
    Cursor cursor = database.rawQuery("SELECT count(*) FROM alphabets", null);
    if (cursor != null && cursor.moveToFirst()) {
      if (cursor.getInt(0) == 0)
        empty = true;
    }
    if (cursor != null)
      cursor.close();

    /*
     * If table is empty, add "Untitled" alphabet with default language else retrieve from a
     * database
     */
    if (empty) {
      mAlphabet = "Untitled";
      mLanguage = MainActivity.LANGUAGE[mSharedPreferences.getInt("defaultLang", 0)];

      ContentValues alphabet = new ContentValues();
      alphabet.put("alphabet", mAlphabet);
      alphabet.put("language", mLanguage);
      alphabet.put("selected", 1);

      try {
        database.insert("alphabets", null, alphabet);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
    } else {
      cursor =
          database.query("alphabets", new String[] {"alphabet", "language"}, "selected=1", null,
              null, null, null);
      if (cursor != null && cursor.moveToFirst()) {
        mAlphabet = cursor.getString(cursor.getColumnIndex("alphabet"));
        mLanguage = cursor.getString(cursor.getColumnIndex("language"));
      }
      if (cursor != null)
        cursor.close();
    }

    database.close();

    /*
     * Save as preferences
     */
    Editor e = mSharedPreferences.edit();
    e.putString("currentAlphabet", mAlphabet);
    e.putString("currentLanguage", mLanguage);
    e.commit();
  }


  class SaveAndSchedule extends AsyncTask<Void, Void, Void> {
    @Override
    protected Void doInBackground(Void... params) {
      /*
       * Copy table layout to bitmap
       */
      TableLayout tableLayout = (TableLayout) findViewById(R.id.tableLayout_main);
      Bitmap alphabet =
          Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
              Bitmap.Config.ARGB_8888);
      Canvas canvas = new Canvas(alphabet);
      tableLayout.draw(canvas);
      /*
       * Save
       */
      String filename =
          (String) android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss",
              new java.util.Date());
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets" + File.separator + filename + ".png");
      FileOutputStream fos = null;
      try {
        fos = new FileOutputStream(file);
      } catch (FileNotFoundException ex) {
        ex.printStackTrace();
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      alphabet.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      try {
        fos.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }

      // Adding to gallery
      ContentValues image = new ContentValues();
      image.put(Images.Media.DATA, file.getAbsolutePath());
      getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);

      /*
       * Schedule
       */
      SQLiteDatabase database = null;
      try {
        database =
            getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }
      ContentValues entry = new ContentValues();
      entry.put("lng", mSharedPreferences.getString("longitude", "0"));
      entry.put("lat", mSharedPreferences.getString("latitude", "0"));
      entry.put("letter", "no");
      entry.put("postcard", "no");
      entry.put("alphabet", "yes");
      entry.put("pText", "");
      entry.put("lang", mLanguage);
      entry.put("prefix", "");
      entry.put("suffix", filename);

      try {
        database.insert("updates", null, entry);
      } catch (SQLiteException ex) {
        ex.printStackTrace();
      }

      database.close();
      return null;
    }
  }

  @Override
  public void onConnectionFailed(ConnectionResult connectionResult) {
    /*
     * Google Play services can resolve some errors it detects. If the error has a resolution, try
     * sending an Intent to start a Google Play services activity that can resolve error.
     */
    if (connectionResult.hasResolution()) {
      try {
        // Start an Activity that tries to resolve the error
        connectionResult.startResolutionForResult(this, CONNECTION_FAILURE_RESOLUTION_REQUEST);
        /*
         * Thrown if Google Play services canceled the original PendingIntent
         */
      } catch (IntentSender.SendIntentException ex) {
        // Log the error
        ex.printStackTrace();
      }
    } else {
      /*
       * If no resolution is available, display a dialog to the user with the error.
       */
      Log.d("Location", "ErrorDialog");
      // showErrorDialog(connectionResult.getErrorCode());
    }
  }

  @Override
  public void onConnected(Bundle connectionHint) {
    if (mSharedPreferences.getBoolean("enableLocation", true)) {
      mLocationClient.requestLocationUpdates(mLocationRequest, this);
    }
  }

  @Override
  public void onDisconnected() {
    Log.d("Location", "Not connected");
  }

  private boolean servicesConnected() {
    // Check that Google Play services is available
    int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
    // If Google Play services is available
    if (ConnectionResult.SUCCESS == resultCode) {
      Log.d("Location", "Connected");
      return true;
      // Google Play services was not available for some reason.
      // resultCode holds the error code.
    } else {
      // Get the error dialog from Google Play services
      Dialog errorDialog =
          GooglePlayServicesUtil.getErrorDialog(resultCode, this,
              CONNECTION_FAILURE_RESOLUTION_REQUEST);

      // If Google Play services can provide an error dialog
      if (errorDialog != null) {
        Log.d("Location", "ErrorDialog");
        return true;
      }
    }
    return true;
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    switch (requestCode) {
      case CONNECTION_FAILURE_RESOLUTION_REQUEST:
        switch (resultCode) {
          case Activity.RESULT_OK:
            break;
          default:
            break;
        }
    }
  }

  class ShareAlphabet extends AsyncTask<Void, Void, String> {
    private ProgressDialog mProgressDialog;

    @Override
    protected void onPreExecute() {
      mProgressDialog = new ProgressDialog(MainActivity.this);
      mProgressDialog.setTitle("Creating alphabet.");
      mProgressDialog.setMessage("Please wait.");
      mProgressDialog.setIndeterminate(false);
      mProgressDialog.setCancelable(false);
      mProgressDialog.show();
    }

    @Override
    protected String doInBackground(Void... params) {
      /*
       * Copy table layout to bitmap
       */
      TableLayout tableLayout = (TableLayout) findViewById(R.id.tableLayout_main);
      Bitmap alphabet =
          Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
              Bitmap.Config.ARGB_8888);
      Canvas canvas = new Canvas(alphabet);
      tableLayout.draw(canvas);
      String filename =
          (String) android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss",
              new java.util.Date());

      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets" + File.separator + filename + ".png");
      FileOutputStream fos = null;
      try {
        fos = new FileOutputStream(file);
      } catch (FileNotFoundException ex) {
        ex.printStackTrace();
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      alphabet.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      try {
        fos.close();
      } catch (IOException ex) {
        ex.printStackTrace();
      }
      alphabet = null;
      // Adding to gallery
      ContentValues image = new ContentValues();
      image.put(Images.Media.DATA, file.getAbsolutePath());
      getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
      return file.getAbsolutePath();
    }

    @Override
    protected void onPostExecute(String path) {
      mProgressDialog.dismiss();
      Intent share = new Intent(MainActivity.this, ShareActivity.class);
      share.putExtra("sharingWhat", "Alphabet");
      share.putExtra("sharePath", path);
      startActivity(share);
    }
  }

  class BitmapWorkerTask extends AsyncTask<Integer, Void, Bitmap> {
    private final WeakReference<ImageView> imageViewReference;

    public BitmapWorkerTask(ImageView imageView) {
      imageViewReference = new WeakReference<ImageView>(imageView);
    }

    public int calculateInSampleSize(BitmapFactory.Options options, int reqWidth, int reqHeight) {
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

    public Bitmap decodeSampledBitmapFromResource(Resources res, int index, int reqWidth,
        int reqHeight) {
      String path = null;
      int resId =
          MainActivity.RESOURCE_INDEX[Arrays.asList(MainActivity.LANGUAGE).indexOf(mLanguage)][index];
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets"
                  + File.separator
                  + mAlphabet
                  + "_"
                  + MainActivity.RESOURCE_NAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                      mLanguage)][index] + ".png");
      if (file.exists())
        path = file.getAbsolutePath();

      // First decode with inJustDecodeBounds=true to check dimensions
      final BitmapFactory.Options options = new BitmapFactory.Options();
      options.inJustDecodeBounds = true;
      if (path != null)
        BitmapFactory.decodeFile(path, options);
      else
        BitmapFactory.decodeResource(res, resId, options);

      // Calculate inSampleSize
      options.inSampleSize = calculateInSampleSize(options, reqWidth, reqHeight);

      // Decode bitmap with inSampleSize set
      options.inJustDecodeBounds = false;

      if (path != null)
        return BitmapFactory.decodeFile(path, options);
      return BitmapFactory.decodeResource(res, resId, options);
    }

    @Override
    protected Bitmap doInBackground(Integer... params) {
      int data = params[0];
      return decodeSampledBitmapFromResource(getResources(), data, mWidth, mHeight);
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

  @Override
  public void onLocationChanged(Location location) {
    Double latitude = location.getLatitude();
    Double longitude = location.getLongitude();
    Editor e = mSharedPreferences.edit();
    e.putString("longitude", Double.toString(longitude));
    e.putString("latitude", Double.toString(latitude));
    e.commit();
  }
}
