## Random Value in List

### Overview

To get a random value in a list we can do something like this:

* determine the length of the list
* choose a random index not greater than the length of the list
* fetch the chosen value

### Code

Create a list of values (1 to 10,000):

    [ 1 10000 range ] capture-results

Calculate the length (keeping a copy of the list):

    dup length?

Find a random index not larger than the length:

    dup random * floor min

And fetch the value:

    fetch
