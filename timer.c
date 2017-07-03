#include <time.h>
#include <stdio.h>

int main()
{
    clock_t tic = clock();

    // do things here
    printf("Hello World.");

    clock_t toc = clock();

    printf("Elapsed: %f seconds\n", (double)(toc - tic) / CLOCKS_PER_SEC);

    return 0;
}
