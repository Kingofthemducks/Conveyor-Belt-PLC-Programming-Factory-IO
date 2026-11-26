{attribute 'qualified_only'}
VAR_GLOBAL

//Operator Inputs
Start : BOOL; 	
Stop : BOOL;
Reset :  BOOL;
EmergencyStop : BOOL;
AutoMode : BOOL;
ManualMode : BOOL;

//Position Sensors
AtBack : BOOL;
AtEntry : BOOL;
AtFront : BOOL;
AtLeftEntry : BOOL;
AtLeftExit : BOOL;
AtRightEntry : BOOL;
AtRightExit : BOOL;
AtLoadPosition : BOOL;
AtUnloadPosition : BOOL;
AtTurntableEntry : BOOL;

//Box Detection
HighBox : BOOL;
LowBox : BOOL;

//Conveyor Outputs
FeederConveyor : BOOL;
EntryConveyor : BOOL;
LeftConveyor : BOOL;
RightConveyor : BOOL;

//Sorting Mechanisms
Turn : BOOL;
Load : BOOL;
Unload : BOOL;
RemoveLeft : BOOL;
RemoveRight : BOOL;
Emitter1 : BOOL;

//Indicator Lights
GreenIndicator : BOOL;
RedIndicator : BOOL;
YellowIndicator : BOOL;
StartLight : BOOL;
StopLight : BOOL;
ResetLight : BOOL;
ProductionCounter : DINT;


END_VAR