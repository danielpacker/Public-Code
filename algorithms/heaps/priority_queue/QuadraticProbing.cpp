        #include <iostream>
        #include <utility>


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
            if( isActive( currentPos ) )
                return;
            array[ currentPos ] = HashEntry( x, ACTIVE );

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


        /**
         * A hash routine for ints.
         */
        int hash( int key, int tableSize )
        {
            if( key < 0 ) key = -key;
            return key % tableSize;
        }
