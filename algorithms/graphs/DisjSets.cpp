
// DisjSets class (mostly from Mark Allan Weiss's textbook)
//
// CONSTRUCTION: with int representing initial number of sets
//
// ******************PUBLIC OPERATIONS*********************
// void union( root1, root2 ) --> Merge two sets
// int find( x )              --> Return set containing x
// ******************ERRORS********************************
// No error checking is performed

#include <vector>
#include <iostream>
using namespace std;

/**
 * Disjoint set class.
 * Use union by rank and path compression.
 * Elements in the set are numbered starting at 0.
 */
class DisjSets
{
    public:

    /**
     * Construct the disjoint sets object.
     * numElements is the initial number of disjoint sets.
     */
    DisjSets( int numElements = 10 ) : s( numElements )
    {
        for( int i = 0; i < s.size( ); i++ )
            s[ i ] = -1;
	}

    void resize ( int newSize )
    {
        s.resize(newSize, -1); // fill with -1's
    }

    /**
     * Union two disjoint sets.
     * For simplicity, we assume root1 and root2 are distinct
     * and represent set names.
     * root1 is the root of set 1.
     * root2 is the root of set 2.
     */
    void unionSets( int root1, int root2 )
    {
        //cout << "root1: " << root1 << " root2: " << root2 << endl;
        if( s[ root2 ] < s[ root1 ] )  // root2 is deeper
            s[ root1 ] = root2;        // Make root2 new root
        else
        {
            if( s[ root1 ] == s[ root2 ] )
                s[ root1 ]--;          // Update height if same
            s[ root2 ] = root1;        // Make root1 new root
        }
    }


    /**
     * Perform a find.
     * Error checks omitted again for simplicity.
     * Return the set containing x.
     */


    /**
     * Perform a find with path compression.
     * Error checks omitted again for simplicity.
     * Return the set containing x.
     */
    int find( int x )
    {
        if( s[ x ] < 0 )
            return x;
        else
            return s[ x ] = find( s[ x ] );
    }

    void dump( )
    {
        cout << "Dumping set:" << endl;
        for (int i=0; i < s.size(); i++)
            printf("%4d", s[i]);
        cout << endl;
        for (int i=0; i < s.size(); i++)
            printf("%4d", i);
        cout << endl;
    }

    private:
         std::vector<int> s;

};


