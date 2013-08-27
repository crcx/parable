from parable import *

def decompile_slice(slice):
    """return a string containing the source code for a given slice"""
    global SLICE_LEN
    i = 0
    s = ' '
    while i < SLICE_LEN:
        o = fetch(slice, i)
        if o == BC_PUSH_N:
            i += 1
            o = fetch(slice, i)
            s += '#' + str(o)
        elif o == BC_PUSH_C:
            i += 1
            o = fetch(slice, i)
            s += '$' + str(chr(o))
        elif o == BC_PUSH_S:
            i += 1
            o = fetch(slice, i)
            s += "'" + slice_to_string(o) + "'"
        elif o == BC_PUSH_COMMENT:
            i += 1
            o = fetch(slice, i)
            s += '"' + slice_to_string(o) + '"'
        elif o == BC_PUSH_F:
            i += 1
            o = fetch(slice, i)
            x = pointer_to_name(o)
            if len(x) == 0:
                s += ' ' + deconstruct(o) + ' '
            else:
                s += '&' + x
        elif o == BC_FLOW_CALL:
            i += 1
            o = fetch(slice, i)
            x = pointer_to_name(o)
            if len(x) == 0:
                s += '&' + str(o) + ' invoke'
            else:
                s += x
        elif o == BC_FLOW_RETURN:
            i = SLICE_LEN
        else:
            s += '`' + str(o)
        i += 1
        s += ' '
    s += ' '
    return s


def generate_retro_source():
    """return a string containing full source code for all named slices and"""
    """their dependencies"""
    global dictionary_names, dictionary_slices
    src = ""
    for s in dictionary_slices:
        src += ": " + pointer_to_name(s) + " "
        src += decompile_slice(s)
        src += ";\n"
    return src + "\n"
