#include <iostream>
#include <string>
#include <unistd.h>
#include "print.h"

void BMIK_MAIN() {
    print_clear();
    print_set_color(PRINT_COLOR_WHITE, PRINT_COLOR_BLACK);
    print_str("64-bit Kernel Initialized\n");
    print_str("Low-Level Assembly loading has passed.\n");
    print_str("C++ functionality is ready.\n");
    delay(6000);

    print_clear();
    print_str("Welcome to the Black Mesa Operating System.\n");
    print_str("This Operating System is for use by BMRF Personnel ONLY.\n");
    print_str("\n");
    print_str("Any unauthorized redistribution of BMRF software will result in termination.\n");
}

void delay(int milliseconds) {
    for (int i = 0; i < milliseconds; i++) {
        for (int j = 0; j < 100000; j++) {
            // Adjust the inner loop based on your system to approximate the desired delay
        }
    }
}