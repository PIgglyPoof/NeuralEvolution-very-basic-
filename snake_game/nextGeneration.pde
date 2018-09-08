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
