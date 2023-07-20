
_back_off:

;ObstacleAvoidance.c,10 :: 		void back_off() //used to drive the robot backward
;ObstacleAvoidance.c,12 :: 		PORTD.F0=HIGH; PORTD.F1=LOW; //Motor 1 reverse
	BSF         PORTD+0, 0 
	BCF         PORTD+0, 1 
;ObstacleAvoidance.c,13 :: 		PORTD.F2=LOW; PORTD.F3=HIGH; //Motor 2 reverse
	BCF         PORTD+0, 2 
	BSF         PORTD+0, 3 
;ObstacleAvoidance.c,14 :: 		Delay_ms(1000);
	MOVLW       51
	MOVWF       R11, 0
	MOVLW       187
	MOVWF       R12, 0
	MOVLW       223
	MOVWF       R13, 0
L_back_off0:
	DECFSZ      R13, 1, 1
	BRA         L_back_off0
	DECFSZ      R12, 1, 1
	BRA         L_back_off0
	DECFSZ      R11, 1, 1
	BRA         L_back_off0
	NOP
	NOP
;ObstacleAvoidance.c,15 :: 		}
L_end_back_off:
	RETURN      0
; end of _back_off

_calculate_distance:

;ObstacleAvoidance.c,17 :: 		void calculate_distance() //function to calculate distance of US
;ObstacleAvoidance.c,19 :: 		TMR1H = 0; TMR1L =0; //clear the timer bits
	CLRF        TMR1H+0 
	CLRF        TMR1L+0 
;ObstacleAvoidance.c,20 :: 		Trigger = 1;
	BSF         PORTB+0, 1 
;ObstacleAvoidance.c,21 :: 		Delay_ms(10);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_calculate_distance1:
	DECFSZ      R13, 1, 1
	BRA         L_calculate_distance1
	DECFSZ      R12, 1, 1
	BRA         L_calculate_distance1
	NOP
	NOP
;ObstacleAvoidance.c,22 :: 		Trigger = 0;
	BCF         PORTB+0, 1 
;ObstacleAvoidance.c,23 :: 		while (Echo==0);
L_calculate_distance2:
	BTFSC       PORTB+0, 2 
	GOTO        L_calculate_distance3
	GOTO        L_calculate_distance2
L_calculate_distance3:
;ObstacleAvoidance.c,24 :: 		T1CON = 1;
	MOVLW       1
	MOVWF       T1CON+0 
;ObstacleAvoidance.c,25 :: 		while (Echo==1);
L_calculate_distance4:
	BTFSS       PORTB+0, 2 
	GOTO        L_calculate_distance5
	GOTO        L_calculate_distance4
L_calculate_distance5:
;ObstacleAvoidance.c,26 :: 		T1CON = 0;
	CLRF        T1CON+0 
;ObstacleAvoidance.c,27 :: 		time_taken = (TMR1L | (TMR1H<<8));
	MOVF        TMR1H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        TMR1L+0, 0 
	IORWF       R0, 1 
	MOVLW       0
	IORWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       _time_taken+0 
	MOVF        R1, 0 
	MOVWF       _time_taken+1 
;ObstacleAvoidance.c,28 :: 		distance= (0.0272*time_taken)/2;
	CALL        _int2double+0, 0
	MOVLW       137
	MOVWF       R4 
	MOVLW       210
	MOVWF       R5 
	MOVLW       94
	MOVWF       R6 
	MOVLW       121
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       128
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       _distance+0 
	MOVF        R1, 0 
	MOVWF       _distance+1 
;ObstacleAvoidance.c,29 :: 		}
L_end_calculate_distance:
	RETURN      0
; end of _calculate_distance

_main:

;ObstacleAvoidance.c,33 :: 		void main(){
;ObstacleAvoidance.c,34 :: 		TRISD.F0 = 0x00; //PORTD declared as output for interfacing L293D
	BCF         TRISD+0, 0 
;ObstacleAvoidance.c,35 :: 		TRISD.F1 = 0x00;
	BCF         TRISD+0, 1 
;ObstacleAvoidance.c,36 :: 		TRISD.F2 = 0x00;
	BCF         TRISD+0, 2 
;ObstacleAvoidance.c,37 :: 		TRISD.F3 = 0x00;
	BCF         TRISD+0, 3 
;ObstacleAvoidance.c,38 :: 		TRISB.F1 = 0; //Trigger pin of US sensor is sent as output pin
	BCF         TRISB+0, 1 
;ObstacleAvoidance.c,39 :: 		TRISB.F2 = 1; //Echo pin of US sensor is set as input pin
	BSF         TRISB+0, 2 
;ObstacleAvoidance.c,40 :: 		TRISD.F0 = 0; TRISD.F1 = 0; //Motor 1 pins declared as output
	BCF         TRISD+0, 0 
	BCF         TRISD+0, 1 
;ObstacleAvoidance.c,41 :: 		TRISD.F2 = 0; TRISD.F3 = 0; //Motor 2 pins declared as output
	BCF         TRISD+0, 2 
	BCF         TRISD+0, 3 
;ObstacleAvoidance.c,42 :: 		T1CON=0x20;
	MOVLW       32
	MOVWF       T1CON+0 
;ObstacleAvoidance.c,43 :: 		while(1){
L_main6:
;ObstacleAvoidance.c,44 :: 		calculate_distance();
	CALL        _calculate_distance+0, 0
;ObstacleAvoidance.c,45 :: 		PORTD.F0=LOW; PORTD.F1=HIGH; //Motor 1 forward
	BCF         PORTD+0, 0 
	BSF         PORTD+0, 1 
;ObstacleAvoidance.c,46 :: 		PORTD.F2=HIGH; PORTD.F3=LOW; //Motor 2 forward
	BSF         PORTD+0, 2 
	BCF         PORTD+0, 3 
;ObstacleAvoidance.c,47 :: 		if (distance>5){
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       _distance+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main15
	MOVF        _distance+0, 0 
	SUBLW       5
L__main15:
	BTFSC       STATUS+0, 0 
	GOTO        L_main8
;ObstacleAvoidance.c,48 :: 		PORTD.F0=LOW; PORTD.F1=HIGH; //Motor 1 forward
	BCF         PORTD+0, 0 
	BSF         PORTD+0, 1 
;ObstacleAvoidance.c,49 :: 		PORTD.F2=HIGH; PORTD.F3=LOW; //Motor 2 forward
	BSF         PORTD+0, 2 
	BCF         PORTD+0, 3 
;ObstacleAvoidance.c,50 :: 		Delay_ms(10);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	NOP
	NOP
;ObstacleAvoidance.c,51 :: 		}else{
	GOTO        L_main10
L_main8:
;ObstacleAvoidance.c,52 :: 		back_off();
	CALL        _back_off+0, 0
;ObstacleAvoidance.c,53 :: 		Delay_ms(10);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main11:
	DECFSZ      R13, 1, 1
	BRA         L_main11
	DECFSZ      R12, 1, 1
	BRA         L_main11
	NOP
	NOP
;ObstacleAvoidance.c,54 :: 		}
L_main10:
;ObstacleAvoidance.c,55 :: 		}
	GOTO        L_main6
;ObstacleAvoidance.c,56 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
