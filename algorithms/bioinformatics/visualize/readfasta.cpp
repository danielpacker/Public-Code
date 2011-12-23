#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cstdlib>
#include <cstring>

using namespace std;

enum { A, T, G, C, U };

class FASTA {

private:

  vector<int> seq; // store bases
  vector<char*> header_fields; // header fields

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
  void read (const char* filename) {
    int count=0;
    string header;
    ifstream myfile(filename);
    if (myfile.is_open())
    {
      while (myfile.good())
      {
	if (count++)
        {
          char c;
          while (myfile.get(c)) 
          {
	    insert_base(c);
          }
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
  }

  int size() {
    return seq.size();
  }

  char* getID() {
    return header_fields[0];
  }
  

};


int main ( int argc, const char* argv[] ) {

  if (argc < 2)
  {
    cout << "No filename passed." << endl;
    return 1;
  }

  FASTA f;
  f.read(argv[1]);
  f.dump();
  cout << "\nRead sequence (" << f.getID() << ") of size " << f.size() << endl;

  return 0;
}
