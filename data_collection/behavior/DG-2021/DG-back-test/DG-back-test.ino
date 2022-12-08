 String text = "";
 int mark = 0,j=0, f[6]={},lick=0,Volume_mm=29;
 int Delay=500;
void setup() 
{ 
  Serial.begin(9600);
  pinMode(13,OUTPUT); //light signal
  pinMode(12,OUTPUT); //trigger zone in to spike 2
  pinMode(6,OUTPUT); //给水
  pinMode(8,OUTPUT); //给光 to spike 2
  pinMode(5,OUTPUT); //抽水
  pinMode(10,OUTPUT); //给水 to spike 2
  pinMode(11,OUTPUT); //声音 to spike 2 
  pinMode(7,INPUT);//lick 信号
  digitalWrite(5,0);
  digitalWrite(6,0);
  digitalWrite(7,0);
  digitalWrite(8,0);
  digitalWrite(10,0);
  digitalWrite(11,0);
  digitalWrite(12,0);
  digitalWrite(13,0);
  
}  
   
void loop() 
{ 
   //Lick trigger reward
  digitalWrite(5,0);
  digitalWrite(6,0);
  digitalWrite(10,0);
  while (Serial.available() > 0)
      {
      //读入之后将字符串，串接到text上面。
        text += char(Serial.read());
        //延时一会，让串口缓存准备好下一个数字，不延时会导致数据丢失，
        delay(10);
        //标记串口读过数据，如果没有数据的话，直接不执行这个while了。
        mark = 1;
      }
if (Serial.read()=='O')
       { digitalWrite(8, 0);////熄灭给光信号
         digitalWrite(13, 0);//熄灭给光信号
         digitalWrite(12, 0);//离开 waiting zone
         digitalWrite(11, 1);// 声音信号
         delay(2000);
         digitalWrite(11, 0);
         }
 if (mark==1)
  {
//    Serial.println(text);
    for(int i = 0; i < text.length() ; i++)
        {
        //逐个分析text[i]字符串的文字，如果碰到文字是分隔符（这里选择逗号分割）则将结果数组位置下移一位
        //即比如11,22,33,55开始的11记到text[0];碰到逗号就j等于1了，
        //再转换就转换到text[1];再碰到逗号就记到text[2];以此类推，直到字符串结束
          if(text[i] == ',')
          {
            j++;
          }
          else
          {
             //如果没有逗号的话，就将读到的数字*10加上以前读入的数字，
             //并且(text[i] - '0')就是将字符'0'的ASCII码转换成数字0（下面不再叙述此问题，直接视作数字0）。
             //比如输入数字是12345，有5次没有碰到逗号的机会，就会执行5次此语句。
             //因为左边的数字先获取到，并且text[0]等于0，
             //所以第一次循环是text[0] = 0*10+1 = 1
             //第二次text[0]等于1，循环是text[0] = 1*10+2 = 12
             //第三次是text[0]等于12，循环是text[0] = 12*10+3 = 123
             //第四次是text[0]等于123，循环是text[0] = 123*10+4 = 1234
             //如此类推，字符串将被变成数字0。
            f[j] = f[j] * 10 + (text[i] - '0');
          }
        }
        if (f[0]==0)//f[0]=0为小鼠进入waiting zone
        
        { digitalWrite(12, 1);}
        if (f[0]==4)
        { digitalWrite(5,1);
          delay(50*f[1]);
          digitalWrite(5,0);
        }
        if (f[0]==1)//f[0]=1时串口信号为给水量
        
        { digitalWrite(6, 1);
          digitalWrite(10, 1);            
          delay(50*f[1]);              
          digitalWrite(6, 0); 
          digitalWrite(10, 0);    
           }
            else if (f[0]==2) //f[0]=2时串口信号为光抑制信号          
        { 
         digitalWrite(13, 1);
         digitalWrite(8, 1); }       
          else if (f[0]==3)
        //f[0]=3时串口信号为光刺激信号
        //f[1]为频率，f[2]为脉冲时长(ms)，f[3]为总共刺激时长（s）
        {  for(int i=1;i<=f[1]*f[3];i ++) 
          { 
         digitalWrite(13, 1);
         digitalWrite(8, 1);
         delay(f[2]);
         digitalWrite(13, 0);
         digitalWrite(8, 0);
         delay(1000/f[1]-f[2]);           
          if (Serial.read()=='O')
            {break;
         }
         }    
         }        
         else if (f[0]==5)
   {
    for(int i=1;i<=100;i ++) 
       { 
         Delay=490*pow(2,-0.25*i)+110*pow(2,-0.0025*i);           
         digitalWrite(13, 1);
         digitalWrite(8, 1);
         delay(f[1]);
         digitalWrite(13, 0);
         digitalWrite(8, 0);
         delay(Delay); // 等待数据传完      
          if (Serial.read()=='O')
            {break;
             }
        }  
    }  
   else if (f[0]==6)
        //f[0]=6时串口信号为光刺激信号
        //f[1]为频率，f[2]为脉冲时长增加值(us)，f[3]为总共刺激时长（s）,f[4]为开始脉冲时长
        {  for(int i=1;i<=f[1]*f[3];i ++) 
          { 
         digitalWrite(13, 1);
         digitalWrite(8, 1);         
         delay(constrain((i-1)*f[2]/1000+f[4],f[4],1000*0.4/f[1]));
         digitalWrite(13, 0);
         digitalWrite(8, 0);
         delay(1000/f[1]-constrain((i-1)*f[2]/1000+f[4],f[4],1000*0.4/f[1]));           
          if (Serial.read()=='O')
            {break;
         }
         }    
         }      
   else if (f[0]==7)
    {
      digitalWrite(12,LOW);
      }
  text="";f[0]={}; f[1]={}; f[2]={};f[3]={};f[4]={};mark=0;j=0;}
//  int a = analogRead(A0);
  int a=digitalRead(7);
  a = 1-a;
  Serial.println(a);
  }
