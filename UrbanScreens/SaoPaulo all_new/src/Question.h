//
//  Question.h
//  SaoPauloAll
//
//  Created by Suse on 07/11/14.
//
//

#ifndef SaoPauloAll_Question_h
#define SaoPauloAll_Question_h
class Question{
public:
    string _text[4];
    string _postcardText;
    
    vector<AlphabetEntry> _alphabet;
    vector<ofImage> question;
    
    //contructor
    Question(int number, vector<AlphabetEntry> theAlphabet){
        _text[0]="O QUE VOCE VE?";
        _postcardText=_text[number];
        _alphabet=theAlphabet;
        
        for (int i=0; i<_postcardText.size()-1; i++) {
            char letter=_postcardText[i];
            for (int j=0; j<_alphabet.size(); j++) {
                printf("postcardLetter: %c, alphabetLetter: %s\n", letter, _alphabet[j]._letter.c_str());
                char alphabetLetter=_alphabet[j]._letter[0];
                if (letter==alphabetLetter) {
                    ofImage image=_alphabet[j]._image;
                    question.push_back(image);
                    printf("added: %c\n", letter);
                    break;
                }
            }
        }
        printf("question size: %lu\n", question.size());
        
    }
    void draw(){
        ofColor(255);
        printf("question size: %lu\n", question.size());

        for(int i=0; i<question.size(); i++){
            ofRect(50, 50+i*80, 52, 75);
            question[i].draw(50,50+i*80, 52,75);
        }
    }

};
#endif
