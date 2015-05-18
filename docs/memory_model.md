# Memory Model

In Parable, memory is organized as series of slices, each of which has a dynamically sized length. Each slice is technically a separate entity, and contains a single function or a set of data.

It's important to note that each quotation is a separate function, existing in its own slice.

Memory addressing is absolute.

## Request, Release, and Collect-Garbage

You can obtain a new slice by using the **request** function. This will find an unused slice, allocate it, and return a pointer on the stack. When you are finished with the slice, you can pass a pointer to **release** to mark it as not in use.

Parable is garbage collected. The runtime will periodically look for slices that no longer appear to be in use and reclaim them automatically. Note that if you have an unused pointer stored in a variable, Parable will assume that it is still needed and not release it automatically. Use **release** in this case.

## Accessing Values in a Slice

Values in a slice are accessed using **fetch**. This takes a pointer and an offset, and returns the numeric value stored at that offset. You can use the coercion functions to convert this to the expected type.

Examples:

    'hello' :p #1 fetch :c

## Updating Values in a Slice

Values can be stored into a slice using **store**. This takes a value, a pointer, and an offset.

    'hello' :p $E over #1 store :s

## Controlling the Length of a Slice

You can obtain the length of a slice using **get-slice-length**. This takes a pointer and returns the length.

If you need to adjust the length, you can use **set-slice-length**. This takes a number (representing the new length) and a pointer and will grow or shrink the slice as necessary.



