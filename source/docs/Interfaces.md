# Implementing Parable: The Interface Layer

Parable consists of two parts: the core language and a user interface layer. By itself, the core language isn't very useful. It has no facilities for input or output, focusing instead on implementing the parser, compiler, byte code interpreter, and standard library of functions. All I/O operations are left up to the interface layer to implement.

This was done to make the core more adaptable to devices that don't implement a traditional terminal environment. It's quite easy to embed Parable into a larger application, and to create an environment incorporating new capabilities for interacting with the world.

## Prerequsites

* Python 2 or 3
* parable.py
* stdlib.p

*The Parable code can be converted to work with Python 3 using **2to3**. The example code below will likely need adjustments in this case.*

## Initialization

The minimal skeleton to initialize the Parable environment is:

    import parable

    if __name__ == '__main__':
        parable.prepare_slices()
        parable.prepare_dictionary()
        parable.parse_bootstrap(open('stdlib.p').readlines())

While optional, it's also useful to collect garbage after loading the standard library:

        parable.collect_garbage()

## Processing Code

To process code:

    parable.interpret(parable.compile("code", request_slice()))

## Displaying the Stack

To display a stack dump is more difficult as you need to account for the various data types. An example:

    def stack_item(i, s):
        return str(i) + ':' + str(s)

    def dump_stack():
        """display the stack"""
        i = 0
        s = ""
        depth = len(parable.stack)
        while i < depth:
            tos = parable.stack[i]
            type = parable.types[i]
            if type == parable.TYPE_NUMBER:
                sys.stdout.write(stack_item(i, "#" + str(tos)))
            elif type == parable.TYPE_CHARACTER:
                sys.stdout.write(stack_item(i, "$" + unicode(unichr(tos)).encode('utf-8')))
            elif type == parable.TYPE_STRING:
                s = "'" + parable.slice_to_string(tos) + "'"
            elif type == parable.TYPE_POINTER:
                s = "&" + str(tos)
                if parable.pointer_to_name(tos) != "":
                    s = s + "\nPointer to: " + parable.pointer_to_name(tos)
                sys.stdout.write(stack_item(i, s))
            elif type == parable.TYPE_FLAG:
                if tos == -1:
                    sys.stdout.write(stack_item(i, "true"))
                elif tos == 0:
                    sys.stdout.write(stack_item(i, "false"))
                else:
                    sys.stdout.write(stack_item(i, "malformed flag"))
            elif type == parable.TYPE_BYTECODE:
                sys.stdout.write(stack_item(i, "`" + str(tos)))
            elif type == parable.TYPE_REMARK:
                s = "\"" + parable.slice_to_string(tos) + "\""
            elif type == parable.TYPE_FUNCTION_CALL:
                s = "Call: " + str(tos)
                sys.stdout.write(stack_item(i, s))
            else:
                sys.stdout.write(stack_item(i, "unmatched type on stack!"))
            i += 1
            sys.stdout.write('\n')

## Extending the VM

Parable provides hooks for the interface layer to add extensions to the byte codes. To make use of this, implement an opcode handler, and pass it to interpret() along with the slice.

    interpret(slice, [function providing new byte codes])

A sample opcode processor:

    def opcodes(slice, offset, opcode):
        if opcode == 2000:
            # do something here
        else:
            return offset

If you extend the byte codes your interface code should also bind them to names.
