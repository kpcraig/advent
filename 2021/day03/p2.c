#include <stdlib.h>
#include <stdio.h>

#define NUM_LENGTH 12 // in the input
#define FILENAME "input"

// #define FILENAME "sample"
// #define NUM_LENGTH 5 // in the sample 

struct node {
    int leaf_count;
    int value; // only valid for leaves.
    struct node* left;
    struct node* right;
};

void insert(struct node* head, char* value) {
    // dangerously assume we know the length of the string, or at least a number less than the length
    struct node* current = head; // please don't let this be null.
    current->leaf_count++;
    for(int i = 0;i < NUM_LENGTH;i++) {
        // we're picking left or right based on the current indexed value
        char v = value[i];
        if(v == '0') {
            if(current->left == NULL) {
                current->left = (struct node*)malloc(sizeof(struct node));
            }
            current = current->left;
        } else {
            if(current->right == NULL) {
                current->right = (struct node*)malloc(sizeof(struct node));
            }
            current = current->right;
        }
        current->leaf_count++;
    }

    char* ptr = NULL;
    current->value = strtoul(value, &ptr, 2);
}

// int descend_min(struct node* head);

int descend_min(struct node* head) {
    if(head->left == NULL && head->right == NULL) {
        return head->value;
    } else if(head->left == NULL) {
        return descend_min(head->right);
    } else if(head->right == NULL) {
        return descend_min(head->left);
    } else {
        // printf("%d vs %d\n", head->left->leaf_count, head->right->leaf_count);
        // fewer zeros or equal
        if(head->left->leaf_count <= head->right->leaf_count) {
            // printf("going left\n");
            return descend_min(head->left);
        } else {
            // printf("going right\n");
            return descend_min(head->right);
        }
    }
}

int descend_max(struct node* head) {
    if(head->left == NULL && head->right == NULL) {
        return head->value;
    } else if(head->left == NULL) {
        return descend_max(head->right);
    } else if(head->right == NULL) {
        return descend_max(head->left);
    } else {
        // more ones or equal
        // printf("%d vs %d\n", head->left->leaf_count, head->right->leaf_count);
        if(head->left->leaf_count <= head->right->leaf_count) {
            // printf("going right\n");
            return descend_max(head->right);
        } else {
            // printf("going left\n");
            return descend_max(head->left);
        }
    }
}

int main() {
    FILE* fd = fopen(FILENAME, "r"); // open input for reading

    ssize_t r;
    char* line = NULL;
    size_t len;
    struct node* head = malloc(sizeof(struct node));
    while((r = getline(&line, &len, fd)) != -1) {
        insert(head, line);
    }

    fclose(fd);

    int o = descend_max(head);
    int c = descend_min(head);

    printf("O2: %d\nCO2: %d\nAnswer: %d", o, c, o * c);

}