class CollisionField
{
  PVector dimensions;
  PVector position;
  CollisionField(PVector d,PVector p)
  {
    this.dimensions = d;
    this.position = p;
  }

  void display(PVector pos)
  {

    position = pos;
    stroke(255,0,0);
    noFill();
    rectMode(CENTER);
    rect(position.x,position.y,dimensions.x,dimensions.y);
  }

  boolean isCollidingWith(CollisionField other)
  {
    if((position.x+dimensions.x/2)>=other.position.x-other.dimensions.x/2 &&
       position.x-dimensions.x/2<=(other.position.x+other.dimensions.x/2)&&
       (position.y+dimensions.y/2)>=other.position.y-other.dimensions.y/2&&
       position.y- dimensions.y/2<=(other.position.y+other.dimensions.y/2))
       {
         //print("IT HIT");
         return true;
       }

    return false;
  }
}