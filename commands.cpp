//
// Created by Robert Smallshire on 2016-10-30.
//

#include "commands.hpp"

const int NUM_FREQ_TEXT = 4;

const char* FREQ_TEXT[] = {"433.2", "433.3", "433.4", "433.5" };

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


/**
 * Request a mapping of integer frequency indexes to frequencies.
 * @return true
 */
bool list_frequencies() {
    for (int i = 0; i < NUM_FREQ_TEXT; ++i) {
        printf("%d %s\n", i, FREQ_TEXT[i]);
    }
    return ok();
}

/**
 *
 * @return
 */
bool get_frequency() {
    printf("%d", radio_frequency_index);
    return ok();
}

bool set_frequency(int frequency_index) {
    if ((frequency_index < 0) || (frequency_index >= NUM_FREQ_TEXT)) {
        return error(ERROR_INDEX_OUT_OF_BOUNDS);
    }
    radio_frequency_index = frequency_index;
    return ok();
}