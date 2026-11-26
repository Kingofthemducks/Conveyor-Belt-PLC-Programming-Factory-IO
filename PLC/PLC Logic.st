//--------------------------------------------------------------
// BUTTONS
//--------------------------------------------------------------

// Start
IF FIO.Start THEN
    MachineRunning := TRUE;
END_IF

// Stop
IF NOT FIO.Stop THEN
    MachineRunning := FALSE;
END_IF

// Emergency Stop
IF NOT FIO.EmergencyStop THEN
    EmergencyLocked := TRUE;
END_IF

// Emergency Override
IF EmergencyLocked THEN
    MachineRunning := FALSE;
END_IF

// Reset emergency lock
IF FIO.Reset AND FIO.EmergencyStop THEN
    EmergencyLocked := FALSE;
END_IF

//--------------------------------------------------------------
// MODE SELECTION
//--------------------------------------------------------------

AutoSelected := FIO.AutoMode;
ManualSelected := FIO.ManualMode;

//--------------------------------------------------------------
// TURN TIMER
//--------------------------------------------------------------

tTurnPulse(
    IN := ((FeedStep = 30) OR (FeedStep = 60))
          AND MachineRunning AND AutoSelected,
    PT := T#8S
);

tEntryFeed(
    IN := (FeedStep = 10) AND MachineRunning AND AutoSelected,
    PT := T#2S
);

tSortDelay(
    IN := (FeedStep = 30) AND MachineRunning AND AutoSelected,
    PT := T#2S
);

tReturnDelay(
    IN := (FeedStep = 50) AND MachineRunning AND AutoSelected,
    PT := T#2S
);

tRestartFeed(
    IN := (FeedStep = 70) AND MachineRunning AND AutoSelected,
    PT := T#2S
);

//--------------------------------------------------------------
// OUTPUT DEFAULTS
//--------------------------------------------------------------

FIO.Emitter1 := FALSE;
FIO.FeederConveyor := FALSE;
FIO.EntryConveyor := FALSE;

FIO.Turn := FALSE;
FIO.Load := FALSE;
FIO.Unload := FALSE;

FIO.LeftConveyor := MachineRunning;
FIO.RightConveyor := MachineRunning;

// Reset sequence when stopped or not in Auto
IF NOT MachineRunning OR EmergencyLocked OR NOT AutoSelected THEN
    FeedStep := 0;
    BoxIsHigh := FALSE;
END_IF

//--------------------------------------------------------------
// AUTOMATIC SEQUENCE
//--------------------------------------------------------------

IF MachineRunning AND AutoSelected THEN

    // Remember box height before it reaches the turntable
    IF (FeedStep = 0 OR FeedStep = 10) AND FIO.HighBox THEN
        BoxIsHigh := TRUE;
    END_IF

    CASE FeedStep OF

        // STEP 0: Normal feeding
        0:
            FIO.Emitter1 := TRUE;
            FIO.FeederConveyor := TRUE;
            FIO.EntryConveyor := TRUE;

            IF FIO.AtTurntableEntry AND NOT AtTurntableEntryPrev THEN
                FeedStep := 10;
            END_IF

			LeftEntryDetected := FALSE;
			RigthEntryDetected := FALSE;
			
			
      // STEP 10: Load box onto turntable
10:
    FIO.Load := TRUE;

    // Keep entry conveyor running for 2 seconds
    IF NOT tEntryFeed.Q THEN
        FIO.EntryConveyor := TRUE;
    END_IF

    // Box reaches front sensor
    IF FIO.AtFront THEN
        FeedStep := 30;
    END_IF

// STEP 30: Turntable movement and sorting delay
30:
    // Turn remains active for 8 seconds
    FIO.Turn := NOT tTurnPulse.Q;

    // After 2 seconds, activate the correct sorting output
    IF tSortDelay.Q THEN
        IF BoxIsHigh THEN
            FIO.Load := TRUE;
        ELSE
            FIO.Unload := TRUE;
        END_IF
    END_IF

    // After 8 seconds, move to sorting step
    IF tTurnPulse.Q THEN
        FeedStep := 40;
    END_IF

// STEP 40: Wait until box reaches the correct conveyor exit
40:
    IF BoxIsHigh THEN
        FIO.Load := TRUE;

        IF FIO.AtLeftExit THEN
            FeedStep := 50;
        END_IF

    ELSE
        FIO.Unload := TRUE;

        IF FIO.AtRightExit THEN
            FeedStep := 50;
        END_IF
    END_IF
			
		// STEP 50: Wait before returning
		50:
    		IF tReturnDelay.Q THEN
        		FeedStep := 70;
    		END_IF

      
// STEP 70: Wait 2 seconds, then restart feeding
70:
    IF tRestartFeed.Q THEN
        BoxIsHigh := FALSE;
        AtTurntableEntryPrev := FALSE;
        FeedStep := 0;
    END_IF
			
			
    END_CASE

//--------------------------------------------------------------
// MANUAL MODE
//--------------------------------------------------------------

ELSIF MachineRunning AND ManualSelected THEN

    FIO.Emitter1 := TRUE;
    FIO.FeederConveyor := TRUE;
    FIO.EntryConveyor := TRUE;

END_IF

//--------------------------------------------------------------
// SENSOR MEMORY
//--------------------------------------------------------------

AtTurntableEntryPrev := FIO.AtTurntableEntry;

//--------------------------------------------------------------
// INDICATORS
//--------------------------------------------------------------

FIO.GreenIndicator := MachineRunning;
FIO.RedIndicator := NOT MachineRunning;
FIO.ResetLight := EmergencyLocked;


// BOX COUNTER
LowBoxTrigger(CLK := FIO.LowBox);

IF FIO.Reset THEN
    BoxCounter := 0;
ELSIF LowBoxTrigger.Q THEN
    BoxCounter := BoxCounter + 1;
END_IF;

// SEND COUNT TO FACTORY I/O DISPLAY
FIO.ProductionCounter := BoxCounter;