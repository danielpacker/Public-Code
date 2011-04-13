/*

    All code by Daniel Packer.

    This is my really horrifying implementation of in-place quicksort. 
    It uses a naive pivot scheme, but seems to run about as fast as the 
    gnu c++ STL sort() on large vectors of ints so far. Use with caution. 
    Working on pivot sampling (see find_pivot) and 3-way pivot.

    The quicksort_simple() function contains all the logic and the rest
    of the functions are utilities for tests and debugging.

*/

#include <vector>
#include <string>
#include <iostream>
#include <math.h>
#include <algorithm>
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
    //cout << "Pivot is: " << vec[pivot] << endl << endl;
    //cout << "Total vec: "; printVec(vec, a, b);

    int i = a+1;
    int k = b;
    for (;;)
    { 
            //cout << vec[i] << " vs " << vec[k] << "           (i = " << i << " k = " << k << ")" << endl;

           if (vec[i] < vec[pivot])               // advance, element already in order
                i++;
            else                                    // i is out of order
                if (vec[k] < vec[pivot])           // j is also out of order. swap!
                {
                     swap( vec[i], vec[k] );
                     //printVec(vec, a, b);
                }
                else
                     k--;
         if (k < i)                                 // sort done, do swap
         {
             while (k >= a && vec[k] > vec[pivot]) { k--; }
             //cout << "final k: " << k << endl;
             if (k >= a)
             {
                 swap( vec[pivot], vec[k] );        // avoid out of bounds
                 //printVec(vec, a, b);
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

#define NUMSORTS 1000   // default number of sorts to run 
#define VECSIZE  10000  // default vector size to test on 
#define MAXINT   10000  // default max integer size for element

// Fill a vector with random numbers
//   Arguments are randomness factor and max value of element
void make_random_vector ( vector<int> & v, int size = VECSIZE, float randomness = 1, int max = MAXINT )
{
    randomness = (randomness > 1 || randomness < 0) ? 1 : randomness; // randomness is 0..1
    v.clear();
    int i;
    for (i=0; i < (size * randomness); i++)
    {
        v.push_back(rand() % max);
    }

    // Fill the rest of the array (non-random portion) with the same number
    while(i++ < size)
        v.push_back(max/2);
}


// run a batch of tests on quicksort_simple by comparing to sort()
void do_test ( vector< vector<int> > & vv )
{
    vector< vector<int> >::iterator it;
    for (it=vv.begin(); it < vv.end(); it++)
    {
        vector<int> v_quicksort_simple = *it;
        vector<int> v_sort = *it;
        quicksort_simple(v_quicksort_simple);
        sort(v_sort.begin(), v_sort.end());
        if (! equal(v_quicksort_simple.begin(), v_quicksort_simple.end(), v_sort.begin()) )
        {
            cout << "FAIL!" << endl;
            cout << "Original: ";
            printVec(*it);
            cout << "Sort: ";
            printVec(v_sort);
            cout << "Quicksort_simple: ";
            printVec(v_quicksort_simple);
            return;
        }
    }
    cout << "Tests passed!" << endl;
}


void do_sort ( vector< vector<int> > & vv )
{
    vector< vector<int> >::iterator it;
    for (it=vv.begin(); it < vv.end(); it++)
        sort((*it).begin(), (*it).end());
}

void do_quicksort ( vector< vector<int> > & vv )
{
    vector< vector<int> >::iterator it;
    for (it=vv.begin(); it <= vv.end(); it++)
        quicksort_simple(*it);
}


int main ( int argc, const char* argv[] )
{
    srand ( time(NULL) );                           // omg. so random!

     // Do sorting requested on command line. Second arg is number of sort jobs to perform.
    if (argv[1] != NULL)
    {
        // Generate our test data
        int numSorts = (argv[2] != NULL) ? atoi(argv[2]) : NUMSORTS; // size of job
        vector< vector<int> > vv;
        for (int test=0; test < numSorts; test++)
        {
            vector<int> v; 
            make_random_vector(v);
            vv.push_back(v);
        }

        if (strcmp(argv[1], "test")==0)
            do_test(vv);                          // test quicksort_simple() against sort()
        else if (strcmp(argv[1], "sort")==0)
            do_sort(vv);                          // run a batch of sort() routines
        else if (strcmp(argv[1], "quicksort")==0)
            do_quicksort(vv);                     // run a batch of quicksort_simple() routines
        else // no valid argument
            printf("INVALID OPTION (use test or sort or quicksort)\n");

        // for (int test=0; test < numSorts; test++) printVec(vv[test]); // make sure it's really sorted
    }
    else
        printf("ERROR: NO SORT SELECTED (test or sort or quicksort)\n");

    return 0;
}

