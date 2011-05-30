#ifndef QUADRATIC_PROBING_H_
#define QUADRATIC_PROBING_H_

#include <vector>
#include <utility>
#include <iostream>
#include <string>
#include "BinomialQueue.h"

using namespace std;


string defaultStr("not found");
//BinomialNode<string> defaultBN(defaultStr, NULL, NULL, NULL);


// QuadraticProbing Hash table class
//
// CONSTRUCTION: an initialization for ITEM_NOT_FOUND
//               and an approximate initial size or default of 101
//
// ******************PUBLIC OPERATIONS*********************
// void insert( x )       --> Insert x
// void remove( x )       --> Remove x
// Hashable find( x )     --> Return item that matches x
// void makeEmpty( )      --> Remove all items
 

template <class Comparable, class HashedObj>
class HashTable
{
  public:
	explicit HashTable( const pair<Comparable, HashedObj*> & notFound = make_pair((Comparable)NULL, (HashedObj*)NULL), int size = 101 );
	HashTable( const HashTable & rhs )
	  : ITEM_NOT_FOUND( rhs.ITEM_NOT_FOUND ),
		array( rhs.array ), currentSize( rhs.currentSize ) { }

	const pair<Comparable, HashedObj*> & find( const Comparable & x ) const;

	void makeEmpty( );
	void insert( const pair<Comparable, HashedObj*> & x );
	void remove( const Comparable & x );
	void dump( );

	const HashTable & operator=( const HashTable & rhs );

	enum EntryType { ACTIVE, EMPTY, DELETED };
  private:
	struct HashEntry
	{
		pair<Comparable, HashedObj*> element;
		EntryType info;

		HashEntry( pair<Comparable, HashedObj*> e = make_pair((Comparable)NULL, (HashedObj*)NULL), EntryType i = EMPTY )
		  : info( i ) { }
		
	};
	
	vector<HashEntry> array;
	int currentSize;
	const pair<Comparable, HashedObj*> ITEM_NOT_FOUND;
	bool isActive( int currentPos ) const;
	int findPos( const Comparable & x ) const;
	void rehash( );
};

int hash( const string & key, int tableSize );
int hash( int key, int tableSize );


/**
 * Internal method to test if a positive number is prime.
 * Not an efficient algorithm.
 */
bool isPrime( int n )
{
	if( n == 2 || n == 3 )
		return true;
	
	if( n == 1 || n % 2 == 0 )
		return false;
	
	for( int i = 3; i * i <= n; i += 2 )
		if( n % i == 0 )
			return false;
	
	return true;
}

/**
 * Internal method to return a prime number at least as large as n.
 * Assumes n > 0.
 */
int nextPrime( int n )
{
	if( n % 2 == 0 )
		n++;
	
	for( ; !isPrime( n ); n += 2 )
		;
	
	return n;
}

/**
 * Construct the hash table.
 */
template <class Comparable, class HashedObj>
HashTable<Comparable, HashedObj>::HashTable( const pair<Comparable, HashedObj*> & notFound, int size )
: ITEM_NOT_FOUND( notFound ), array( nextPrime( size ) )
{
	makeEmpty( );
}

/**
 * Insert item x into the hash table. If the item is
 * already present, then do nothing.
 */
template <class Comparable, class HashedObj>
void HashTable<Comparable, HashedObj>::insert( const pair<Comparable, HashedObj*> & x )
{
	// Insert x as active
	int currentPos = findPos( x.first );
	//cout << "pos for " << x.first << " is " << currentPos << endl;
	if( isActive( currentPos ) )
		return;
	//cout << "storing!\n";
	
	// work around bug in hashentry constructor...
	HashEntry he;
	he.element = x;
	he.info = ACTIVE;
	
	array[ currentPos ] = he;
	
	// Rehash; see Section 5.5
	if( ++currentSize > array.size( ) / 2 )
		rehash( );
}

/**
 * Expand the hash table.
 */
