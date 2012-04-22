/*
 *
 * A C++ library for parsing FASTA nucleotide and peptide sequence files, and
 * for basic sequence manipulation
 * 
 * Author: Daniel Packer <dp at danielpacker dot org>
 *
 */

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cstdlib>
#include <cstring>
#include <map>
#include <sstream>

#define DEBUG 1

using namespace std;

enum { MODE_NUCLEOTIDE, MODE_PEPTIDE };

enum { A = 0, T = 1, G = 2, C = 3, U = 4 };

const char * AA_CONSTANTS_FILE = "aa_constants.txt";
const char * AA_COLORS_FILE    = "aa_colors.txt";


/*
 * RGB color value and name. Useful for rendering AminoAcids in color.
 *
 */
struct aa_color {
  string name;
  int r;
  int g;
  int b;

  void dump() {
    cout << "[" << name << "]: " << r << ", " << g << ", " << b << endl;
  }
};

/*
 * AminoAcid encapsulates known constants associated with each amino acid 
 * e.g weight, codons. Provides accessors/mutators.
 *
 */
class AminoAcid {

  public:

  vector<string> codons_; // possible codons
  string name_;
  string triple_abbrev_;
  char abbrev_;
  aa_color color_;
  string formula_;
  double weight_;

  aa_color color() {
    return color_;
  }

  void color(aa_color c) {
    color_ = c;
  }

  vector<string> codons() {
    return codons_;
  }

  void codons(vector<string> c) {
    codons_ = c;
  }

  string name() {
    return name_;
  }

  void name(string a) {
    name_ = a;
  }


  string triple_abbrev() {
    return triple_abbrev_;
  }

  void triple_abbrev(string a) {
    triple_abbrev_ = a;
  }


  char abbrev() {
    return abbrev_;
  }

  void abbrev(char a) {
    abbrev_ = a;
  }

  string formula() {
    return formula_;
  }

  void formula(string f) {
    formula_ = f;
  }

  double weight() {
    return weight_;
  }

  void weight(double wt) {
    weight_ = wt;
  }

  void dump() {
    cout << "[" << name_ << "]: " << triple_abbrev_ << ", " << abbrev_ << endl;
    color_.dump();
  }
};


/*
 * FASTA objects parse FASTA files and populates data structures with contents.
 *
 */
class FASTA {

private:

  vector<int> seq;                    // store bp seq
  vector<char*> header_fields;        // header fields

  map<char, AminoAcid> amino_acids;   // amino acid records
  map<string, char> codon_map;        // map amino acids to codons
  vector<char> peptide_seq;            // store amino acid seq
  map<string, aa_color> aa_color_map; // mappings of amino acid colors


  void insert_amino (string codon) {
    char abbr = codon_map[codon];
    AminoAcid a = amino_acids[abbr];
    //cout << "NAME: " << *(a.name) << endl;
    //cout << "ABREV: " << a.abbrev << endl;
    peptide_seq.push_back(a.abbrev());
  }


  void insert_base(char c) {
    int pushVal = -1;
    switch(c) {
      case 'A':
        pushVal = A;
        break;
      case 'T':
        pushVal = T;
        break;
      case 'G':
        pushVal = G;
        break;
      case 'C':
        pushVal = C;
        break;
      case 'U':
        pushVal = U;
        break;
      default:
        //cout << "fail at seq pos " << seq.size() << " with char " << c << endl;
        //exit(1);
        break;
     };

     if (pushVal != -1)
       seq.push_back(pushVal);
  }


  /*
   * Load values from space delimited files into data structures for use
   *
   */
  void init () {
    load_colors();
    load_aa_constants();
  }


public:

  /*
   * constructor -- initialize object, set up
   *
   */
  FASTA() {
    init();
  }


  /* 
   * Reset all values to default (empty) 
   *
   */
  void reset() {
    seq.clear();
    header_fields.clear();
    peptide_seq.clear();
  }


  /* 
   * load the color values for amino acids from a file
   *
   */
  void load_colors (const char* filename = AA_COLORS_FILE) {
    int count=0;
    string definition_line;
    ifstream myfile(filename);
    if (myfile.is_open())
    {
      while (myfile.good() && ! myfile.eof())
      {
        // read def line which is TABBREV-SPACE-NAME-SPACE-ABBREV-SPACE-CSV,CSV,etc.
        getline(myfile, definition_line);

        if (definition_line.length() > 0) // oddly necessary
        {
          char* cstr = new char[definition_line.size()+1];
          strcpy(cstr, definition_line.c_str());
          char *triple_abbr = strtok(cstr, " ");
          char *name;
          char *code;
          if (triple_abbr)
            name = strtok(NULL, " ");
          if (name)
            code = strtok(NULL, " ");

          aa_color aac;
          if (name != NULL)
            aac.name = std::string(name);

          // extract r g b values
          char *r = strtok(code, ",");
          char *g = strtok(NULL, ",");
          char *b = strtok(NULL, ",");
          aac.r = atoi(r);
          aac.g = atoi(g);
          aac.b = atoi(b);

          //cout << "[" << triple_abbr << ", " << name << "]: r " << r << " g " << g << " b " << b << endl;
          aa_color_map[triple_abbr] = aac;

        } // end check for empty line
      }
      myfile.close();
    }

    // see what's in aa_color_map!
    /*
    map<string, aa_color>::iterator ci;
    for (ci=aa_color_map.begin(); ci != aa_color_map.end(); ci++)
    {
      cout << "aa: " << ci->first << endl;
      aa_color a = ci->second;
      a.dump();
    }
    */
    
  }

