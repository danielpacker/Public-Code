/*

 graph.cpp - graph implementation by Daniel Packer
 
 Features:
 * adjacency list input from a file -- see readAdjacencyList()
 * vertex construction from those adj. lists -- see vertexes private member
 * display of vertices and edges -- see dump()
 
 Details:
 
 Our graph needs to store edges and vertexes.
 
 The adjacency list can be implemented as a stand-alone list
 or broken up into by-vertex lists each embedded in a vertex.
 
 Here we are storing the adjacencies in the vertex as a list of
 edges.
 
 Edges are STL pairs of ints (node number) and floats (positive weight).
 
 */

#include <vector>
#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <sstream>
#include <assert.h>
#include <queue>

using namespace std;

#define INFINITY 0xFFFF

/*
 Vertex contains a vector of target/weight edge data as pairs of ints/floats
   and is constructed with that data. A graph object has a vector of vertexes.
 
 Multiple properties to support shortest path algorithm (dijsktra).
 */
struct vertex {
	
	vector< pair< int, float > > edges;
	
	// properties to support shortest path
	bool known;			// dist known?
	int dist;			// distance from start
	int id;				// numeric node id
	vertex * path;		// path from this vertex
	
	vertex ( vector< pair< int, float > > e, int num ) : known(false), dist(INFINITY), edges(e), id(num) { }
	
	void dump ( )
	{
		cout << "VERTEX " << id << ": " << endl <<
		" known: " << (int)known << fixed << setprecision(2) <<
				", dist: " << dist <<
		//		" path:  " << path->id <<
		endl;
		
		for (int i=0; i < edges.size(); i++)
		{
			pair<int, float> e = edges[i];
			cout << " edge: (target " << e.first << ", weight " << e.second << ")" << endl;
		}
	}
};


/*
 Custom comparison class/function to use for priority queue
 */
class CompareVertexes {
public:
    bool operator()(vertex& v1, vertex& v2)
    {
		if (v1.dist < v2.dist) return true;
		return false;
    }
};


/*
 The graph object that contains all the important features.
 */
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
		
		for (int i=0; i < vertexes.size(); i++)
			vertexes[i].dump();
		/*
		
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
		 */
	}
	
	
	/*  Reads vertexes and edges from a data file and creates vertexes with
		the adjacency lists in the file. Takes a filename arg.
	 
		This code does hardly any error checking so it requires the 
		following format very strictly:
	 
		<integer of vertices to expect>
		<vertex number (int)> [target vertex int (space) target vertex weight, ...] -1
	    ... (until EOF)
	*/
	void readAdjacencyList (string fileName = string("input.txt"))
	{
		ifstream ifs(fileName.c_str());
		string temp, word;
		
		int wordCount    = 0;		// use to delete every other word
		int vertCount    = 0;		// count the vertices as we read them
		int vertExpected = 0;		// the number of vertices to expect
		int vertNum      = -1;		// number of vertex
		int edgeTarget   = -1;		// target of edge
		float edgeWeight = -1;		// weight of edge
		bool startVert   = false;	// start reading vertices?
		
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
					if (vertExpected==0 && (vertExpected = atoi(word.c_str())))
							continue;
					
					startVert = true;	// start reading vertexes

					if (word == "-1")	// base case for end of line
						continue;
			
					if (vertNum==-1)	// new vertex
						vertNum = atoi(word.c_str());
					else if (edgeTarget==-1)
						edgeTarget= atoi(word.c_str());	
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
					//cout << "adding vertex" << endl;
					vertex v(adj, vertNum);			// create a new vertex with an internal adj. list
					//v.dump();
					
					vertexes.push_back(v);	// add vertex to graph
					adj.clear();			// reset adj list
					vertNum=-1;
				}
				wordCount=0;				// reset wordcount for line
								
			}
		}
		else
			cout << "=== ERROR: COULDN'T OPEN FILE '" << fileName << "' ===" << endl;
	}
	
	
	
	/*
	 
	 Implementation of disjkstra with a priority queue
	 
	 The basics of the algorithm are:
	 
	 
	 * pick a start vertex s
	 
	 * for all vertexes w adjacent to s
	 
		* if 
	 
	 
	 Store all vertexes in pq
	 
	 Set start vertex dist to 0 and pop minimum (removes start vertex from pq)
	 
	 
	 
	 loop:
	 
		pop min from pq
	 
	 
	 */
	
	void dijkstra ( int vertNum =-1 ) 
	{
		cout << "hrm\n";
		if (vertNum = -1)
		{
			int vertexNum;
			cout << "Enter a vertex number: " << endl;
			cin >> vertexNum;
			cout << endl;
		}
		
		
		// Create priority queue or vertexes that sorts by vertex.dist
		priority_queue<vertex, vector<vertex>, CompareVertexes> pq;

		// add all the vertexes to the queue so we can pull out least dist
		for (int i=0; i < vertexes.size(); i ++)
			pq.push(vertexes[i]);


		// Main dijkstra loop
		for (;;)
		{
			
			// get vertex with smallest unknown dist
			vertex v = pq.top();
			pq.pop();


			// iterate through adjacency list
			vector< pair<int, float> > edges = v.edges;
			
			cout << " edges size" << edges.size() << endl;

			for (int i=0; i < edges.size(); i++)
			{
				
				cout << "hrm2\n";

				vertex w = vertexes[edges[i].first];
				int w_cost = edges[i].second;
				cout << "hrm3\n";
				
				//if (w.dist + w_cost < 
				w.dump();
				cout << "cost: " << w_cost << endl;
				
			}
			
			
			
		}
		
		//BinaryHeap pq;
		
		
	}
	
private:
	
	vector< vertex > vertexes;	// store adjacency list
};


int main ( )
{
	// Declare a graph object
	graph g;
	
	// Graph will read the text file and instantiate vertexes with
	//  the weighted adjacency lists read from the file.
	g.readAdjacencyList("dgraph_test2.txt");
	
	// Print out the graph as a set of vertices and edge targets/weights
	g.dump();

	//g.dijkstra();
	
	// g.flow();
	
	// g.networkFlow();
	
	// g.unDirected();
	
	// g.dfs();
	
	
	return 0;
}