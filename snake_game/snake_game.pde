import java.util.*;
import java.io.*;
import java.io.Serializable;


int noOfSnakes=2000;
Snake snake[]=new Snake[noOfSnakes];
int cols,rows;
int scl=10;
int no=0;
Snake globalBest=new Snake();


void setup(){
  size(400,400);
  cols=(int)400/scl;
  rows=(int)400/scl;
  
  for(int i=0;i<noOfSnakes;++i)
   snake[i]=new Snake();
   
}

void draw(){
  background(0);
  
    if(no==noOfSnakes){
    no=0;
    newGeneration();
  }

  int bestscore=0,index=0;
  for(int i=0;i<noOfSnakes;++i){
    if(snake[i].alive){
    snake[i].update();
    snake[i].input();
    if(snake[i].eat(snake[i].food.x,snake[i].food.y)){
      snake[i].food=new Food();
      snake[i].health+=20;
      snake[i].fitness+=1;
      snake[i].score+=1;
    }
     snake[i].death();
    }
    if(snake[i].score>bestscore){
      bestscore=snake[i].score;
      index=i;
    }
  }
  
  snake[index].food.show();
    snake[index].show();

  fill(255);
    text("score "+bestscore,scl,scl);
  
}


// the sanky snake
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



public class NueralNetwork implements Serializable{
  
  int input=27,hiddenLength=20,hidden[],output=4;
  double inputMatrix[];                            //INPUT MATRIX
  public double weightOne[][];                             // WEIGHT FROM INPUT TO HIDDEN
  double hiddenMatrix[];                          //hidden values
  public double weightTwo[][];                              //  WEIGHT FROM HIDDEN TO OUTPUT
  double outputMatrix[];                           // OUTPUT MATRIX
  
  
  // CREATING COPY
  NueralNetwork(NueralNetwork other){
    this.weightOne=new double[this.input][this.hiddenLength];
    this.hiddenMatrix=new double[this.hiddenLength+1];
    this.hiddenMatrix[this.hiddenLength]=1;
    this.outputMatrix=new double[this.output];
    this.weightTwo=new double[this.hiddenLength+1][this.output];
    
    for(int i=0;i<this.input;++i){
      for(int j=0;j<this.hiddenLength;++j){
        this.weightOne[i][j]=other.weightOne[i][j];
      }
    }
    
    for(int i=0;i<this.hiddenLength+1;++i){
      for(int j=0;j<this.output;++j){
        this.weightTwo[i][j]=other.weightTwo[i][j];
      }
    }
    
    
  }
  
  NueralNetwork(){
    this.weightOne=new double[this.input][this.hiddenLength];       
    for(int i=0;i<this.input;++i){
      for(int j=0;j<this.hiddenLength;++j){
        this.weightOne[i][j]=random(-1,1);
      }
    }
    
    this.hiddenMatrix=new double[this.hiddenLength+1];
      this.hiddenMatrix[this.hiddenLength]=1;
    
    this.weightTwo=new double[this.hiddenLength+1][this.output];
    for(int i=0;i<this.hiddenLength+1;++i){
      for(int j=0;j<this.output;++j){
        this.weightTwo[i][j]=random(-1,1);
      }
    }
    
    this.outputMatrix=new double[this.output];
    
  }
  
  // INITIALIZE INPUT ARRAY
  
  public void init(double inputMatrix[]){
    
    this.inputMatrix=new double[this.input];
    
    this.inputMatrix[this.input-1]=1;                 // random bias
    for(int i=0;i<this.input-1;++i)                   // INPUT MATRIX VALUE
      this.inputMatrix[i]=inputMatrix[i];
  }
  
  public double[] startProcess(){
    
    // FINDING HIDDENMATRIX VALUES
    for(int i=0;i<this.hiddenLength;++i){
      this.hiddenMatrix[i]=0.0;
      for(int j=0;j<this.input;++j){
        this.hiddenMatrix[i]+=this.inputMatrix[j]*this.weightOne[j][i];
      }
      this.hiddenMatrix[i]=this.sigmoid(this.hiddenMatrix[i]);
    }
    
    
    // CALCULATING OUTPUT MATRIX
    for(int i=0;i<this.output;++i){
      this.outputMatrix[i]=0.0;
      for(int j=0;j<this.hiddenLength+1;++j){
        this.outputMatrix[i]+=this.hiddenMatrix[j]*this.weightTwo[j][i];
      }
      this.outputMatrix[i]=this.sigmoid(this.outputMatrix[i]);
    }
    
    
    return this.outputMatrix;
    
  }
  
  
  public void Crossover(NueralNetwork a){
    int row,col;
    row=floor(random(this.input));
    col=floor(random(this.hiddenLength));
    
    for(int i=0;i<=row;++i){
      for(int j=0;j<=col;++j){
        this.weightOne[i][j]=a.weightOne[i][j];
      }
    }
    
    row=floor(random(this.hiddenLength+1));
    col=floor(random(this.output));
    
    for(int i=0;i<=row;++i){
      for(int j=0;j<=col;++j){
        this.weightTwo[i][j]=a.weightTwo[i][j];
      }
    }
    
  }
  
  public void MUTATION(){
        
    for(int i=0;i<this.input;++i){
      for(int j=0;j<this.hiddenLength;++j){
        if(random(1)<0.1){
        this.weightOne[i][j]=random(-1,1);
        }
      }
    }
    
    for(int i=0;i<this.hiddenLength+1;++i){
      for(int j=0;j<this.output;++j){
        if(random(1)<0.1){
        this.weightTwo[i][j]=random(-1,1);
        }
      }
    }
    
  }
  
  public double sigmoid(double x){
    return 1/(1+Math.exp(x));
  }
  
}



public void newGeneration(){
  
    Arrays.sort(snake, new Comparator<Snake>() {
    @Override
    public int compare(Snake o1, Snake o2) {
       if(o1.fitness>o2.fitness)
         return 1;
        else if(o1.fitness<o2.fitness)
        return -1;
        else 
        return 0;
    }
 });
 
    if(globalBest.fitness<snake[noOfSnakes-1].fitness){
      globalBest.nueron=new NueralNetwork(snake[noOfSnakes-1].nueron);
      globalBest.fitness=snake[noOfSnakes-1].fitness;
    }
  
   System.out.println(globalBest.fitness);
   
   for(int i=600;i<800;++i){
     snake[i].nueron=new NueralNetwork(globalBest.nueron);
     }
   
   
   int j=noOfSnakes-1;
   for(int i=1;i<=100;++i){
     if(i%10==0)
         j--;
     snake[i].nueron=new NueralNetwork(snake[j].nueron);
   }
   
   for(int i=101;i<=600;++i){
     snake[i].nueron=new NueralNetwork(snake[j--].nueron);
   }
   
   for(int i=1;i<500;++i){
     int a=floor(random(1500,noOfSnakes));
     int b=floor(random(1500,noOfSnakes));
     if(0.5>random(1)){
        snake[a].nueron.Crossover(snake[i].nueron);
        snake[b].nueron.Crossover(snake[i].nueron);
     }
   }
   
   for(int i=0;i<500;++i){
     int a=floor(random(0,noOfSnakes-700));
     int b=floor(random(700,noOfSnakes));
     snake[b].nueron.Crossover(snake[a].nueron);
       
     
   }
   
   for(int i=650;i<noOfSnakes;++i){
     if(0.40>random(1)){
     snake[i].nueron.MUTATION();
     }
   }
   
   for(int i=0;i<noOfSnakes;++i){
     snake[i].reset();
   }
   
}
