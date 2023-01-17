# RNL_RobotNorgeRAPIDLibrary Version 1.0 ALFA
A standard library of functionality for the RAPID programming language

## Required Options

RMQ
 - Multitasking
 Or
 - PC-interface
 
worldZoneEvents
 - World Zones

## Installation

RNL is installed by a task-to-task basis.   
To Install RNL, import all of the RNL modules into the task
and adjust the task declaration to specify the following parameters:  

(NOTE: The system parameter must be editied in the file directly as the -RmqMaxMsgSize and -RmqMaxNoOfMsg
parameters are not exposed in RobotSudio)

(NOTE: The name of the task must be uniqe)

```
      -Name "[UNIQE_TASKNAME]" -Type "[TYPE]" -Entry "RNL_main"\
      -RmqType "Remote"\
      -RmqMode "Synchronous" -RmqMaxMsgSize 3000 -RmqMaxNoOfMsg 10
```
  
In addition, to use the world zone event features of RNL, the signals RNL_WZ_doZone_1 through RNL_WZ_doZone_50
must be declared as virtual digital outputs in the IO configuration.