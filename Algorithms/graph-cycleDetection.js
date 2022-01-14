function constructGraphAdjacencyList(edges){
    let dict = {}
    edges.forEach(edge => {
        if(dict[edge.fromNode]){
            dict[edge.fromNode].push(edge.toNode)
        }else{
            dict[edge.fromNode] = [edge.toNode]
        }
    });
    return dict
}

function checkCycle(graph){
    let allNodes = []
    for (const fromNode in graph) {
        allNodes.push(parseInt(fromNode))
    }

    for (let i = 0; i < allNodes.length; i++) {
        const node = allNodes[i];
        let path = [node]
        let cycle = dfsToCheckCycle(graph, node, path)
        if (cycle !== undefined){
            return cycle
        }
    }
}

function dfsToCheckCycle(graph, node, path){
    let adjacentNodes = graph[node]
    if (!adjacentNodes){
        return undefined
    }

    for (let i = 0; i < adjacentNodes.length; i++) {
        const adjacentNode = adjacentNodes[i];
        let set = new Set(path)
        let nodeHasBeenTraversedBefore = set.has(adjacentNode)
        path.push(adjacentNode)
        if(nodeHasBeenTraversedBefore){
            return path   
        }

        let result = dfsToCheckCycle(graph, adjacentNode, path)
        if (result !== undefined){
            return path
        }
        path.pop()
    }

    return undefined
}

function test(shouldHaveCycle, testCase){
    let cycle = checkCycle(constructGraphAdjacencyList(testCase))
    if(shouldHaveCycle && cycle === undefined) {
        console.log("should have cycle for for test case", testCase)
        return
    }
    if(!shouldHaveCycle && cycle !== undefined) {
        console.log("should not have cycle for for test case", testCase)
        return
    }
    console.log(cycle)
}
let shouldHaveCycle = true
let shouldNotHaveCycle = !shouldHaveCycle
test(shouldHaveCycle, [{fromNode: 0, toNode: 0}])
test(shouldNotHaveCycle, [{fromNode: 0, toNode: 1}])
test(shouldHaveCycle, [
    {fromNode: 0, toNode: 1},
    {fromNode: 1, toNode: 0},
])
test(shouldNotHaveCycle, [
    {fromNode: 0, toNode: 1},
    {fromNode: 1, toNode: 2},
])
test(shouldNotHaveCycle, [
    {fromNode: 0, toNode: 1},
    {fromNode: 2, toNode: 1},
])
test(shouldNotHaveCycle, [
    {fromNode: 0, toNode: 1},
    {fromNode: 1, toNode: 2},
    {fromNode: 1, toNode: 3},
    {fromNode: 1, toNode: 4},
])
test(shouldHaveCycle, [
    {fromNode: 0, toNode: 1},
    {fromNode: 1, toNode: 2},
    {fromNode: 1, toNode: 3},
    {fromNode: 3, toNode: 0},
])
