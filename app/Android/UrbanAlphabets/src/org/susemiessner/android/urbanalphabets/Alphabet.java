package org.susemiessner.android.urbanalphabets;

public class Alphabet {
  private String name;
  private String lang;

  public Alphabet() {}

  public Alphabet(String name, String lang) {
    this.setName(name);
    this.setLang(lang);
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getLang() {
    return lang;
  }

  public void setLang(String lang) {
    this.lang = lang;
  }
}
