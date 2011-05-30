#include <iostream>
#include <fstream>
#include <sstream>
#include <utility>
#include "BinaryHeap.h"
#include "LeftistHeap.h"
#include "BinomialQueue.h"
#include "QuadraticProbing.h"

using namespace std;



/*
 
	Daniel Packer

    Original versions of BinaryHeap, LeftistHeap, BinomialQueue, 
	QuadraticProbing base implementations borrowed from Mark Weiss's textbook 
	source.

*/

int comparisons = 0;        // keep track of comparisons

        ////////////////////////////////////////////////////////////////////////
        /// START OF BINARY HEAP IMPLEMENTATION

        /**
         * Construct the binary heap.
         * capacity is the capacity of the binary heap.
         */
        template <class Comparable>
        BinaryHeap<Comparable>::BinaryHeap( int capacity )
          : array( capacity + 1 ), currentSize( 0 )
        {
        }

        /**
         * Insert item x into the priority queue, maintaining heap order.
         * Duplicates are allowed.
         * Throw Overflow if container is full.
         */
        template <class Comparable>
        void BinaryHeap<Comparable>::insert( const Comparable & x )
        {
            if( isFull( ) )
                throw Overflow( );

                // Percolate up
            int hole = ++currentSize;
            for( ; hole > 1 && x < array[ hole / 2 ]; hole /= 2 )
			{
				comparisons++; // for the for loop iteration
                array[ hole ] = array[ hole / 2 ];
			}
            array[ hole ] = x;
        }

        /**
         * Find the smallest item in the priority queue.
         * Return the smallest item, or throw Underflow if empty.
         */
        template <class Comparable>
        const Comparable & BinaryHeap<Comparable>::findMin( ) const
        {
            if( isEmpty( ) )
                throw Underflow( );
            return array[ 1 ];
        }

        /**
         * Remove the smallest item from the priority queue.
         * Throw Underflow if empty.
         */
        template <class Comparable>
        void BinaryHeap<Comparable>::deleteMin( )
        {
            if( isEmpty( ) )
                throw Underflow( );

            array[ 1 ] = array[ currentSize-- ];
            percolateDown( 1 );
        }

        /**
         * Remove the smallest item from the priority queue
         * and place it in minItem. Throw Underflow if empty.
         */
        template <class Comparable>
        void BinaryHeap<Comparable>::deleteMin( Comparable & minItem )
        {
            if( isEmpty( ) )
                throw Underflow( );

            minItem = array[ 1 ];
            array[ 1 ] = array[ currentSize-- ];
            percolateDown( 1 );
        }

        /**
         * Establish heap order property from an arbitrary
         * arrangement of items. Runs in linear time.
         */
        template <class Comparable>
        void BinaryHeap<Comparable>::buildHeap( )
        {
            for( int i = currentSize / 2; i > 0; i-- )
                percolateDown( i );
        }

        /**
         * Test if the priority queue is logically empty.
         * Return true if empty, false otherwise.
         */
        template <class Comparable>
        bool BinaryHeap<Comparable>::isEmpty( ) const
        {
            return currentSize == 0;
        }

        /**
         * Test if the priority queue is logically full.
         * Return true if full, false otherwise.
         */
        template <class Comparable>
        bool BinaryHeap<Comparable>::isFull( ) const
        {
            return currentSize == array.size( ) - 1;
        }

        /**
         * Make the priority queue logically empty.
         */
        template <class Comparable>
        void BinaryHeap<Comparable>::makeEmpty( )
        {
            currentSize = 0;
        }

        template <class Comparable>
        void BinaryHeap<Comparable>::dump( )
        {
            for (int i=0; i < array.size(); i++)
            {
                std::cout << "array[" << i << "]: " << array[i] << endl;
            }
        }

        /**
         * Internal method to percolate down in the heap.
         * hole is the index at which the percolate begins.
         */
        template <class Comparable>
        void BinaryHeap<Comparable>::percolateDown( int hole )
        {
/* 1*/      int child;
/* 2*/      Comparable tmp = array[ hole ];

/* 3*/      for( ; hole * 2 <= currentSize; hole = child )
            {
/* 4*/          child = hole * 2;
/* 5*/          if( child != currentSize && array[ child + 1 ] < array[ child ] )
                {   
/* 6*/              child++;
					comparisons++;  // for < above
                }
				comparisons+=2;		// for != above and < below
				
/* 7*/          if( array[ child ] < tmp )
                {
/* 8*/              array[ hole ] = array[ child ];
                }
                else
/* 9*/              break;
            }
/*10*/      array[ hole ] = tmp;
        }

            
        // read each line of data file, word by word, and insert words
        //  takes a file_op (INSERT, INSERT_NONAVL, SEARCH, DELETE_EVERY_OTHER) to determine action to take
        //  one function for all ops reduces file IO code redundancy
        template <class Comparable>
        void insertFromFile (BinaryHeap<Comparable> & bh, string fileName = string("input.txt"))
        {
            ifstream ifs(fileName.c_str());
            string temp, word;

            if (ifs)                        // make sure file is open
                while (getline(ifs, temp))
                {
                    stringstream ss(temp);
                    while (ss >> word)
                        bh.insert(word);       // insert every word in file
                }
            else
                cout << "=== ERROR: COULDN'T OPEN FILE '" << fileName << "' ===" << endl;
        }


        /// END OF BINARY HEAP IMPLEMENTATION
        ////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////
        /// START OF LEFTIST HEAP IMPLEMENTATION

        /**
         * Construct the leftist heap.
         */
        template <class Comparable>
        LeftistHeap<Comparable>::LeftistHeap( )
        {
            root = NULL;
        }

        /**
         * Copy constructor.
         */
        template <class Comparable>
        LeftistHeap<Comparable>::LeftistHeap( const LeftistHeap<Comparable> & rhs )
        {
            root = NULL;
            *this = rhs;
        }


        /**
         * Destruct the leftist heap.
         */
        template <class Comparable>
        LeftistHeap<Comparable>::~LeftistHeap( )
        {
            makeEmpty( );
        }

        /**
         * Merge rhs into the priority queue.
         * rhs becomes empty. rhs must be different from this.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::merge( LeftistHeap & rhs )
        {
            if( this == &rhs )    // Avoid aliasing problems
                return;
    
            root = merge( root, rhs.root );
            rhs.root = NULL;
        }

        /**
         * Internal method to merge two roots.
         * Deals with deviant cases and calls recursive merge1.
         */
        template <class Comparable>
        LeftistNode<Comparable> *
        LeftistHeap<Comparable>::merge( LeftistNode<Comparable> * h1,
                                        LeftistNode<Comparable> * h2 ) const
        {
			comparisons++;		// for if below
            if( h1 == NULL )
                return h2;

			comparisons++;		// for if below
            if( h2 == NULL )
                return h1;
			
			comparisons++;		// for if below
            if( h1->element < h2->element )
            {
                return merge1( h1, h2 );
            }
            else
                return merge1( h2, h1 );
        }

        /**
         * Internal method to merge two roots.
         * Assumes trees are not empty, and h1's root contains smallest item.
         */
        template <class Comparable>
        LeftistNode<Comparable> *
        LeftistHeap<Comparable>::merge1( LeftistNode<Comparable> * h1,
                                         LeftistNode<Comparable> * h2 ) const
        {
			comparisons++;			 // for if below
            if( h1->left == NULL )   // Single node
                h1->left = h2;       // Other fields in h1 already accurate
            else
            {
                h1->right = merge( h1->right, h2 );
				comparisons++;		// for if below
                if( h1->left->npl < h1->right->npl )
                    swapChildren( h1 );
                h1->npl = h1->right->npl + 1;
            }
            return h1;
        }

        /**
         * Swaps t's two children.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::swapChildren( LeftistNode<Comparable> * t ) const
        {
            LeftistNode<Comparable> *tmp = t->left;
            t->left = t->right;
            t->right = tmp;
        }

        /**
         * Insert item x into the priority queue, maintaining heap order.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::insert( const Comparable & x )
        {
            root = merge( new LeftistNode<Comparable>( x ), root );
        }

        /**
         * Find the smallest item in the priority queue.
         * Return the smallest item, or throw Underflow if empty.
         */
        template <class Comparable>
        const Comparable & LeftistHeap<Comparable>::findMin( ) const
        {
            if( isEmpty( ) )
                throw Underflow( );
            return root->element;
        }

        /**
         * Remove the smallest item from the priority queue.
         * Throws Underflow if empty.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::deleteMin( )
        {
            if( isEmpty( ) )
                throw Underflow( );

            LeftistNode<Comparable> *oldRoot = root;
            root = merge( root->left, root->right );
            delete oldRoot;
        }

        /**
         * Remove the smallest item from the priority queue.
         * Pass back the smallest item, or throw Underflow if empty.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::deleteMin( Comparable & minItem )
        {
            minItem = findMin( );
            deleteMin( );
        }

        /**
         * Test if the priority queue is logically empty.
         * Returns true if empty, false otherwise.
         */
        template <class Comparable>
        bool LeftistHeap<Comparable>::isEmpty( ) const
        {
            return root == NULL;
        }

        /**
         * Test if the priority queue is logically full.
         * Returns false in this implementation.
         */
        template <class Comparable>
        bool LeftistHeap<Comparable>::isFull( ) const
        {
            return false;
        }

        /**
         * Make the priority queue logically empty.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::makeEmpty( )
        {
            reclaimMemory( root );
            root = NULL;
        }

        /**
         * Deep copy.
         */
        template <class Comparable>
        const LeftistHeap<Comparable> &
        LeftistHeap<Comparable>::
        operator=( const LeftistHeap<Comparable> & rhs )
        {
            if( this != &rhs )
            {
                makeEmpty( );
                root = clone( rhs.root );
            }
            return *this;
        }

        /**
         * Internal method to make the tree empty.
         * WARNING: This is prone to running out of stack space;
         *          exercises suggest a solution.
         */
        template <class Comparable>
        void LeftistHeap<Comparable>::reclaimMemory( LeftistNode<Comparable> * t ) const
        {
            if( t != NULL )
            {
                reclaimMemory( t->left );
                reclaimMemory( t->right );
                delete t;
            }
        }

        /**
         * Internal method to clone subtree.
         * WARNING: This is prone to running out of stack space.
         *          exercises suggest a solution.
         */
        template <class Comparable>
        LeftistNode<Comparable> *
        LeftistHeap<Comparable>::clone( LeftistNode<Comparable> * t ) const
        {
            if( t == NULL )
                return NULL;
            else
                return new LeftistNode<Comparable>( t->element, clone( t->left ),
                                              clone( t->right ), t->npl );
        }
            
        // read each line of data file, word by word, and insert words
        //  takes a file_op (INSERT, INSERT_NONAVL, SEARCH, DELETE_EVERY_OTHER) to determine action to take
        //  one function for all ops reduces file IO code redundancy
        template <class Comparable>
        void insertFromFile (LeftistHeap<Comparable> & lh, string fileName = string("input.txt"))
        {
            ifstream ifs(fileName.c_str());
            string temp, word;

            if (ifs)                        // make sure file is open
                while (getline(ifs, temp))
                {
                    stringstream ss(temp);
                    while (ss >> word)
                        lh.insert(word);       // insert every word in file
                }
            else
                cout << "=== ERROR: COULDN'T OPEN FILE '" << fileName << "' ===" << endl;
        }


        /// END OF LEFTIST HEAP IMPLEMENTATION
        ////////////////////////////////////////////////////////////////////////

        ////////////////////////////////////////////////////////////////////////
        /// START OF BINOMIAL QUEUE IMPLEMENTATION


        static const int MAX_TREES = 3000;

        /**
         * Construct the binomial queue.
         */
        template <class Comparable>
        BinomialQueue<Comparable>::BinomialQueue( ) : theTrees( MAX_TREES )
        {
            for( int i = 0; i < theTrees.size( ); i++ )
                theTrees[ i ] = NULL;
            currentSize = 0;
        }

        /**
         * Copy constructor is left as an exercise.
         */
        template <class Comparable>
        BinomialQueue<Comparable>::
        BinomialQueue( const BinomialQueue<Comparable> & rhs )
        {
            cout << "Copy constructor is unimplemented" << endl;
        }

        /**
         * Destroy the binomial queue.
         */
        template <class Comparable>
        BinomialQueue<Comparable>::~BinomialQueue( )
        {
            makeEmpty( );
        }

        /**
         * Merge rhs into the priority queue.
         * rhs becomes empty. rhs must be different from this.
         * Throw Overflow if result exceeds capacity.
         */
        template <class Comparable>
        void BinomialQueue<Comparable>::merge( BinomialQueue<Comparable> & rhs )
        {
            if( this == &rhs )    // Avoid aliasing problems
                return;

            if( currentSize + rhs.currentSize > capacity( ) )
                throw Overflow( );

            currentSize += rhs.currentSize;

            BinomialNode<Comparable> *carry = NULL;
            for( int i = 0, j = 1; j <= currentSize; i++, j *= 2 )
            {
                BinomialNode<Comparable> *t1 = theTrees[ i ];
                BinomialNode<Comparable> *t2 = rhs.theTrees[ i ];

                int whichCase = t1 == NULL ? 0 : 1;
				comparisons++;							// for ternary above
                whichCase += t2 == NULL ? 0 : 2;
				comparisons++;							// for ternary above
                whichCase += carry == NULL ? 0 : 4;
				comparisons++;							// for ternary above

                switch( whichCase )
                {
                  case 0: /* No trees */
                  case 1: /* Only this */
                    break;
                  case 2: /* Only rhs */
                    theTrees[ i ] = t2;
                    rhs.theTrees[ i ] = NULL;
                    break;
                  case 4: /* Only carry */
                    theTrees[ i ] = carry;
                    carry = NULL;
                    break;
                  case 3: /* this and rhs */
                    carry = combineTrees( t1, t2 );
                    theTrees[ i ] = rhs.theTrees[ i ] = NULL;
                    break;
                  case 5: /* this and carry */
                    carry = combineTrees( t1, carry );
                    theTrees[ i ] = NULL;
                    break;
                  case 6: /* rhs and carry */
                    carry = combineTrees( t2, carry );
                    rhs.theTrees[ i ] = NULL;
                    break;
                  case 7: /* All three */
                    theTrees[ i ] = carry;
                    carry = combineTrees( t1, t2 );
                    rhs.theTrees[ i ] = NULL;
                    break;
                }
            }

            for( int k = 0; k < rhs.theTrees.size( ); k++ )
                rhs.theTrees[ k ] = NULL;
            rhs.currentSize = 0;
        }        

        /**
         * Return the result of merging equal-sized t1 and t2.
         */
        template <class Comparable>
        BinomialNode<Comparable> *
        BinomialQueue<Comparable>::combineTrees( BinomialNode<Comparable> *t1,
                                                 BinomialNode<Comparable> *t2 ) const
        {
			comparisons++;						// for if below
            if( t2->element < t1->element )
                return combineTrees( t2, t1 );
            t2->nextSibling = t1->leftChild;
            t1->leftChild = t2;
            return t1;
        }

        /**
         * Insert item x into the priority queue, maintaining heap order.
         * This implementation is not optimized for O(1) performance.
         * Throw Overflow if capacity exceeded.
         */
        template <class Comparable>
        void BinomialQueue<Comparable>::insert( const Comparable & x, int priority )
        {
            BinomialQueue oneItem;
            oneItem.currentSize = 1;
            oneItem.theTrees[ 0 ] = new BinomialNode<Comparable>( x, NULL, NULL );

			// store the location of the node in the hash table
			ht.insert(make_pair(priority, oneItem.theTrees[ 0 ]));
			
            merge( oneItem );
        }

        /**
         * Return the smallest item in the priority queue.
         * Throw Underflow if empty.
         */
        template <class Comparable>
        const Comparable & BinomialQueue<Comparable>::findMin( ) const
        {
            if( isEmpty( ) )
                throw Underflow( );

            return theTrees[ findMinIndex( ) ]->element;
        }

    
        /**
         * Find index of tree containing the smallest item in the priority queue.
         * The priority queue must not be empty.
         * Return the index of tree containing the smallest item.
         */
        template <class Comparable>
        int BinomialQueue<Comparable>::findMinIndex( ) const
        {
            int i;
            int minIndex;

            for( i = 0; theTrees[ i ] == NULL; i++ )
                ;

            for( minIndex = i; i < theTrees.size( ); i++ )
                if( theTrees[ i ] != NULL &&
                    theTrees[ i ]->element < theTrees[ minIndex ]->element )
                    minIndex = i;

            return minIndex;
        }

        /**
         * Remove the smallest item from the priority queue.
         * Throw Underflow if empty.
         */
        template <class Comparable>
        void BinomialQueue<Comparable>::deleteMin( )
        {
            Comparable x;
            deleteMin( x );
        }


        /**
         * Remove the smallest item from the priority queue, and
         * copy it into minItem.  Throw Underflow if empty.
         */
        template <class Comparable>
        void BinomialQueue<Comparable>::deleteMin( Comparable & minItem )
        {
            if( isEmpty( ) )
                throw Underflow( );

            int minIndex = findMinIndex( );
            minItem = theTrees[ minIndex ]->element;

            BinomialNode<Comparable> *oldRoot = theTrees[ minIndex ];
            BinomialNode<Comparable> *deletedTree = oldRoot->leftChild;
            delete oldRoot;

            BinomialQueue deletedQueue;
            deletedQueue.currentSize = ( 1 << minIndex ) - 1;
            for( int j = minIndex - 1; j >= 0; j-- )
            {
                deletedQueue.theTrees[ j ] = deletedTree;
                deletedTree = deletedTree->nextSibling;
                deletedQueue.theTrees[ j ]->nextSibling = NULL;
            }

            theTrees[ minIndex ] = NULL;
            currentSize -= deletedQueue.currentSize + 1;

            merge( deletedQueue );
        }

        /**
         * Test if the priority queue is logically empty.
         * Return true if empty, false otherwise.
         */
        template <class Comparable>
        bool BinomialQueue<Comparable>::isEmpty( ) const
        {
            return currentSize == 0;
        }

        /**
         * Test if the priority queue is logically full.
         * Return true if full, false otherwise.
         */
        template <class Comparable>
        bool BinomialQueue<Comparable>::isFull( ) const
        {
            return currentSize == capacity( );
        }

        /**
         * Make the priority queue logically empty.
         */
        template <class Comparable>
        void BinomialQueue<Comparable>::makeEmpty( )
        {
            currentSize = 0;
            for( int i = 0; i < theTrees.size( ); i++ )
                makeEmpty( theTrees[ i ] );
        }

        /**
         * Deep copy.
         */
        template <class Comparable>
        const BinomialQueue<Comparable> &
        BinomialQueue<Comparable>::
        operator=( const BinomialQueue<Comparable> & rhs )
        {
            if( this != &rhs )
            {
                makeEmpty( );
                theTrees.resize( rhs.theTrees.size( ) );  // Just in case
                for( int i = 0; i < rhs.theTrees.size( ); i++ )
                    theTrees[ i ] = clone( rhs.theTrees[ i ] );
                currentSize = rhs.currentSize;
            }
            return *this;
        }

        /**
         * Return the capacity.
         */
        template <class Comparable>
        int BinomialQueue<Comparable>::capacity( ) const
        {
            return ( 1 << theTrees.size( ) ) - 1;
        }

        /**
         * Make a binomial tree logically empty, and free memory.
         */
        template <class Comparable>
        void BinomialQueue<Comparable>::
        makeEmpty( BinomialNode<Comparable> * & t ) const
        {
            if( t != NULL )
            {
                makeEmpty( t->leftChild );
                makeEmpty( t->nextSibling );
                delete t;
                t = NULL;
            }
        }


        /**
         * Internal method to clone subtree.
         */
        template <class Comparable>
        BinomialNode<Comparable> *
        BinomialQueue<Comparable>::clone( BinomialNode<Comparable> * t ) const
        {
            if( t == NULL )
                return NULL;
            else
                return new BinomialNode<Comparable>( t->element,
                           clone( t->leftChild ), clone( t->nextSibling ) );
        }

		template <class Comparable>
		void BinomialQueue<Comparable>::dump_ht ( )
		{
			ht.dump();
		}


        // read each line of data file, word by word, and insert words
        //  takes a file_op (INSERT, INSERT_NONAVL, SEARCH, DELETE_EVERY_OTHER) to determine action to take
        //  one function for all ops reduces file IO code redundancy
        template <class Comparable>
        void insertFromFile (BinomialQueue<Comparable> & bq, string fileName = string("input.txt"))
        {
            ifstream ifs(fileName.c_str());
            string temp, word;
			int priority = 0;

            if (ifs)                        // make sure file is open
                while (getline(ifs, temp))
                {
                    stringstream ss(temp);
                    while (ss >> word)
                        bq.insert(word, priority++);       // insert every word in file
                }
            else
                cout << "=== ERROR: COULDN'T OPEN FILE '" << fileName << "' ===" << endl;
        }



        /// END OF BINOMIAL QUEUE IMPLEMENTATION 
        ////////////////////////////////////////////////////////////////////////

        int main ()
        {

			/*
            // (1a) Binary Heap priority queue
            BinaryHeap<string> pq_bh(100000);
            string top;
            insertFromFile(pq_bh, string("wordsHW2.txt")); // insert N elements from file
            while (! pq_bh.isEmpty())
            {
                top = pq_bh.findMin();
                //cout << "the next value: " << top << endl;
                pq_bh.deleteMin();                         // perform N deleteMin()'s
            }
            // show total # of comparisons via deleteMin()
            cout << comparisons << " comparisons performed via deleteMin() with binary heap priority queue" << endl;

            comparisons = 0;    // reset counter


            // (1b) Leftist Heap priority queue
            LeftistHeap<string> pq_lh;
            insertFromFile(pq_lh, string("wordsHW2.txt")); // insert N elements from file
            while (! pq_lh.isEmpty())
            {
                top = pq_lh.findMin();
                //cout << "the next value: " << top << endl;
                pq_lh.deleteMin();                         // perform N deleteMin()'s
            }
            // show total # of comparisons via deleteMin()
            cout << comparisons << " comparisons performed via deleteMin() with leftist heap priority queue" << endl;

            comparisons = 0;    // reset counter

			*/
            // (1c) Binomial Queue priority queue
			string top;
            BinomialQueue<string> pq_bq;
            insertFromFile(pq_bq, string("testwords.txt")); // insert N elements from file
            while (! pq_bq.isEmpty())
            {
                top = pq_bq.findMin();
                cout << "the next value: " << top << endl;
                pq_bq.deleteMin();                         // perform N deleteMin()'s
            }
			pq_bq.dump_ht();
//            // show total # of comparisons via deleteMin()
//            cout << comparisons << " comparisons performed via deleteMin() with binomial queue priority queue" << endl;



            //pq_bh.dump();


            //LeftistHeap<string> pq_lh;
            //BinomialQueue<string> ph_bq;
			
			//string fruit("bananas");
			//pair <string, string*> hitem = make_pair("fruit", &fruit);
			//pair <string, string*> notfound = make_pair(string("not found"), msg);
		
			//string item("an item");
//			string item2("another item");
//			string item3("yet another");
//			
//			BinomialNode<string> bn(item, NULL, NULL, NULL);
//			BinomialNode<string> bn2(item2, NULL, NULL, &bn);
//			bn.leftChild = &bn2;
//			
//			HashTable<string, BinomialNode<string> > ht;
//			ht.insert(make_pair(bn.element, &bn));
//			
//			cout << "bn's element is " << bn.element << endl;			
//			cout << "bn's found element is " << ht.find(bn.element).first << endl;
//			
//			HashTable<string, string> ht2;
//			ht2.insert(make_pair(item, &item));
//			
//			cout << "location of item is : " << &item << endl;
//			cout << "value of item is " << ht2.find(item).first << endl;
//			cout << "position of found item is " << ht2.find(item).second << endl;
			
/*
            pair <string, int> notfound = make_pair("not found", -1);
            HashTable<string> ht(notfound, 100000);
            string searchFor("five");
            ht.insert( make_pair(searchFor, &searchFor) );
            pair<string, int> found = ht.find(searchFor);
            if (found.second != -1)
                cout << "Found '" << found.first << "' and it's position is " << found.second << endl;
            else
                cout << "'" << searchFor << "' not found in hashtable." << endl;

            searchFor = string("asdfasdf");
            found = ht.find(searchFor);
            if (found.second != -1)
                cout << "Found '" << found.first << "' and it's position is " << found.second << endl;
            else
                cout << "'" << searchFor << "' not found in hashtable." << endl;

*/
			
            return 0;
        }
