<?
/* parable
 * Copyright (c) 2013, Charles Childers
 */


$MAX_SLICES = 64000;
$SLICE_LEN = 1000;

$stack = array();
$types = array();
$dictionary_names  = array();
$dictionary_map  = array();
$p_slices = array();
$p_map = array();

$TYPE_NUMBER    = 100;
$TYPE_STRING    = 200;
$TYPE_CHARACTER = 300;
$TYPE_FUNCTION  = 400;
$TYPE_FLAG      = 500;

$BC_PUSH_N        = 100;
$BC_PUSH_S        = 101;
$BC_PUSH_C        = 102;
$BC_PUSH_F        = 103;
$BC_PUSH_COMMENT  = 104;
$BC_TYPE_N        = 110;
$BC_TYPE_S        = 111;
$BC_TYPE_C        = 112;
$BC_TYPE_F        = 113;
$BC_TYPE_FLAG     = 114;
$BC_GET_TYPE      = 120;
$BC_ADD           = 200;
$BC_SUBTRACT      = 201;
$BC_MULTIPLY      = 202;
$BC_DIVIDE        = 203;
$BC_REMAINDER     = 204;
$BC_FLOOR         = 205;
$BC_BITWISE_SHIFT = 210;
$BC_BITWISE_AND   = 211;
$BC_BITWISE_OR    = 212;
$BC_BITWISE_XOR   = 213;
$BC_COMPARE_LT    = 220;
$BC_COMPARE_GT    = 221;
$BC_COMPARE_LTEQ  = 222;
$BC_COMPARE_GTEQ  = 223;
$BC_COMPARE_EQ    = 224;
$BC_COMPARE_NEQ   = 225;
$BC_FLOW_IF       = 300;
$BC_FLOW_WHILE    = 301;
$BC_FLOW_UNTIL    = 302;
$BC_FLOW_TIMES    = 303;
$BC_FLOW_CALL     = 304;
$BC_FLOW_CALL_F   = 305;
$BC_FLOW_DIP      = 306;
$BC_FLOW_SIP      = 307;
$BC_FLOW_BI       = 308;
$BC_FLOW_TRI      = 309;
$BC_FLOW_RETURN   = 399;
$BC_MEM_COPY      = 400;
$BC_MEM_FETCH     = 401;
$BC_MEM_STORE     = 402;
$BC_MEM_REQUEST   = 403;
$BC_MEM_RELEASE   = 404;
$BC_MEM_COLLECT   = 405;
$BC_STACK_DUP     = 500;
$BC_STACK_DROP    = 501;
$BC_STACK_SWAP    = 502;
$BC_STACK_OVER    = 503;
$BC_STACK_TUCK    = 504;
$BC_STACK_NIP     = 505;
$BC_STACK_DEPTH   = 506;
$BC_STACK_CLEAR   = 507;
$BC_QUOTE_NAME    = 600;
$BC_STRING_SEEK   = 700;
$BC_STRING_SUBSTR = 701;
$BC_STRING_NUMERIC= 702;
$BC_TO_LOWER      = 800;
$BC_TO_UPPER      = 801;
$BC_LENGTH        = 802;
$BC_REPORT_ERROR  = 900;


function startsWith($haystack, $needle)
{
    return !strncmp($haystack, $needle, strlen($needle));
}

function endsWith($haystack, $needle)
{
    $length = strlen($needle);
    if ($length == 0)
        return FALSE;
    else
        return (substr($haystack, -$length) === $needle);
}


$errors = array();

function clear_errors()
{
    global $errors;
    $i = 0;
    while ($i < count($errors))
    {
        array_pop($errors);
        $i += 1;
    }
}


function report_error($text)
{
    global $errors;
    array_push($errors, $text);
}


function check_depth($cells)
{
    global $stack;
    if (count($stack) < $cells)
    {
        report_error('Stack underflow: ' . $cells . ' values required.');
        return FALSE;
    }
    else
        return TRUE;
}