  void load_aa_constants (const char* filename = AA_CONSTANTS_FILE) {
    int count=1;
    string definition_line;
    ifstream myfile(filename);
    if (myfile.is_open())
    {
      while (myfile.good() && ! myfile.eof())
      {
        // read def line which is TABBREV-SPACE-NAME-SPACE-ABBREV-SPACE-CSV,CSV,etc.
        getline(myfile, definition_line);

        if (definition_line.length() > 0) // oddly necessary
        {
          char* cstr = new char[definition_line.size()+1];
          strcpy(cstr, definition_line.c_str());
          char *triple_abbr = strtok(cstr, " ");
          char *name;
          char *single_abbr;
          char *form;
          char *wt;
          char *code;
          if (triple_abbr)
            name = strtok(NULL, " ");
          if (name)
            single_abbr = strtok(NULL, " ");
          if (single_abbr)
            form = strtok(NULL, " ");
          if (form)
            wt = strtok(NULL, " ");
          if (wt)
            code = strtok(NULL, " ");

          cout << "name: " << name << " single_abbr: " << single_abbr << " triple_abbr: " << triple_abbr << " code: " << code << endl;
          AminoAcid a;
          if (name != NULL)
            a.name(std::string(name));
          if (single_abbr != NULL)
            a.abbrev(*single_abbr);
          if (triple_abbr != NULL)
            a.triple_abbrev(triple_abbr);
          if (form != NULL)
            a.formula(form);
          if (wt != NULL)
            a.weight(strtod(wt, NULL));

  //cout << "CODE: [" << code << "]" << endl;
          char *tlc = strtok(code, ",");
          vector<string> codons;
          while (tlc != NULL)
          {
             // push the amino acid to the peptide_seq
             codons.push_back(std::string(tlc));
             //cout << "TLC: " << tlc << endl;
             codon_map[tlc] = *single_abbr;
             tlc = strtok(NULL, ",");
          }
          a.codons(codons); // finalize amino acid
          a.color(aa_color_map[triple_abbr]);

          amino_acids[a.abbrev()] = a;
          count++;
        } // end check for empty line
      }
      myfile.close();
    }

    // see what's in codon_map!
    /*
    map<string, char>::iterator ci;
    for (ci=codon_map.begin(); ci != codon_map.end(); ci++)
    {
      //cout << "hrm\n";
      cout << "codon: " << ci->first << endl;
      cout << "amino: " << ci->second << endl;
      AminoAcid a = amino_acids[ci->second];
      a.dump();
    }
    */
   
    
  }

  /* 
   * Read constants from space delimited amino acids file.
   * 
   */
  void read (const char* filename, int mode = MODE_NUCLEOTIDE) {

    int count=0;
    string header;
    ifstream myfile(filename);
    if (myfile.is_open())
    {
      while (myfile.good())
      {
        if (count++)
        {
          if (mode == MODE_NUCLEOTIDE)
          {
            char c;
            while (myfile.get(c)) 
            {
              insert_base(c);
              //if (DEBUG) cout << "BASE: " << c << endl;
            }
          }
          else if (mode == MODE_PEPTIDE)
          {
           while (!myfile.eof())
           {
              string line;
              stringstream ss;
              getline(myfile, line, '\n');
              ss << line;
              
              char codon[3];
              while (ss.get(codon, 4))
              {
                //cout << "CODON: " << codon << endl;
                insert_amino(codon);
              }
            }
          }
          else { cout << "ERROR: UNKNOWN MODE\n"; }
            
      	}
      	else { // parse header
          getline(myfile, header);
          char* cstr = new char[header.size()+1];
          strcpy(cstr, header.c_str());
          char *pch = strtok(cstr, ">| ");
          while (pch)
          {
             header_fields.push_back(pch);
             pch = strtok(NULL, ">| ");
          }
        }
      }
      myfile.close();
    }
    else cout << "Unable to open file '" << filename << "'\n";
  } 


  /*
   * Dump the data from the FASTA file for debugging.
   *
   */
  void dump_seq() {
    vector<int>::iterator it;
    for (it=seq.begin(); it < seq.end(); it++)
    {
      cout << " " << *it;
    }
    
    cout << "CODING SEQ\n";
    vector<char>::iterator cit;
    for (cit=peptide_seq.begin(); cit < peptide_seq.end(); cit++)
    {
      cout << *cit;
      //AminoAcid a = amino_acids[*cit];
      // a.dump();
      //string tla = a.triple_abbrev;
      //cout << "TLA: " << tla << endl;
      //aa_color aac = aa_color_map[tla];
      //aac.dump();

      if (cit < peptide_seq.end()-1) cout << ", ";
    }
    cout << endl;
 
  }

  int size() {
    return seq.size();
  }

  char* getID() {
    return header_fields[0];
  }

  vector<AminoAcid> getCodingSeq() {
    vector<AminoAcid> coding;
    vector<char>::iterator ci;
    for (ci = peptide_seq.begin(); ci < peptide_seq.end(); ci++)
    {
      coding.push_back(amino_acids[*ci]);
    }
    return coding;
  }

  vector<int> getSeq() {
    return seq;
  }

  vector<char*> getHeader() {
    return header_fields;
  }
  

  char nucLookup( int num ) {
    switch(num) {
      case 0:
        return 'a';
      case 1:
        return 't';
      case 2:
        return 'g';
      case 3:
        return 'c';
      case 4:
        return 'u';
      break;
    };
}


};

