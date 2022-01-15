#include <stdio.h>
#include "string.h"

int main() {
    int a = 10;
    int *ap = &a;
    printf("%d", *ap);
    return 0;
}