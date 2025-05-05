#include <stdio.h>
#include <unistd.h>

int main(void) {
    printf("Hello from printf!\n");
    write(1, "Hello from write!\n", 18);
    return 0;
}
