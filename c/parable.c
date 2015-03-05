/* parable language
 * copyright (c)2013, charles childers
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

#include "prototypes.h"
#include "bytecodes.h"
#include "types.h"
#include "config.h"

/*  Error Reporting */
char *errors;

void prepare_error_reporting()
{
    errors = malloc(SLICE_LEN);
    memset(errors, '\0', SLICE_LEN);
}

void report_error(char *string)
{
    strcat(errors, string);
}

void clear_errors()
{
    memset(errors, '\0', SLICE_LEN);
}

void end_error_reporting()
{
    free(errors);
}

/*  Memory Manager  */

double slices[MAX_SLICES][SLICE_LEN];
int slice_map[MAX_SLICES];

int request_slice()
{
    int offset = 0;
    int slice = -1;
    int i = 0;
    while (offset < MAX_SLICES && slice == -1)
    {
        if (slice_map[offset] == 0)
        {
            slice_map[offset] = 1;
            slice = offset;
        }
        offset++;
    }
    if (slice != -1)
    {
        while (i < SLICE_LEN)
        {
            store(0, slice, i);
            i++;
        }
    }
    return slice;
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

void copy_slice(int source, int dest)
{
    int i = 0;
    for (i = 0; i < SLICE_LEN; i++)
        store(fetch(source, i), dest, i);
}

void mem_collect()
{
    // TODO: implement memory scanner and garbage collection
    // TODO: routines. this is only necessary for programs with
    // TODO: long runtimes. (e.g., nothing in my current task set)
}

char *slice_to_string(int s, char *string)
{
    int o = 0;

    while (fetch(s, o) != 0)
    {
        string[o] = (char) fetch(s, o);
        o++;
    }
    string[o] = '\0';
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

double data[STACK_DEPTH];
double types[STACK_DEPTH];
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

void stack_dup()
{
    char s[STRING_LEN];
    char *p = s;
    double v = tos_type();
    if (v == TYPE_STRING)
    {
        v = data[sp - 1];
        slice_to_string(v, p);
        stack_push(string_to_slice(p), TYPE_STRING);
    }
    else
    {
        stack_push(data[sp - 1], v);
    }
}

void stack_over()
{
    char s[STRING_LEN];
    char *p = s;
    double v = types[sp - 2];
    if (v == TYPE_STRING)
    {
        v = data[sp - 2];
        slice_to_string(v, p);
        stack_push(string_to_slice(p), TYPE_STRING);
    }
    else
    {
        stack_push(data[sp - 2], v);
    }
}

void stack_tuck()
{
    char s[STRING_LEN];
    char *p = s;
    double v = tos_type();
    if (v == TYPE_STRING)
    {
        v = data[sp - 1];
        stack_swap();
        slice_to_string(v, p);
        stack_push(string_to_slice(p), TYPE_STRING);
    }
    else
    {
        stack_swap();
        stack_push(data[sp - 2], v);
    }
}

double tos_type()
{
    return types[sp - 1];
}


double nos_type()
{
    return types[sp - 2];
}


/*  Byte Code Interpreter  */

void interpret(int slice)
{
    int a, b, c, q, m, x, y, z;
    int i, j;
    double da, db;
    int offset = 0;
    char reform[STRING_LEN];
    double scratch;
    char *output;

    char foo[STRING_LEN];
    char bar[STRING_LEN];
    char baz[STRING_LEN];
    char p[STRING_LEN];

    while (offset < SLICE_LEN)
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
                    memset(reform, '\0', STRING_LEN);
                    slice_to_string(b, p);
                    memcpy(reform, p, strlen(p));
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
                    output = malloc(STRING_LEN);
                    sprintf(output, "%f", stack_pop());
                    stack_push(string_to_slice(output), TYPE_STRING);
                    free(output);
                }
                if (a == TYPE_CHARACTER)
                {
                    output = malloc(STRING_LEN);
                    output[0] = (char) stack_pop();
                    output[1] = '\0';
                    stack_push(string_to_slice(output), TYPE_STRING);
                    free(output);
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
                    slice_to_string(stack_pop(), foo);
                    stack_push((double) foo[0], TYPE_CHARACTER);
                }
                types[sp - 1] = TYPE_CHARACTER;
                break;
            case BC_TYPE_F:
                types[sp - 1] = TYPE_FUNCTION;
                break;
            case BC_TYPE_FLAG:
                a = tos_type();
                if (a == TYPE_STRING)
                {
                    b = stack_pop();
                    slice_to_string(b, p);
                    if (strcmp(p, "true") == 0)
                        stack_push(-1, TYPE_FLAG);
                    else if (strcmp(p, "false") == 0)
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
                    slice_to_string(stack_pop(), foo);
                    slice_to_string(stack_pop(), bar);
                    stack_push(string_to_slice(strcat(bar, foo)), TYPE_STRING);
                }
                else
                {
                    report_error("BC_ADD only works for NUMBER and STRING types\n");
                    a = stack_pop();
                    b = stack_pop();
                    offset = SLICE_LEN;
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
            case BC_POW:
                da = stack_pop();
                db = stack_pop();
                stack_push(pow(db, da), TYPE_NUMBER);
                break;
            case BC_BITWISE_SHIFT:
                a = stack_pop();
                b = stack_pop();
                if (a < 0)
                    stack_push((double) ((int) b << (int) abs(a)), TYPE_NUMBER);
                else
                    stack_push((double) ((int) b >> (int) a), TYPE_NUMBER);
                break;
            case BC_BITWISE_AND:
                a = stack_pop();
                b = stack_pop();
                stack_push((double) ((int) b & (int) a), TYPE_NUMBER);
                break;
            case BC_BITWISE_OR:
                a = stack_pop();
                b = stack_pop();
                stack_push((double) ((int) b | (int) a), TYPE_NUMBER);
                break;
            case BC_BITWISE_XOR:
                a = stack_pop();
                b = stack_pop();
                stack_push((double) ((int) b ^ (int) a), TYPE_NUMBER);
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
                    slice_to_string(b, foo);
                    slice_to_string(y, bar);
                    if (strcmp(foo, bar) == 0)
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
                    offset = SLICE_LEN;
                    report_error("ERROR: types do not match\n");
                }
                break;
            case BC_COMPARE_NEQ:
                a = tos_type();
                b = stack_pop();
                x = tos_type();
                y = stack_pop();
                if (a == TYPE_STRING && x == TYPE_STRING)
                {
                    slice_to_string(b, foo);
                    slice_to_string(y, bar);
                    if (strcmp(foo, bar) != 0)
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
                    offset = SLICE_LEN;
                    report_error("ERROR: types do not match\n");
                }
                break;
            case BC_FLOW_IF:
                a = stack_pop();
                b = stack_pop();
                c = stack_pop();
                if (c == -1)
                    interpret(b);
                else
                    interpret(a);
                break;
            case BC_FLOW_WHILE:
                a = stack_pop();
                b = -1;
                while (b == -1)
                {
                    interpret(a);
                    b = stack_pop();
                }
                break;
            case BC_FLOW_UNTIL:
                a = stack_pop();
                b = 0;
                while (b == 0)
                {
                    interpret(a);
                    b = stack_pop();
                }
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
                interpret((int) stack_pop());
                break;
            case BC_FLOW_DIP:
                a = stack_pop();
                b = tos_type();
                c = stack_pop();
                interpret(a);
                stack_push(c, b);
                break;
            case BC_FLOW_SIP:
                a = stack_pop();
                stack_dup();
                b = tos_type();
                c = stack_pop();
                interpret(a);
                stack_push(c, b);
                break;
            case BC_FLOW_BI:
                a = stack_pop();
                b = stack_pop();
                stack_dup();
                x = tos_type();
                y = stack_pop();
                interpret(b);
                stack_push(y, x);
                interpret(a);
                break;
            case BC_FLOW_TRI:
                a = stack_pop();
                b = stack_pop();
                c = stack_pop();
                stack_dup();
                x = tos_type();
                y = stack_pop();
                stack_dup();
                m = tos_type();
                q = stack_pop();
                interpret(c);
                stack_push(q, m);
                interpret(b);
                stack_push(y, x);
                interpret(a);
                break;
            case BC_FLOW_RETURN:
                offset = SLICE_LEN;
                break;
            case BC_MEM_COPY:
                a = stack_pop();
                b = stack_pop();
                copy_slice(b, a);
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
                mem_collect();
                break;
            case BC_STACK_DUP:
                stack_dup();
                break;
            case BC_STACK_DROP:
                stack_pop();
                break;
            case BC_STACK_SWAP:
                stack_swap();
                break;
            case BC_STACK_OVER:
                stack_over();
                break;
            case BC_STACK_TUCK:
                stack_tuck();
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
                slice_to_string(a, p);
                add_definition(p, (int) b);
                break;
            case BC_STRING_SEEK:
                slice_to_string(stack_pop(), foo);
                slice_to_string(stack_pop(), bar);
                output = strstr(bar, foo);
                if (output != NULL)
                    stack_push(abs(bar - baz), TYPE_NUMBER);
                else
                    stack_push(-1, TYPE_NUMBER);
                break;
            case BC_STRING_SUBSTR:
                output = malloc(STRING_LEN);
                a = stack_pop();
                b = stack_pop();
                slice_to_string(stack_pop(), foo);
                j = 0;
                for (i = b; i < a; i++)
                {
                    output[j] = foo[i];
                    j++;
                }
                output[j] = '\0';
                stack_push(string_to_slice(output), TYPE_STRING);
                break;
            case BC_STRING_NUMERIC:
                slice_to_string(stack_pop(), foo);
                a = strtod(foo, &output);
                if (output == foo)
                    stack_push(0, TYPE_FLAG);
                else
                    stack_push(-1, TYPE_FLAG);
                break;
            case BC_TO_LOWER:
                a = tos_type();
                if (a == TYPE_STRING)
                {
                    slice_to_string(stack_pop(), foo);
                    for(z = 0; foo[z]; z++)
                        foo[z] = tolower(foo[z]);
                    stack_push(string_to_slice(foo), TYPE_STRING);
                }
                else if (a == TYPE_CHARACTER)
                {
                    data[sp - 1] = (double) tolower((char) data[sp - 1]);
                }
                break;
            case BC_TO_UPPER:
                a = tos_type();
                if (a == TYPE_STRING)
                {
                    slice_to_string(stack_pop(), foo);
                    for(z = 0; foo[z]; z++)
                        foo[z] = toupper(foo[z]);
                    stack_push(string_to_slice(foo), TYPE_STRING);
                }
                else if (a == TYPE_CHARACTER)
                {
                    data[sp - 1] = (double) toupper((char) data[sp - 1]);
                }
                break;
            case BC_LENGTH:
                a = stack_pop();
                slice_to_string(a, p);
                stack_push((double) strlen(p), TYPE_NUMBER);
                break;
            case BC_REPORT_ERROR:
                slice_to_string(stack_pop(), p);
                report_error(p);
                break;
            case BC_TRIG_SIN:
                stack_push(sin(stack_pop()), TYPE_NUMBER);
                break;
            case BC_TRIG_COS:
                stack_push(cos(stack_pop()), TYPE_NUMBER);
                break;
            case BC_TRIG_TAN:
                stack_push(tan(stack_pop()), TYPE_NUMBER);
                break;
            case BC_TRIG_ASIN:
                stack_push(asin(stack_pop()), TYPE_NUMBER);
                break;
            case BC_TRIG_ACOS:
                stack_push(acos(stack_pop()), TYPE_NUMBER);
                break;
            case BC_TRIG_ATAN:
                stack_push(atan(stack_pop()), TYPE_NUMBER);
                break;
            case BC_TRIG_ATAN2:
                a = stack_pop();
                stack_push(atan2(stack_pop(), a), TYPE_NUMBER);
                break;
        }
        offset++;
    }
}




