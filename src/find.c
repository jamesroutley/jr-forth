#include <stdio.h>
#include <strings.h>
#include <stdint.h>

struct Entry {
    struct Entry *link_address;
    unsigned char immediate_flag;
    char name[10];
    void *code;
};


int findC(unsigned int *xt, struct Entry *latest, char *name) {
    while (1) {
        if (strcasecmp(name, latest->name) == 0) {
            *xt = &latest->code;
            return 0;
        }
        if (latest->link_address == 0) {
            printf("Not Found\n");
            *xt = &name;
            return 1;
        }
        latest = latest->link_address;
    }
}
