# AT commands

A state machine for identifying Hayes-style AT commands.

This is very much an experiment so I can get to grips with using the Ragel State Machine Compiler
from C.

The objective is to be able to parse a Hayes-AT style command set (one command per line) with
error recovery and with streaming input one character at a time as if from a serial port,
without needing to buffer a whole line. The current state of the machine encodes and partially
recieved command.
