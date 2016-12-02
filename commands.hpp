//
// Created by Robert Smallshire on 2016-10-30.
//

#ifndef ATCOMMANDS_COMMANDS_HPP
#define ATCOMMANDS_COMMANDS_HPP

#include <cstring>
#include <cstdlib>
#include <cstdio>

#include "radio.hpp"

extern const int NUM_FREQ_TEXT;

extern const char* FREQ_TEXT[];

extern bool quiet;
extern bool verbose;

enum Response {
    RESPONSE_OK = 0,
    RESPONSE_ERROR_BAD_COMMAND,
    RESPONSE_ERROR_INDEX_OUT_OF_BOUNDS,

    RESPONSE_ERROR_END,
    RESPONSE_ERROR_BEGIN = RESPONSE_ERROR_INDEX_OUT_OF_BOUNDS };


extern const char* response_messages[RESPONSE_ERROR_END];

bool ok();
bool response(int response_id);

bool quiet_on();
bool quiet_off();

bool verbose_numeric();
bool verbose_text();

bool list_frequencies();
bool get_frequency();
bool set_frequency(int frequency_index);

bool list_rssi_thresholds();
bool get_rssi_threshold();
bool set_rssi_threshold(int rssi_threshold_index);

bool list_lna_gains();
bool get_lna_gain();
bool set_lna_gain(int lna_gain_index);

bool list_baseband_bandwidths();
bool get_baseband_bandwidth();
bool set_baseband_bandwidth(int baseband_bandwidth_index);

bool sample_rssi(float duration_seconds);

bool inquiry(int inquiry_index);

#endif //ATCOMMANDS_COMMANDS_HPP
