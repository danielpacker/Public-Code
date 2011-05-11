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
	
	void dump ( )
	{
		// Display graph adjacency list
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
					cout << "word: " << word << " WORDCOUNT: " << wordCount << endl;
					
					// base case for vertex count included in text file (first line probably)
					if (vertCount==0)
						if(atoi(word.c_str()))	
							vertExpected = atoi(word.c_str());
						else
							
							if (vertNum==-1)	// new vertnum
								vertNum = atoi(word.c_str());
							else if (edgeTarget==-1)
								edgeTarget= atoi(word.c_str());	
							else if (edgeWeight==-1)
							{
								// now we have a target and a weight pair
								edgeWeight= atoi(word.c_str());
								adj.push_back(make_pair(edgeTarget, edgeWeight));
								edgeTarget = edgeWeight = -1; // reset to read next pair
							}
						
				}			
				
				vertex v(adj);			// create a new vertex with an internal adj. list
				vertexes.push_back(v);	// add vertex to graph
				
				adj.clear();			// reset adj list
				wordCount=0;			// reset wordcout for line
				vertCount++;			// up the vertex count
				
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
	g.readAdjacencyList("dgraph_333.txt");
	return 0;
}