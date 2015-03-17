<? set_time_limit(60); ?>
<!DOCTYPE html>
<head>
<title>parable language</title>
<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.min.css" rel="stylesheet">
<link href="//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet">
<style>
    i { font-size: 200%; }
</style>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-246810-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
<meta charset=UTF-8>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
<div class="container">
  <div class="row"><div class="span12">&nbsp;</div></div>

  <div class="row">
    <div class="span6">
      <form name='editor' id='editor' action='punga.php' method='post'>
          <textarea rows='10' class='span6' name='code' placeholder='enter your code here'><? echo $_POST['code']; ?></textarea>
      <a onClick='document.forms["editor"].submit()' class='btn'>Evaluate</a>
      </form>
    </div>
    <div class="span6">
      <?
          require_once("parable.php");
          $bootstrap = explode("\n", $_POST['code']);

          foreach ($bootstrap as $src)
          {
              if (strlen(trim($src)) > 0)
              {
                  $s = compile($src, request_slice());
                  interpret($s);
              }
          }

          if (!empty($errors))
          {
              echo "<div class='alert alert-error'>";
              foreach ($errors as $err)
              {
                  echo "<tt>$err</tt><br>\n";
              }
              $errors = array();
              echo "</div>";
          }

          $TYPE_NUMBER    = 100;
          $TYPE_STRING    = 200;
          $TYPE_CHARACTER = 300;
          $TYPE_FUNCTION  = 400;
          $TYPE_FLAG      = 500;

          if (!empty($stack))
          {
          echo "<table class='table table-bordered'>";
          $i = 0;
          while ($i <= count($stack))
          {
              if ($types[$i] == $TYPE_NUMBER)
              {
                  echo "<tr><td>$i</td><td>#" . $stack[$i] . "</td></tr>";
              }
              if ($types[$i] == $TYPE_CHARACTER)
              {
                  echo "<tr><td>$i</td><td>$" . chr($stack[$i]) . "</td></tr>";
              }
              if ($types[$i] == $TYPE_STRING)
              {
                  echo "<tr><td>$i</td><td>'" . slice_to_string($stack[$i]) . "'</td></tr>";
              }
              if ($types[$i] == $TYPE_FUNCTION)
              {
                  echo "<tr><td>$i</td><td>&amp;" . $stack[$i] . "</td></tr>";
              }
              if ($types[$i] == $TYPE_FLAG)
              {
                  if ($stack[$i] == -1)
                      echo "<tr><td>$i</td><td>true</td></tr>";
                  if ($stack[$i] == 0)
                      echo "<tr><td>$i</td><td>false</td></tr>";
                  if ($stack[$i] != 0 && $stack[$i] != -1)
                      echo "<tr><td>$i</td><td>malformed flag</td></tr>";
              }
              $i += 1;
          }
          echo "</table>";
          }
      ?>
    </div>
  </div>

  <div class="row"><div class="span12">&nbsp;</div></div>
  <div class="row"><div class="span12"><a href="http://forthworks.com/parable">Parable</a><br>
    &copy; 2012-2013, <a href="http://forthworks.com">Charles Childers</a>
  </div></div>
  <!-- parable is copyright (c) 2012-2013, charles childers -->
</div>
</body>
</html>
