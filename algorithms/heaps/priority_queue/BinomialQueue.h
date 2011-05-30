#ifndef BINOMIAL_QUEUE_H_
#define BINOMIAL_QUEUE_H_

#include <iostream>
#include <vector>
#include "QuadraticProbing.h"

using namespace std;

// Binomial queue class
//
// CONSTRUCTION: with no parameters
//
// ******************PUBLIC OPERATIONS*********************
// void insert( x )       --> Insert x
// deleteMin( )           --> Return and remove smallest item
// Comparable findMin( )  --> Return smallest item
// bool isEmpty( )        --> Return true if empty; else false
// bool isFull( )         --> Return true if full; else false
// void makeEmpty( )      --> Remove all items
// void merge( rhs )      --> Absorb rhs into this heap
// ******************ERRORS********************************
// Throws Underflow and Overflow as warranted


  // Node and forward declaration because g++ does
  // not understand nested classes.

template <class ComparableKey, class Comparable>
class BinomialQueue;

template <class ComparableKey, class Comparable>
class BinomialNode
{
	
public:
	ComparableKey key;	// store the key
	Comparable	  value;	// store the value
	BinomialNode *leftChild;
	BinomialNode *nextSibling;
	BinomialNode *parent;
	
	// swap everything between two parent and child
	void swapChildParent(BinomialNode<ComparableKey, Comparable> * parent)
	{
		BinomialNode *tempNS = parent->nextSibling;
		BinomialNode *tempP = parent->parent;
		
		// if necessary children of the parent
		if (parent->leftChild)
			parent->leftChild->parent = this;

		parent->leftChild = leftChild;
		parent->nextSibling = nextSibling;
		parent->parent = this;				// this is now the parent
				
		leftChild = parent;					// parent is now child
		nextSibling = tempNS;
		parent = tempP;
	}

	BinomialNode( const ComparableKey & theKey, const Comparable & theVal,
				  BinomialNode *lt, BinomialNode *rt, BinomialNode *pt = NULL )
	  : key( theKey ), value ( theVal ), leftChild( lt ), nextSibling( rt ), parent( pt ) { }
	friend class BinomialQueue<ComparableKey, Comparable>;
};

template <class ComparableKey, class Comparable>
class BinomialQueue
{
  public:
	BinomialQueue( );
	BinomialQueue( const BinomialQueue & rhs );
	~BinomialQueue( );

	bool isEmpty( ) const;
	bool isFull( ) const;
	const Comparable & findMin( ) const;

	void insert( const Comparable & x, int priority );
	void deleteMin( );
	void deleteMin( Comparable & minItem );
	void makeEmpty( );
	void merge( BinomialQueue & rhs );
	void dump_ht();
	
	const BinomialQueue & operator=( const BinomialQueue & rhs );
	
	BinomialNode<ComparableKey, Comparable> * clone( BinomialNode<ComparableKey, Comparable> * t ) const;
	BinomialNode<ComparableKey, Comparable> * combineTrees( BinomialNode<ComparableKey, Comparable> *t1,
											BinomialNode<ComparableKey, Comparable> *t2 ) const;

	HashTable<ComparableKey, BinomialNode<ComparableKey, Comparable> > ht;
	void percolateUp ( BinomialNode<ComparableKey, Comparable> * bn );
	
  private:
	int currentSize;                // Number of items in the priority queue
	vector<BinomialNode<ComparableKey, Comparable> *> theTrees;   // An array of tree roots

	int findMinIndex( ) const;
	int capacity( ) const;
				void makeEmpty( BinomialNode<ComparableKey, Comparable> * & t ) const;
};




#endif