function prepare_memory()
{
    global $p_slices, $p_map, $MAX_SLICES;
    $i = 0;
    while ($i < $MAX_SLICES)
    {
        array_push($p_slices, array());
        array_push($p_map, 0);
        $i += 1;
    }
}


function request_slice()
{
    global $p_slices, $p_map, $MAX_SLICES;
    $i = 0;
    while ($i < $MAX_SLICES)
    {
        if ($p_map[$i] == 0)
        {
            $p_map[$i] = 1;
            $s = $i;
            return $i;
        }
        $i += 1;
    }
    return -1;
}

function release_slice($s)
{
    global $p_map;
    $p_map[$s] = 0;
}

function store($v, $s, $o)
{
    global $p_slices;
    $p_slices[$s][$o] = $v;
}

function fetch($s, $o)
{
    global $p_slices;
    return $p_slices[$s][$o];
}

function compile($str, $slice)
{
    global $MAX_SLICES, $SLICE_LEN;
    global $stack, $types;
    global $dictionary_names, $dictionary_map;
    global $p_slices, $p_map;
    global $TYPE_NUMBER, $TYPE_STRING, $TYPE_CHARACTER, $TYPE_FUNCTION, $TYPE_FLAG;
    global $BC_PUSH_N, $BC_PUSH_S, $BC_PUSH_C, $BC_PUSH_F, $BC_PUSH_COMMENT;
    global $BC_TYPE_N, $BC_TYPE_S, $BC_TYPE_C, $BC_TYPE_F, $BC_TYPE_FLAG;
    global $BC_GET_TYPE, $BC_ADD, $BC_SUBTRACT, $BC_MULTIPLY, $BC_DIVIDE;
    global $BC_REMAINDER, $BC_FLOOR, $BC_BITWISE_SHIFT, $BC_BITWISE_AND, $BC_BITWISE_OR;
    global $BC_BITWISE_XOR, $BC_COMPARE_LT, $BC_COMPARE_GT, $BC_COMPARE_LTEQ, $BC_COMPARE_GTEQ;
    global $BC_COMPARE_EQ, $BC_COMPARE_NEQ, $BC_FLOW_IF, $BC_FLOW_WHILE, $BC_FLOW_UNTIL;
    global $BC_FLOW_TIMES, $BC_FLOW_CALL, $BC_FLOW_CALL_F, $BC_FLOW_DIP, $BC_FLOW_SIP;
    global $BC_FLOW_BI, $BC_FLOW_TRI, $BC_FLOW_RETURN, $BC_MEM_COPY, $BC_MEM_FETCH;
    global $BC_MEM_STORE, $BC_MEM_REQUEST, $BC_MEM_RELEASE, $BC_MEM_COLLECT, $BC_STACK_DUP;
    global $BC_STACK_DROP, $BC_STACK_SWAP, $BC_STACK_OVER, $BC_STACK_TUCK, $BC_STACK_NIP;
    global $BC_STACK_DEPTH, $BC_STACK_CLEAR, $BC_QUOTE_NAME, $BC_STRING_SEEK, $BC_STRING_SUBSTR;
    global $BC_STRING_NUMERIC, $BC_TO_LOWER, $BC_TO_UPPER, $BC_LENGTH, $BC_REPORT_ERROR;

    $tokens = explode(' ', trim($str));
    $l = count($tokens);
    $i = 0;
    $nest = array();
    $offset = 0;

    while ($i < $l)
    {
        if (startsWith($tokens[$i], "#"))
        {
            store($BC_PUSH_N, $slice, $offset);
            $offset += 1;
            store(floatval(substr($tokens[$i], 1)), $slice, $offset);
            $offset += 1;
        }
        elseif (startsWith($tokens[$i], "$"))
        {
            store($BC_PUSH_C, $slice, $offset);
            $offset += 1;
            store(ord(substr($tokens[$i], 1)), $slice, $offset);
            $offset += 1;
        }
        elseif (startsWith($tokens[$i], "`"))
        {
            store(floatval(substr($tokens[$i], 1)), $slice, $offset);
            $offset += 1;
        }
        elseif (startsWith($tokens[$i], "&"))
        {
            store($BC_PUSH_F, $slice, $offset);
            $offset += 1;
            if (is_numeric(substr($tokens[$i], 1)))
                store(intval(substr($tokens[$i], 1)), $slice, $offset);
            else
            {
                if (lookup_pointer(substr($tokens[$i], 1)) == -1)
                {
                    report_error("ERROR: unable to map '". substr($tokens[$i], 1) ."' to a slice!");
                    store(0, $slice, $offset);
                }
                else
                    store($dictionary_map[lookup_pointer(substr($tokens[$i], 1))], $slice, $offset);
            }
            $offset += 1;
        }
        elseif (startsWith($tokens[$i], "'"))
        {
            $s = "";
            if (endsWith($tokens[$i], "'"))
                $s = $tokens[$i];
            else
            {
                $j = $i + 1;
                $s = $tokens[$i];
                while ($j < $l)
                {
                    $s .= " ";
                    $s .= $tokens[$j];
                    if (endsWith($tokens[$j], "'"))
                    {
                        $i = $j;
                        $j = $l;
                    }
                    $j += 1;
                }
            }
            $s = substr($s, 1, strlen($s) - 2);
            $z = string_to_slice($s);
            store($BC_PUSH_S, $slice, $offset);
            $offset += 1;
            store($z, $slice, $offset);
            $offset += 1;
        }
        elseif (startsWith($tokens[$i], "\""))
        {
            $s = "";
            if (endsWith($tokens[$i], "\""))
                $s = $tokens[$i];
            else
            {
                $j = $i + 1;
                $s = $tokens[$i];
                while ($j < $l)
                {
                    $s .= " ";
                    $s .= $tokens[$j];
                    if (endsWith($tokens[$j], "\""))
                    {
                        $i = $j;
                        $j = $l;
                    }
                    $j += 1;
                }
            }
            $s = substr($s, 1, strlen($s) - 2);
            $z = string_to_slice($s);
            store($BC_PUSH_COMMENT, $slice, $offset);
            $offset += 1;
            store($z, $slice, $offset);
            $offset += 1;
        }
        elseif ($tokens[$i] == "[")
        {
            array_push($nest, $slice);
            array_push($nest, $offset);
            $slice = request_slice();
            $offset = 0;
        }
        elseif ($tokens[$i] == "]")
        {
            $old = $slice;
            store($BC_FLOW_RETURN, $slice, $offset);
            $offset = array_pop($nest);
            $slice = array_pop($nest);
            store($BC_PUSH_F, $slice, $offset);
            $offset += 1;
            store($old, $slice, $offset);
            $offset += 1;
        }
        elseif ($tokens[$i] == "")
        {
        }
        else
        {
            if (lookup_pointer($tokens[$i]) == -1)
                report_error("ERROR: name '". $tokens[$i] ."' not found!");
            else
            {
                store($BC_FLOW_CALL, $slice, $offset);
                $offset += 1;
                store($dictionary_map[lookup_pointer($tokens[$i])], $slice, $offset);
                $offset += 1;
            }
        }
        $i += 1;
    }
    store($BC_FLOW_RETURN, $slice, $offset);
    return $slice;
}


