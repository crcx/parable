# Memory Model

In Parable, memory is organized a series of slices, each of a specific (implementation defined) length. Each slice is technically a separate entity, and is contains a single function or set of data.

It's important to note that each quotation is a separate function, existing in its own slice.

Memory addressing is absolute.

## Request, Release, and Collect-Garbage

You can obtain a new slice by using the **request** function. This will find an unused slice, allocate it, and return a pointer on the stack. When you are finished with the slice, you can pass a pointer to **release** to mark it as not in use.

Parable is garbage collected. The runtime will periodically look for slices that no longer appear to be in use and reclaim them automatically. Note that if you have an unused pointer stored in a variable, Parable will assume that it is still needed and not release it automatically. Use **release** in this case.

