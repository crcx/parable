/* parable language
 * copyright (c)2013, charles childers
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

#include "config.h"
#include "prototypes.h"
#include "types.h"

extern char *errors;
extern double data[STACK_DEPTH];
extern double types[STACK_DEPTH];
extern int sp;

/*  Load and run bootstrap  */

void read_line(FILE *file, char *line_buffer)
{
    if (file == NULL)
    {
        printf("Error: file pointer is null.");
        exit(1);
    }

    if (line_buffer == NULL)
    {
        printf("Error allocating memory for line buffer.");
        exit(1);
    }

    char ch = getc(file);
    int count = 0;

    while ((ch != '\n') && (ch != EOF))
    {
        line_buffer[count] = ch;
        count++;
        ch = getc(file);
    }

    line_buffer[count] = '\0';
}


void parse_bootstrap(char *fname)
{
    char source[64000];

    FILE *fp;

    fp = fopen(fname, "r");
    if (fp == NULL)
        return;

    while (!feof(fp))
    {
        read_line(fp, source);
        interpret(compile(source, request_slice()));
    }

    fclose(fp);
}


void dump_stack()
{
    int x = 0;
    char p[STRING_LEN];

    while (x < sp)
    {
        if ((sp - 1) == x)
            printf("TOS");
        printf("\t%i\t", x);
        if (types[x] == TYPE_CHARACTER)
            printf("$%c\n", (char)data[x]);
        if (types[x] == TYPE_NUMBER)
            printf("#%f\n", data[x]);
        if (types[x] == TYPE_FUNCTION)
            printf("&%f\n", data[x]);
        if (types[x] == TYPE_FLAG)
        {
            if (data[x] == -1)
                printf("true\n");
            else if (data[x] == 0)
                printf("false\n");
            else
                printf("malformed flag\n");
        }
        if (types[x] == TYPE_STRING)
        {
            slice_to_string(data[x], p);
            printf("'%s'\n", p);
        }
        x++;
    }
}


int main(int argc, char **argv)
{
    sp = 0;
    prepare_dictionary();
    prepare_error_reporting();
    parse_bootstrap("bootstrap.p");
    if (argc > 1)
        parse_bootstrap(argv[1]);
    else
        printf("parable\n(c) 2013, charles childers\n\nTry:\n  %s filename\n", argv[0]);
    dump_stack();
    if (strlen(errors) > 0)
        printf("Error Log:\n%s\n", errors);
    end_error_reporting();
    return 0;
}
