package org.susemiessner.android.urbanalphabets;

public class Alphabet {
  private String mName;
  private String mLang;

  public Alphabet() {}

  public Alphabet(String name, String lang) {
    this.setName(name);
    this.setLang(lang);
  }

  public String getName() {
    return mName;
  }

  public void setName(String name) {
    mName = name;
  }

  public String getLang() {
    return mLang;
  }

  public void setLang(String lang) {
    mLang = lang;
  }
}
