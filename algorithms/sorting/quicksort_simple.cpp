/*

 function quicksort(array)
     var list less, greater
     if length(array) ≤ 1
         return array  // an array of zero or one elements is already sorted
     select and remove a pivot value pivot from array
     for each x in array
         if x ≤ pivot then append x to less
         else append x to greater
     return concatenate(quicksort(less), pivot, quicksort(greater))

pseucodecode from wikipedia, requires O(N) extra space. not best approach.

*/

#include <vector>
#include <string>
#include <iostream>
#include <math.h>
using namespace std;


/*
    Given a vector of generic comparables, find a pivot suitable for quicksort.
    The first, middle, and last elements of the vector are compared, and the
    value in between the other two is returned.
    */
template <typename Comparable>
Comparable find_pivot ( vector<Comparable> & unsorted )
{
    Comparable first  = unsorted[0];
    Comparable middle = unsorted[ceil(unsorted.size()/2)];
    Comparable last   = unsorted[unsorted.size()-1];
    cout << first << ", " << middle << ", " << last << endl;

    if (first <= middle)
        if (middle <= last)
            return middle;
        else
            return last;
    else if (middle <= first)
        if (first <= last)
            return first;
        else
            return last;
     else if (last <= first)
         if (first <= middle)
             return first;
         else
             return middle;
}


template <typename Comparable>
void quicksort_simple ( vector<Comparable> & vec, int a=0, int b=-100 )
{
    //cout << "a: " << a << " b: " << b << endl;
    if (b==-100)
        b = vec.size()-1;      // default index of last element

    if (vec.size() <= 1)
        return;                     // abort if vector is empty

     if (a < 0 || b < 0 || b <= a)
         return;

    // Choose the middle of three values, first, last, and middle
    //Comparable pivot = find_pivot(vec);
    int pivot = a;        // use first element as pivot
    cout << "Pivot is: " << vec[pivot] << endl << endl;
    cout << "Total vec: "; printVec(vec, a, b);

    int i = a+1;
    int k = b;
    for (;;)
    { 
            cout << vec[i] << " vs " << vec[k] << "           (i = " << i << " k = " << k << ")" << endl;

           if (vec[i] < vec[pivot])               // advance, element already in order
                i++;
            else                                    // i is out of order
                if (vec[k] < vec[pivot])           // j is also out of order. swap!
                {
                     swap( vec[i], vec[k] );
                     printVec(vec, a, b);
                }
                else
                     k--;
         if (k < i)                                 // sort done, do swap
         {
             while (k >= a && vec[k] > vec[pivot]) { k--; }
             cout << "final k: " << k << endl;
             if (k >= a)
             {
                 swap( vec[pivot], vec[k] );        // avoid out of bounds
                 printVec(vec, a, b);
             }
             break;
         }

    } // end infinite for

    // only recurse if we have lists greater than len 2
    quicksort_simple(vec, a, k-1); quicksort_simple(vec, k+1, b);

}

// Swap two Comparables
template <class Comparable>
void swap( Comparable & lhs, Comparable & rhs )
{
    Comparable temp = lhs;
    lhs = rhs;
    rhs = temp;
}

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



int main ( int argc, const char* argv[] )
{

    vector<int> v;

    srand ( time(NULL) );
    for (int i=0; i < 6; i++) v.push_back(rand() % 10);
    //v.push_back(7); v.push_back(4); v.push_back(9); v.push_back(7); v.push_back(9); v.push_back(7); v.push_back(1); v.push_back(8);
    //v.push_back(8); v.push_back(5); v.push_back(8); v.push_back(5); v.push_back(7); v.push_back(8); v.push_back(1); v.push_back(0);
    //v.push_back(0); v.push_back(5); v.push_back(1); v.push_back(5); v.push_back(7); v.push_back(3); v.push_back(2);

    cout << "original list: ";
    printVec(v);
    cout << endl;
    quicksort_simple(v);
    cout << endl << "sorted list: ";
    printVec(v);

    return 0;
}

