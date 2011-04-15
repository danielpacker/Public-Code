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
 
Analysis:
 
 Over 7 runs on 100k network size, average number of
 connections was 602,842.4, or 60,284.2 seconds (if 
 secs = connections * 1/10 sec).
 
 Avg expected time is NETWORK_SIZE * 0.6 sec.
 
 Over 7 runs on 10k network size, average number of
 connections was 478,943.6 or 47,894.4 secs (if
 secs = connections * 1/10 sec).
 
 Avg expected time is NETWORKSIZE * 4.7 sec.
 
 Over 7 runs on 1k network size, average number of
 connections was 371,396.3, or 37,139.6 secs (if
 secs = connections * 1/10 sec).
 
 Avg expected time is NETWORKSIZE * 37.1 sec.
 
 In general, run time is 1/10sec * (log10 N) * 10^6.

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
bool everyNodeInfected( DisjSets & dj, int network_size = NETWORK_SIZE )
{
    int infected_network_root = dj.find(INFECTED_NODE);
    for (int i=0; i < network_size; i++) 
        if (dj.find(i) != infected_network_root)
            return false;
    return true;
}


int main ( int argc, char * argv[] )
{
    srand ( time(NULL) );
	
	int network_size = (argv[1] != NULL) ? atoi(argv[1]) : NETWORK_SIZE;
    DisjSets dj(network_size);

    dj.unionSets(dj.find(0), dj.find(2));

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

        if (everyNodeInfected(dj), network_size)                  // stop, all infected.
            break;
    }

    //cout << "infected node value: " << dj.find(INFECTED_NODE) << endl;
    //dj.dump();

    int seconds = ticks/10;
    //int hours = (seconds/60)/60;
    //int minutes = (seconds/60) % (hours*60);

    cout << "-------------------------------------------------------------------" << endl
         << "Total time for complete infection of " << NETWORK_SIZE << " nodes: "
         << seconds << " seconds" << endl;
         //<< " (" << hours << " hours, " << minutes << " minutes)" << endl;
    cout << "Total random connections made: "
         << ticks << endl
         << "-------------------------------------------------------------------" << endl;

    return 0;
}
