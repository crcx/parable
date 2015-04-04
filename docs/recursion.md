# Recursion

In Parable, recursion is handled through redefintion. So a simple recursive loop might look like:

    [ ] 'foo' define
    [ foo ] 'foo' define

An unending loop isn't much use, but we can implement a simple counted loop using recursion by doing:

    [ ] 'foo' define
    [ dup #10 <> [ dup #1 + foo ] if-true ] 'foo' define

    #1 foo

Recursion is a powerful tool, but it's often more practical to use the looping combinators instead. E.g., the above counted loop could also be done without recursion using the **repeat** combinator.

    #1 #10 [ dup #1 + ] repeat
