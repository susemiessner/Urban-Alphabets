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

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
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
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

public class MainActivity extends ActionBarActivity {
  /*
   * Languages: Finnish/Swedish Danish/Norwegian English/Portugese German Spanish Russian Latvian
   */
  public static final String RESOURCERAWNAME[][] = {
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
  public static final int RESOURCERAWINDEX[][] = {
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
  public static final String LETTERNAME[][] = {
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
  private int imageViewId[] = {R.id.imageview_main1, R.id.imageview_main2, R.id.imageview_main3,
      R.id.imageview_main4, R.id.imageview_main5, R.id.imageview_main6, R.id.imageview_main7,
      R.id.imageview_main8, R.id.imageview_main9, R.id.imageview_main10, R.id.imageview_main11,
      R.id.imageview_main12, R.id.imageview_main13, R.id.imageview_main14, R.id.imageview_main15,
      R.id.imageview_main16, R.id.imageview_main17, R.id.imageview_main18, R.id.imageview_main19,
      R.id.imageview_main20, R.id.imageview_main21, R.id.imageview_main22, R.id.imageview_main23,
      R.id.imageview_main24, R.id.imageview_main25, R.id.imageview_main26, R.id.imageview_main27,
      R.id.imageview_main28, R.id.imageview_main29, R.id.imageview_main30, R.id.imageview_main31,
      R.id.imageview_main32, R.id.imageview_main33, R.id.imageview_main34, R.id.imageview_main35,
      R.id.imageview_main36, R.id.imageview_main37, R.id.imageview_main38, R.id.imageview_main39,
      R.id.imageview_main40, R.id.imageview_main41, R.id.imageview_main42};
  private String currentAlphabet;
  private String currentLanguage;
  private SharedPreferences mSharedPreferences;
  private ActionBar actionBar;
  private List<Integer> imageViewIdList;
  private TableLayout tableLayout;
  private LocationManager mlocManager;
  private LocationListener mlocListener;
  private MenuItem saved;
  private LinearLayout linearLayout;
  private int width;
  private int height;
  private int margin;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
    try {
      currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    } catch (ClassCastException ex) {
      // currentAlphabet is always a string.
      Log.d("MainActivity", ex.getMessage());
    }
    try {
      currentLanguage = mSharedPreferences.getString("currentLanguage", "");
    } catch (ClassCastException ex) {
      // currentLanguage is always a string.
      Log.d("MainActivity", ex.getMessage());
    }
    if (currentAlphabet.equals("") || currentLanguage.equals(""))
      initialize();

    actionBar = getSupportActionBar();
    actionBar.setTitle(currentAlphabet);

    imageViewIdList = new ArrayList<Integer>();
    for (int i = 0; i < 42; i++)
      imageViewIdList.add(imageViewId[i]);

    saved = null;
    mlocListener = new MyLocationListener();
    mlocManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
    tableLayout = (TableLayout) findViewById(R.id.tablelayout_main);
    linearLayout = (LinearLayout) findViewById(R.id.layout_main);

    ViewTreeObserver vto = linearLayout.getViewTreeObserver();
    vto.addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
      @SuppressWarnings("deprecation")
      @SuppressLint("NewApi")
      @Override
      public void onGlobalLayout() {
        try {
          if (Build.VERSION.SDK_INT < 16)
            linearLayout.getViewTreeObserver().removeGlobalOnLayoutListener(this);
          else
            linearLayout.getViewTreeObserver().removeOnGlobalLayoutListener(this);
        } catch (IllegalStateException ex) {
          Log.d("MainActivity", ex.getMessage());
        }
        width = linearLayout.getWidth();
        RelativeLayout relativeLayout = (RelativeLayout) findViewById(R.id.relativelayout_main);
        height = linearLayout.getHeight() - relativeLayout.getHeight();
        margin = (height * 5) / 1000;
        height = (height - margin * 2 * 7) / 7;
        width = (height * 439) / 534;
        /*
         * Saving as preferences
         */
        Editor e = mSharedPreferences.edit();
        e.putInt("imageViewWidth", width);
        e.putInt("imageViewHeight", height);
        e.putInt("imageViewExtra", margin);
        e.commit();
        setImageViewDimensions();
        setImages();
      }
    });
  }

