#include <iostream>
#include "fasta.cpp"

using namespace std;

int main () {

  FASTA f;
  
  f.read("CP001438.1.fasta", 0);
  //f.read("CP001438.1.fasta", MODE_CODING);
  //f.dump();

  return 0;
}
