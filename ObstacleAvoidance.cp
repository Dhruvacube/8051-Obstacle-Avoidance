#line 1 "D:/Dhruva/Documents/Obstacle_avoidance/ObstacleAvoidance.c"





int time_taken;

int distance=10;

void back_off()
{
 PORTD.F0= 1 ; PORTD.F1= 0 ;
 PORTD.F2= 0 ; PORTD.F3= 1 ;
 Delay_ms(1000);
}

void calculate_distance()
{
 TMR1H = 0; TMR1L =0;
  PORTB.F1  = 1;
 Delay_ms(10);
  PORTB.F1  = 0;
 while ( PORTB.F2 ==0);
 T1CON = 1;
 while ( PORTB.F2 ==1);
 T1CON = 0;
 time_taken = (TMR1L | (TMR1H<<8));
 distance= (0.0272*time_taken)/2;
}



void main(){
 TRISD.F0 = 0x00;
 TRISD.F1 = 0x00;
 TRISD.F2 = 0x00;
 TRISD.F3 = 0x00;
 TRISB.F1 = 0;
 TRISB.F2 = 1;
 TRISD.F0 = 0; TRISD.F1 = 0;
 TRISD.F2 = 0; TRISD.F3 = 0;
 T1CON=0x20;
 while(1){
 calculate_distance();
 PORTD.F0= 0 ; PORTD.F1= 1 ;
 PORTD.F2= 1 ; PORTD.F3= 0 ;
 if (distance>5){
 PORTD.F0= 0 ; PORTD.F1= 1 ;
 PORTD.F2= 1 ; PORTD.F3= 0 ;
 Delay_ms(10);
 }else{
 back_off();
 Delay_ms(10);
 }
 }
}
