<?
require_once("parable.php");

$bootstrap = file('tests.parable');

foreach ($bootstrap as $src)
{
    if (strlen(trim($src)) > 0)
    {
        $s = compile($src, request_slice());
        interpret($s);
    }

    foreach ($errors as $err)
    {
        echo "<tt>$err</tt><br>\n";
    }
    $errors = array();

}



$TYPE_NUMBER    = 100;
$TYPE_STRING    = 200;
$TYPE_CHARACTER = 300;
$TYPE_FUNCTION  = 400;
$TYPE_FLAG      = 500;

$i = 0;
while ($i < count($stack))
{
    if ($types[$i] == $TYPE_NUMBER)
    {
        echo $i, ' #', $stack[$i], '<br>';
    }
    if ($types[$i] == $TYPE_CHARACTER)
    {
        echo $i, ' $', chr($stack[$i]), '<br>';
    }
    if ($types[$i] == $TYPE_STRING)
    {
        echo $i, " '", slice_to_string($stack[$i]), "'<br>";
    }
    if ($types[$i] == $TYPE_FUNCTION)
    {
        echo $i, ' &amp;', $stack[$i], '<br>';
    }
    if ($types[$i] == $TYPE_FLAG)
    {
        echo $i, ' FLAG: ', $stack[$i], '<br>';
    }
    echo "\n";
    $i += 1;
}

foreach ($dictionary_names as $n)
{
//    echo $n."\n";
}

?>
