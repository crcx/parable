/* parable language
 * copyright (c)2013, charles childers
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "bytecodes.h"
#include "types.h"

int compile(char *, int);
int request_slice();
void release_slice(int);
void interpret(int slice);

void stack_push(double, double);
double stack_pop();
void stack_swap();
void stack_over();
void stack_tuck();
double stack_depth();
void add_definition(char *name, int slice);


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
    while (o < l)
    {
        store((double) string[o], s, o);
        o++;
    }
    return s;
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


/*  Byte Code Interpreter  */

void interpret(int slice)
{
    int a, b, c, x, y, z;
    int offset = 0;
    char reform[1024];
    double scratch;
    char *output = malloc(1024);
    char *foo;

    while (offset < 1024)
    {
        switch ((int) slices[slice][offset])
        {
            case BC_PUSH_N:
                offset++;
                stack_push(slices[slice][offset], TYPE_NUMBER);
                break;
            case BC_PUSH_S:
                offset++;
                stack_push(slices[slice][offset], TYPE_STRING);
                break;
            case BC_PUSH_C:
                offset++;
                stack_push(slices[slice][offset], TYPE_CHARACTER);
                break;
            case BC_PUSH_F:
                offset++;
                stack_push(slices[slice][offset], TYPE_FUNCTION);
                break;
            case BC_PUSH_COMMENT:
                offset++;
                break;
            case BC_TYPE_N:
                a = tos_type();
                if (a == TYPE_STRING)
                {
                    b = stack_pop();
                    memset(reform, '\0', 1024);
                    memcpy(reform, slice_to_string(b), strlen(slice_to_string(b)));
                    scratch = (double) atof(reform);
                    stack_push(scratch, TYPE_NUMBER);
                }
                else
                    types[sp - 1] = TYPE_NUMBER;
                break;
            case BC_TYPE_S:
                a = tos_type();
                if (a == TYPE_NUMBER)
                {
                    sprintf(output, "%f", stack_pop());
                    stack_push(string_to_slice(output), TYPE_STRING);
                }
                if (a == TYPE_CHARACTER)
                {
                    output[0] = (char) stack_pop();
                    output[1] = '\0';
                    stack_push(string_to_slice(output), TYPE_STRING);
                }
                if (a == TYPE_FUNCTION)
                {
                    types[sp - 1] = TYPE_STRING;
                }
                if (a == TYPE_FLAG)
                {
                    b = stack_pop();
                    if (b == -1)
                        stack_push(string_to_slice("true"), TYPE_STRING);
                    else if (b == 0)
                        stack_push(string_to_slice("false"), TYPE_STRING);
                    else
                        stack_push(string_to_slice("malformed flag"), TYPE_STRING);
                }
                break;
            case BC_TYPE_C:
                a = tos_type();
                if (a == TYPE_STRING)
                {
                    foo = slice_to_string(stack_pop());
                    stack_push((float) foo[0], TYPE_CHARACTER);
                }
                types[sp - 1] = TYPE_CHARACTER;
                break;
            case BC_TYPE_F:
                break;
            case BC_TYPE_FLAG:
                a = tos_type();
                if (a == TYPE_STRING)
                {
                    b = stack_pop();
                    if (strcmp(slice_to_string(b), "true") == 0)
                        stack_push(-1, TYPE_FLAG);
                    else if (strcmp(slice_to_string(b), "false") == 0)
                        stack_push(0, TYPE_FLAG);
                    else
                        stack_push(1, TYPE_FLAG);
                }
                else
                    types[sp - 1] = TYPE_FLAG;
                break;
            case BC_GET_TYPE:
                stack_push(tos_type(), TYPE_NUMBER);
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
            case BC_REMAINDER:
                a = stack_pop();
                b = stack_pop();
                stack_push(b % a, TYPE_NUMBER);
                break;
            case BC_FLOOR:
                stack_push(floor(stack_pop()), TYPE_NUMBER);
                break;
            case BC_BITWISE_SHIFT:
                a = stack_pop();
                b = stack_pop();
                if (a < 0)
                    stack_push((float) ((int) b << (int) a), TYPE_NUMBER);
                else
                    stack_push((float) ((int) b >> (int) a), TYPE_NUMBER);
                break;
            case BC_BITWISE_AND:
                a = stack_pop();
                b = stack_pop();
                stack_push((float) ((int) b & (int) a), TYPE_NUMBER);
                break;
            case BC_BITWISE_OR:
                a = stack_pop();
                b = stack_pop();
                stack_push((float) ((int) b | (int) a), TYPE_NUMBER);
                break;
            case BC_BITWISE_XOR:
                a = stack_pop();
                b = stack_pop();
                stack_push((float) ((int) b ^ (int) a), TYPE_NUMBER);
                break;
            case BC_COMPARE_LT:
                a = stack_pop();
                b = stack_pop();
                if (b < a)
                    stack_push(-1, TYPE_FLAG);
                else
                    stack_push(0, TYPE_FLAG);
                break;
            case BC_COMPARE_GT:
                a = stack_pop();
                b = stack_pop();
                if (b > a)
                    stack_push(-1, TYPE_FLAG);
                else
                    stack_push(0, TYPE_FLAG);
                break;
            case BC_COMPARE_LTEQ:
                a = stack_pop();
                b = stack_pop();
                if (b <= a)
                    stack_push(-1, TYPE_FLAG);
                else
                    stack_push(0, TYPE_FLAG);
                break;
            case BC_COMPARE_GTEQ:
                a = stack_pop();
                b = stack_pop();
                if (b >= a)
                    stack_push(-1, TYPE_FLAG);
                else
                    stack_push(0, TYPE_FLAG);
                break;
            case BC_COMPARE_EQ:
                a = tos_type();
                b = stack_pop();
                x = tos_type();
                y = stack_pop();
                if (a == TYPE_STRING && x == TYPE_STRING)
                {
                    if (strcmp(slice_to_string(b), slice_to_string(y)) == 0)
                        stack_push(-1, TYPE_FLAG);
                    else
                        stack_push(0, TYPE_FLAG);
                }
                else if (a == x)
                {
                    if (b == y)
                        stack_push(-1, TYPE_FLAG);
                    else
                        stack_push(0, TYPE_FLAG);
                }
                else
                {
                    offset = 1024;
                    printf("ERROR: types do not match\n");
                }
                break;
            case BC_COMPARE_NEQ:
                a = tos_type();
                b = stack_pop();
                x = tos_type();
                y = stack_pop();
                if (a == TYPE_STRING && x == TYPE_STRING)
                {
                    if (strcmp(slice_to_string(b), slice_to_string(y)) != 0)
                        stack_push(-1, TYPE_FLAG);
                    else
                        stack_push(0, TYPE_FLAG);
                }
                else if (a == x)
                {
                    if (b != y)
                        stack_push(-1, TYPE_FLAG);
                    else
                        stack_push(0, TYPE_FLAG);
                }
                else
                {
                    offset = 1024;
                    printf("ERROR: types do not match\n");
                }
                break;
            case BC_FLOW_IF:
                break;
            case BC_FLOW_WHILE:
                break;
            case BC_FLOW_UNTIL:
                break;
            case BC_FLOW_TIMES:
                a = stack_pop();
                b = stack_pop();
                while (b > 0)
                {
                    interpret(a);
                    b--;
                }
                break;
            case BC_FLOW_CALL:
                offset++;
                interpret((int) fetch(slice, offset));
                break;
            case BC_FLOW_CALL_F:
                interpret(stack_pop());
                break;
            case BC_FLOW_DIP:
                break;
            case BC_FLOW_SIP:
                break;
            case BC_FLOW_BI:
                break;
            case BC_FLOW_TRI:
                break;
            case BC_FLOW_RETURN:
                offset = 1024;
                break;
            case BC_MEM_COPY:
                break;
            case BC_MEM_FETCH:
                a = stack_pop();
                b = stack_pop();
                stack_push(fetch(b, a), TYPE_NUMBER);
                break;
            case BC_MEM_STORE:
                a = stack_pop();
                b = stack_pop();
                c = stack_pop();
                store(c, b, a);
                break;
            case BC_MEM_REQUEST:
                stack_push(request_slice(), TYPE_FUNCTION);
                break;
            case BC_MEM_RELEASE:
                release_slice(stack_pop());
                break;
            case BC_MEM_COLLECT:
                break;
            case BC_STACK_DUP:
                break;
            case BC_STACK_DROP:
                stack_pop();
                break;
            case BC_STACK_SWAP:
                stack_swap();
                break;
            case BC_STACK_OVER:
                break;
            case BC_STACK_TUCK:
                break;
            case BC_STACK_NIP:
                stack_swap();
                stack_pop();
                break;
            case BC_STACK_DEPTH:
                stack_push(sp, TYPE_NUMBER);
                break;
            case BC_STACK_CLEAR:
                sp = 0;
                break;
            case BC_QUOTE_NAME:
                a = stack_pop();
                b = stack_pop();
                add_definition(slice_to_string(a), (int) b);
                break;
            case BC_STRING_SEEK:
                break;
            case BC_STRING_SUBSTR:
                break;
            case BC_STRING_NUMERIC:
                break;
            case BC_TO_LOWER:
                break;
            case BC_TO_UPPER:
                break;
            case BC_LENGTH:
                break;
            case BC_REPORT_ERROR:
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
    int s = request_slice();
    compile(def, s);
    add_definition("define", s);
}


int lookup_definition(char *name)
{
    int slice = -1;
    int n = namep;
    while (n > 0)
    {
        n--;
        if (strcmp(names[n], name) == 0)
            slice = pointers[n];
    }
    return slice;
}


/*  Compiler  */
int compile_cell(double value, int slice, int offset)
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

    for (token = strtok_r(source, " ", &state); token != NULL; token = strtok_r(NULL, " ", &state))
    {
        prefix = (char)token[0];
        switch (prefix)
        {
            case '\'':
                if (token[strlen(token) - 1] == '\'')
                {
                    memset(reform, '\0', 1024);
                    memcpy(reform, &token[1], strlen(token) - 2);
                    reform[strlen(token) - 2] = '\0';
                    o = compile_cell(BC_PUSH_S, s, o);
                    o = compile_cell((double) string_to_slice(reform), s, o);
                }
                else
                    printf("multi token string parser not implemented\n");
                break;
            case '"':
                if (token[strlen(token) - 1] == '"')
                {
                    memset(reform, '\0', 1024);
                    memcpy(reform, &token[1], strlen(token) - 2);
                    reform[strlen(token) - 2] = '\0';
                    o = compile_cell(BC_PUSH_COMMENT, s, o);
                    o = compile_cell((double) string_to_slice(reform), s, o);
                }
                else
                    printf("multi token comment parser not implemented\n");
                break;
            case '#':
                memset(reform, '\0', 1024);
                memcpy(reform, &token[1], strlen(token));
                scratch = (double) atof(reform);
                o = compile_cell(BC_PUSH_N, s, o);
                o = compile_cell(scratch, s, o);
                break;
            case '&':
                /* TODO: named pointers */
                memset(reform, '\0', 1024);
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
                memset(reform, '\0', 1024);
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
        if (types[sp] == TYPE_FLAG)
        {
            if (data[sp] == -1)
                printf("true\n");
            else if (data[sp] == 0)
                printf("false\n");
            else
                printf("malformed flag\n");
        }
        if (types[sp] == TYPE_STRING)
        {
            printf("'%s'\n", slice_to_string(data[sp]));
        }
    }
}

int main()
{
    int s, o;
    char name[] = "+";
    sp = 0;
    prepare_dictionary();
    parse_bootstrap("bootstrap.p");
    parse_bootstrap("test.p");
    dump_stack();
/*
    while (namep > 0)
    {
        namep--;
        printf("%s-%i  ", names[namep], pointers[namep]);
    }
    printf("\n");
*/
    return 0;
}
