/* parable language
 * copyright (c)2013, charles childers
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "bytecodes.h"
#include "types.h"

int compile(char *, int);
int request_slice();
void release_slice(int);

void stack_push(double, double);
double stack_pop();
void stack_swap();
void stack_over();
void stack_tuck();
double stack_depth();


/*  Memory Manager  */

double slices[10000][1024];
int slice_map[10000];

int request_slice()
{
    int offset = 0;
    while (offset < 10000)
    {
        if (slice_map[offset] == 0)
        {
            slice_map[offset] = 1;
            return offset;
        }
        offset++;
    }
    return -1;
}


void release_slice(int slice)
{
    slice_map[slice] = 0;
}


double fetch(int s, int o)
{
    return slices[s][o];
}

void store(double v, int s, int o)
{
    slices[s][o] = v;
}

char *slice_to_string(int s)
{
    char *string = malloc(1024);
    int o = 0;

    while (fetch(s, o) != 0)
    {
        string[o] = (char) fetch(s, o);
        o++;
    }
    return string;
}

int string_to_slice(char *string)
{
    int s = request_slice();
    int o = 0;
    int l = strlen(string);
    while (o > l)
    {
        store(string[o], s, o);
        o++;
    }
}


/*  Data Stack  */

double data[64000];
double types[64000];
int sp;

void stack_push(double value, double type)
{
    data[sp] = value;
    types[sp] = type;
    sp++;
}


double stack_pop()
{
    sp--;
    return data[sp];
}


void stack_swap()
{
    double x, y, xt, yt;
    xt = types[sp - 1];
    x  = data[sp - 1];
    yt = types[sp - 2];
    y  = data[sp - 2];
    data[sp - 2] = x;
    types[sp - 2] = xt;
    data[sp - 1] = y;
    types[sp - 1] = yt;
}


double tos_type()
{
    return types[sp - 1];
}


double nos_type()
{
    return types[sp - 2];
}


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


void parse_bootstrap()
{
    char source[64000];

    FILE *fp;

    fp = fopen("bootstrap.p", "r");
    if (fp == NULL)
        return;

    while (!feof(fp))
    {
        read_line(fp, source);
        compile(source, request_slice());
    }

    fclose(fp);
}


/*  Byte Code Interpreter  */

void interpret(int slice)
{
    int a, b, c, x, y, z;
    int offset = 0;
    while (offset < 1024)
    {
        switch ((int) slices[slice][offset])
        {
            case BC_PUSH_N:
                offset++;
                stack_push(slices[slice][offset], TYPE_NUMBER);
                break;
            case BC_PUSH_C:
                offset++;
                stack_push(slices[slice][offset], TYPE_CHARACTER);
                break;
            case BC_PUSH_S:
                offset++;
                stack_push(slices[slice][offset], TYPE_STRING);
                break;
            case BC_PUSH_F:
                offset++;
                stack_push(slices[slice][offset], TYPE_FUNCTION);
                break;
            case BC_FLOW_CALL:
                offset++;
                interpret((int)slices[slice][offset]);
                break;
            case BC_PUSH_COMMENT:
                offset++;
                break;
            case BC_FLOW_RETURN:
                offset = 1024;
                break;
            case BC_ADD:
                if (tos_type() == TYPE_NUMBER && nos_type() == TYPE_NUMBER)
                {
                    a = stack_pop();
                    b = stack_pop();
                    stack_push(b + a, TYPE_NUMBER);
                }
                else if (tos_type() == TYPE_STRING && nos_type() == TYPE_STRING)
                {
                    a = stack_pop();
                    b = stack_pop();
                    stack_push(0, TYPE_NUMBER);
                    printf("WARNING: string concatenation not supported yet\n");
                }
                else
                {
                    printf("BC_ADD only works for NUMBER and STRING types\n");
                    a = stack_pop();
                    b = stack_pop();
                    offset = 1024;
                }
                break;
            case BC_SUBTRACT:
                a = stack_pop();
                b = stack_pop();
                stack_push(b - a, TYPE_NUMBER);
                break;
            case BC_MULTIPLY:
                a = stack_pop();
                b = stack_pop();
                stack_push(b * a, TYPE_NUMBER);
                break;
            case BC_DIVIDE:
                a = stack_pop();
                b = stack_pop();
                stack_push(b / a, TYPE_NUMBER);
                break;
            case BC_STACK_SWAP:
                stack_swap();
                break;
            case BC_STACK_DROP:
                stack_pop();
                break;
            case BC_STACK_NIP:
                stack_swap();
                stack_pop();
                break;
        }
        offset++;
    }
}




