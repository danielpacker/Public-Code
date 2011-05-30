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

        template <class Comparable>
        class BinomialQueue;

        template <class Comparable>
        class BinomialNode
        {
			
		public:
            Comparable    element;
            BinomialNode *leftChild;
            BinomialNode *nextSibling;
			BinomialNode *parent;

            BinomialNode( const Comparable & theElement, 
                          BinomialNode *lt, BinomialNode *rt, BinomialNode *pt = NULL )
              : element( theElement ), leftChild( lt ), nextSibling( rt ), parent( pt ) { }
            friend class BinomialQueue<Comparable>;
        };

        template <class Comparable>
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
			
			BinomialNode<Comparable> * clone( BinomialNode<Comparable> * t ) const;
			BinomialNode<Comparable> * combineTrees( BinomialNode<Comparable> *t1,
													BinomialNode<Comparable> *t2 ) const;

          private:
			HashTable<int, BinomialNode<Comparable> > ht;
            int currentSize;                // Number of items in the priority queue
            vector<BinomialNode<Comparable> *> theTrees;   // An array of tree roots

            int findMinIndex( ) const;
            int capacity( ) const;
                        void makeEmpty( BinomialNode<Comparable> * & t ) const;
        };




        #endif