/*  Dictionary  */
char names[MAX_NAMES][STRING_LEN];
int pointers[MAX_NAMES];
int namep;

void add_definition(char *name, int slice)
{
    if (lookup_definition(name) == -1)
    {
        strcpy(names[namep], name);
        pointers[namep] = slice;
        namep++;
    }
    else
    {
        copy_slice(slice, lookup_definition(name));
    }
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
    char reform[STRING_LEN];
    double scratch;
    int o = 0;
    int nest[NEST_LIMIT];
    int nest_o[NEST_LIMIT];
    int np = 0;
    int current = s;
    int i;

    for (token = strtok_r(source, " ", &state); token != NULL; token = strtok_r(NULL, " ", &state))
    {
        prefix = (char)token[0];
        switch (prefix)
        {
            case '\'':
                if (token[strlen(token) - 1] == '\'')
                {
                    memset(reform, '\0', STRING_LEN);
                    memcpy(reform, &token[1], strlen(token) - 2);
                    reform[strlen(token) - 2] = '\0';
                    o = compile_cell(BC_PUSH_S, s, o);
                    o = compile_cell((double) string_to_slice(reform), s, o);
                }
                else
                {
                    memset(reform, '\0', STRING_LEN);
                    memcpy(reform, &token[1], strlen(token) - 1);

                    i = 0;
                    while (i == 0)
                    {
                        strcat(reform, " ");
                        token = strtok_r(NULL, " ", &state);
                        if (token[strlen(token) - 1] == '\'' || token == NULL)
                        {
                            i = 1;
                            token[strlen(token) - 1] = '\0';
                            strcat(reform, token);
                        }
                        else
                            strcat(reform, token);
                    }
                    o = compile_cell(BC_PUSH_S, s, o);
                    o = compile_cell((double) string_to_slice(reform), s, o);
                }
                break;
            case '"':
                if (token[strlen(token) - 1] == '"')
                {
                    memset(reform, '\0', STRING_LEN);
                    memcpy(reform, &token[1], strlen(token) - 2);
                    reform[strlen(token) - 2] = '\0';
                    o = compile_cell(BC_PUSH_COMMENT, s, o);
                    o = compile_cell((double) string_to_slice(reform), s, o);
                }
                else
                {
                    memset(reform, '\0', STRING_LEN);
                    memcpy(reform, &token[1], strlen(token) - 1);

                    i = 0;
                    while (i == 0)
                    {
                        strcat(reform, " ");
                        token = strtok_r(NULL, " ", &state);
                        if (token[strlen(token) - 1] == '"' || token == NULL)
                        {
                            i = 1;
                            token[strlen(token) - 1] = '\0';
                            strcat(reform, token);
                        }
                        else
                            strcat(reform, token);
                    }
                    o = compile_cell(BC_PUSH_COMMENT, s, o);
                    o = compile_cell((double) string_to_slice(reform), s, o);
                }
                break;
            case '#':
                memset(reform, '\0', STRING_LEN);
                memcpy(reform, &token[1], strlen(token));
                scratch = (double) atof(reform);
                o = compile_cell(BC_PUSH_N, s, o);
                o = compile_cell(scratch, s, o);
                break;
            case '&':
                memset(reform, '\0', STRING_LEN);
                memcpy(reform, &token[1], strlen(token));
                if (lookup_definition(reform) != -1)
                {
                    scratch = lookup_definition(reform);
                    o = compile_cell(BC_PUSH_F, s, o);
                    o = compile_cell(scratch, s, o);
                }
                else
                {
                    scratch = (double) atof(reform);
                    o = compile_cell(BC_PUSH_F, s, o);
                    o = compile_cell(scratch, s, o);
                }
                break;
            case '$':
                scratch = (double) token[1];
                o = compile_cell(BC_PUSH_C, s, o);
                o = compile_cell(scratch, s, o);
                break;
            case '`':
                memset(reform, '\0', STRING_LEN);
                memcpy(reform, &token[1], strlen(token));
                scratch = (double) atof(reform);
                o = compile_cell(scratch, s, o);
                break;
            default:
                if (strcmp(token, "[") == 0)
                {
                    nest[np] = s;
                    nest_o[np] = o;
                    s = request_slice();
                    o = 0;
                    np++;
                }
                else if (strcmp(token, "]") == 0)
                {
                    o = compile_cell(BC_FLOW_RETURN, s, o);
                    current = s;
                    np--;
                    s = nest[np];
                    o = nest_o[np];
                    o = compile_cell(BC_PUSH_F, s, o);
                    o = compile_cell(current, s, o);
                }
                else
                {
                    if (lookup_definition(token) != -1)
                    {
                        o = compile_cell(BC_FLOW_CALL, s, o);
                        o = compile_cell(lookup_definition(token), s, o);
                    }
                    else
                    {
                        report_error("function not found: ");
                        report_error(token);
                        report_error("\n");
                    }
                }
                break;
        }
    }
    return s;
}
