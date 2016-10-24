#include <stdio.h>
#include <string.h>
%%{
machine foo;
    write data;
}%%
int main( int argc, char **argv )
{
    int cs;
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

            action GetFrequency {
                printf("GetFrequency\n");
            }

            action SetFrequency {
                printf("SetFrequency\n");
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

            noop = "AT" % DoNothing;
            redo = "A/" % RepeatLastCommand;
            help = "AT&V" % ShowHelp;
            get_freq = "AT+F?" % GetFrequency;
            set_freq = "AT+F=" % SetFrequency;
            echo_off = "ATE0" % EchoOff;
            echo_on = "ATE1" % EchoOn;
            quiet_off = "ATQ0" % QuietOff;
            quiet_on = "ATQ1" % QuietOn;
            verbose_off = "ATV0" % VerboseOn;
            verbose_on = "ATV1" % VerboseOff;
            reset = "ATZ" % Reset;

            decimal = [0-9]+ ( '.' [0-9]+ )?;
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

            terminator = '\n'
                       | '^M'
                       ;

            consume_line := [^terminator]* terminator @{ fgoto main; };

            main := (
                (
                    (space* . command . space*. terminator)
                    $!BadCommandError
                )
            )*;

            write init;
            write exec;
        }%%
    }
    printf("result = %i\n", cs >= foo_first_final );
    return 0;
}
