void prepare_error_reporting();
void report_error(char *string);
void clear_errors();
void end_error_reporting();
int request_slice();
void release_slice(int slice);
double fetch(int s, int o);
void store(double v, int s, int o);
void copy_slice(int source, int dest);
void mem_collect();
char *slice_to_string(int s, char *string);
int string_to_slice(char *string);
void stack_push(double value, double type);
double stack_pop();
void stack_swap();
void stack_dup();
void stack_over();
void stack_tuck();
double tos_type();
double nos_type();
void read_line(FILE *file, char *line_buffer);
void parse_bootstrap(char *fname);
void interpret(int slice);
void add_definition(char *name, int slice);
void hide_definition(char *name);
void prepare_dictionary();
int lookup_definition(char *name);
int find_header(char *name);
int compile_cell(double value, int slice, int offset);
int compile(char *source, int s);
