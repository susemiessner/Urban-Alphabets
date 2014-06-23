package org.susemiessner.android.urbanalphabets;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.os.Environment;

public class Data {
	// Constants
	public static final String RESOURCERAWNAME[][] = {
			/*F/S*/
			{"letter_a", "letter_b", "letter_c", "letter_d","letter_e", "letter_f",
			"letter_g", "letter_h", "letter_i", "letter_j", "letter_k", "letter_l",
			"letter_m", "letter_n", "letter_o", "letter_p", "letter_q", "letter_r",
			"letter_s", "letter_t", "letter_u", "letter_v", "letter_w", "letter_x",
			"letter_y", "letter_z", "letter_aa", "letter_oo", "letter_adot",
			"letter_dot", "letter_exclaim", "letter_question", "letter_0", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7",
			"letter_8", "letter_9"},
			/*D/N*/
			{"letter_a", "letter_b", "letter_c", "letter_d","letter_e", "letter_f",
			"letter_g", "letter_h", "letter_i", "letter_j", "letter_k", "letter_l",
			"letter_m", "letter_n", "letter_o", "letter_p", "letter_q", "letter_r",
			"letter_s", "letter_t", "letter_u", "letter_v", "letter_w", "letter_x",
			"letter_y", "letter_z", "letter_ae", "letter_danisho", "letter_adot",
			"letter_dot", "letter_exclaim", "letter_question", "letter_0", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7",
			"letter_8", "letter_9"},
			/*E/P*/
			{"letter_a", "letter_b", "letter_c", "letter_d","letter_e", "letter_f",
			"letter_g", "letter_h", "letter_i", "letter_j", "letter_k", "letter_l",
			"letter_m", "letter_n", "letter_o", "letter_p", "letter_q", "letter_r",
			"letter_s", "letter_t", "letter_u", "letter_v", "letter_w", "letter_x",
			"letter_y", "letter_z", "letter_plus", "letter_dollar", "letter_comma",
			"letter_dot", "letter_exclaim", "letter_question", "letter_0", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7",
			"letter_8", "letter_9"},
			/*G*/
			{"letter_a", "letter_b", "letter_c", "letter_d","letter_e", "letter_f",
			"letter_g", "letter_h", "letter_i", "letter_j", "letter_k", "letter_l",
			"letter_m", "letter_n", "letter_o", "letter_p", "letter_q", "letter_r",
			"letter_s", "letter_t", "letter_u", "letter_v", "letter_w", "letter_x",
			"letter_y", "letter_z", "letter_aa", "letter_oo", "letter_uu", "letter_dot",
			"letter_exclaim", "letter_question", "letter_0", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5", "letter_6", "letter_7",
			"letter_8", "letter_9"},
			/*S*/
			{"letter_a", "letter_b", "letter_c", "letter_d","letter_e", "letter_f",
			"letter_g", "letter_h", "letter_i", "letter_j", "letter_k", "letter_l",
			"letter_m", "letter_n", "letter_o", "letter_p", "letter_q", "letter_r",
			"letter_s", "letter_t", "letter_u", "letter_v", "letter_w", "letter_x",
			"letter_y", "letter_z", "letter_spanishn", "letter_plus", "letter_comma",
			"letter_dot", "letter_exclaim", "letter_question", "letter_0", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5", "letter_6",
			"letter_7", "letter_8", "letter_9"},
			/*R*/
			{"letter_a", "letter_rusb", "letter_b", "letter_rusg", "letter_rusd",
			"letter_e", "letter_rusjo", "letter_russche", "letter_russe",
			"letter_rusi", "letter_rusikratkoje", "letter_k", "letter_rusl",
			"letter_m", "letter_rusn", "letter_o", "letter_rusp", "letter_p",
			"letter_c", "letter_t", "letter_y", "letter_rusf", "letter_x",
			"letter_rusz", "letter_rustsche", "letter_russcha",
			"letter_rustschescha", "letter_rusmjachkisnak",
			"letter_rusui", "letter_ruse", "letter_rusju",
			"letter_rusja", "letter_0", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5",
			"letter_6", "letter_7", "letter_8", "letter_9"},
			/*L*/
			{"letter_a", "letter_latva", "letter_b", "letter_c", "letter_latvc",
			"letter_d", "letter_e", "letter_latve", "letter_f",
			"letter_g", "letter_latvg", "letter_h", "letter_i",
			"letter_latvi", "letter_j", "letter_k", "letter_latvk",
			"letter_l", "letter_latvl", "letter_m", "letter_n", "letter_latvn",
			"letter_o", "letter_p", "letter_r", "letter_s",
			"letter_latvs", "letter_t", "letter_u", "letter_latvu", "letter_v",
			"letter_z", "letter_latvz", "letter_1",
			"letter_2", "letter_3", "letter_4", "letter_5", "letter_6", 
			"letter_7", "letter_8", "letter_9"}
			};
	public static final int RESOURCERAWINDEX[][] = {
			/*F/S*/
			{R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d,
			R.raw.letter_e, R.raw.letter_f, R.raw.letter_g, R.raw.letter_h,
			R.raw.letter_i, R.raw.letter_j, R.raw.letter_k, R.raw.letter_l,
			R.raw.letter_m, R.raw.letter_n, R.raw.letter_o, R.raw.letter_p,
			R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
			R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, 
			R.raw.letter_y, R.raw.letter_z, R.raw.letter_aa, R.raw.letter_oo,
			R.raw.letter_adot, R.raw.letter_dot, R.raw.letter_exclaim,
			R.raw.letter_question, R.raw.letter_0, R.raw.letter_1, R.raw.letter_2,
			R.raw.letter_3, R.raw.letter_4, R.raw.letter_5, R.raw.letter_6,
			R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
			/*D/N*/
			{R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d,
			R.raw.letter_e, R.raw.letter_f, R.raw.letter_g, R.raw.letter_h,
			R.raw.letter_i, R.raw.letter_j, R.raw.letter_k, R.raw.letter_l,
			R.raw.letter_m, R.raw.letter_n, R.raw.letter_o, R.raw.letter_p,
			R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
			R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, 
			R.raw.letter_y, R.raw.letter_z, R.raw.letter_ae, R.raw.letter_danisho,
			R.raw.letter_adot, R.raw.letter_dot, R.raw.letter_exclaim, 
			R.raw.letter_question, R.raw.letter_0, R.raw.letter_1, 
			R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, R.raw.letter_5,
			R.raw.letter_6, R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
			/*E/P*/
			{R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d,
			R.raw.letter_e, R.raw.letter_f, R.raw.letter_g, R.raw.letter_h,
			R.raw.letter_i, R.raw.letter_j, R.raw.letter_k, R.raw.letter_l,
			R.raw.letter_m, R.raw.letter_n, R.raw.letter_o, R.raw.letter_p,
			R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
			R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x,
			R.raw.letter_y, R.raw.letter_z, R.raw.letter_plus, R.raw.letter_dollar,
			R.raw.letter_comma, R.raw.letter_dot, R.raw.letter_exclaim, 
			R.raw.letter_question, R.raw.letter_0, R.raw.letter_1, R.raw.letter_2,
			R.raw.letter_3, R.raw.letter_4, R.raw.letter_5, R.raw.letter_6,
			R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
			/*G*/
			{R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d,
			R.raw.letter_e, R.raw.letter_f, R.raw.letter_g, R.raw.letter_h,
			R.raw.letter_i, R.raw.letter_j, R.raw.letter_k, R.raw.letter_l,
			R.raw.letter_m, R.raw.letter_n, R.raw.letter_o, R.raw.letter_p,
			R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
			R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x, R.raw.letter_y,
			R.raw.letter_z, R.raw.letter_aa, R.raw.letter_oo, R.raw.letter_uu,
			R.raw.letter_dot, R.raw.letter_exclaim, R.raw.letter_question, R.raw.letter_0,
			R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4,
			R.raw.letter_5, R.raw.letter_6, R.raw.letter_7, R.raw.letter_8,
			R.raw.letter_9},
			/*S*/
			{R.raw.letter_a, R.raw.letter_b, R.raw.letter_c, R.raw.letter_d,
			R.raw.letter_e, R.raw.letter_f, R.raw.letter_g, R.raw.letter_h,
			R.raw.letter_i, R.raw.letter_j, R.raw.letter_k, R.raw.letter_l,
			R.raw.letter_m, R.raw.letter_n, R.raw.letter_o, R.raw.letter_p,
			R.raw.letter_q, R.raw.letter_r, R.raw.letter_s, R.raw.letter_t,
			R.raw.letter_u, R.raw.letter_v, R.raw.letter_w, R.raw.letter_x,
			R.raw.letter_y, R.raw.letter_z, R.raw.letter_spanishn, R.raw.letter_plus, 
			R.raw.letter_comma, R.raw.letter_dot, R.raw.letter_exclaim,
			R.raw.letter_question, R.raw.letter_0, R.raw.letter_1, R.raw.letter_2,
			R.raw.letter_3, R.raw.letter_4, R.raw.letter_5, R.raw.letter_6, 
			R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
			/*R*/
			{R.raw.letter_a, R.raw.letter_rusb, R.raw.letter_b, R.raw.letter_rusg,
			R.raw.letter_rusd, R.raw.letter_e, R.raw.letter_rusjo, 
			R.raw.letter_russche, R.raw.letter_russe, R.raw.letter_rusi, 
			R.raw.letter_rusikratkoje, R.raw.letter_k, R.raw.letter_rusl,
			R.raw.letter_m, R.raw.letter_rusn, R.raw.letter_o, R.raw.letter_rusp,
			R.raw.letter_p, R.raw.letter_c, R.raw.letter_t, R.raw.letter_y, 
			R.raw.letter_rusf, R.raw.letter_x, R.raw.letter_rusz, R.raw.letter_rustsche,
			R.raw.letter_russcha, R.raw.letter_rustschescha, R.raw.letter_rusmjachkisnak,
			R.raw.letter_rusui, R.raw.letter_ruse, R.raw.letter_rusju, R.raw.letter_rusja,
			R.raw.letter_0, R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4, 
			R.raw.letter_5, R.raw.letter_6, R.raw.letter_7, R.raw.letter_8, R.raw.letter_9},
			/*L*/
			{R.raw.letter_a, R.raw.letter_latva, R.raw.letter_b, R.raw.letter_c,
			R.raw.letter_latvc, R.raw.letter_d, R.raw.letter_e, R.raw.letter_latve,
			R.raw.letter_f, R.raw.letter_g, R.raw.letter_latvg, R.raw.letter_h, 
			R.raw.letter_i, R.raw.letter_latvi, R.raw.letter_j,
			R.raw.letter_k, R.raw.letter_latvk, R.raw.letter_l,
			R.raw.letter_latvl, R.raw.letter_m, R.raw.letter_n, 
			R.raw.letter_latvn, R.raw.letter_o, R.raw.letter_p,
			R.raw.letter_r, R.raw.letter_s, R.raw.letter_latvs,
			R.raw.letter_t, R.raw.letter_u, R.raw.letter_latvu,
			R.raw.letter_v, R.raw.letter_z, R.raw.letter_latvz,
			R.raw.letter_1, R.raw.letter_2, R.raw.letter_3, R.raw.letter_4,
			R.raw.letter_5, R.raw.letter_6, R.raw.letter_7, R.raw.letter_8,
			R.raw.letter_9}
			};
	
	public static final char LETTER[][] = {
		/*F/S*/
		{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', 'Ä', 'Ö', 'Å', '.', '!', '?', '0', '1',
		'2', '3', '4', '5', '6', '7', '8', '9'},
		/*D/N*/
		{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', 'Æ', 'Ø', 'Å', '.', '!', '?', '0', '1',
		'2', '3', '4', '5', '6', '7', '8', '9'},
		/*E/P*/
		{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', '+', '$', ',', '.', '!', '?', '0', '1',
		'2', '3', '4', '5', '6', '7', '8', '9'},
		/*G*/
		{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', 'Ä', 'Ö', 'Ü', '.', '!', '?', '0', '1',
		'2', '3', '4', '5', '6', '7', '8', '9'},
		/*S*/
		{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z', 'Ñ', '+', ',', '.', '!', '?', '0', '1',
		'2', '3', '4', '5', '6', '7', '8', '9'},
		/*R*/
		{'A', 'Б', 'B', 'Г', 'Д', 'E', 'Ё', 'Ж', 'З',
		'И', 'Й', 'K', 'Л',
		'M', 'Н', 'O', 'П', 'P',
		'C', 'T', 'Y', 'Ф', 'X',
		'Ц', 'Ч', 'Ш',
		'Щ', 'Ь',
		'Ы', 'Э', 'Ю',
		'Я', '0', '1',
		'2', '3', '4', '5',
		'6', '7', '8', '9'},
		/*L*/
		{'A', 'Ā', 'B', 'C', 'Č',
		'D', 'E', 'Ē', 'F',
		'G', 'Ģ', 'H', 'I',
		'Ī', 'J', 'K', 'Ķ',
		'L', 'Ļ', 'M', 'N', 'Ņ',
		'O', 'P', 'R', 'S',
		'Š', 'T', 'U', 'Ū', 'V',
		'Z', 'Ž', '1',
		'2', '3', '4', '5', '6', 
		'7', '8', '9'}
		};
	public static final String LETTERNAME[][] = {
		/*F/S*/
		{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
		"M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
		"Y", "Z", "AA", "OO", "AAA", ".", "!", "?", "0", "1",
		"2", "3", "4", "5", "6", "7", "8", "9"},
		/*D/N*/
		{"A", "B", "C", "D","E", "F", "G", "H", "I", "J", "K", "L",
		"M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
		"Y", "Z", "AE", "OO", "AAA", ".", "!", "?", "0", "1",
		"2", "3", "4", "5", "6", "7", "8", "9"},
		/*E/P*/
		{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
		"M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
		"Y", "Z", "+", "$", ",", ".", "!", "?", "0", "1",
		"2", "3", "4", "5", "6", "7", "8", "9"},
		/*G*/
		{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
		"M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
		"Y", "Z", "AA", "OO", "UU", ".", "!", "?", "0", "1",
		"2", "3", "4", "5", "6", "7", "8", "9"},
		/*S*/
		{"A", "B", "C", "D","E", "F", "G", "H", "I", "J", "K", "L",
		"M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
		"Y", "Z", "NN", "+", ",", ".", "!", "?", "0", "1",
		"2", "3", "4", "5", "6", "7", "8", "9"},
		/*R*/
		{"A", "RusB", "B", "RusG", "RusD", "E", "RusJo", "RusSche", "RrusSe",
		"RusI", "RusIkratkoje", "K", "RusL",
		"M", "RusN", "O", "RusP", "P",
		"C", "T", "Y", "RusF", "X",
		"RusZ", "RusTsche", "RusScha",
		"RusTschescha", "RusMjachkiSnak",
		"RusUi", "RusE", "RusJu",
		"RusJa", "0", "1",
		"2", "3", "4", "5",
		"6", "7", "8", "9"},
		/*L*/
		{"A", "LatvA", "B", "C", "LatvC",
		"D", "E", "LatvE", "F",
		"G", "LatvG", "H", "I",
		"LatvI", "J", "K", "LatvK",
		"L", "LatvL", "M", "N", "LatvN",
		"O", "P", "R", "S",
		"LatvS", "T", "U", "LatvU", "V",
		"Z", "LatvZ", "1",
		"2", "3", "4", "5", "6", 
		"7", "8", "9"}
		};
	public static final String[] LANGUAGE = {
			"Finnish/Swedish",
			"Danish/Norwegian",
			"English/Portugese",
			"German",
			"Spanish",
			"Russian",
			"Latvian",
	};
	// Constants
	public static final int OPEN_GALLERY = 0;
	public static final String TOPLEVELDIR = "UrbanAlphabets";
	public static final int MAX = 42;
	// Variables
	private static List<Alphabet> listAlphabet = null;
	private static int selected;
	
	private static int recentlyAssigned;
	private static byte[] rawImageData = null;
	private static Bitmap croppedBitmap = null;
	private static SQLiteDatabase mDatabase = null;
	private static Context mContext = null;
	private static boolean updatePending;
	
	private Data() {
	}
	
	public static void init(Context context) {
		if(mContext == null)
			mContext = context;
		if(listAlphabet == null)
			listAlphabet = new ArrayList<Alphabet>();
		if(listAlphabet.isEmpty())
			initAlphabet();
	}

	public static void initAlphabet() {
		if(isTableEmpty()) {
			addAlphabet("Untitled", Arrays.asList(LANGUAGE).indexOf("Finnish/Swedish"));
		} else {
			openDatabase();
			Cursor  cursor = mDatabase.rawQuery("select * from alphabets", null);
			if (cursor .moveToFirst()) {
	            while (cursor.isAfterLast() == false) {
	                listAlphabet.add(new Alphabet(cursor.getString(cursor
	                        .getColumnIndex("alphabet")), cursor.getString(cursor
	    	                        .getColumnIndex("language"))));
	                if(cursor.getInt(cursor.getColumnIndex("selected")) == 1) {
	                	selected = cursor.getPosition();
	                }
	                cursor.moveToNext();
	            }
	        }
			closeDatabase();
		}
	}
	
	public static String getSelectedAlphabetName() {
		return listAlphabet.get(selected).getName();	
	}
	
	public static String getSelectedAlphabetLanguage() {
		return listAlphabet.get(selected).getLang();
	}
	
	public static void saveBitmapAsPNG(Bitmap bitmap) {
		File filename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + "share.png");
		
		if(filename.exists())
			filename.delete();
	
		try {
			FileOutputStream fos = new FileOutputStream(filename);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
	        bitmap.compress(CompressFormat.PNG, 100, bos);
	        bos.flush();
			fos.close();
		} catch(Exception e) {
			
		}
	}

	public static String getLetterName() {
		return LETTERNAME[Arrays.asList(LANGUAGE).
		                  indexOf(getSelectedAlphabetLanguage())][recentlyAssigned];
	}

	public static String getPathToRecentlyAssigned() {
		updatePending = false;
		File filename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + getSelectedAlphabetName()
				+ File.separator + RESOURCERAWNAME[Arrays.asList(LANGUAGE).
				  indexOf(getSelectedAlphabetLanguage())][recentlyAssigned]
				+ ".png");
		if(filename.exists())
			return filename.getAbsolutePath();
		return null;
	}

	public static int getRawResourceId(int index) {
		return RESOURCERAWINDEX[Arrays.asList(LANGUAGE).
		      				  indexOf(getSelectedAlphabetLanguage())][index];
	}
	
	public static String getLetterPath(int index) {

		File filename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + getSelectedAlphabetName()
				+ File.separator + RESOURCERAWNAME[Arrays.asList(LANGUAGE).
				indexOf(getSelectedAlphabetLanguage())][index]
				+ ".png");
		if(filename.exists())
			return filename.getAbsolutePath();
		return null;
	}
	
	public static void createStorageDir() {
		File filename = new File(Environment.getExternalStoragePublicDirectory
								(Environment.DIRECTORY_DCIM), TOPLEVELDIR);
		if(!filename.exists())
			filename.mkdirs();	
	}
	
	private static void createStorageDir(String alphabetName) {
		File filename = new File(Environment.getExternalStoragePublicDirectory
								(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
								File.separator + alphabetName);
		if(!filename.exists())
			filename.mkdirs();
	}

	public static void addAlphabet(String alphabetName, int option) {
		listAlphabet.add(new Alphabet(alphabetName, LANGUAGE[option]));
		createStorageDir(alphabetName);
		selected = getSize() - 1;
		addAlphabet();
	}

	public static void changeAlphabetName(String alphabetNewName) {
		String alphabetName = getSelectedAlphabetName();
		String language = getSelectedAlphabetLanguage();
		listAlphabet.remove(selected);
		renameSelected(alphabetName, alphabetNewName);
		listAlphabet.add(selected, new Alphabet(alphabetNewName, language));
		
		openDatabase();
		ContentValues replaced = new ContentValues();
		replaced.put("alphabet", alphabetNewName);
		try {
			mDatabase.update("alphabets", replaced, "alphabet=?", 
					new String[]{alphabetName});	
		} catch (SQLiteException ex) {
		}
		closeDatabase();
	}
	
	public static void changeAlphabetLanguage(int option) {
		String alphabetName = getSelectedAlphabetName();
		listAlphabet.remove(selected);
		listAlphabet.add(selected, new Alphabet(alphabetName, LANGUAGE[option]));
		
		openDatabase();
		ContentValues replaced = new ContentValues();
		replaced.put("language", LANGUAGE[option]);
		try {
			mDatabase.update("alphabets", replaced, "alphabet=?", 
					new String[]{alphabetName});	
		} catch (SQLiteException ex) {
		}
		closeDatabase();
	}
	
	private static void renameSelected(String oldName, String newName) {
		File oldfilename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + oldName);
		File newfilename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + newName);
		oldfilename.renameTo(newfilename);
	}

