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

enum { MODE_NONCODING, MODE_CODING };

enum { A = 0, T = 1, G = 2, C = 3, U = 4 };


struct aa_color {
  string name;
  int r;
  int g;
  int b;

  void dump() {
    cout << "[" << name << "]: " << r << ", " << g << ", " << b << endl;
  }
};

struct aminoAcid {
  vector<string> codons; // possible codons
  string name;
  string triple_abbrev;
  char abbrev;
  aa_color color;

  void dump() {
    cout << "[" << name << "]: " << triple_abbrev << ", " << abbrev << endl;
    color.dump();
  }
};

/* encoding scheme

Amino acids will have fields for their proper name, their abbreviation (one letter), and their possible codons. The codons will be represented by their unique 4 bit value.

In order to make a sequence of amino acids, we iterate through the sequence, calculating codon indexes. For each codon index, we look at a mapping of codon indexes to amino acids to determine what acid to add to the list. We retrieve an amino acid object ref from the map and retrieve its name or abbreviation to add to the list.

*/
  

class FASTA {

private:

  vector<int> seq;                    // store bp seq
  vector<char*> header_fields;        // header fields

  map<char, aminoAcid> amino_acids;   // amino acid records
  map<string, char> codon_map;        // map amino acids to codons
  vector<char> coding_seq;            // store amino acid seq
  map<string, aa_color> aa_color_map; // mappings of amino acid colors

  void insert_amino (string codon) {
    char abbr = codon_map[codon];
    aminoAcid a = amino_acids[abbr];
    //cout << "NAME: " << *(a.name) << endl;
    //cout << "ABREV: " << a.abbrev << endl;
    coding_seq.push_back(a.abbrev);
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


public:

  void map_colors (const char* filename = "amino_colors.txt") {
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

  void map_codons (const char* filename = "codons.txt") {
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
          char *code;
          if (triple_abbr)
            name = strtok(NULL, " ");
          if (name)
            single_abbr = strtok(NULL, " ");
          if (single_abbr)
            code = strtok(NULL, " ");

//          cout << "name: " << name << " single_abbr: " << single_abbr << " triple_abbr: " << triple_abbr << " code: " << code << endl;
          aminoAcid a;
          if (name != NULL)
            a.name = std::string(name);
          if (single_abbr != NULL)
            a.abbrev = *single_abbr;
          if (triple_abbr != NULL)
            a.triple_abbrev = triple_abbr;

  //cout << "CODE: [" << code << "]" << endl;
          char *tlc = strtok(code, ",");
          vector<string> codons;
          while (tlc != NULL)
          {
             // push the amino acid to the coding_seq
             codons.push_back(std::string(tlc));
             //cout << "TLC: " << tlc << endl;
             codon_map[tlc] = *single_abbr;
             tlc = strtok(NULL, ",");
          }
          a.codons = codons; // finalize amino acid
          a.color = aa_color_map[triple_abbr];

          amino_acids[a.abbrev] = a;
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
      aminoAcid a = amino_acids[ci->second];
      a.dump();
    }
    */
   
    
  }

  void init () {
    map_colors();
    map_codons();
  }

  void read (const char* filename, int mode = MODE_NONCODING) {

    init(); // initialize data

    int count=0;
    string header;
    ifstream myfile(filename);
    if (myfile.is_open())
    {
      while (myfile.good())
      {
        if (count++)
        {
          if (mode == MODE_NONCODING)
          {
            char c;
            while (myfile.get(c)) 
            {
              insert_base(c);
              //if (DEBUG) cout << "BASE: " << c << endl;
            }
          }
          else if (mode == MODE_CODING)
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

  void dump() {
    vector<int>::iterator it;
    for (it=seq.begin(); it < seq.end(); it++)
    {
      cout << " " << *it;
    }
    
    cout << "CODING SEQ\n";
    vector<char>::iterator cit;
    for (cit=coding_seq.begin(); cit < coding_seq.end(); cit++)
    {
      cout << *cit;
      //aminoAcid a = amino_acids[*cit];
      // a.dump();
      //string tla = a.triple_abbrev;
      //cout << "TLA: " << tla << endl;
      //aa_color aac = aa_color_map[tla];
      //aac.dump();

      if (cit < coding_seq.end()-1) cout << ", ";
    }
    cout << endl;
 
  }

  int size() {
    return seq.size();
  }

  char* getID() {
    return header_fields[0];
  }

  vector<aminoAcid> getCodingSeq() {
    vector<aminoAcid> coding;
    vector<char>::iterator ci;
    for (ci = coding_seq.begin(); ci < coding_seq.end(); ci++)
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
  

};

