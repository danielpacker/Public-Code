#include <iostream>
#include "fasta.cpp"

using namespace std;

int main (int argc, char* argv[]) {

  // There is one required paramter -- the FASTA file
  if (argc < 2)
  {
    cout << "Filename missing." << endl;
    cout << "Usage: parsefasta <filename>" << endl;
    return 1;
  }

  char * filename = argv[1];
  FASTA f;                                   // define FASTA parser
  f.read(filename, MODE_PEPTIDE, TYPE_CDNA); // read FASTA file as coding DNA to peptides
  f.dump_seq(true);                          // dump the contents of the peptides
  f.print_amino_constants();                 // print the amino acid constants table
  f.reset();                                 // reset object for reuse
  return 0;
}