template <class Comparable, class HashedObj>
void HashTable<Comparable, HashedObj>::rehash( )
{
	vector<HashEntry> oldArray = array;
	
	// Create new double-sized, empty table
	array.resize( nextPrime( 2 * oldArray.size( ) ) );
	for( int j = 0; j < array.size( ); j++ )
		array[ j ].info = EMPTY;
	
	// Copy table over
	currentSize = 0;
	for( int i = 0; i < oldArray.size( ); i++ )
		if( oldArray[ i ].info == ACTIVE )
			insert( oldArray[ i ].element );
}

/**
 * Method that performs quadratic probing resolution.
 * Return the position where the search for x terminates.
 */
template <class Comparable, class HashedObj>
int HashTable<Comparable, HashedObj>::findPos( const Comparable & x ) const
{
	/* 1*/      int collisionNum = 0;
	/* 2*/      int currentPos = hash( x, array.size( ) );
	
	/* 3*/      while( array[ currentPos ].info != EMPTY &&
					  array[ currentPos ].element.first != x )
	{
		/* 4*/          currentPos += 2 * ++collisionNum - 1;  // Compute ith probe
		/* 5*/          if( currentPos >= array.size( ) )
		/* 6*/              currentPos -= array.size( );
	}
	
	/* 7*/      return currentPos;
}


/**
 * Remove item x from the hash table.
 */
template <class Comparable, class HashedObj>
void HashTable<Comparable, HashedObj>::remove( const Comparable & x )
{
	int currentPos = findPos( x );
	if( isActive( currentPos ) )
		array[ currentPos ].info = DELETED;
}

/**
 * Find item x in the hash table.
 * Return the matching item or ITEM_NOT_FOUND if not found
 */
template <class Comparable, class HashedObj>
const pair<Comparable, HashedObj*> & HashTable<Comparable, HashedObj>::find( const Comparable & x ) const
{
	int currentPos = findPos( x );
	if( isActive( currentPos ) )
		return array[ currentPos ].element;
	else
		return ITEM_NOT_FOUND;
}

/**
 * Make the hash table logically empty.
 */
template <class Comparable, class HashedObj>
void HashTable<Comparable, HashedObj>::makeEmpty( )
{
	currentSize = 0;
	for( int i = 0; i < array.size( ); i++ )
		array[ i ].info = EMPTY;
}

/**
 * Deep copy.
 */
template <class Comparable, class HashedObj>
const HashTable<Comparable, HashedObj> & HashTable<Comparable, HashedObj>::
operator=( const HashTable<Comparable, HashedObj> & rhs )
{
	if( this != &rhs )
	{
		array = rhs.array;
		currentSize = rhs.currentSize;
	}
	return *this;
}


/**
 * Return true if currentPos exists and is active.
 */
template <class Comparable, class HashedObj>
bool HashTable<Comparable, HashedObj>::isActive( int currentPos ) const
{
	return array[ currentPos ].info == ACTIVE;
}

/**
 * A hash routine for string objects.
 */
int hash( const string & key, int tableSize )
{
	int hashVal = 0;
	
	for( int i = 0; i < key.length( ); i++ )
		hashVal = 37 * hashVal + key[ i ];
	
	hashVal %= tableSize;
	if( hashVal < 0 )
		hashVal += tableSize;
	
	return hashVal;
}

// Dump the contents of the hash table
template <class Comparable, class HashedObj>
void HashTable<Comparable, HashedObj>::dump( )
{
	cout << "DUMPING HASHTABLE:" << endl;
	for (int i=0; i < array.size(); i++)
	{
		pair<Comparable, HashedObj*> p = array[i].element;
		if (p.second)
			cout << p.first << ", " << p.second << endl;
	}
}

/**
 * A hash routine for ints.
 */
int hash( int key, int tableSize )
{
	if( key < 0 ) key = -key;
	return key % tableSize;
}

#endif
