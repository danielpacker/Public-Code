#include <iostream>
#include "fasta.cpp"

using namespace std;

int main () {

  FASTA f;
  
  f.read("CSCI435.fasta", MODE_PEPTIDE, TYPE_CDNA);
  f.dump_seq(true);
  //f.print_amino_constants();
  f.reset();
  //f.read("CSCI435.fasta", MODE_NUCLEOTIDE);
  //f.dump_seq();
  //f.read("CP001438.1.fasta", MODE_NUCLEOTIDE);
  //f.dump_seq();
  //f.reset();
  //f.read("CP001438.1.fasta", MODE_PEPTIDE);
  //f.dump_seq();
  //f.dump();

  return 0;
}
