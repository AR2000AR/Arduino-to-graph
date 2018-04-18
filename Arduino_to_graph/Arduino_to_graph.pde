//Par Rémi Audrezet
import processing.serial.*;//importation de la librairie serie
Serial port;//initialisation de la librairie serie
Table table;
int Rx;//Création de la variable pour stocker la valeur lu sur la liaison serie
int t=0;
int yP1=750;
int yP2=750;
int yP3=750;
int[] result1={},result2={},result3={};
int curLoop=0;
int pas=1;
//Configurations=========================
int maxLoop=72;                   //72=1h
int graphHight=700;               //echelle du graph
int TFR=20;                       //frameRate cible (frequ d'echantillonage
boolean save=true;                //sauvegarde csv
//=======================================
void setup()
{
  size(1100,800);
  background(255);
  if(TFR!=20 && TFR!=10 && TFR!=5 && TFR!=1 && TFR<=20)
  {
    TFR=int(map(TFR,1,20,1,4))*5;
  }
  if(TFR>20)
  {
    TFR=20;
  }
  frameRate(TFR);
  pas=int(20.0*(1.0/float(TFR)));
  println(Serial.list());
  port = new Serial(this,Serial.list()[1],9600);//initialisation de la liaison serie
  effacer();
}

void drawGraph()
{
  stroke(0);
  fill(0);
  for(int i=50;i<1100;i=i+100)
  {
    line(i,50,i,760);
    text((i-50)/20,i-5,770);
  }
  float c=graphHight;
  for(int i=50;i<=750;i=i+50)
  {
    line(45,i,1050,i);
    text(c,1,i+5);
    //c=c-50;
    c=c-(graphHight/14.0);
    
  }
}

void effacer()
{
  background(255);
  drawGraph();
}

void draw()
{
  if(t>1000)
  {
    effacer();
    t=0;
    if(save==true)
    {
      table = new Table();
      table.addColumn("timeStamp");
      table.addColumn("time");
      table.addColumn("value1");
      table.addColumn("value2");
      table.addColumn("value3");
      for(int i=0;i<=result1.length-1 || i<=result1.length-1 || i<=result1.length-1;i=i+1)
      {
        TableRow newRow = table.addRow();
        newRow.setInt("timeStamp",i);
        newRow.setFloat("time",int(0.05*i*100)/100.0);
        newRow.setInt("value1",result1[i]);
        newRow.setInt("value2",result2[i]);
        newRow.setInt("value3",result3[i]);
      }
      saveTable(table,"record_"+day()+"_"+month()+"_"+year()+"_"+hour()+"h"+minute()+"_"+second()+".csv");
    }  
    int[] result={};
    if(curLoop==maxLoop)
    {
      noLoop();
    }
    else
    {
      curLoop=curLoop+1;
    }
  }
  else
  {
    port.write(1);
    if (port.available()>0)//verifie qu'un message est reçu sur le port serie
    {
      Rx=port.read();//lit le message
      stroke(0,0,255);
      line(t+50,yP1,t+50+pas,map(Rx,0,255,750,50));
      yP1=int(map(Rx,0,255,750,50));
      result1 = append(result1,int(map(Rx,0,255,0,graphHight)));
      t=t+pas;
    }
    
    port.write(2);
    if (port.available()>0)//verifie qu'un message est reçu sur le port serie
    {
      Rx=port.read();//lit le message
      stroke(0,255,0);
      line(t+50,yP2,t+50+pas,map(Rx,0,255,750,50));
      yP2=int(map(Rx,0,255,750,50));
      result2 = append(result2,int(map(Rx,0,255,0,graphHight)));
    }
    
    port.write(3);
    if (port.available()>0)//verifie qu'un message est reçu sur le port serie
    {
      Rx=port.read();//lit le message
      stroke(255,0,0);
      line(t+50,yP3,t+50+pas,map(Rx,0,255,750,50));
      yP3=int(map(Rx,0,255,750,50));
      result3 = append(result3,int(map(Rx,0,255,0,graphHight)));
    }
  }
}
