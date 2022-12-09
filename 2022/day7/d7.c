#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct directory {
  char* name;
  struct directory* children;
  int child_count;
  struct directory* parent;
  struct file* files;
  int file_count;
};

struct file {
  char* name;
  int size;
};

int size(struct directory* d) {
  // size of myself
  int sz = 0;
  for(int i = 0;i < d->file_count;i++) {
    sz+= d->files[i].size;
  }

  // size of children
  for(int i = 0;i < d->child_count;i++) {
    sz+= size(&(d->children[i]));
  }

  return sz;
}

int p1(struct directory* d) {
  int p1_sizes = 0;
  for(int i = 0;i < d->child_count;i++) {
    p1_sizes += p1(&(d->children[i]));
  }

  int sz = size(d);
  if(sz < 100000) {
    p1_sizes += sz;
  }

  return p1_sizes;
}

void p2_list(int** sizes, int* sizes_size, struct directory* d) {
  // this always adds to the end b/c it's adventofcode
  int sz = (*sizes_size);
  *sizes = (int*)realloc(*sizes, sizeof(int)*(sz+1));
  (*sizes)[sz] = size(d);
  (*sizes_size) = sz+1;
  for(int i = 0;i < d->child_count;i++) {
    p2_list(sizes, sizes_size, &(d->children[i]));
  }
}

int p2(struct directory* d) {
  int* sizes = NULL;
  int* sizes_size = calloc(1, sizeof(int));
  p2_list(&sizes, sizes_size, d);

  int needed = 30000000 - (70000000 - size(d));
  int smallest_largest = 70000000; // some random value
  for(int i = 0;i < (*sizes_size);i++) {
    if(sizes[i] > needed && sizes[i] < smallest_largest) {
      smallest_largest = sizes[i];
    }
  }

  return smallest_largest;
}

struct directory* find_child(char* name, struct directory* children, size_t sz) {
  for(int i = 0;i < sz;i++) {
    if(strcmp(children[i].name, name) == 0) {
      return &children[i];
    }
  }

  return NULL;
}

int main() {
  // the bulk of this code is STOLEN from MYSELF from LAST YEAR, and now also THIS YEAR

  FILE* fd = fopen("/Users/kpcraig/workspace/advent/2022/day7/input", "r"); // open input for reading

  // this is advent of code, so assume there are values and assume the input is correct
  char* line = NULL;
  size_t len = 0;
  ssize_t read;
  struct directory root = {
    .name= "/",
    .child_count = 0,
    .file_count = 0,
  };
  struct directory* curr = &root;
  while((read = getline(&line, &len, fd)) != -1) {
//    printf("%s", line);
//    char* line_trimmed = calloc(strlen(line), sizeof(char));
//    line_trimmed[strlen(line_trimmed)-1] = '\0';
    line[strlen(line)-1] = '\0';

    // figure out what kind of line this is
    char* lead = strtok(line, " ");
    if(strcmp(lead, "$") == 0) {
      // could be cd or ls
      char* ls_cd = strtok(NULL, " ");
      if(strcmp(ls_cd, "cd") == 0) {
        char* dirname = strtok(NULL, " ");
        // can be one of [new subdirectory], [/], or [..]
        if(strcmp(dirname, "/") == 0) {
          continue;
        } else if (strcmp(dirname, "..") == 0) {
          printf("up a directory\n");
          curr = curr->parent;
        } else {
          printf("down to %s\n", dirname);
          curr = find_child(dirname, curr->children, curr->child_count);
        }
      }
    } else if(strcmp(lead, "dir") == 0) {
      // is a new child directory
      char* dirname = strtok(NULL, " ");
      // i assure you i feel very guilty about this
      printf("creating %s\n", dirname);
      struct directory* cs = realloc(curr->children, (curr->child_count+1)*sizeof(struct directory));
      int idx = curr->child_count;
      cs[idx].name = calloc(strlen(dirname), sizeof(char));
      strcpy(cs[idx].name, dirname);
      cs[idx].child_count = 0;
      cs[idx].file_count = 0;
      cs[idx].children = NULL;
      cs[idx].files = NULL;
      cs[idx].parent = curr;
      curr->children = cs;
      curr->child_count++;
    } else {
      // is a file
      char* file_size = calloc(strlen(lead), sizeof(char));
      strcpy(file_size, lead);
      int sz = atoi(file_size);
      char* filename = strtok(NULL, " ");
      // i feel less guilty the second time
      struct file* fs = realloc(curr->files, (curr->file_count+1)*sizeof(struct file));
      int idx = curr->file_count;
      fs[curr->file_count].name = filename;
      fs[curr->file_count].size = sz;
      curr->files = fs;
      curr->file_count++;
    }
  }

  printf("size: %d\n", size(&root));
  printf("p1: %d\n", p1(&root));
  printf("p2: %d\n", p2(&root));
}