/*
 *
 * A C++ library for parsing FASTA nucleotide and peptide sequence files, and
 * for basic sequence manipulation
 *
 * File are read into a buffer line by line, so memory usage is minimal even
 * for massive files. Reading frame recognition is implemented.
 * 
 * Author: Daniel Packer <dp at danielpacker dot org>
 *
 * TODO:
 * - add filename extenstion recognition (nucleotide vs amino acid, etc.)
 * - implement template sequences (not just coding sequences)
 * - imlement reading amino acids direct from fasta
 * - implement automatic fasta file generator/testing framework
 * - implement orf struct and store vector of orfs with their start/end pos
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
#include <algorithm>
#include "utility.cpp"

#define DEBUG 1

using namespace std;

enum { MODE_NUCLEOTIDE, MODE_PEPTIDE, TYPE_CDNA, TYPE_NDNA, TYPE_RNA };

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
    cout << "[" << name_ << "]: " << triple_abbrev_ << ", " << abbrev_ << ", " << weight_ << ", " << formula_ << endl;
    color_.dump();
    cout << "Codons:\n";
    printVec(codons_);
  }
};


/*
 * FASTA objects parse FASTA files and populates data structures with contents.
 *
 * Explanation of mappings:
 * - amino_acids maps single letter abbreviations for amino acids to amino acid objects
 * - codon_map maps triple letter codon strings with the single letter abbreviations
 */
class FASTA {

private:

  vector<char> seq;                   // store bp seq
  vector<char*> header_fields;        // header fields

  map<char, AminoAcid> amino_acids;   // amino acid records
  map<string, char> codon_map;        // map amino acids to codons
  vector<string> valid_codons;        // just a list of valid codons, like the keys of codon_map
  vector<char> peptide_seq;           // store amino acid seq
  map<string, aa_color> aa_color_map; // mappings of amino acid colors


  /*
   * Insert entire orf (of amino acids)
   *
   */
  void insert_orf (vector<string> & orf) {
    vector<string>::iterator it;
    for (it=orf.begin(); it < orf.end(); it++)
    {
      insert_amino(*it);
    }
    orf.clear();
  }


  /*
   * Insert an amino acid into the peptide sequence
   *
   */
  void insert_amino (string codon) {
    //cout << "codon: " << codon << endl;
    char abbr = codon_map[codon];
    //cout << "abbr: " << abbr << endl;
    AminoAcid a = amino_acids[abbr];
    //cout << "NAME: " << a.name() << endl;
    //cout << "ABREV: " << a.abbrev() << endl;
    peptide_seq.push_back(a.abbrev());
  }


  /*
   * Insert a base into the nucleotide sequence
   *
   */
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

  bool is_coding(std::string codon) {
    bool found_codon = grepVec(codon, valid_codons);
    return found_codon;
  }

  bool is_stop(std::string codon) {
    AminoAcid stop_aa = amino_acids['*'];
    vector<string> stop_codons = stop_aa.codons();
    bool found_stop = grepVec(codon, stop_codons);
    return found_stop;
  }

