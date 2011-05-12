/*
 *  graph.cpp
 *  
 *
 *  Created by Daniel Packer
 *
 *  Graph object implementation including adjacency list, disjkstra, and flow
 *
 */

/*
 
 
 Our graph needs to store edges and vertexes.
 
 The adjacency list can be implemented as a stand-alone list
 or broken up into by-vertex lists each embedded in a vertex.
 
 Here we are storing the adjacencies in the vertex as a list of
 edges.
 
 Edges are STL pairs of ints (node number) and floats (positive weight).
 
 */

#include <vector>
#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
//#include <stdlib.h>

using namespace std;

struct vertex {
	
	vector< pair< int, float > > edges;
	
	vertex ( vector< pair< int, float > > e) : edges(e) { }
	
};
 


class graph {
	
public:
	
	graph ( )
	{
	}
	
	~graph ( )
	{
	}
	
	// Display graph adjacency list
	void dump ( )
	{
		vector< vertex >::iterator iv;
		int vertexCount=0;
		
		for ( iv=vertexes.begin() ; iv < vertexes.end(); iv++ )
		{
			cout << "VERTEX #: " << vertexCount << " :";
			
			vector< pair< int, float > > e = (*iv).edges;
			vector< pair< int, float > >::iterator ip;

			for ( ip=e.begin() ; ip < e.end(); ip++ )
				cout << "( " << (*ip).first << ", " << (*ip).second << " ) ";			
			
			cout << endl;
			
			vertexCount++;
		}
	}
	
	
	
	void readAdjacencyList (string fileName = string("input.txt"))
	{
		ifstream ifs(fileName.c_str());
		string temp, word;
		
		int wordCount=0;		// use to delete every other word
		int vertCount=0;		// count the vertices as we read them
		int vertExpected=0;		// the number of vertices to expect
		int vertNum=-1;			// number of vertex
		int edgeTarget=-1;		// target of edge
		float edgeWeight=-1;	// weight of edge
		bool startVert=false;	// start reading vertices?
		
		vector< pair< int, float > > adj;
		
		if (ifs) // make sure that file is open, or print error
		{
			// read line by line
			while (getline(ifs, temp))
			{
				stringstream ss(temp);
				while (ss >> word)
				{
					wordCount++;
					//cout << "word: " << word << " WORDCOUNT: " << wordCount << endl;
					
					// base case for vertex count included in text file (first line probably)
					if (vertCount==0)
						if(atoi(word.c_str()))	
						{
							vertExpected = atoi(word.c_str());
							continue;
						}
					
					startVert = true;	// start reading vertexes
					
					if (word == "-1")	// base case for end of line
						continue;
			
					if (vertNum==-1)	// new vertex
					{
						vertCount++;			// up the vertex count
						vertNum = atoi(word.c_str());
					}
					else if (edgeTarget==-1)
					{
						edgeTarget= atoi(word.c_str());	
					}
					else if (edgeWeight==-1)
					{
						// now we have a target and a weight pair
						edgeWeight= atof(word.c_str());
						adj.push_back(make_pair(edgeTarget, edgeWeight));
						edgeTarget = edgeWeight = -1; // reset to read next pair
					}
						
				}			
				
				// If we're reading vertices, create vertex with adj list and save it
				if (startVert)
				{
					vertex v(adj);			// create a new vertex with an internal adj. list
					vertexes.push_back(v);	// add vertex to graph
					adj.clear();			// reset adj list
				}
				wordCount=0;				// reset wordcount for line
								
			}
		}
		else
			cout << "=== ERROR: COULDN'T OPEN FILE '" << fileName << "' ===" << endl;
	}
	
	
	
	
private:
	
	vector< vertex > vertexes;	// store adjacency list
};


int main ( )
{
	graph g;
	g.readAdjacencyList("dgraph_test.txt");
	g.dump();
	return 0;
}