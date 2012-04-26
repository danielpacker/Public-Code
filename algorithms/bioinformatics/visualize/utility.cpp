#ifndef _UTILITY_STUFF_
#define _UTILITY_STUFF_
/*

    All code by Daniel Packer.

    Useful utility functions.

    printVec(vector<Comparable>, int, int) - prints out a vector from range a,b
    swap(Comparable &, Comparable &) - swaps two comparable objects

*/

#include <vector>
#include <iostream>
#include <sstream>
using namespace std;

/*
 * Swap two Comparables in place
 *
 */
template <class Comparable>
void swap( Comparable & lhs, Comparable & rhs )
{
    Comparable temp = lhs;
    lhs = rhs;
    rhs = temp;
}

/*
 * print a vector's elements from range left to right
 *
 */
template <typename Comparable>
void printVec ( const vector<Comparable> & v , int left=0, int right=-1 )
{
    if (right == -1)
        right = v.size()-1;

    typename std::vector<Comparable>::const_iterator it;
    for (int i=left; i <= right && i < v.size(); i++)
        cout << v[i] << " ";
    cout << endl;
}


/*
 * see below -- implements split
 *
 */
vector<string> &split(const string &s, char delim, vector<string> &elems) {
    stringstream ss(s);
    string item;
    while(getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}


/*
 * Split a string into vector of strings with delimiter delim
 *
 */
vector<string> split(const string &s, char delim) {
    vector<string> elems;
    return split(s, delim, elems);
}

/*
 * Return whether or not element s is found in vector v
 *
 */
template <typename Comparable>
bool grepVec(const Comparable &s, vector<Comparable> &v) {
  typename std::vector<Comparable>::const_iterator it;
  for (int i=0; i < v.size(); i++)
  {
    //cout << "COMPARING [" << v[i] << "] to [" << s << "]" << endl;
    if (v[i] == s) return true;
  }
    //cout << "GREPPING LIST ITEM: " << v[i] << endl;
  return false; 
}


/*
 * Replace string sOld with string sNew in string s (in place)
 *
 */
void strReplace(std::string & s, const std::string & sOld, const std::string & sNew)
{
  size_t pos = 0;
  while((pos = s.find(sOld, pos)) != std::string::npos)
  {
     s.replace(pos, sOld.length(), sNew);
     pos += sNew.length();
  }
}

#endif
