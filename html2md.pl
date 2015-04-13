#!usr/bin/perl -w

use POSIX qw(strftime);

use LWP;
use LWP::Simple; 
use open ':std', ':encoding(UTF-8)';
use encoding "utf-8";
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

$thepath = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror"; 
$out_file = "$thepath/temp_file";
$md_file = "$thepath/jstatsoft";
my $date = strftime "%Y-%m-%d", localtime;


my @k = "52".."64";
my $k;
foreach $k(@k){
  
  sleep 5;

  my $url = "http://www.jstatsoft.org/v$k";

  my $content = get $url;
  die "Couldn't get $url" unless defined $content;
  

  my $begin = "\<h3\>Volume ";
  my $end = "\<div class=\"actions\" style=\"margin-top: 30px;\">";

  if($content =~ m/$begin(.*)$end/sgm){
    open PLOG,">$out_file" or die "Couldn't open $out_file: $!";
    print PLOG $1; 
    close PLOG; 

    open DATA, $out_file or die "cannot open file";
    open LOG,">$md_file/$date-v$k.md" or die "Couldn't open $out_file: $!";
    while (<DATA>) {
      my $file = $_;
      if ($file =~ m#^(\d*)</h3>#sg){
        print LOG "---\npublished: false\ntitle: 第 $1 卷\nlayout: post\nauthor: Yu\ncategories: Volume\n---\n\n* table of content\n{:toc}\n\n"; 
      }elsif ($file =~ m#<h4>(.*)</h4>#sg ){       
        print LOG "## $1\n\n***\n\n";        
      }elsif ($file =~ m# <a href="/v$k/(\w\d+)">(.*)</a><br/>#sg){
        print LOG "### [$2](/jstatsoft/v$k/$1.html)\n\n";  
      }elsif ($file =~ m#<i>(.*)</i><br/>#sg){
        print LOG "*$1*\n\n";   
      }elsif ($file =~ m#^\s+(.*)<div class='da#sg){
        print LOG "##### $1\n\n";
        if ($file =~ m#tes'>(.*)</div>#sg){
          print LOG "##### $1\n\n";
           
        }
      }
    }
    close LOG;  
    close DATA;
  }
}
