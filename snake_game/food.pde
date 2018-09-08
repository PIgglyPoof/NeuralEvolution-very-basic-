// food for snake
class Food{
  public int x=(int)random(5,rows-5);
  public int y=(int)random(5,cols-5);
  
  Food(){
    this.y*=scl;
    this.x*=scl;
  }
  
  public void show(){
    fill(255);
    rect(this.x,this.y,scl,scl);
  }
  
}
