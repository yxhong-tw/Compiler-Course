#include "stdio.h"
#include <stdlib.h>
#include "string.h"

typedef struct List {
    int size;
    char** items;
    int maxSize;
}my_list;

// In case, [1,2,3][1:2], the Slice's startIndex=1, endIndex=2, hasStartIndex=1, hasEndIndex=1, step=1
// In case, [1,2,3][:2], the Slice's endIndex=2, hasStartIndex=0, hasEndIndex=1, step=1
// In case, [1,2,3][1::5], the Slice's startIndex=1, hasStartIndex=1, hasEndIndex=0, step=5
typedef struct Slice {
    int startIndex;
    int endIndex;
    int hasStartIndex;
    int hasEndIndex;
    int step;
}my_slice;

my_list* create_list() {
    const int maxSize = 10000;
    my_list* list = malloc(sizeof(my_list));
    list->items = malloc(sizeof(char*)*maxSize);
    list->size = 0;
    list->maxSize = maxSize;
    return list;
}


int append_last(my_list* list, char* c) {
    list->items[list->size] = malloc((strlen(c)+1) * sizeof(char));
    strcpy(list->items[list->size], c);
    list->size+=1;
    return list->size;
}

int append_head(my_list* list, char* c) {
    int i;
    for (i = list->size-1; i > -1 ; i--) {
        list->items[i+1] = list->items[i];
    }
    list->items[0] = malloc((strlen(c)+1) * sizeof(char));
    strcpy(list->items[0], c);
    list->size+=1;
    return list->size;
}

my_list* concat_list(my_list* first_list , my_list* second_list) {
    my_list* new_list = create_list();
    int i;
    for(i = 0; i < first_list->size; i++) {
        append_last(new_list, first_list->items[i]);
    }
    for(i = 0; i < second_list->size; i++) {
        append_last(new_list, second_list->items[i]);
    }
    return new_list;
}

my_list* repeat_list(my_list* list , int repeat_num) {
    my_list* new_list = create_list();
    // if repeat num <= 0, list would be empty
    int ori_size = list->size;
    if (repeat_num <= 0) {
        return new_list;
    }
    int r; 
    int i;
    for (r = 0 ; r < repeat_num ; r++) {
        for(i =0; i < ori_size; i++) {
            append_last(new_list, list->items[i]);
        }
    }
    return new_list;
}

void print_list(my_list* list) {
    printf("[");
    int i;
    for (i = 0 ; i < list->size ; i++ ) {
        printf("%s", list->items[i]);
        if (i != list->size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

my_list* create_list_slice(my_list* list, my_slice* slice) {
    int start_index = slice->hasStartIndex?slice->startIndex:0;
    int end_index = slice->hasEndIndex?slice->endIndex:list->size;
    if (start_index < 0 ) {
        start_index += list->size;
    }
    if (end_index < 0) {
        end_index += list->size;
    }

    if (start_index < 0) {
        start_index = 0;
    }
    
    if (end_index < 0) {
        end_index = 0;
    }

    int len = end_index - start_index;
    if (end_index > list->size) {
        end_index = list->size;
    }
    if (start_index > list->size) {
        end_index = list->size;
    }
    my_list* new_list = create_list();
    int i;
    for(i = start_index; i < end_index ; i+=slice->step) {
        append_last(new_list, list->items[i]);
    }
    return new_list;
}


int main() {
    my_list* list = create_list();
    my_list* list2 = create_list();
    my_list* list3;
    append_last(list, "12");
    append_last(list, "2");
    append_head(list, "5");
    append_head(list, "2");
    append_head(list2, "55");
    print_list(list);
    print_list(list2);
    list3 = concat_list(list, list2);
    print_list(list3);
    my_slice slice; 
    slice.hasStartIndex = 1;
    slice.hasEndIndex = 1;
    slice.startIndex = 1;
    slice.endIndex = -2;
    slice.step = 1;
    // for case [2, 5, 12, 2][1:-2:1]
    print_list(create_list_slice(list, &slice)); 
    slice.hasStartIndex = 1;
    slice.startIndex = 1;
    slice.hasEndIndex = 0;
    // for case [2, 5, 12, 2][1:]
    print_list(create_list_slice(list, &slice));
    return 0;
}