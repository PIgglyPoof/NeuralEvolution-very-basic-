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
