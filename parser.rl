#include <stdio.h>
#include <string.h>
#include <stdint.h>

#include "commands.hpp"

/*
 *  A nice example here of capturing integers and floats with
 *  state machine transitions.
 */

static long int intField = 0;
static long int fracNumerator = 0;
static long int fracDenominator = 1;
static int cs;  /* Current state */

%%{
    machine microscript;

    action BadCommandError {
        printf("BadCommandError\n");
        fhold;
        fgoto consume_line;
    }

    action DoNothing {
        printf("Do nothing\n");
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

    action Inquiry {
        printf("Inquiry\n");
    }

    action Reset {
        printf("Reset\n");
    }

    action ListFrequencies {
        printf("ListFrequencies\n");
        list_frequencies();
    }

    action GetFrequency {
        printf("GetFrequency\n");
        get_frequency();
    }

    action SetFrequency {
        int frequency_index = intField;
        printf("SetFrequency index=%d\n", frequency_index);
        set_frequency(frequency_index);
    }

    action ListRssis {
        //list_rssis();
    }

    action GetRssi {
        //get_rssi();
    }

    action SetRssi {
        int rssi_index = intField;;
        printf("SetRssi index=%d\n", rssi_index);
        //set_rssi(rssi_index);
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
    help = "AT&V" % ShowHelp;
    echo_off = /ATE0?/ % EchoOff;
    echo_on = "ATE1" % EchoOn;
    quiet_off = /ATQ0?/ % QuietOff;
    quiet_on = "ATQ1" % QuietOn;
    verbose_off = /ATV0?/ % VerboseOff;
    verbose_on = "ATV1" % VerboseOn;
    inquiry = /ATI[0-9]?/ % Inquiry;
    reset = "ATZ" % Reset;
    get_freq = "AT+FREQ?" % GetFrequency;
    lst_freq = "AT+FREQ#" % ListFrequencies;
    set_freq = "AT+FREQ=".integer % SetFrequency;
    get_rssi = "AT+RSSI?" % GetRssi;
    set_rssi = "AT+RSSI=".integer % SetRssi;
    lst_rssi = "AT+RSSI#" % ListRssis;


    start_scan = "AT+SCAN" % Scan;

    command = noop
              | help
              | get_freq
              | lst_freq
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
}%%

%% write data;

void init_microscript( void ) {
  %% write init;
}

void parse_microscript(const char* p, uint16_t len, uint8_t is_eof) {
  const char* pe = p + len; /* pe points to 1 byte beyond the end of this block of data */
  const char* eof = is_eof ? pe : ((const char*) 0); /* Indicates the end of all data, 0 if not in this block */

  %% write exec;
}

int main( int argc, char **argv )
{
    init_microscript();

    //long int intField = 0;
    //long int fracNumerator = 0;
    //long int fracDenominator = 1;
    if ( argc > 1 ) {
        char *p = argv[1];
        parse_microscript(p, strlen(p), 0);
    }

    printf("intField = %ld\n", intField);
    printf("fracNumerator = %ld\n", fracNumerator);
    printf("fracDenominator = %ld\n", fracDenominator);
    printf("result = %i\n", cs >= microscript_first_final );
    return 0;
}
