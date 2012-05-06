class GraphComponent {
  // All components in a graph have properties
  // Every component of a given graph should have a unique id
  int id;
  String name;
  float weight;
  
  GraphComponent() {
    id = -1;
    name = "";
    weight = 1.0;
  }
  public void print() {
    println( this.toString() );    
  }
  public String toString() {
    return id + ": \"" + name + "\" (weight: " + weight + ")";
  }
}

class GraphVertex extends GraphComponent {
  GraphVertex( int idNew ) {
    id = idNew;
  }
  GraphVertex( int idNew, String nameNew ) {
    id = idNew;
    name = nameNew;
  }
}

class GraphEdge extends GraphComponent {
  // An edge represents a relation between two vertices (not necessarily distinct), which may be considered source and sink vertices in a directed graph
  public GraphVertex sourceVertex;
  public GraphVertex sinkVertex;
  
  GraphEdge( int idNew, GraphVertex sourceVertexNew, GraphVertex sinkVertexNew ) {
    id = idNew;
    sourceVertex = sourceVertexNew;
    sinkVertex = sinkVertexNew;
  }
  public void print() {
    println( sourceVertex.toString() + " -> " + sinkVertex.toString() );
  }
}

class GraphHyperedge extends GraphComponent {
  // Instead of a single source and single sink vertex, a hyperedge connects any number of vertices with any number of vertices
  
}

class Graph {
  public ArrayList vertices;
  public ArrayList edges;
  int maxVertexId;
  int maxEdgeId;
  
  Graph() {
    vertices = new ArrayList();
    edges = new ArrayList();
    maxVertexId = -1;
    maxEdgeId = -1;
  }
  
  public boolean addVertex() {
    maxVertexId += 1;
    vertices.add( new GraphVertex(maxVertexId) );
    return true;
  }
  
  public boolean addEdge( GraphVertex sourceVertex, GraphVertex sinkVertex ) {
    if( this.isVertex( sourceVertex ) && this.isVertex( sinkVertex ) ) {
      maxEdgeId += 1;
      edges.add( new GraphEdge(maxEdgeId, sourceVertex, sinkVertex) );
      return true;
    } 
    return false;
  }
  
  public int vertexCount() {
    return vertices.size();
  }
  
  public boolean isVertex( GraphVertex cmpVertex ) {
    boolean exists = false;
    for( int i=0; i < vertices.size(); i++ ) {
      GraphVertex thisVertex = (GraphVertex)vertices.get( i );
      if( thisVertex == cmpVertex ) {
        exists = true;
        break;
      }
    }
    return exists;
  }
  public void printVertices() {
    for( int i = 0; i < vertices.size(); i++ ) {
      GraphVertex thisVertex = (GraphVertex)vertices.get( i );
      thisVertex.print();
    }
  }
  public void printEdges() {
    for( int i = 0; i < edges.size(); i++ ) {
      GraphEdge thisEdge = (GraphEdge)edges.get( i );
      thisEdge.print();
    }
  }
  public void print() {
    this.printVertices();
    this.printEdges();
  }
}

class CompleteGraph extends Graph {
  // With every addition  of a vertex, all incident edges are added implicitly
  public boolean addVertex() {
    maxVertexId += 1;
    vertices.add( new GraphVertex( maxVertexId ) );
    for( int i = 0; i < vertices.size()-1; i++ ) {
      GraphVertex srcVertex = (GraphVertex)vertices.get( i );
      GraphVertex sinkVertex = (GraphVertex)vertices.get( vertices.size()-1 );
      this.addEdge( srcVertex, sinkVertex );
    }
    return true;
  }
}
