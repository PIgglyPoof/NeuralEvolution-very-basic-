public class Snake{
  
  public Food food=new Food();
  int score=0;
  double health=20;
  double time=0;
  int x=(int)200;
  int y=(int)200;
  int direction=2; // 1= top, 2=right, 3=down ,4=left
  int xspeed=1;
  int yspeed=0;
  double fitness=0.0;
  PVector tail[]=new PVector[50];
  public boolean alive=true;
  int total=0;                                           // LENGTH OF SNAKE
  public NueralNetwork nueron=new NueralNetwork();
  
  Snake(){
    tail[0]=new PVector(this.x,this.y);
    tail[1]=new PVector(this.x-scl,this.y);
    tail[2]=new PVector(this.x-2*scl,this.y);
    tail[3]=new PVector(this.x-3*scl,this.y);
    tail[4]=new PVector(this.x-3*scl,this.y);
    
    total=4;
  }
  
  public void reset(){
    this.score=0;
    this.time=0;
    food=new Food();
    this.x=(int)200;
    this.y=(int)200;
    this.direction=2;
    this.xspeed=1;
    this.yspeed=0;
    this.health=20;
    this.fitness=0.0;
    tail=new PVector[100];
    this.alive=true;
    total=0;
    tail[0]=new PVector(this.x,this.y);
    tail[1]=new PVector(this.x-scl,this.y);
    tail[2]=new PVector(this.x-2*scl,this.y);
    tail[3]=new PVector(this.x-3*scl,this.y);
    tail[4]=new PVector(this.x-3*scl,this.y);
    total=4;
  }
  
  void up(){
    this.direction=1;
    this.dir(0,-1);
  }
  void down(){
    this.direction=3;
    this.dir(0,1);
  }
  void left(){
    this.direction=4;
    this.dir(-1,0);
  }
  void right(){
    this.direction=2;
    this.dir(1,0);
  }
  
  public void input(){
    double output[]=new double[4];
    double input[]=new double[26];
    double temp[]=new double[3];
    
    
    temp=findDirection(new PVector(0,-scl));
    for(int i=0;i<3;++i){
      input[i]=temp[i];
    }
    
    temp=findDirection(new PVector(scl,-scl));
    for(int i=0;i<3;++i){
      input[i+3]=temp[i];
    }
    
    temp=findDirection(new PVector(scl,0));
    for(int i=0;i<3;++i){
      input[i+6]=temp[i];
    }
    
    temp=findDirection(new PVector(scl,scl));
    for(int i=0;i<3;++i){
      input[i+9]=temp[i];
    }
    
    temp=findDirection(new PVector(0,scl));
    for(int i=0;i<3;++i){
      input[i+12]=temp[i];
    }
    
    temp=findDirection(new PVector(-scl,scl));
    for(int i=0;i<3;++i){
      input[i+15]=temp[i];
    }
    
    temp=findDirection(new PVector(-scl,0));
    for(int i=0;i<3;++i){
      input[i+18]=temp[i];
    }
    
    temp=findDirection(new PVector(-scl,-scl));
    for(int i=0;i<3;++i){
      input[i+21]=temp[i];
    }
    
    input[24]=(this.food.x-this.x)/width;
    input[25]=(this.food.y-this.y)/height;
    
    this.nueron.init(input);
    output=this.nueron.startProcess();
    
    int index=0;
    
    for(int i=1;i<4;++i){
      if(output[index]<output[i])
        index=i;
    }
    
       
    if(index==0&&this.direction!=3)
      this.up();
    else if(index==1&&this.direction!=4)
      this.right();
    else if(index==2&&this.direction!=1)
      this.down();
    else if(this.direction!=2)
      this.left();
    
  }
  
  public double[] findDirection(PVector direction){
    int xpos=this.x;
    int ypos=this.y;
    double temp[]=new double[3];
    boolean foodFind=false;
    boolean wallFind=false;
    boolean bodyFind=false;
    
    int dir=1;
    
    // GOING RIGHT
    while(!wallFind){
      xpos+=(int)direction.x;
      ypos+=(int)direction.y;
      
      if(!foodFind&&xpos==food.x&&ypos==food.y){
        foodFind=true;
        temp[0]=1/dir;
      }
      
      if(!bodyFind){
        for(int i=1;i<=total;++i){
          if(xpos==tail[i].x&&ypos==tail[i].y){
            bodyFind=true;
            temp[1]=1/dir;
          }
        }
      }
      
      if(xpos<=0||xpos>=width-scl||ypos<=0||ypos>=height-scl){
        wallFind=true;
        temp[2]=1/dir;
      }
      
      ++dir;
      
    }
    
    if(!foodFind){
      temp[0]=1;
    }
    
    if(!bodyFind){
      temp[1]=1;
    }
    
    return temp;
  }
   
  public void update(){
    time+=0.1;
    health-=0.1;
    for(int i=total;i>=1;--i){
      tail[i]=tail[i-1];
    }
    
    this.x=this.x+this.xspeed*scl;
    this.y=this.y+this.yspeed*scl;
    this.x=constrain(this.x,0,width-scl);
    this.y=constrain(this.y,0,height-scl);
    
    tail[0]=new PVector(this.x,this.y);
  }
  
  public void show(){
    
    for(int i=1;i<=total;++i){
      fill(255,0,0);
      rect(this.tail[i].x,this.tail[i].y,scl,scl);
    }
    
    fill(255,0,0);
    rect(this.x,this.y,scl,scl);
  }
  
  public void dir(int xspeed,int yspeed){
    this.xspeed=xspeed;
    this.yspeed=yspeed;
  }
  
  public boolean eat(int x,int y){  // recieve food location
    if(this.x==x&&this.y==y){
      ++this.total;
      this.tail[this.total]=this.tail[this.total-1];
      return true;
    }
    else
      return false;
  }
  
  public void death(){
    for(int i=1;i<=total;++i){
      if(this.x==this.tail[i].x&&this.y==this.tail[i].y){
        this.alive=false;
        this.fitness=(this.health*this.time*this.fitness)/1000;
        ++no;
        break;
      }
    }
    
    if(health<0||this.x==0||this.x==width-scl||this.y==0||this.y==height-scl){
      this.alive=false;
      this.fitness=(this.fitness*this.health*this.time)/1000;
      ++no;
    }   
      
  }
}
