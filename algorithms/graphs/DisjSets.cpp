
// DisjSets class (somewhat borrowed from Mark Allan Weiss's textbook)
// adapted by Daniel Packer
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
#include <cstdlib>
#include "stdio.h"

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

    int randSetMember(int set)
    {
      //cout << "getting random member of set " << set << endl;
      vector<int> members = getSetMembers(set);
      //cout << members.size() << " members in set " << set << endl;
      int member = 0;
      if (members.size() > 0)
      {
        int index = rand() % members.size();
        member = members[index];
      }
      
      return member;
    }

    vector<int> getSetMembers(int elem)
    {
      vector<int> members;
      int set = find(elem);
      //cout << "set for elem " << elem << " is " << set << endl;
      if (set < 0)
      {
        //cout << "elem is a parent. adding to members" << endl;
        members.push_back(elem);
      }
      if (set != -1)
      {
        for( int i = 0; i < s.size(); i++ )
        {
          //cout << i << " in set " << s[i] << endl;
          if (find(i) == set)
          {
            members.push_back(i);
            //cout << "member: " << i << endl;
          }
        }
      }
      return members;
    }
          

    private:
         std::vector<int> s;

};