function prepare_dictionary()
{
    global $dictionary_names, $dictionary_map;
    $s = request_slice();
    compile("`600", $s);
    add_definition('define', $s);
}


function lookup_pointer($name)
{
    global $dictionary_names, $dictionary_map;
    $s = -1;
    foreach ($dictionary_names as $key => $value)
        if ($value == $name)
            $s = $key;
    return $s;
}


function add_definition($name, $s)
{
    global $dictionary_names, $dictionary_map;
    if (lookup_pointer($name) == -1)
    {
        array_push($dictionary_names, $name);
        array_push($dictionary_map, $s);
    }
    else
        copy_slice($s, $dictionary_map[lookup_pointer($name)]);
}


function interpret($slice)
{
    global $MAX_SLICES, $SLICE_LEN;
    global $stack, $types;
    global $dictionary_names, $dictionary_map;
    global $p_slices, $p_map;
    global $TYPE_NUMBER, $TYPE_STRING, $TYPE_CHARACTER, $TYPE_FUNCTION, $TYPE_FLAG;
    global $BC_PUSH_N, $BC_PUSH_S, $BC_PUSH_C, $BC_PUSH_F, $BC_PUSH_COMMENT;
    global $BC_TYPE_N, $BC_TYPE_S, $BC_TYPE_C, $BC_TYPE_F, $BC_TYPE_FLAG;
    global $BC_GET_TYPE, $BC_ADD, $BC_SUBTRACT, $BC_MULTIPLY, $BC_DIVIDE;
    global $BC_REMAINDER, $BC_FLOOR, $BC_BITWISE_SHIFT, $BC_BITWISE_AND, $BC_BITWISE_OR;
    global $BC_BITWISE_XOR, $BC_COMPARE_LT, $BC_COMPARE_GT, $BC_COMPARE_LTEQ, $BC_COMPARE_GTEQ;
    global $BC_COMPARE_EQ, $BC_COMPARE_NEQ, $BC_FLOW_IF, $BC_FLOW_WHILE, $BC_FLOW_UNTIL;
    global $BC_FLOW_TIMES, $BC_FLOW_CALL, $BC_FLOW_CALL_F, $BC_FLOW_DIP, $BC_FLOW_SIP;
    global $BC_FLOW_BI, $BC_FLOW_TRI, $BC_FLOW_RETURN, $BC_MEM_COPY, $BC_MEM_FETCH;
    global $BC_MEM_STORE, $BC_MEM_REQUEST, $BC_MEM_RELEASE, $BC_MEM_COLLECT, $BC_STACK_DUP;
    global $BC_STACK_DROP, $BC_STACK_SWAP, $BC_STACK_OVER, $BC_STACK_TUCK, $BC_STACK_NIP;
    global $BC_STACK_DEPTH, $BC_STACK_CLEAR, $BC_QUOTE_NAME, $BC_STRING_SEEK, $BC_STRING_SUBSTR;
    global $BC_STRING_NUMERIC, $BC_TO_LOWER, $BC_TO_UPPER, $BC_LENGTH, $BC_REPORT_ERROR;

    $offset = 0;
    while ($offset < $SLICE_LEN)
    {
        $opcode = intval(fetch($slice, $offset));
        if ($opcode == $BC_PUSH_N)
        {
            $offset += 1;
            stack_push(floatval(fetch($slice, $offset)), $TYPE_NUMBER);
        }
        elseif ($opcode == $BC_PUSH_S)
        {
            $offset += 1;
            stack_push(floatval(fetch($slice, $offset)), $TYPE_STRING);
        }
        elseif ($opcode == $BC_PUSH_C)
        {
            $offset += 1;
            stack_push(floatval(fetch($slice, $offset)), $TYPE_CHARACTER);
        }
        elseif ($opcode == $BC_PUSH_F)
        {
            $offset += 1;
            stack_push(floatval(fetch($slice, $offset)), $TYPE_FUNCTION);
        }
        elseif ($opcode == $BC_PUSH_COMMENT)
        {
            $offset += 1;
        }
        elseif ($opcode == $BC_TYPE_N)
        {
            if (check_depth(1))
                stack_change_type($TYPE_NUMBER);
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_TYPE_S)
        {
            if (check_depth(1))
                stack_change_type($TYPE_STRING);
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_TYPE_C)
        {
            if (check_depth(1))
                stack_change_type($TYPE_CHARACTER);
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_TYPE_F)
        {
            if (check_depth(1))
                stack_change_type($TYPE_FUNCTION);
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_TYPE_FLAG)
        {
            if (check_depth(1))
                stack_change_type($TYPE_FLAG);
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_GET_TYPE)
        {
            if (check_depth(1))
                stack_push(stack_type(), $TYPE_NUMBER);
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_ADD)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $TYPE_NUMBER and $y == $TYPE_NUMBER)
                {
                    stack_push($a + $b, $TYPE_NUMBER);
                }
                elseif ($x == $TYPE_STRING and $y == $TYPE_STRING)
                {
                    $a = slice_to_string($a);
                    $b = slice_to_string($b);
                    stack_push(string_to_slice($b . $a), $TYPE_STRING);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_ADD only works with NUMBER and STRING types, found '."$x:$a and $y:$b");
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_SUBTRACT)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                stack_push($b - $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_MULTIPLY)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                stack_push($a * $b, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_DIVIDE)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                stack_push($b / $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_REMAINDER)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                stack_push($b % $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOOR)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $a = float($a);
                stack_push(floor($a), $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_BITWISE_SHIFT)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                if ($a < 0)
                    stack_push($b << abs($a), $TYPE_NUMBER);
                else
                    stack_push($b >> $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_BITWISE_AND)
        {
            if (check_depth(2))
            {
                $a = intval(stack_pop());
                $b = intval(stack_pop());
                stack_push($b & $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_BITWISE_OR)
        {
            if (check_depth(2))
            {
                $a = intval(stack_pop());
                $b = intval(stack_pop());
                stack_push($b | $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_BITWISE_XOR)
        {
            if (check_depth(2))
            {
                $a = intval(stack_pop());
                $b = intval(stack_pop());
                stack_push($b ^ $a, $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_COMPARE_LT)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $TYPE_NUMBER and $y == $TYPE_NUMBER)
                {
                    if ($b < $a)
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_COMPARE_LT only recognizes NUMBER types');
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_COMPARE_GT)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $TYPE_NUMBER and $y == $TYPE_NUMBER)
                {
                    if ($b > $a)
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_COMPARE_LT only recognizes NUMBER types');
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_COMPARE_LTEQ)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $TYPE_NUMBER and $y == $TYPE_NUMBER)
                {
                    if ($b <= $a)
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_COMPARE_LTEQ only recognizes NUMBER types');
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_COMPARE_GTEQ)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $TYPE_NUMBER and $y == $TYPE_NUMBER)
                {
                    if ($b >= $a)
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_COMPARE_GTEQ only recognizes NUMBER types');
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_COMPARE_EQ)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $y and $x != $TYPE_STRING)
                {
                    if ($b == $a)
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                elseif ($x == $y and $x == $TYPE_STRING)
                {
                    if (slice_to_string($b) == slice_to_string($a))
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_COMPARE_EQ requires matched types');
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_COMPARE_NEQ)
        {
            if (check_depth(2))
            {
                $x = stack_type();
                $a = stack_pop();
                $y = stack_type();
                $b = stack_pop();
                if ($x == $y and $x != $TYPE_STRING)
                {
                    if ($b != $a)
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                elseif ($x == $y and $x == $TYPE_STRING)
                {
                    if (slice_to_string($b) != slice_to_string($a))
                        stack_push(-1, $TYPE_FLAG);
                    else
                        stack_push(0, $TYPE_FLAG);
                }
                else
                {
                    $offset = $SLICE_LEN;
                    report_error('$BC_COMPARE_NEQ requires matched types');
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_IF)
        {
            if (check_depth(3))
            {
                $a = stack_pop();
                $b = stack_pop();
                $c = stack_pop();
                if ($c == -1)
                    interpret($b);
                else
                    interpret($a);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_WHILE)
        {
            if (check_depth(1))
            {
                $quote = stack_pop();
                $a  = -1;
                while ($a == -1)
                {
                    interpret($quote);
                    $a = stack_pop();
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_UNTIL)
        {
            if (check_depth(1))
            {
                $quote = stack_pop();
                $a  = 0;
                while ($a == 0)
                {
                    interpret($quote);
                    $a = stack_pop();
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_TIMES)
        {
            if (check_depth(2))
            {
                $quote = stack_pop();
                $count = stack_pop();
                while ($count > 0)
                {
                    interpret($quote);
                    $count -= 1;
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_CALL)
        {
            $offset += 1;
            interpret(fetch($slice, $offset));
        }
        elseif ($opcode == $BC_FLOW_CALL_F)
        {
            if (check_depth(1))
            {
                $a = stack_pop();
                interpret($a);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_DIP)
        {
            if (check_depth(2))
            {
                $quote = stack_pop();
                $vtype = stack_type();
                $value = stack_pop();
                interpret($quote);
                stack_push($value, $vtype);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_SIP)
        {
            if (check_depth(2))
            {
                $quote = stack_pop();
                stack_dup();
                $vtype = stack_type();
                $value = stack_pop();
                interpret($quote);
                stack_push($value, $vtype);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_BI)
        {
            if (check_depth(3))
            {
               $a = stack_pop();
               $b = stack_pop();
               stack_dup();
               $x = stack_type();
               $y = stack_pop();
               interpret($b);
               stack_push($y, $x);
               interpret($a);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_TRI)
        {
            if (check_depth(4))
            {
                $a = stack_pop();
                $b = stack_pop();
                $c = stack_pop();
                stack_dup();
                $x = stack_type();
                $y = stack_pop();
                stack_dup();
                $m = stack_type();
                $q = stack_pop();
                interpret($c);
                stack_push($q, $m);
                interpret($b);
                stack_push($y, $x);
                interpret($a);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_FLOW_RETURN)
            $offset = $SLICE_LEN;
        elseif ($opcode == $BC_MEM_COPY)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                copy_slice($b, $a);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_MEM_FETCH)
        {
            if (check_depth(2))
            {
                $a = stack_pop();
                $b = stack_pop();
                stack_push(fetch($b, $a), $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_MEM_STORE)
        {
            if (check_depth(3))
            {
                $a = stack_pop();
                $b = stack_pop();
                $c = stack_pop();
                store($c, $b, $a);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_MEM_REQUEST)
            stack_push(request_slice(), $TYPE_FUNCTION);
        elseif ($opcode == $BC_MEM_RELEASE)
        {
            if (check_depth(1))
                release_slice(stack_pop());
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_MEM_COLLECT)
        {
            collect_unused_slices();
        }
        elseif ($opcode == $BC_STACK_DUP)
        {
            if (check_depth(1))
                stack_dup();
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STACK_DROP)
        {
            if (check_depth(1))
                stack_drop();
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STACK_SWAP)
        {
            if (check_depth(2))
                stack_swap();
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STACK_OVER)
        {
            if (check_depth(2))
                stack_over();
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STACK_TUCK)
        {
            if (check_depth(2))
                stack_tuck();
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STACK_NIP)
        {
            if (check_depth(2))
            {
                stack_swap();
                stack_drop();
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STACK_DEPTH)
            stack_push(count($stack), $TYPE_NUMBER);
        elseif ($opcode == $BC_STACK_CLEAR)
            stack_clear();
        elseif ($opcode == $BC_QUOTE_NAME)
        {
            if (check_depth(2))
            {
                $name = slice_to_string(stack_pop());
                $ptr  = stack_pop();
                add_definition($name, $ptr);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STRING_SEEK)
        {
            if (check_depth(2))
            {
                $a = slice_to_string(stack_pop());
                $b = slice_to_string(stack_pop());
                if (strpos($b, $a) === FALSE)
                    stack_push(-1, $TYPE_NUMBER);
                 else
                    stack_push(strpos($b, $a), $TYPE_NUMBER);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STRING_SUBSTR)
        {
            if (check_depth(3))
            {
                $a = intval(stack_pop());
                $b = intval(stack_pop());
                $c = slice_to_string(stack_pop());
                $c = substr($c, $b, $a);
                stack_push(string_to_slice($c), $TYPE_STRING);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_STRING_NUMERIC)
        {
            if (check_depth(1))
            {
                $a = slice_to_string(stack_pop());
                if (is_numeric($a))
                    stack_push(-1, $TYPE_FLAG);
                else
                    stack_push(0, $TYPE_FLAG);
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_TO_UPPER)
        {
            if (check_depth(1))
            {
                $t = stack_type();
                if ($t == $TYPE_STRING)
                {
                    $ptr = stack_pop();
                    $a = strtoupper(slice_to_string($ptr));
                    stack_push(string_to_slice($a), $TYPE_STRING);
                }
                elseif ($t == $TYPE_CHARACTER)
                {
                    $a = stack_pop();
                    $b = " ";
                    $b[0] = chr($a);
                    $c = strtoupper($b);
                    $a = $c[0];
                    stack_push(ord($a), $TYPE_CHARACTER);
                }
                else
                    $t = 0;
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_TO_LOWER)
        {
            if (check_depth(1))
            {
                $t = stack_type();
                if ($t == $TYPE_STRING)
                {
                    $ptr = stack_pop();
                    $a = strtolower(slice_to_string($ptr));
                    stack_push(string_to_slice($a), $TYPE_STRING);
                }
                elseif ($t == $TYPE_CHARACTER)
                {
                    $a = stack_pop();
                    $b = " ";
                    $b[0] = chr($a);
                    $c = strtolower($b);
                    $a = $c[0];
                    stack_push(ord($a), $TYPE_CHARACTER);
                }
                else
                    $t = 0;
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_LENGTH)
        {
            if (check_depth(1))
            {
                if (stack_type() == $TYPE_STRING)
                {
                    $a = slice_to_string(stack_tos());
                    stack_push(strlen($a), $TYPE_NUMBER);
                }
                else
                {
                    stack_drop();
                    stack_push(0, $TYPE_NUMBER);
                }
            }
            else
                $offset = $SLICE_LEN;
        }
        elseif ($opcode == $BC_REPORT_ERROR)
        {
            if (check_depth(1))
            {
                if (stack_type() == $TYPE_STRING)
                {
                    $a = slice_to_string(stack_tos());
                    report_error($a);
                }
            }
            $offset = $SLICE_LEN;
        }
        else
            $offset = $SLICE_LEN;

        $offset += 1;
    }
}



function string_to_slice($string)
{
    $s = request_slice();
    $i = 0;
    $limit = strlen($string);
    while ($i < $limit)
    {
        store(ord(substr($string, $i, 1)), $s, $i);
        $i += 1;
    }
    store(0, $s, $i);
    return $s;
}

function slice_to_string($slice)
{
    global $SLICE_LEN;
    $s = array();
    $i = 0;
    while ($i < $SLICE_LEN)
    {
        if (fetch($slice, $i) != 0)
            array_push($s, chr(fetch($slice, $i)));
        else
            $i = $SLICE_LEN;
        $i += 1;
    }
    return join("", $s);
}


function stack_clear()
{
    global $stack;
    $i = count($stack);
    while ($i > 0)
    {
        stack_drop();
        $i -= 1;
    }
}

function stack_push($v, $t)
{
    global $stack, $types;
    array_push($stack, $v);
    array_push($types, $t);
}


function stack_pop()
{
    global $stack, $types;
    array_pop($types);
    return array_pop($stack);
}

function stack_drop()
{
    stack_pop();
}

function tos()
{
    global $stack;
    return count($stack) - 1;
}

function stack_tos()
{
    global $stack;
    return $stack[tos()];
}

function stack_type()
{
    global $types;
    $a = array_pop($types);
    array_push($types, $a);
    return $a;
}

function stack_swap()
{
    $at = stack_type();
    $av = stack_pop();
    $bt = stack_type();
    $bv = stack_pop();
    stack_push($av, $at);
    stack_push($bv, $bt);
}

function stack_dup()
{
    global $TYPE_NUMBER, $TYPE_STRING, $TYPE_CHARACTER, $TYPE_FUNCTION, $TYPE_FLAG;

    $at = stack_type();
    $av = stack_pop();
    stack_push($av, $at);
    if ($at == $TYPE_STRING)
    {
        $s = request_slice();
        copy_slice($av, $s);
        stack_push($s, $at);
    }
    else
        stack_push($av, $at);
}


function stack_over()
{
    global $TYPE_NUMBER, $TYPE_STRING, $TYPE_CHARACTER, $TYPE_FUNCTION, $TYPE_FLAG;

    $at = stack_type();
    $av = stack_pop();
    $bt = stack_type();
    $bv = stack_pop();
    stack_push($bv, $bt);
    stack_push($av, $at);
    if ($bt == $TYPE_STRING)
    {
        $s = request_slice();
        copy_slice($bv, $s);
        stack_push($s, $bt);
    }
    else
        stack_push($bv, $bt);
}

function stack_tuck()
{
    stack_swap();
    stack_over();
}


function copy_slice($source, $dest)
{
    global $SLICE_LEN;

    $i = 0;
    while ($i < $SLICE_LEN)
    {
        store(fetch($source, $i), $dest, $i);
        $i += 1;
    }
}


function stack_change_type($type)
{
    global $TYPE_NUMBER, $TYPE_STRING, $TYPE_CHARACTER, $TYPE_FUNCTION, $TYPE_FLAG;
    global $types, $stack;

    if ($type == $TYPE_NUMBER)
    {
        if (stack_type() == $TYPE_STRING)
        {
            $a = stack_pop();

            if (is_numeric(slice_to_string($a)))
                stack_push(floatval(slice_to_string($a)), $TYPE_NUMBER);
            else
                stack_push(0, $TYPE_NUMBER);
        }
        else
        {
            array_pop($types);
            array_push($types, $TYPE_NUMBER);
        }
    }
    elseif ($type == $TYPE_STRING)
    {
        if (stack_type() == $TYPE_NUMBER)
            stack_push(string_to_slice(strval(stack_pop())), $TYPE_STRING);
        elseif (stack_type() == $TYPE_CHARACTER)
        {
            $s = " ";
            $s[0] = chr(stack_pop());
            stack_push(string_to_slice($s), $TYPE_STRING);
        }
        elseif (stack_type() == $TYPE_FLAG)
        {
            $s = stack_pop();
            if ($s == -1)
                stack_push(string_to_slice('true'), $TYPE_STRING);
            elseif ($s == 0)
                stack_push(string_to_slice('false'), $TYPE_STRING);
            else
                stack_push(string_to_slice('malformed flag'), $TYPE_STRING);
        }
        elseif (stack_type() == $TYPE_FUNCTION)
        {
            array_pop($types);
            array_push($types, $TYPE_STRING);
        }
        else
            return 0;
    }
    elseif ($type == $TYPE_CHARACTER)
    {
        if (stack_type() == $TYPE_STRING)
        {
            $s = slice_to_string(stack_pop());
            stack_push(ord($s[0]), $TYPE_CHARACTER);
        }
        else
        {
            $s = stack_pop();
            stack_push(intval($s), $TYPE_CHARACTER);
        }
    }
    elseif ($type == $TYPE_FUNCTION)
    {
        array_pop($types);
        array_push($types, $TYPE_FUNCTION);
    }
    elseif ($type == $TYPE_FLAG)
    {
        if (stack_type() == $TYPE_STRING)
        {
            $s = slice_to_string(stack_pop());
            if ($s == 'true')
                stack_push(-1, $TYPE_FLAG);
            elseif ($s == 'false')
                stack_push(0, $TYPE_FLAG);
            else
                stack_push(1, $TYPE_FLAG);
        }
        else
        {
            $s = stack_pop();
            stack_push($s, $TYPE_FLAG);
        }
    }
    else
        return;
}


function parse_bootstrap($lines)
{
    global $errors;
    foreach ($lines as $src)
    {
        if (strlen(trim($src)) > 0)
        {
            $s = compile($src, request_slice());
            interpret($s);
        }

        foreach ($errors as $msg)
            echo "<tt>$msg</tt><br>";

        $errors = array();
    }
}

prepare_memory();
prepare_dictionary();
parse_bootstrap(file('bootstrap.p'));
?>
