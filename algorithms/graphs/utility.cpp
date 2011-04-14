/*

    All code by Daniel Packer.

    Useful utility functions.

    printVec(vector<Comparable>, int, int) - prints out a vector from range a,b
    swap(Comparable &, Comparable &) - swaps two comparable objects

*/

#include <vector>
#include <iostream>
using namespace std;

// Swap two Comparables
template <class Comparable>
void swap( Comparable & lhs, Comparable & rhs )
{
    Comparable temp = lhs;
    lhs = rhs;
    rhs = temp;
}

// print a vector's elements from range left to right
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

