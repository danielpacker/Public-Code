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
void quicksort_simple ( vector<Comparable> & vec, int a=0, int b=0 )
{
    if (b==0)
        b = vec.size()-1;      // default index of last element

    if (vec.size() <= 1)
        return;                     // abort if vector is empty

    // Choose the middle of three values, first, last, and middle
    //Comparable pivot = find_pivot(vec);
    int pivot = a;        // use first element as pivot
    cout << "Pivot: " << vec[pivot] << endl;

    int i = a+1;
    int j = b;
    int x = 0;
    for (;;)
    {
        cout << vec[i] << " vs " << vec[j] << "       (vec[" << i << "] vs vec[" << j << "])" << endl;
        if (vec[i] <= vec[pivot]) // advance, element already in order
            i++;
         else   // we found a leftside value greater than pivot ( need to swap )
             if (vec[j] <= vec[pivot]) // we found a right side value less than pivot
             {
                 // do swap
                 cout << "SWAP\n";
                 Comparable temp = vec[j];
                 vec[j--] = vec[i];
                 vec[i++] = temp;
                 printVec(vec);
             }
             else
                 j--;

         if (j < i)
             break;
    }

    cout << "final j: " << j << " final i: " << i << endl;
    // swap middle with last
    if (vec[pivot] > vec[j])
    {
        Comparable temp = vec[pivot];
        vec[pivot] = vec[j];
        vec[j] = temp;
    }
}

template <typename Comparable>
void printVec ( const vector<Comparable> & v )
{
    typename std::vector<Comparable>::const_iterator it;
    for (it = v.begin(); it < v.end(); it++)
        cout << *it << " ";
    cout << endl;
}



int main ( )
{

    vector<int> v;
    srand ( time(NULL) );
    for (int i=0; i < 8; i++)
        v.push_back(rand() % 10);

    printVec(v);
    quicksort_simple(v);
    cout << "sorted list: ";
    printVec(v);

    return 0;
}

