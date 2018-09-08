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
