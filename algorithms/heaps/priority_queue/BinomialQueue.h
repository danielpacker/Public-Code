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
	BinomialNode<ComparableKey, Comparable> *leftChild;
	BinomialNode<ComparableKey, Comparable> *nextSibling;
	BinomialNode<ComparableKey, Comparable> *parent;
	
	// swap everything between two parent and child
	void swapChildParent()
	{
		
//		cout << "swapChildParent()!" << endl;
		if (parent != NULL)
		{
			
//			cout << "swapChildParent() swapping " << this->value << " with " << parent->value << endl;
			
			BinomialNode<ComparableKey, Comparable> *tempNS = parent->nextSibling;
			BinomialNode<ComparableKey, Comparable> *tempPP = parent->parent;
			BinomialNode<ComparableKey, Comparable> *tempP  = parent;
			
//			cout << parent << "swapChildParent() is the parent address " << " and " << tempPP << " is the temp parent" << endl;
			
			// Parent adopts childrens children
			if (leftChild !=NULL)
				parent->leftChild = leftChild;
			
			// Parent adopts childrens siblings
			if (nextSibling != NULL)
				parent->nextSibling = nextSibling;

			// Child adopts parents siblings
			if (tempNS != NULL)
				nextSibling = tempNS;
			
			// Child adopts parents parent
			if (tempPP != NULL)
			{
				//cout << tempPP << " is tempPP" << endl;
				//cout << this->parent << " is parent" << endl;

				//				cout << tempP->value << " is the value swapChildParent()" << endl;
//				cout << parent->value << " is the value swapChildParent()" << endl;
				parent = tempPP;
			}
			
			tempP->parent = this;		// child is now the parent
			leftChild = tempP;			// parent is now child
		}
	}

	BinomialNode( const ComparableKey & theKey, const Comparable & theVal,
				  BinomialNode *lt = NULL, BinomialNode *rt = NULL, BinomialNode *pt = NULL )
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
	void decreaseKey ( BinomialNode<ComparableKey, Comparable> * bn, ComparableKey newKey );
	void decreaseKey ( ComparableKey key, ComparableKey newKey );
	
  private:
	int currentSize;                // Number of items in the priority queue
	vector<BinomialNode<ComparableKey, Comparable> *> theTrees;   // An array of tree roots

	int findMinIndex( ) const;
	int capacity( ) const;
				void makeEmpty( BinomialNode<ComparableKey, Comparable> * & t ) const;
};




#endif
