#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <math.h>

#define KIND_VALUE 0
#define KIND_LIST 1

typedef struct {
  int kind;
  void* value; // either int* or Packet*
  size_t size; // 1 if kind is value
} Packet;

char* stringify(Packet* p) {
  char* string = calloc(1000, sizeof(char));
  if(p->kind == KIND_VALUE) {
    sprintf(string, "%d", *(int*)(p->value));
  } else {
    size_t sz = p->size;
    if(sz == 0) {
      return "[]";
    }
    string[0] = '[';
    Packet** list = (Packet**)p->value;
    for(int i = 0;i < sz-1;i++) {

      strcat(string, stringify(list[i]));
      strcat(string, ",");
    }
    strcat(string, stringify(list[sz-1]));
    strcat(string, "]");
  }
  return string;
}

size_t find_comma_locations(char* line, int* loc_array) {
  int csz = 0;
  int bracket_depth = 0;
  int lsz = strlen(line);
  for(int i = 0;i < lsz;i++) {
    if(line[i] == '[') {
      bracket_depth++;
    } else if(line[i] == ',' && bracket_depth == 1) {
      loc_array[csz++] = i;
    } else if(line[i] == ']') {
      bracket_depth--;
    }
  }
  return csz;
}

size_t split_by_locations(char* line, int* loc_array, int loc_sz, char** parts) {
  int psz = 0;
  if(loc_sz == 0) {
    // return a trimmed line
    parts[0] = calloc(1000, sizeof(char));
    memcpy(parts[0], line+1, strlen(line)-2);
    return 1;
  }
  // add the first one manually
  parts[psz] = calloc(1000, sizeof(char));
  int len = loc_array[0] - 1;
  memcpy(parts[psz++], line+1, len);
  for(int i = 1;i < loc_sz;i++) {
    len = loc_array[i] - (loc_array[i-1]+1);
    parts[psz] = calloc(1000, sizeof(char));
    memcpy(parts[psz++], line+loc_array[i-1]+1, len);
  }
  len = (strlen(line)-1) - (loc_array[loc_sz-1]+1);
  parts[psz] = calloc(1000, sizeof(char));
  memcpy(parts[psz++], line+loc_array[loc_sz-1]+1, len);

  return psz;
}

void parse(char* line, Packet* p) {
  if(strcmp(line, "[]") == 0) {
    p->kind = KIND_LIST;
    p->value = NULL;
    p->size = 0;
    return ;
  }

  if(line[0] == '[') {
    p->kind = KIND_LIST;
    p->value = calloc(1000, sizeof(Packet*));
    int* comma_locs = calloc(1000, sizeof(int));
    size_t comma_count = find_comma_locations(line, comma_locs);
    char** parts = calloc(1000, sizeof(char*));
    size_t parts_count = split_by_locations(line, comma_locs, comma_count, parts);
    for(int i = 0;i < parts_count;i++) {
      Packet* inner_packet = calloc(1, sizeof(Packet));
      parse(parts[i], inner_packet);
      ((Packet**)(p->value))[i] = inner_packet;
      p->size = parts_count;
    }
    return ;
  } else {
    // is value
    p->kind = KIND_VALUE;
    int* value = calloc(1, sizeof(int));
    *value = atoi(line);
    p->value = value;
    p->size = 1;
    return ;
  }
}

Packet* convert_to_subpacket(int v) {
  Packet* p = calloc(1, sizeof(Packet));
  p->kind = KIND_LIST;
  Packet** pl = calloc(1, sizeof(Packet*));
  p->size = 1;
  Packet* inner_p = calloc(1, sizeof(Packet));
  inner_p->kind = KIND_VALUE;
  inner_p->value = calloc(1, sizeof(int));
  *(int*)(inner_p->value) = v;
  inner_p->size = 1;

  pl[0] = inner_p;
  p->value = pl;
//  printf("wrapped value: %s\n", stringify(p));
  return p;
}

int compare(const Packet* first, const Packet* second) {
  if(first->kind == KIND_VALUE && second->kind == KIND_VALUE) {
    int* fv = first->value;
    int* sv = second->value;
    if(*fv < *sv) {
      return -1;
    } else if(*fv > *sv) {
      return 1;
    } else {
      return 0;
    }
  } else if(first->kind == KIND_LIST && second->kind == KIND_LIST) {
    size_t fL = first->size;
    size_t sL = second->size;
    int tiebreaker = 0;
    if(fL < sL) {
      tiebreaker = -1;
    } else if(sL < fL) {
      tiebreaker = 1;
    }
    int l = (fL < sL) ? fL : sL;
    Packet** f = (Packet**)first->value;
    Packet** s = (Packet**)second->value;
    for(int i = 0;i < l;i++) {
      int cmp = compare(f[i], s[i]);
      if(cmp != 0) {
        return cmp;
      }
    }
    return tiebreaker;
  } else {
    // heterogeneous
    if(first->kind == KIND_VALUE) {
      Packet* fl = convert_to_subpacket(*(int*)(first->value));
      return compare(fl, second);
    } else {
      Packet* sl = convert_to_subpacket(*(int*)(second->value));
      return compare(first, sl);
    }
  }
}

int void_compare(const void* v1, const void* v2) {
//  printf("comparing %s vs %s\n", stringify(v1), stringify(v2));
  return compare(*(Packet**)v1, *(Packet**)v2);
}

int main(int argc, char** argv) {
  // the bulk of this reader code is STOLEN from MYSELF from LAST YEAR, and now also THIS YEAR
  char* filename = argv[1];

  FILE* fd = fopen(filename, "r"); // open input for reading

  // this is advent of code, so assume there are values and assume the input is correct
  char* line = NULL;
  size_t len = 0;
  ssize_t read;
  Packet** packets = calloc(1000, sizeof(Packet*));

  // line is obviously the line, len is the line's capacity (null means will allocate)
  // read is number of bytes read
  int pc = 0;
  while((read = getline(&line, &len, fd)) != -1) {
    // trim newline
    line[strlen(line)-1] = '\0';

    // skip blanks
    if(strlen(line) < 2) {
      continue;
    }

    Packet* p = (Packet*)calloc(1, sizeof(Packet));
    parse(line, p);
    packets[pc] = p;
    pc++;
  }

  int sum = 0;
  for(int i = 0;i < pc;i+=2) {
    Packet* first = packets[i];
    Packet* second = packets[i+1];
//    printf("compare: %s, %s\n",stringify(first), stringify(second) );
    int c = compare(first, second);
//    printf("compare: %s, %s: %d\n", stringify(first), stringify(second), c);
    if(compare(first, second) == -1) {
      sum += i/2 + 1;
    }
  }
  printf("%d\n", sum);

  Packet* two = calloc(1, sizeof(Packet));
  Packet* six = calloc(1, sizeof(Packet));
  parse("[[2]]", two);
  parse("[[6]]", six);
  packets[pc++] = two;
  packets[pc++] = six;
  qsort(packets, pc, sizeof(Packet*), void_compare);

  int key = 1;
  for(int i = 0;i < pc;i++) {
    char* val = stringify(packets[i]);
    if(strcmp(val, "[[2]]") == 0 || strcmp(val, "[[6]]") == 0) {
      key *= i + 1;
    }
  }
  printf("%d\n", key);
}