/*  Dictionary  */
char names[10000][1024];
int pointers[10000];
int namep;

void add_definition(char *name, int slice)
{
    strcpy(names[namep], name);
    pointers[namep] = slice;
    namep++;
}


void prepare_dictionary()
{
    namep = 0;
    char def[] = "`600";
    char def2[] = "`200";
    int s = request_slice();
    compile(def, s);
    add_definition("define", s);
    s = request_slice();
    compile(def2, s);
    add_definition("+", s);
}


int lookup_definition(char *name)
{
    int slice = -1;
    int n = namep;
    while (n > 0)
    {
        n--;
        if (strcmp(names[n], name) == 0)
            slice = n;
    }
    return slice;
}


/*  Compiler  */
int compile_cell(float value, int slice, int offset)
{
    slices[slice][offset] = value;
    offset++;
    return offset;
}


int compile(char *source, int s)
{
    char *token;
    char *state;
    char prefix;
    char reform[1024];
    double scratch;
    int o = 0;
    int nest[1024];
    int nest_o[1024];
    int np = 0;
    int current = s;

    printf("-------------------\n");
    for (token = strtok_r(source, " ", &state); token != NULL; token = strtok_r(NULL, " ", &state))
    {
        prefix = (char)token[0];
        switch (prefix)
        {
            case '\'':
                printf("string parser not implemented\n");
                break;
            case '"':
                printf("comment parser not implemented\n");
                break;
            case '#':
                memcpy(reform, &token[1], strlen(token));
                scratch = (double) atof(reform);
                o = compile_cell(BC_PUSH_N, s, o);
                o = compile_cell(scratch, s, o);
                break;
            case '&':
                /* TODO: named pointers */
                memcpy(reform, &token[1], strlen(token));
                scratch = (double) atof(reform);
                o = compile_cell(BC_PUSH_F, s, o);
                o = compile_cell(scratch, s, o);
                break;
            case '$':
                scratch = (double) token[1];
                o = compile_cell(BC_PUSH_C, s, o);
                o = compile_cell(scratch, s, o);
                break;
            case '`':
                memcpy(reform, &token[1], strlen(token));
                scratch = (double) atof(reform);
                o = compile_cell(scratch, s, o);
                break;
            case '[':
                nest[np] = s;
                nest_o[np] = o;
                s = request_slice();
                o = 0;
                np++;
                break;
            case ']':
                o = compile_cell(BC_FLOW_RETURN, s, o);
                current = s;
                np--;
                s = nest[np];
                o = nest_o[np];
                o = compile_cell(BC_PUSH_F, s, o);
                o = compile_cell(current, s, o);
                break;
            default:
                if (lookup_definition(token) != -1)
                {
                    o = compile_cell(BC_FLOW_CALL, s, o);
                    o = compile_cell(lookup_definition(token), s, o);
                }
                else
                    printf("function %s not found\n", token);
                break;
        }
    }
    return s;
}



/*  main() - to be moved to a separate file later  */

void dump_stack()
{
    while (sp > 0)
    {
        printf("%i: ", sp);
        sp--;
        if (types[sp] == TYPE_CHARACTER)
            printf("$%c\n", (char)data[sp]);
        if (types[sp] == TYPE_NUMBER)
            printf("#%f\n", data[sp]);
        if (types[sp] == TYPE_FUNCTION)
            printf("&%f\n", data[sp]);
        if (types[sp] == TYPE_STRING)
        {
            printf("'%s'\n", slice_to_string(data[sp]));
        }
    }
}

int main()
{
    int s, o;
    sp = 0;
    char test[] = "$a $1 [ #2 #3 ] #100 #200 + #-45.44 [ 'hello' ]";
    prepare_dictionary();
//    parse_bootstrap();
    s = request_slice();
    compile(test, s);
    interpret(s);
    s = request_slice();
    o = 0;
    o = compile_cell(98, s, o);
    o = compile_cell(99, s, o);
    o = compile_cell(100, s, o);
    o = compile_cell(0, s, o);
    stack_push(s, TYPE_STRING);
    dump_stack();
    return 0;
}
