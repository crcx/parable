# Prefixes

In Parable, a prefix is a single character which is added to the start of a token. The compiler uses this to decide how to process the token.

The prefixes recognized are:

<table width='100%' style='border: 1px solid black'>
    <tr>
        <td valign='top' width='10%'>#</td>
        <td valign='top' width='90%'>Numbers</td>
    </tr>
    <tr>
        <td valign='top' width='10%'>$</td>
        <td valign='top' width='90%'>Characters</td>
    </tr>
    <tr>
        <td valign='top' width='10%'>'</td>
        <td valign='top' width='90%'>Strings</td>
    </tr>
    <tr>
        <td valign='top' width='10%'>&</td>
        <td valign='top' width='90%'>Pointers</td>
    </tr>
</table>

Each prefix corresponds to a specific data type. Prefixes are not optional and are a critical part of the language.
