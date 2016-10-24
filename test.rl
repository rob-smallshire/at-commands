#include <stdio.h>
#include <string.h>

/*
 *  A nice example here of capturing integers and floats with
 *  state machine transitions.
 */

%%{
machine foo;
    write data;
}%%
int main( int argc, char **argv )
{
    int cs;
    long int intField = 0;
    long int fracNumerator = 0;
    long int fracDenominator = 1;
    if ( argc > 1 ) {
        char *p = argv[1];
        char *pe = p + strlen( p );
        char *eof;

        %%{
            action BadCommandError {
                printf("BadCommandError\n");
                fhold;
                fgoto consume_line;
            }

            action DoNothing {
                printf("Do nothing\n");
            }

            action RepeatLastCommand {
                printf("Repeat last command\n");
            }

            action ShowHelp {
                printf("Show help\n");
            }

            action EchoOn {
                printf("EchoOn\n");
            }

            action EchoOff {
                printf("EchoOff\n");
            }

            action QuietOn {
                printf("QuietOn\n");
            }

            action QuietOff {
                printf("QuietOn\n");
            }

            action VerboseOn {
                printf("VerboseOn\n");
            }

            action VerboseOff {
                printf("VerboseOff\n");
            }

            action Reset {
                printf("Reset\n");
            }

            action GetFrequency {
                printf("GetFrequency\n");
            }

            action SetFrequency {
                float frequency = intField + (float)fracNumerator / fracDenominator;
                printf("SetFrequency %f MHz\n", frequency);
            }

            action Scan {
                printf("Scan\n");
            }

            action StartDecimalInteger {
                intField = 0;
            }

            action ShiftDecimalIntegerDigit {
                intField *= 10;
                intField += fc - '0';
            }

            action StartDecimalFraction {
                fracNumerator = 0;
                fracDenominator = 1;
            }

            action ShiftDecimalFractionDigit {
                fracNumerator *= 10;
                fracNumerator += fc - '0';
                fracDenominator *= 10;
            }

            integer = digit+ >StartDecimalInteger $ShiftDecimalIntegerDigit;
            fraction = ('.' >StartDecimalFraction).(digit+ $ShiftDecimalFractionDigit);
            decimal = integer fraction?;

            noop = "AT" % DoNothing;
            redo = "A/" % RepeatLastCommand;
            help = "AT&V" % ShowHelp;
            echo_off = "ATE0" % EchoOff;
            echo_on = "ATE1" % EchoOn;
            quiet_off = "ATQ0" % QuietOff;
            quiet_on = "ATQ1" % QuietOn;
            verbose_off = "ATV0" % VerboseOn;
            verbose_on = "ATV1" % VerboseOff;
            reset = "ATZ" % Reset;
            get_freq = "AT+FREQ?" % GetFrequency;
            set_freq = "AT+FREQ=".decimal % SetFrequency;
            start_scan = "AT+SCAN" % Scan;

            command = redo
                    | noop
                    | help
                    | get_freq
                    | set_freq
                    | echo_off
                    | echo_on
                    | quiet_off
                    | quiet_on
                    | verbose_off
                    | verbose_on
                    | reset
                    ;

            ws = [\t ];

            terminator = '\n'
                       | '^M'
                       ;

            consume_line := [^terminator]* terminator @{ fgoto main; };

            main := (
                (
                    (ws* . command . ws*. terminator)
                    $!BadCommandError
                )
            )*;

            write init;
            write exec;
        }%%
    }
    printf("intField = %ld\n", intField);
    printf("fracNumerator = %ld\n", fracNumerator);
    printf("fracDenominator = %ld\n", fracDenominator);
    printf("result = %i\n", cs >= foo_first_final );
    return 0;
}