  @Override
  protected void onRestart() {
    super.onRestart();
    try {
      currentAlphabet = mSharedPreferences.getString("currentAlphabet", "");
    } catch (ClassCastException ex) {
      Log.d("MainActivity", ex.getMessage());
    }
    try {
      currentLanguage = mSharedPreferences.getString("currentLanguage", "");
    } catch (ClassCastException ex) {
      Log.d("MainActivity", ex.getMessage());
    }
    if (currentAlphabet.equals("") || currentLanguage.equals(""))
      initialize();
    actionBar.setTitle(currentAlphabet);
    setImages();
  }

  public void onResume() {
    super.onResume();
    if (mSharedPreferences.getBoolean("enableLocation", true)) {
      mlocManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 1000, 0, mlocListener);
      mlocManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000, 0, mlocListener);
      // 1 -> 1000
    }
    String username = mSharedPreferences.getString("username", "");
    if (saved != null && !username.equals("")) {
      onOptionsItemSelected(saved);
      saved = null;
    }
  }

  public void onPause() {
    super.onPause();
    if (mSharedPreferences.getBoolean("enableLocation", true))
      mlocManager.removeUpdates(mlocListener);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.main, menu);
    return true;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.item_alphabet_info: {
        Intent alphabetInfo = new Intent(this, AlphabetInfoActivity.class);
        startActivity(alphabetInfo);
        return true;
      }
      case R.id.item_share_alphabet: {
        /*
         * Copy table layout to bitmap
         */
        Bitmap alphabet =
            Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(alphabet);
        tableLayout.draw(canvas);
        new SaveBitmap().execute(alphabet);
        Intent share = new Intent(this, ShareActivity.class);
        share.putExtra("sharingWhat", "Alphabet");
        startActivity(share);
        return true;
      }
      case R.id.item_save_alphabet: {
        Bitmap alphabet =
            Bitmap.createBitmap(tableLayout.getWidth(), tableLayout.getHeight(),
                Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(alphabet);
        tableLayout.draw(canvas);
        new SaveAndSchedule().execute(alphabet);
        return true;
      }
      case R.id.item_write_postcard: {
        Intent writePostcard = new Intent(this, WritePostcardActivity.class);
        startActivity(writePostcard);
        return true;
      }
      case R.id.item_my_alphabets: {
        Intent myAlphabets = new Intent(this, MyAlphabetsActivity.class);
        startActivity(myAlphabets);
        return true;
      }
      case R.id.item_settings: {
        Intent settings = new Intent(this, SettingsActivity.class);
        startActivity(settings);
        return true;
      }
      default:
        return super.onContextItemSelected(item);
    }
  }

  private void initialize() {
    SQLiteDatabase database = null;
    boolean empty = false;

    try {
      database =
          getApplicationContext().openOrCreateDatabase("db.sqlite", Context.MODE_PRIVATE, null);
    } catch (SQLiteException ex) {
      throw new RuntimeException("Couldn't open a database", ex);
    }

    try {
      database.execSQL("CREATE TABLE IF NOT EXISTS alphabets(alphabet TEXT, language TEXT, "
          + "selected INTEGER)");
      database.execSQL("CREATE TABLE IF NOT EXISTS updates(lng TEXT, lat TEXT, letter TEXT, "
          + "postcard TEXT, alphabet TEXT, pText TEXT, lang TEXT, prefix TEXT, suffix TEXT )");
    } catch (SQLiteException ex) {
      database.close();
      Log.d("MainActivity", ex.getMessage());
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
      currentAlphabet = "Untitled";
      currentLanguage = MainActivity.LANGUAGE[mSharedPreferences.getInt("defaultLang", 0)];

      ContentValues alphabet = new ContentValues();
      alphabet.put("alphabet", currentAlphabet);
      alphabet.put("language", currentLanguage);
      alphabet.put("selected", 1);

      try {
        database.insert("alphabets", null, alphabet);
      } catch (SQLiteException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
    } else {
      cursor =
          database.query("alphabets", new String[] {"alphabet", "language"}, "selected=1", null,
              null, null, null);
      if (cursor != null && cursor.moveToFirst()) {
        currentAlphabet = cursor.getString(cursor.getColumnIndex("alphabet"));
        currentLanguage = cursor.getString(cursor.getColumnIndex("language"));
      }
      if (cursor != null)
        cursor.close();
    }

    database.close();

    /*
     * Save as preferences
     */
    Editor e = mSharedPreferences.edit();
    e.putString("currentAlphabet", currentAlphabet);
    e.putString("currentLanguage", currentLanguage);
    e.commit();
  }

  private void setImageViewDimensions() {
    for (int i = 0; i < 42; i++) {
      ImageView iv = (ImageView) findViewById(imageViewId[i]);
      TableRow.LayoutParams parms = new TableRow.LayoutParams(width, height);
      parms.setMargins(margin, margin, margin, margin);
      iv.setLayoutParams(parms);
    }
  }

  private void setImages() {
    for (int index = 0; index < 42; index++) {
      ImageView imageView = (ImageView) findViewById(imageViewId[index]);
      new BitmapWorkerTask(imageView).execute(index);
    }
  }

  public void showMenu(View v) {
    openOptionsMenu();
  }

  public void takePhoto(View v) {
    Intent takePhoto = new Intent(this, TakePhotoActivity.class);
    startActivity(takePhoto);
  }

  public void viewLetter(View v) {
    Intent viewLetter = new Intent(this, ViewLetterActivity.class);
    viewLetter.putExtra("currentAlphabet", currentAlphabet);
    viewLetter.putExtra("currentLanguage", currentLanguage);
    viewLetter.putExtra("currentIndex", imageViewIdList.indexOf(v.getId()));
    startActivity(viewLetter);
  }

  class SaveBitmap extends AsyncTask<Bitmap, Void, Void> {

    @Override
    protected Void doInBackground(Bitmap... params) {
      Bitmap bitmap = (Bitmap) params[0];
      String filename =
          (String) android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss",
              new java.util.Date());
      filename = "share";
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets" + File.separator + filename + ".png");
      FileOutputStream fos = null;
      try {
        fos = new FileOutputStream(file);
      } catch (FileNotFoundException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      bitmap.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      try {
        fos.close();
      } catch (IOException ex) {
        Log.d("MainActivty", ex.getMessage());
      }

      // Adding to gallery
      ContentValues image = new ContentValues();
      image.put(Images.Media.DATA, file.getAbsolutePath());
      getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, image);
      return null;
    }
  }

  class SaveAndSchedule extends AsyncTask<Bitmap, Void, Void> {
    @Override
    protected Void doInBackground(Bitmap... params) {
      /*
       * Save
       */
      Bitmap bitmap = (Bitmap) params[0];
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
        Log.d("MainActivity", ex.getMessage());
      }
      BufferedOutputStream bos = new BufferedOutputStream(fos);
      bitmap.compress(CompressFormat.PNG, 100, bos);
      try {
        bos.flush();
      } catch (IOException ex) {
        Log.d("MainActivity", ex.getMessage());
      }
      try {
        fos.close();
      } catch (IOException ex) {
        Log.d("MainActivty", ex.getMessage());
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
        Log.d("MainActivity", ex.getMessage());
      }
      ContentValues entry = new ContentValues();
      entry.put("lng", mSharedPreferences.getString("longitude", ""));
      entry.put("lat", mSharedPreferences.getString("latitude", ""));
      entry.put("letter", "no");
      entry.put("postcard", "no");
      entry.put("alphabet", "yes");
      entry.put("pText", "");
      entry.put("lang", currentLanguage);
      entry.put("path", filename);

      try {
        database.insert("updates", null, entry);
      } catch (SQLiteException ex) {
        Log.d("MainActivity", ex.getMessage());
      }

      database.close();
      return null;
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
          MainActivity.RESOURCERAWINDEX[Arrays.asList(MainActivity.LANGUAGE).indexOf(
              currentLanguage)][index];
      File file =
          new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM),
              "UrbanAlphabets"
                  + File.separator
                  + currentAlphabet
                  + "_"
                  + MainActivity.RESOURCERAWNAME[Arrays.asList(MainActivity.LANGUAGE).indexOf(
                      currentLanguage)][index] + ".png");
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
      return decodeSampledBitmapFromResource(getResources(), data, width, height);
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

  /* Class My Location Listener */
  public class MyLocationListener implements LocationListener {
    @Override
    public void onLocationChanged(Location loc) {
      Double latitude = loc.getLatitude();
      Double longitude = loc.getLongitude();
      Editor e = mSharedPreferences.edit();
      e.putString("longitude", Double.toString(longitude));
      e.putString("latitude", Double.toString(latitude));
      e.commit();
    }

    @Override
    public void onProviderDisabled(String provider) {
      runOnUiThread(new Runnable() {
        @Override
        public void run() {
          AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
          builder.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
              dialog.dismiss();
            }
          });
          AlertDialog dialog = builder.create();
          dialog.setMessage("You want to share location. Enable devices from phone settings to"
              + " share location.");
          Window window = dialog.getWindow();
          window.setGravity(Gravity.BOTTOM);
          dialog.show();
        }
      });
    }

    @Override
    public void onProviderEnabled(String provider) {}

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {}
  }
}
