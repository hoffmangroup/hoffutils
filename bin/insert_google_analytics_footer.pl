#!/usr/bin/perl -w

use strict;

my $footer = <<END;

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-48283039-1', 'pmgenomics.ca');
  ga('send', 'pageview');

</script>
END

my $html = "";
{
    local $/ = undef ;
    $html = <>;
}
if($html !~ s/(<\/head>)/$footer$1/si)
{
    $html .= $footer;
}
print $html;
