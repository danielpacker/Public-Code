#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

enum { A, T, G, C, U };

class FASTA {

private:
  vector<char> seq; // store bases

  void insert_base(char c) {
    int pushVal;
    switch(c) {
      case 'A':
        pushVal = A;
      case 'T':
        pushVal = T;
      case 'G':
        pushVal = G;
      case 'C':
        pushVal = C;
      case 'U':
        pushVal = U;
     };

     seq.push_back(pushVal);
  }


public:
  void read (const char* filename) {
    int count=0;
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
      }
      myfile.close();
    }
    else cout << "Unable to open file '" << filename << "'\n";
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

  return 0;
}
