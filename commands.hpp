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

enum Error { ERROR_INDEX_OUT_OF_BOUNDS,

             ERROR_END,
             ERROR_BEGIN = ERROR_INDEX_OUT_OF_BOUNDS };


extern const char* error_messages[ERROR_END];

bool ok();
bool error(int error_id);

bool list_frequencies();
bool get_frequency();
bool set_frequency(int frequency_index);




#endif //ATCOMMANDS_COMMANDS_HPP
