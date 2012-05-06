import traer.physics.*;
ParticleSystem physics;

int EDGE_LENGTH = 80;
int GRAPH_SIZE = 10;

CompleteGraph cg;

void setup() {
  size( 400, 400 );
  smooth();
  strokeWeight( 2 );
  ellipseMode( CENTER );
  physics = new ParticleSystem( 0, 0 );
  physics.setIntegrator( ParticleSystem.MODIFIED_EULER );
  
  cg = new CompleteGraph();
  for( int i = 0; i < GRAPH_SIZE; i++ ) {
    cg.addVertex();  
    physics.makeParticle();  
  }
  
  for( int i = 0; i < cg.edges.size(); i++ ) {
    GraphEdge e = (GraphEdge)cg.edges.get( i );
    Particle srcParticle = physics.getParticle( e.sourceVertex.id );
    Particle sinkParticle = physics.getParticle( e.sinkVertex.id );
    physics.makeAttraction( srcParticle, sinkParticle, -1000, EDGE_LENGTH );
    physics.makeSpring( srcParticle, sinkParticle, 0.1, 0.2, EDGE_LENGTH );
    srcParticle.position().set( sinkParticle.position().x() + random( -100, 100 ), sinkParticle.position().y() + random( -100, 100 ), 0 );
  }
  
//  cg.print();
  frameRate( 20 );
}

void draw() {
  physics.tick();
  translate( width/2, height/2 );
  background( 255 );
  fill( 0 );
  drawNetwork();
}

void drawNetwork()
{      
//   http://murderandcreate.com/physics/random_arboretum/Random_Arboretum.txt
  // draw edges 
  stroke( 0 );
  beginShape( LINES );
  for ( int i = 0; i < physics.numberOfSprings(); ++i )
  {
    Spring e = physics.getSpring( i );
    Particle a = e.getOneEnd();
    Particle b = e.getTheOtherEnd();
    vertex( a.position().x(), a.position().y() );
    vertex( b.position().x(), b.position().y() );
  }
  endShape();
  
    // draw vertices
  fill( 160, 0, 0 );
  noStroke();
  for ( int i = 0; i < physics.numberOfParticles(); ++i )
  {
    Particle v = physics.getParticle( i );
    ellipse( v.position().x(), v.position().y(), 10, 10 );
  }
}