  bool is_start(std::string codon) {
    AminoAcid stop_aa = amino_acids['M'];
    vector<string> stop_codons = stop_aa.codons();
    bool found_stop = grepVec(codon, stop_codons);
    return found_stop;
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

          //cout << "name: " << name << " single_abbr: " << single_abbr << " triple_abbr: " << triple_abbr << " code: " << code << endl;
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
             valid_codons.push_back(std::string(tlc));
             tlc = strtok(NULL, ",");
          }
          a.codons(codons); // finalize amino acid
          a.color(aa_color_map[triple_abbr]);
          //cout << "storing the amino acid (" << a.abbrev() << ")\n";
          //a.dump();
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
   * Supports cDNA only. Implement RNA and non-coding DNA in future.
   * 
   */
  void read (const char* filename, int mode = MODE_NUCLEOTIDE, int type = TYPE_CDNA) {

    int count=0;
    string header;
    ifstream myfile(filename);
    string codon;          // the next codon we're reading
    vector<string> orf;
    bool in_orf = false;

    if (myfile.is_open())    // Is file open?
    {
      while (myfile.good())  // Is file good?
      {
        if (count++)         // Only work on file after parsing the header
        {
          /*
           * In MODE_NUCLEOTIDE we only collect each base. We don't care about peptides.
           *
           */
          if (mode == MODE_NUCLEOTIDE)
          {
            char c;
            while (myfile.get(c)) 
            {
              //insert_base(c);
              seq.push_back(c);
              //if (DEBUG) cout << "BASE: " << c << endl;
            }
          }
          /*
           * In MODE_PEPTIDE we want to interpret nucleotides as coding for amino acids.
           *
           */
          else if (mode == MODE_PEPTIDE)
          {
            while (!myfile.eof())
            {
              string line;
              getline(myfile, line);
              line = DNA2RNA(line, type);
              stringstream ss;
              ss.write(line.c_str(), line.size());

              int line_size = line.size();
              char next_char;

              //cout << "LOOP\n";

              /*
               * There are two conditions in which we need to "rewind" and find the next
               * reading frame. The first condition is when an ORF reaches a STOP. The
               * other condition is when we encounter non-coding codons.
               *
               */
              while (ss.peek() != EOF) // Read until we can't read no more
              {
                next_char = ss.get();
                //cout << "GOT CHAR: " << next_char << endl;
                codon += next_char;    // Build up the codon char by char

                // If we have collected 3 chars, let's check out this codon!
                if (codon.size() == 3)
                {
                  //cout << "considering codon: " << codon << endl;
                  //cout << "in_orf: " << in_orf << endl;
                  //cout << "is_stop: " << is_stop(codon) << endl;
                  //cout << "is_start: " << is_start(codon) << endl;
 
                  // If this codon is non-coding, set in_orf=false and rewind
                  if (! is_coding(codon) )
                  {
                    ss.seekg((int)ss.tellg()-2);
                    codon.clear();
                    continue;
                  }

                  // If we're no in an orf and we find one, set flag
                  if ( in_orf == false )
                  {
                    if ( is_start(codon) )
                    {
                      in_orf = true;
                    }
                    else // find reading frame
                    {
                      ss.seekg((int)ss.tellg()-2);
                      codon.clear();
                      continue;
                    }
                  }
                  
                  if ( in_orf == true ) // we're in the ORF
                  {
                    orf.push_back(codon); // save the codon to the orf

                    // If we're in an orf and we find a stop, set flag
                    if ( is_stop(codon) )
                    {
                      //cout << "STOP\n";
                      in_orf = false;
                      insert_orf(orf);
                      orf.clear();
                    }
                    codon.clear(); // done with codon, clear it
                  }
                } // end if codon size==3
              } // end reading this line
            } // end reading this file
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
  void dump_seq(bool verbose = false) {
    vector<char>::iterator it;
    if (seq.size() > 0)
    {
      cout << "\nNUCLEOTIDE SEQ:\n";
      for (it=seq.begin(); it < seq.end(); it++)
      {
        cout << *it << " ";
      }
      cout << endl;
    }
    
    if (peptide_seq.size())
    {
      cout << "\nPEPTIDE SEQ:\n";
      vector<char>::iterator cit;
      int wordct=0;
      for (cit=peptide_seq.begin(); cit < peptide_seq.end(); cit++)
      {
        if (verbose)
        {
          if (*cit == '*')
          {
            cout << endl;
            wordct=0;
          }
          else
          {
          AminoAcid a = amino_acids[*cit];
          if (wordct != 0)
            cout << "-";
 
          cout << a.triple_abbrev();
          wordct++;
         }
        }
        else
        {
          cout << *cit;
          if (cit < peptide_seq.end()-1) cout << ", ";
        }
        //AminoAcid a = amino_acids[*cit];
        // a.dump();
        //string tla = a.triple_abbrev;
        //cout << "TLA: " << tla << endl;
        //aa_color aac = aa_color_map[tla];
        //aac.dump();

      }
      cout << endl << endl;
    }
  }

  /*
   * Dump the data from the FASTA file for debugging.
   *
   */
  void print_amino_constants() {
    map<char, AminoAcid>::iterator ci;
    for (ci = amino_acids.begin(); ci != amino_acids.end(); ci++)
    {
      AminoAcid aa = (*ci).second;
      if (aa.triple_abbrev() != "STP")
        cout << aa.triple_abbrev() << " " << aa.name() << " " << aa.formula() << endl;
    }
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

  vector<char> getSeq() {
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

  /*
   * convert DNA to RNA (simple T -> U substitution)
   * parameter: boolean for whether coding or non-coding
   *
   */
  std::string DNA2RNA( const std::string DNA, int type = TYPE_CDNA ) {
    string RNA = DNA;
    //cout << "DNA IN: " << RNA << endl;
    // For coding DNA, all we need is to swap T with U
    if (type == TYPE_CDNA)
    {
      strReplace(RNA, "T", "U");
      strReplace(RNA, "t", "u");
    }
    // non-coding template (anti-sense) strand needs reverse compliment
    else if (type == TYPE_NDNA)
    {
      std::reverse(RNA.begin(), RNA.end());
      strReplace(RNA, "T", "A");
      strReplace(RNA, "t", "a");
      strReplace(RNA, "A", "t");
      strReplace(RNA, "a", "t");
      strReplace(RNA, "C", "G");
      strReplace(RNA, "c", "g");
      strReplace(RNA, "G", "C");
      strReplace(RNA, "g", "c");
      RNA = DNA2RNA(RNA, TYPE_CDNA);
    }
    //cout << "RNA OUT: " << RNA << endl;
    return RNA;
  }

};

