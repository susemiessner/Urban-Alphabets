package org.susemiessner.urbanalphabets;

import java.util.ArrayList;

import org.susemiessner.urbanalphabets.R.raw;

import android.app.Activity;

public class Languages extends Activity {
	
	private static  int[] mCollection ={
			R.raw._0,R.raw._1,R.raw._2,R.raw._3,R.raw._4,R.raw._5,R.raw._6,
			R.raw._7,R.raw._8,R.raw._9,R.raw._10,R.raw._11,R.raw._12,
			R.raw._13,R.raw._14,R.raw._15,R.raw._16,R.raw._17,R.raw._18,
			R.raw._19,R.raw._20,R.raw._21,R.raw._22,R.raw._23,R.raw._24,
			R.raw._25,R.raw._26,R.raw._27,R.raw._28,R.raw._29,R.raw._30,
			R.raw._31,R.raw._32,R.raw._33,R.raw._34,R.raw._35,R.raw._36,
			R.raw._37,R.raw._38,R.raw._39,R.raw._40,R.raw._41,R.raw._42,
			R.raw._43,R.raw._44,R.raw._45,R.raw._46,R.raw._47,R.raw._48,
			R.raw._49,R.raw._50,R.raw._51,R.raw._52,R.raw._53,R.raw._54,
			R.raw._55,R.raw._56,R.raw._57,R.raw._58,R.raw._59,R.raw._60,
			R.raw._61,R.raw._62,R.raw._63,R.raw._64,R.raw._65,R.raw._66,
			R.raw._67,R.raw._68,R.raw._69,R.raw._70
		
	
		/*
		R.raw.letter_a,R.raw.letter_b,R.raw.letter_c,R.raw.letter_d,R.raw.letter_e,R.raw.letter_f,
		R.raw.letter_g,R.raw.letter_h,R.raw.letter_i,R.raw.letter_j,raw.letter_k,R.raw.letter_l,
		R.raw.letter_m,R.raw.letter_n,R.raw.letter_o,R.raw.letter_p,R.raw.letter_q,R.raw.letter_r,
		R.raw.letter_s,R.raw.letter_t,R.raw.letter_u,R.raw.letter_v,R.raw.letter_w,R.raw.letter_x,
		R.raw.letter_y,R.raw.letter_z,R.raw.letter_a_withdoubledotsabove,R.raw.letter_o_withdoubledotsabove,R.raw.letter_a_circleabove,R.raw.letter_dot,
		R.raw.letter_exclamation,R.raw.letter_questionmark,R.raw.letter_0,R.raw.letter_1,R.raw.letter_2,R.raw.letter_3,
		R.raw.letter_4,R.raw.letter_5,R.raw.letter_6,R.raw.letter_7,R.raw.letter_8,R.raw.letter_9,
	*/
	};



	private static ArrayList<String> alphabetsCollection = new ArrayList<String>(); // whole collection
	private static ArrayList<String> defaultSet = new ArrayList<String>();
	private static ArrayList<String> currentSet = new ArrayList<String>();
	
	
	public static ArrayList<String> getAlphabetsCollection() {
		return alphabetsCollection;
	}

	public static void setAlphabetsCollection(ArrayList<String> alphabetsCollection) {
		Languages.alphabetsCollection = alphabetsCollection;
	}




	private static ArrayList<String> getRawFiles() throws IllegalAccessException,
			IllegalArgumentException {
		 ArrayList<String> alphabets = new ArrayList<String>();

			for (int count = 0; count < mCollection.length; count++) {
				String filename = "android.resource://"
						+ HomeActivity.PACKAGE_NAME + "/"
						+ mCollection[count]; // getting the exactfilename
				alphabets.add(filename);


			}
		
		return alphabets;

	}

	public static ArrayList<String> getDefaultSet() throws IllegalAccessException, IllegalArgumentException {
		if (defaultSet.isEmpty()){
			
			setDefaultSet();
		}
		return defaultSet;
	}

	public static void setDefaultSet() throws IllegalAccessException, IllegalArgumentException {
	
		
		if (alphabetsCollection.isEmpty()){
			
			setAlphabetsCollection(getRawFiles());
		}
		
		for(int index =0; index < 42; index++){
			defaultSet.add(alphabetsCollection.get(index));
			
			
		}
	}

	public static ArrayList<String> getCurrentSet() {
		return currentSet;
	}

	public static void setCurrentSet(ArrayList<String> currentSet) {
		Languages.currentSet = currentSet;
	}


}