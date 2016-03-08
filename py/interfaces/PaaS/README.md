# Parable as a Service

## The Concept

So I had this idea: allow a Parable session to be transmitted back and forth
across the internet so that I could remotely execute bits of code over time.
This is my attempt to implement it.

I started towards this with the current releases of Apologue, an iOS based
interface to Parable. But there it's not quite the same: code is submitted,
and a partial snapshot containing the stack results, dictionary headers, and
a subset of the full memory snapshot is returned. There's no facility to run
subsequent code within the previous results. So everything has to be compiled
and run each time. This is not ideal.

PaaS solves this by returning a snapshot of a Parable session. This snapshot
contains the entire memory space, full stack, full dictionary headers, error
logs, etc. Subsequent calls pass the snapshot along with the request, with a
new snapshot of the results being returned.

The secondary problem is space: a full snapshot is pretty big (over 1MB). Since
this is too big to be practical, PaaS returns the results as a bzip2 compressed
sequence. To keep it simple for transmit/receive this is then base64 encoded.

PaaS has some functions that allow returning specific pieces from a snapshot so
that your code doesn't need to handle the encoded, compressed data. (If your
interfaces support it you'll get better performance if you can work with the
data offline.

## The Server Interface

### getpso

Parameters:

    req:  getpso

Returns:

    snapshot

### evaluate

Parameters:

    req:     evaluate
    pso:     snapshot
    source:  code to process

Returns:

    snapshot

### stack

Parameters:

    req:  stack
    pso:  snapshot

Returns:

    json sequence

The returned JSON has two arrays: **values** and **types**.

### dictionary

Parameters:

    req:  dictionary
    pso:  snapshot

Returns:

    json sequence

The returned JSON has two arrays: **names** and **pointers**.

### errors

Parameters:

    req:  errors
    pso:  snapshot

Returns:

    json sequence

The returned JSON is an array of error messages. Remove them using **clear_errors**.

### clear_errors

Parameters:

    req:  clear_errors
    pso:  snapshot

Returns:

    snapshot
