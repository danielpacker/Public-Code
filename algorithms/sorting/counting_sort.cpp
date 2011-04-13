using namespace std;
#include <vector>;
#include <algorithm>;
#include <iostream>;

/* 
    Author is Daniel Packer unless otherwise noted.

    When I first wrote this, I was just testing an idea I had in class to
    use constant time array indexing as a sorting mechanism, without any
    comparisons. As it turns out, this is similar to the radix and 
    counting sorts, which go way back. The downside of this approach is
    that you need O(M) memory where M is your largest index/value as
    a giant net for all your potential values, and that can be a lot of
    memory. I found it very practical though, and it was still faster
    than quicksort for array sizes in the millions with large ints.
    
    This algorithm depends on being able to index the values, so they
    have to be integers. Future versions could accomodate other types
    by somehow converting/hashing the values into integers, turning
    this into a kind of sorted hash table (is this a hash map?).

    The performance of this algorithm is almost 2x faster than the
    built in gcc STL c++ sort(), which should be equivalent to a very
    fast quicksort. That makes sense since quicksort is O(NlogN) and
    without comparisons, this sort is linear!
*/
template <class Comparable>
void arraysort( vector<Comparable> & a, Comparable max = 0 )
{
    printf("\ndoing arraysort\n");

    // If array extent is implicit, use vector size and assume
    //  that no element will be larger than the vector size
    if (!max)
        max = a.size();

    Comparable * arr = NULL;
    arr = new Comparable[max];

    vector<int>::const_iterator it;
    for ( it=a.begin() ; it < a.end(); it++ )
        arr[*it] = *it;

    a.clear();
    for (int i=0; i < max; i++)
        if (arr[i]) 
            a.push_back(arr[i]);
}

/**
* Shellsort, using Shell's (poor) increments. The textbook implementation. Copyright is with textbook author.
*/
template <class Comparable>
void shellsort( vector<Comparable> & a )
{
    printf("\ndoing shellsort\n");

    for( int gap = a.size( ) / 2; gap > 0; gap /= 2 )
        for( int i = gap; i < a.size( ); i++ )
        {
            Comparable tmp = a[ i ];
            int j = i;

            for( ; j >= gap && tmp < a[ j - gap ]; j -= gap )
            a[ j ] = a[ j - gap ];
            a[ j ] = tmp;
        }
}

int main (int argc, char * argv[])
{
    // generate a vector full of random integers called stuff
    vector<int> stuff;
    srand ( time(NULL) );
    for (int i=0; i < 100000; i++)
        stuff.push_back(rand() % 100000);

    // Do sort requested on command line
    if (argv[1] != NULL)
        if (strcmp(argv[1], "shellsort")==0)
            shellsort(stuff);   // do shellshort
        else if (strcmp(argv[1], "arraysort")==0)
            arraysort(stuff);
        else if (strcmp(argv[1], "stlsort")==0)
        {
            printf("\ndoing STL sort\n");
            sort(stuff.begin(), stuff.end());
        }
        else // no valid argument
        ;
    else
        printf("ERROR: NO SORT SELECTED (shellshort or arraysort or stlsort)\n");

    return 0;
}
