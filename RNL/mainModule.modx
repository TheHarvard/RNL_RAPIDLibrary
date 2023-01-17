MODULE mainModule
    
    !///////////////////////////////////////////////////////////////////////////
    !///////////////////////////////////////////////////////////////////////////
    !////                                                                   ////
    !////                               NOTE:                               ////
    !////                                                                   ////
    !////            This version of RNL is a ALFA version.                 ////
    !////      Features are broken an buggy, but the core functionality     ////
    !////            should function well enough for testing                ////
    !////                                                                   ////
    !////     =========================================================     ////
    !////     DO NOT INSTALL OR USE THIS VERSION OF RNL IN ANY PROJECT      ////
    !////     =========================================================     ////
    !////                                                                   ////
    !////          A "Stable" BETA version of RNL will be released          ////
    !////               once RNL is ready for use in projects.              ////
    !////                                                                   ////
    !///////////////////////////////////////////////////////////////////////////
    !///////////////////////////////////////////////////////////////////////////
    

    !===========================================================================
    ! === Global Data ===
    !===========================================================================

    !Add your Global Data here

    !Example event
    PERS event exampleEvent:=[9999];

    !===========================================================================
    ! === Config ===
    !===========================================================================

    PROC config()

        !Add your confdiguration code here

        !Example subscription for the example event and example response
        CREATE NEW_subscription(\triggerEvent:=exampleEvent
        \reciverProcName:="on_exampleEvent");

    ENDPROC

    !===========================================================================
    ! === Init ===
    !===========================================================================

    PROC init()

        !Add your initialization code here

    ENDPROC

    !===========================================================================
    ! === Main ===
    !===========================================================================

    PROC main()

        !Add your main code here

    ENDPROC

    !===========================================================================
    ! === Event Responses ===
    !===========================================================================

    PROC on_exampleEvent(dataPointer einfo)

        !Add your evemt response code here.

    ENDPROC

    !===========================================================================
    ! === StateMachine States  ===
    !===========================================================================

    PROC state_exampleState(INOUT stateInfo info)
        TEST info.eInfo.triggerEvent

        CASE onStart:
            !Called when the state starts

        CASE exampleEvent:
            !Called when the state machine recives "exampleEvent"

            !CHANGE_TO changes the state to a new state
            CHANGE_TO info,"newState","This is the reason for changing to a new state";

            !SUSPEND-FOR changes the state to a new state, but enables this state to resume later
            SUSPEND_FOR info,"newState","This is the reason for suspending this stat for the next";

            !DONE Ends this state and resumes the last suspended state
            DONE info,"This is the reason for this state beeing done";

        CASE onUpdate:
            !Called once every main cycle

        CASE onEnd:
            !Called once as the state ends

        CASE onSuspend:
            !Called once when the state is suspended

        CASE onResume:
            !Called once when the state resumes from beeing suspended

        DEFAULT:
            !Called whenever the state recives an event that is not soesifically defined

        ENDTEST
    ENDPROC

ENDMODULE