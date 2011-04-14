/*

Daniel Packer, CSCI335
Assignment 4, Union Find, Part A

The disjoint set code is borrowed from the textbook,
and uses union-by-height (rank) and path compression.

The code below creates a disjoint set object of size
100,00, simulating a 100,000 node network.

Random connections are made until all connections are
in the same group as the infected node.

The everyNodeInfected() function detects at any given
time, if all nodes are in the infected group. It's a 
slow, linear function, so total time to check is 
quadratic, so have patience.

*/


#include <iostream>
#include <vector>
#include <math.h>

#include "DisjSets.cpp"     // disjoint set implementation

using namespace std;

#define NETWORK_SIZE 100000 // network size
#define INFECTED_NODE 0     // which node is infected first

/*
  Check if every node in dj set is infected. True or false.
*/
bool everyNodeInfected( const DisjSets & dj )
{
    int infected_network_root = dj.find(INFECTED_NODE);
    for (int i=0; i < NETWORK_SIZE; i++) 
        if (dj.find(i) != infected_network_root)
            return false;
    return true;
}


int main ( int argc, char * argv[] )
{
    srand ( time(NULL) );
    DisjSets dj(NETWORK_SIZE);

    int ticks = 0;      // track total connections made (10 per sec)
    for (;;)            // start simulation
    {
        // randomly select two different nodes in network
        int random_node_1 = rand() % NETWORK_SIZE;
        int random_node_2 = rand() % NETWORK_SIZE;
        while (random_node_1 == random_node_2)
            random_node_2 = rand() % NETWORK_SIZE;  //de-dupe

        int set_1 = dj.find(random_node_1);
        int set_2 = dj.find(random_node_2);

        if (set_1 != set_2)                         // if not connected,
            dj.unionSets(set_1, set_2);             // make connection

        ticks++;

        if (everyNodeInfected(dj))                  // stop, all infected.
            break;
    }

    //cout << "infected node value: " << dj.find(INFECTED_NODE) << endl;
    //dj.dump();

    int seconds = ticks/10;
    int hours = (seconds/60)/60;
    int minutes = (seconds/60) % (hours*60);

    cout << "-------------------------------------------------------------------" << endl
         << "Total time for complete infection of " << NETWORK_SIZE << " nodes: "
         << seconds << " seconds"
         << " (" << hours << " hours, " << minutes << " minutes)" << endl;
    cout << "Total random connections made: "
         << ticks << endl
         << "-------------------------------------------------------------------" << endl;

    return 0;
}
