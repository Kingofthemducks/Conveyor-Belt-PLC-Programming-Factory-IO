PROGRAM PLC_PRG
VAR
    // Machine control
    MachineRunning : BOOL := FALSE;
    EmergencyLocked : BOOL := FALSE;

    // Operation modes
    AutoSelected : BOOL := TRUE;
    ManualSelected : BOOL := FALSE;

    // Automatic sequence
    FeedStep : INT := 0;
    BoxIsHigh : BOOL := FALSE;
    AtTurntableEntryPrev : BOOL := FALSE;
	LeftEntryDetected : BOOL := FALSE;
	RigthEntryDetected : BOOL := FALSE;

	BoxCounter : DINT := 0;
	LowBoxTrigger : R_TRIG;

    // Turntable timer
    tTurnPulse : TON;
	tEntryFeed : TON;
	tSortDelay : TON;
	tReturnDelay : TON;
	tRestartFeed : TON;
	
	
END_VAR