<?
require_once("parable.php");

$bootstrap = file($argv[1]);

foreach ($bootstrap as $src)
{
    if (strlen(trim($src)) > 0)
    {
        $s = compile($src, request_slice());
        interpret($s);
    }

    foreach ($errors as $err)
    {
        echo "$err";
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
        echo $i, "\t", ' #', $stack[$i];
    }
    if ($types[$i] == $TYPE_CHARACTER)
    {
        echo $i, "\t", ' $', chr($stack[$i]);
    }
    if ($types[$i] == $TYPE_STRING)
    {
        echo $i, "\t", " '", slice_to_string($stack[$i]), "'";
    }
    if ($types[$i] == $TYPE_FUNCTION)
    {
        echo $i, "\t", ' &', $stack[$i];
    }
    if ($types[$i] == $TYPE_FLAG)
    {
        echo $i, "\t", ' FLAG: ', $stack[$i];
    }
    echo "\n";
    $i += 1;
}

?>
