package main

import (
	"fmt"
)

type Vertex = string
type Edge struct {
	FromNode Vertex
	ToNode   Vertex
	Weight   int
}
type Graph struct {
	adjacencyList map[Vertex][]Edge
}
type shortestDistanceTable = map[Vertex]ShortestDistanceEntry
type ShortestDistanceEntry struct {
	edge                       Edge //map vertex destination with lowest distance inbound edge
	shortestDistanceFromSource int
}

func (graph Graph) findShortestPath(fromNode, toNode Vertex) (path []Vertex, found bool) {
	table := graph.generateShortestDistanceTable(fromNode)
	return backtrack(table, toNode, fromNode)
}

func (graph Graph) generateShortestDistanceTable(fromNode Vertex) (table shortestDistanceTable) {
	//we'll use BFS
	table = make(shortestDistanceTable)
	visitedEdge := map[Edge]bool{}
	bfsQueue := []Vertex{fromNode}

	for {
		if len(bfsQueue) == 0 {
			break
		}

		currentNode := bfsQueue[0]
		bfsQueue = bfsQueue[1:] //dequeue
		edges, ok := graph.adjacencyList[currentNode]
		if !ok {
			//currentNode not found or doesn't have any child
			continue
		}

		for _, edge := range edges {
			_, vertexAlreadyVisited := visitedEdge[edge]
			if vertexAlreadyVisited {
				continue
			}

			bfsQueue = append(bfsQueue, edge.ToNode) //enqueue

			currentShortestEntry, alreadyExist := table[edge.ToNode]
			previousNodeEntry, currentlyVisitedNodeIsNotSourceNode := table[edge.FromNode]

			distanceToSourceFromCurrentlyVisitedNode := 0
			if currentlyVisitedNodeIsNotSourceNode {
				distanceToSourceFromCurrentlyVisitedNode = previousNodeEntry.shortestDistanceFromSource
			}

			distanceToSourceFromNewEdge := edge.Weight + distanceToSourceFromCurrentlyVisitedNode
			if !alreadyExist { //no edge that can be compared yet
				table[edge.ToNode] = ShortestDistanceEntry{edge: edge, shortestDistanceFromSource: distanceToSourceFromNewEdge}
			}
			newEdgeIsShorter := alreadyExist && (currentShortestEntry.shortestDistanceFromSource > distanceToSourceFromNewEdge)
			if newEdgeIsShorter {
				table[edge.ToNode] = ShortestDistanceEntry{edge: edge, shortestDistanceFromSource: distanceToSourceFromNewEdge}
			}

			visitedEdge[edge] = true
		}
	}

	return
}

func backtrack(table shortestDistanceTable, toNode, fromNode Vertex) (path []Vertex, found bool) {
	for {
		entry, ok := table[toNode]
		edge := entry.edge

		if !ok {
			//toNode not found
			found = false
			return
		}

		path = append([]Vertex{edge.ToNode}, path...) //prepend
		if edge.FromNode == fromNode {
			path = append([]Vertex{fromNode}, path...)
			found = true
			break
		} else {
			toNode = edge.FromNode
		}
	}
	return
}

func test(graph Graph, fromNode, toNode Vertex, expectedPath []Vertex, expectedFound bool) {
	path, found := graph.findShortestPath(fromNode, toNode)
	if found != expectedFound {
		fmt.Printf("found doesn't match: actual %v, expected %v\n", found, expectedFound)
		return
	}
	if fmt.Sprintf("%v", path) != fmt.Sprintf("%s", expectedPath) {
		fmt.Printf("found doesn't match: actual %v, expected %v\n", path, expectedPath)
		return
	}
	fmt.Println("case succeeded")
}

func main() {
	test(
		Graph{
			adjacencyList: map[Vertex][]Edge{
				"A": {Edge{FromNode: "A", ToNode: "B", Weight: 1}, Edge{FromNode: "A", ToNode: "C", Weight: 3}},
				"B": {Edge{FromNode: "B", ToNode: "C", Weight: 1}},
			},
		},
		"A", //from
		"C", //to
		[]Vertex{"A", "B", "C"},
		true,
	)
	test(
		Graph{
			adjacencyList: map[Vertex][]Edge{
				"A": {Edge{ToNode: "B", Weight: 1}, Edge{ToNode: "C", Weight: 3}},
				"B": {Edge{ToNode: "C", Weight: 1}},
			},
		},
		"B", //from
		"A", //to
		[]Vertex{},
		false,
	)
	test(
		Graph{
			adjacencyList: map[Vertex][]Edge{
				"A": {Edge{FromNode: "A", ToNode: "B", Weight: 6}, Edge{FromNode: "A", ToNode: "D", Weight: 1}},
				"D": {Edge{FromNode: "D", ToNode: "B", Weight: 2}, Edge{FromNode: "D", ToNode: "E", Weight: 1}},
				"B": {Edge{FromNode: "B", ToNode: "C", Weight: 5}, Edge{FromNode: "B", ToNode: "E", Weight: 2}},
				"E": {Edge{FromNode: "E", ToNode: "C", Weight: 5}},
			},
		},
		"A", //from
		"C", //to
		[]Vertex{"A", "D", "E", "C"},
		true,
	)
}
