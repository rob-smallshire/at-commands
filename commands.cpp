//
// Created by Robert Smallshire on 2016-10-30.
//

#include "commands.hpp"

const int NUM_FREQ_TEXT = 4;
const char* FREQ_TEXT[] = {"433.2", "433.3", "433.4", "433.5" };

const int NUM_RSSI_THRESHOLD_TEXT = 6;
const char* RSSI_THRESHOLD_TEXT[] = {"-103", "-97", "-91", "-85", "-79", "-73"};

const int NUM_LNA_GAIN_TEXT = 4;
const char* LNA_GAIN_TEXT[] = {"0", "-14", "-6", "-20"};

const int NUM_BASEBAND_BANDWIDTH_TEXT = 6;
const char* BASEBAND_BANDWIDTH_TEXT[] = {"400", "340", "270", "200", "134", "67"};

bool quiet = false;
bool verbose = true;

const char* error_messages[ERROR_END] = {
        /* ERROR_INDEX_OUT_OF_BOUNDS */ "Index out of bounds.",
};

bool ok() {
    if (!quiet) {
        printf("OK\n");
    }
    return true;
}

bool error(int error_id) {
    if (!quiet) {
        if (verbose) {
            printf("Error: %s\n", error_messages[error_id]);
        } else {
            printf("%d", error_id);
        }
    }
    return false;
}

bool list_frequencies() {
    for (int i = 0; i < NUM_FREQ_TEXT; ++i) {
        printf("%d: %s MHz\n", i, FREQ_TEXT[i]);
    }
    return ok();
}

bool get_frequency() {
    printf("%d\n", radio_frequency_index);
    return ok();
}

bool set_frequency(int frequency_index) {
    if ((frequency_index < 0) || (frequency_index >= NUM_FREQ_TEXT)) {
        return error(ERROR_INDEX_OUT_OF_BOUNDS);
    }
    radio_frequency_index = frequency_index;
    return ok();
}

bool list_rssi_thresholds() {
    for (int i = 0; i < NUM_RSSI_THRESHOLD_TEXT; ++i) {
        printf("%d: %s dBm\n", i, RSSI_THRESHOLD_TEXT[i]);
    }
    return ok();
}

bool get_rssi_threshold() {
    printf("%d\n", radio_rssi_threshold_index);
    return ok();
}

bool set_rssi_threshold(int rssi_threshold_index) {
    if ((rssi_threshold_index < 0) || (rssi_threshold_index >= NUM_RSSI_THRESHOLD_TEXT)) {
        return error(ERROR_INDEX_OUT_OF_BOUNDS);
    }
    radio_rssi_threshold_index = rssi_threshold_index;
    return ok();
}

bool list_lna_gains() {
    for (int i = 0; i < NUM_LNA_GAIN_TEXT; ++i) {
        printf("%d: %s dB\n", i, LNA_GAIN_TEXT[i]);
    }
    return ok();
}

bool get_lna_gain() {
    printf("%d\n", radio_lna_gain_index);
    return ok();
}

bool set_lna_gain(int lna_gain_index) {
    if ((lna_gain_index < 0) || (lna_gain_index >= NUM_LNA_GAIN_TEXT)) {
        return error(ERROR_INDEX_OUT_OF_BOUNDS);
    }
    radio_lna_gain_index = lna_gain_index;
    return ok();
}

bool list_baseband_bandwidths() {
    for (int i = 0; i < NUM_BASEBAND_BANDWIDTH_TEXT; ++i) {
        printf("%d: %s kHz\n", i, BASEBAND_BANDWIDTH_TEXT[i]);
    }
    return ok();
}

bool get_baseband_bandwidth() {
    printf("%d\n", radio_baseband_bandwidth_index);
    return ok();
}

bool set_baseband_bandwidth(int baseband_bandwidth_index) {
    if ((baseband_bandwidth_index < 0) || (baseband_bandwidth_index >= NUM_LNA_GAIN_TEXT)) {
        return error(ERROR_INDEX_OUT_OF_BOUNDS);
    }
    radio_baseband_bandwidth_index = baseband_bandwidth_index;
    return ok();
}

bool sample_rssi(float duration_seconds) {
    return ok();
}

bool inquiry(int inquiry_index) {
    switch (inquiry_index) {
        case 0:
            printf("FSK Receiver and Decoder HAT for Raspberry Pi\n");
            break;
        case 1:
            printf("Sixty North AS\n");
            break;
        default:
            return error(ERROR_INDEX_OUT_OF_BOUNDS);
    }
    return ok();
}