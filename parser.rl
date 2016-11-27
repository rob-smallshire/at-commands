#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>
#include <ctype.h>

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
        printf("Error: Command not recognized\n");
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

    action ListRssiThresholds {
        list_rssi_thresholds();
    }

    action GetRssiThreshold {
        get_rssi_threshold();
    }

    action SetRssiThreshold {
        int rssi_index = intField;;
        printf("SetRssi index=%d\n", rssi_index);
        set_rssi_threshold(rssi_index);
    }

    action ListLnaGains {
        list_lna_gains();
    }

    action GetLnaGain {
        get_lna_gain();
    }

    action SetLnaGain {
        int lna_gain_index = intField;;
        printf("SetLnaGain index=%d\n", lna_gain_index);
        set_lna_gain(lna_gain_index);
    }

    action ListBasebandBandwidths {
        list_baseband_bandwidths();
    }

    action GetBasebandBandwidth {
        get_baseband_bandwidth();
    }

    action SetBasebandBandwidth {
        int baseband_bandwidth_index = intField;;
        printf("SetBasebandBandwidth index=%d\n", baseband_bandwidth_index);
        set_baseband_bandwidth(baseband_bandwidth_index);
    }

    action SampleRssi {
        float duration_seconds = float(fracNumerator) / float(fracDenominator);
        printf("SampleRssi duration_seconds=%f\n", duration_seconds);
        sample_rssi(duration_seconds);
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

    action StartTerminator {
        printf("StartTerminator\n");
    }

    action EndTerminator {
        printf("EndTerminator");
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

    get_rssit = "AT+RSSIT?" % GetRssiThreshold;
    set_rssit = "AT+RSSIT=".integer % SetRssiThreshold;
    lst_rssit = "AT+RSSIT#" % ListRssiThresholds;

    get_lnag = "AT+LNAG?" % GetLnaGain;
    set_lnag = "AT+LNAG=".integer % SetLnaGain;
    lst_lnag = "AT+LNAG#" % ListLnaGains;

    get_bbbw = "AT+BBBW?" % GetBasebandBandwidth;
    set_bbbw = "AT+BBBW=".integer % SetBasebandBandwidth;
    lst_bbbw = "AT+BBBW#" % ListBasebandBandwidths;

    sample_rssi = "AT+SRSSI=".decimal % SampleRssi;

    start_scan = "AT+SCAN" % Scan;

    command = noop
              | help
              | get_freq
              | lst_freq
              | set_freq
              | lst_rssit
              | get_rssit
              | set_rssit
              | lst_lnag
              | get_lnag
              | set_lnag
              | lst_bbbw
              | get_bbbw
              | set_bbbw
              | echo_off
              | echo_on
              | quiet_off
              | quiet_on
              | verbose_off
              | verbose_on
              | reset
              ;

    ws = [\t ];

    terminator = '\n' | '^M';

    consume_line := [^terminator]* terminator @{ fgoto main; };

    main := (
                (
                    (ws* . command . ws* . terminator?)
                    @!BadCommandError
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

int is_empty(const char *s) {
  while (*s != '\0') {
    if (!isspace(*s))
      return 0;
    s++;
  }
  return 1;
}

int main( int argc, char **argv )
{
    if ( argc > 1 ) {
        char *p = argv[1];
        init_microscript();
        parse_microscript(p, strlen(p), 0);
        printf("intField = %ld\n", intField);
        printf("fracNumerator = %ld\n", fracNumerator);
        printf("fracDenominator = %ld\n", fracDenominator);
        printf("result = %i\n", cs >= microscript_first_final );
    }
    else {
        assert(argc == 1);
        while (true) {
            init_microscript();
            char* line = 0;
            size_t size;
            int num_chars = getline(&line, &size, stdin);
            if (num_chars == -1) {
                printf("No line\n");
            }
            else {
                if (is_empty(line)) {
                    break;
                }
                else {
                    parse_microscript(line, num_chars, 0);
                }
            }
            free(line);
        }
        printf("Bye!\n");
    }
    return 0;
}
