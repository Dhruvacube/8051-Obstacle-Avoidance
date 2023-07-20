#define Trigger PORTB.F1 //34 is Trigger
#define Echo PORTB.F2//35 is Echo
#define LOW 0
#define HIGH 1

int time_taken;

int distance=10;

void back_off() //used to drive the robot backward
{
  PORTD.F0=HIGH; PORTD.F1=LOW; //Motor 1 reverse
  PORTD.F2=LOW; PORTD.F3=HIGH; //Motor 2 reverse
  Delay_ms(1000);
}

void calculate_distance() //function to calculate distance of US
{
  TMR1H = 0; TMR1L =0; //clear the timer bits
  Trigger = 1;
  Delay_ms(10);
  Trigger = 0;
  while (Echo==0);
  T1CON = 1;
  while (Echo==1);
  T1CON = 0;
  time_taken = (TMR1L | (TMR1H<<8));
  distance= (0.0272*time_taken)/2;
}



void main(){
  TRISD.F0 = 0x00; //PORTD declared as output for interfacing L293D
  TRISD.F1 = 0x00;
  TRISD.F2 = 0x00;
  TRISD.F3 = 0x00;
  TRISB.F1 = 0; //Trigger pin of US sensor is sent as output pin
  TRISB.F2 = 1; //Echo pin of US sensor is set as input pin
  TRISD.F0 = 0; TRISD.F1 = 0; //Motor 1 pins declared as output
  TRISD.F2 = 0; TRISD.F3 = 0; //Motor 2 pins declared as output
  T1CON=0x20;
  while(1){
    calculate_distance();
    PORTD.F0=LOW; PORTD.F1=HIGH; //Motor 1 forward
    PORTD.F2=HIGH; PORTD.F3=LOW; //Motor 2 forward
    if (distance>5){
      PORTD.F0=LOW; PORTD.F1=HIGH; //Motor 1 forward
      PORTD.F2=HIGH; PORTD.F3=LOW; //Motor 2 forward
      Delay_ms(10);
    }else{
      back_off();
      Delay_ms(10);
    }
  }
}