	public static void resetAlphabet() {
		deleteRecursive(new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + getSelectedAlphabetName()), false);
	}

	public static void deleteAlphabet() {
		deleteRecursive(new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + getSelectedAlphabetName()), true);
		String alphabetName = getSelectedAlphabetName();
		listAlphabet.remove(selected);
		openDatabase();
		mDatabase.delete("alphabets", "alphabet=?", new String[] {alphabetName});
		closeDatabase();
		if(listAlphabet.size() == 0) {
			initAlphabet();
		}
		else {
			selected = 0;
		}
	}

	private static boolean isTableEmpty() {
		openDatabase();
		boolean status = false;
		Cursor cursor = mDatabase.rawQuery("SELECT count(*) FROM alphabets", null);
		if(cursor != null) {
			cursor.moveToFirst();
			if(cursor.getInt(0) == 0)
				status = true;
		}
		closeDatabase();
		return status;
	}
	
	private static void deleteRecursive(File fileOrDirectory, boolean delTopLevel) {
		if (fileOrDirectory.isDirectory())
			for (File child : fileOrDirectory.listFiles())
				deleteRecursive(child, true);
		if(delTopLevel)
			fileOrDirectory.delete();
	}
	
	public static String[] getLanguage() {
		return LANGUAGE;
	}
	
	public static int getSelectedLanguageIndex() {
		return Arrays.asList(LANGUAGE).indexOf(getSelectedAlphabetLanguage());
	}

	public static void setRawImageData(byte[] data) {
		rawImageData = data;
	}
	
	public static byte[] getRawImageData() {
		return rawImageData;
	}

	public static void setCroppedBitmap(Bitmap bitmap) {
		croppedBitmap = bitmap;
	}
	
	public static Bitmap getCroppedBitmap() {
		return croppedBitmap;
	}

	public static void assignPhotoToSelectedLetter(int option) {
		File filename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + getSelectedAlphabetName()
				+ File.separator + RESOURCERAWNAME[Arrays.asList(LANGUAGE).
				indexOf(getSelectedAlphabetLanguage())][option]
				+ ".png"); 
		try {
			FileOutputStream fos = new FileOutputStream(filename);
			BufferedOutputStream bos = new BufferedOutputStream(fos);
	        croppedBitmap.compress(CompressFormat.PNG, 100, bos);
	        bos.flush();
			fos.close();
		} catch(Exception e) {
			
		}
		recentlyAssigned = option;
		updatePending = true;
	}

	public static int getSize() {
		return listAlphabet.size();
	}
	
	public static String[] toArray() {
		String[] alphabetName = new String[getSize()];
		int i = 0;
		for (Alphabet alphabet: listAlphabet)
			alphabetName[i++] = alphabet.getName();
		return alphabetName;
	}

	public static int getSelectedIndex() {
		return selected;
	}
	
	public static void setSelectedIndex(int option) {
		selected = option;
	}

	public static String getSharePath() {
		File filename = new File(Environment.getExternalStoragePublicDirectory
				(Environment.DIRECTORY_DCIM), TOPLEVELDIR +
				File.separator + "share.png");
		if(filename.exists()) {
			return filename.getAbsolutePath();
		}
		return null;
	}
	
	public static int getBlank() {
		return R.raw.letter_empty;
	}
	
	public static int getCurrentLanguageIndex() {
		return Arrays.asList(LANGUAGE).indexOf(getSelectedAlphabetLanguage());
	}
	
	private static void openDatabase() {
		// Create directory databases
		File filename = new File(mContext.getFilesDir().getPath() + 
				File.separator + "databases");
		if(!filename.exists())
			filename.mkdirs();
		
		filename = new File(mContext.getFilesDir().getPath() + File.separator +
				"databases" + File.separator + "db.sqlite");
		try{
			mDatabase = SQLiteDatabase.openDatabase(filename.getAbsolutePath(),
						null, SQLiteDatabase.CREATE_IF_NECESSARY);
		} catch (SQLiteException ex) {
		}
		createTable();
	}
	
	private static void closeDatabase() {
		mDatabase.close();
	}
	
	private static void createTable() {
		try {
			mDatabase.execSQL("CREATE TABLE IF NOT EXISTS alphabets(alphabet TEXT,"
					+ " language TEXT, selected INTEGER)");
		} catch (SQLiteException ex) {
			
		}
	}
	
	public static void addAlphabet() {
		openDatabase();
		// Clear previous selection if present else do nothing 
		ContentValues replaced = new ContentValues();
		replaced.put("selected", 0);
		try {
			mDatabase.update("alphabets", replaced, "selected=1", null);	
		} catch (SQLiteException ex) {
		}
		
		// Add new alphabet with selection
		ContentValues alphabet = new ContentValues();
		alphabet.put("alphabet", getSelectedAlphabetName());
		alphabet.put("language", getSelectedAlphabetLanguage());
		alphabet.put("selected", 1);
		try {
			mDatabase.insert("alphabets", null, alphabet);	
		} catch (SQLiteException ex) {
			
		}
		closeDatabase();
	}

	public static boolean updatePending() {
		return updatePending;
	}
}	
