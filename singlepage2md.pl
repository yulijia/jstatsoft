#!usr/bin/perl -w

use POSIX qw(strftime);
use LWP;
use LWP::Simple; 
use open ':std', ':encoding(UTF-8)';

use encoding "utf-8";
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');

my $date = strftime "%Y-%m-%d", localtime;
my $thepath = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror"; 
my $out_file = "$thepath/temp_file";
my $md_output = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror/jstatsoft";
my @k = ("58");##"43".."64";
my $k;
foreach $k(@k){

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
    system "mkdir $md_output/v$k";
    while (<DATA>) {
      my $file = $_;
      sleep 2;
      if ($file =~ m# <a href="/v$k/(\w\d+)">(.*)</a><br/>#sg){
        my $page=$1;
        my $url = "http://www.jstatsoft.org/v$k/$page/";
        my $content = get $url;
        die "Couldn't get $url" unless defined $content;
       $page =~ /i/ ? & subpage_article($content,$page,$k) :
       $page =~ /s/ ? & subpage_software($content,$page,$k):
       $page =~ /b/ ? & subpage_book($content,$page,$k): 
                      & subpage_code($content,$page,$k);
      }
    }
    close DATA;
  }
}

sub subpage_article{
  my $web = "http://www.jstatsoft.org";
  my $path = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror"; 
  my $output = "$path/temp_file_output";
  my $md_output = "$path/jstatsoft";
  my $begin = "<table id=\"show-document\" style=\"width:100%;\">";
  my $end = "<div class=\'license\' style=\'text-align: center; margin-top: 12px; width: 100%;\'>";
  my ($content,$page,$k) = @_;
  if($content =~ m/$begin(.*)$end/sgm){
    open PLOG1,">$output" or die "Couldn't open $out_file: $!";
    print PLOG1 $1; 
    close PLOG1; 

    open DATA1, $output or die "cannot open file";
    my $flag=0;
    #system "mkdir $md_output/v$k";
    open LOG,">$md_output/v$k/$date-$page.md" or die "Couldn't open $out_file: $!";
    
    print LOG "---\npublished: false\ntitle: $page\nlayout: post\nauthor: Yu\ncategories: v$k\nhidden: true\n---\n\n";
    
    print LOG "| Item | Detail | Link |\n|---:|---|---|\n";
      while (<DATA1>) {
      my $file = $_;
      if ( $file =~ m#<td class=(?:"|')label(?:"|')>(.*):\s?</td>#sg){
        $result = $1;
        if ($result eq "Supplements"){
          print LOG "| $result | | |\n";
        }else{
          print LOG "| $result |";
        } 
      } elsif(!defined $result){
      } elsif ( $result eq "Authors") {
        if($file =~ m#<td class="content">(\D*)</td>#sg ){       
          print LOG " $1| |\n";       
        } 
      } elsif ($result eq "Title") {
        if ($file =~ m#</span><b>(.*)</b></td>#sg){
          print LOG "$1 | [download]($web/v$k/$page/paper) |\n";
        }
      } elsif ($result eq "Reference") {
        if ($file =~ m#<td class="content">(.*)<div class='dates'>(.*)</div></td>#sg){
          print LOG "$1 | |\n| | $2| | \n";
        }
      } elsif ($result eq "Type") {
        if ($file =~ m#<td class="content">(\D*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Abstract") {
        if ($file =~ m#<p>(.*)</p>#sg || $file =~ m#<p>(.*)<?/?p?>?#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Paper") {
        if ($file =~ m#</span>(.*)<br/>(.*)</td>#sg){
          print LOG " $1 $2| [download]($web/v$k/$page/paper) |\n";  
        }
      } elsif ($result eq "Supplements") {
        if ($file =~ m#<a href="/v$k/$page/(.*)">download</a>]\s?(?:.*)</span>(.*)<br/>(.*)</td>#sg){ 
          print LOG "| |$2 $3|  [download]($web/v$k/$page/$1) |\n"; 
        }
      } elsif ($result eq "Resources") {
        if ($file =~ m#<td class="content"><a href="/v$k/$page/bibtex">BibTeX</a> | <a href="/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/(.*)&prefix=oai_dc">OAI</a></td>#sg){
          print LOG " [BibTeX]($web/v$k/$page/bibtex) [OAI]($web/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/$page&prefix=oai_dc)| |\n"; 
          }
        }
    }
    print LOG "| |  | [返回卷目录]({{site.baseurl}}/volume/v$k.html) |";
    close LOG;  
    close DATA1;
  }

}



sub subpage_book{
  my $web = "http://www.jstatsoft.org";
  my $path = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror"; 
  my $output = "$path/temp_file_output";
  my $md_output = "$path/jstatsoft";
  my $begin = "<table id=\"show-document\" style=\"width:100%;\">";
  my $end = "<div class=\'license\' style=\'text-align: center; margin-top: 12px; width: 100%;\'>";
  my ($content,$page,$k) = @_;
  if($content =~ m/$begin(.*)$end/sgm){
    open PLOG1,">$output" or die "Couldn't open $out_file: $!";
    print PLOG1 $1; 
    close PLOG1; 

    open DATA1, $output or die "cannot open file";
    #system "mkdir $md_output/v$k";
    
    open LOG,">$md_output/v$k/$date-$page.md" or die "Couldn't open $out_file: $!";
    
    print LOG "---\npublished: false\ntitle: $page\nlayout: post\nauthor: Yu\ncategories: v$k\nhidden: true\n---\n\n";
    
    print LOG "| Item | Detail | Link |\n|---:|---|---|\n";
    my $flag=0;
    while (<DATA1>) {
      my $file = $_;
      if ( $file =~ m#<td class=(?:"|')label(?:"|')>(.*):\s?</td>#sg){
        $result = $1;
        if ($result eq "Supplements"){
          print LOG "| $result | | |\n";
        }else{
          print LOG "| $result |";
        } 
      } elsif(!defined $result){
      } elsif ( $result eq "Reviewers") {
        if($file =~ m#<td class="content">(\D*)</td>#sg ){       
          print LOG " $1| |\n";       
        } 
      } elsif ($result eq "Title") {
        if ($file =~ m#</span><b>(.*)</b></td>#sg){
          print LOG "$1 | [download]($web/v$k/$page/paper) |\n";
        }
      } elsif ($result eq "Reference") {
        if ($file =~ m#<td class="content">(.*)<div class='dates'>(.*)</div></td>#sg){
          print LOG "$1 | |\n| | $2| | \n";
        }
      } elsif ($result eq "Type") {
        if ($file =~ m#<td class="content">(\D*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Book\'s authors"){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Book\'s title"){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Book\'s publisher"){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "ISBN"){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Year"){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      }elsif ($result eq "Paper") {
        if ($file =~ m#</span>(.*)<br/>(.*)</td>#sg){
          print LOG " $1 $2| [download]($web/v$k/$page/paper) |\n";  
        }
      } elsif ($result eq "Supplements") {
        if ($file =~ m#<a href="/v$k/$page/(.*)">download</a>]\s?(?:.*)</span>(.*)<br/>(.*)</td>#sg){ 
          print LOG "| |$2 $3|  [download]($web/v$k/$page/$1) |\n"; #
        }
      } elsif ($result eq "Resources") {
        if ($file =~ m#<td class="content"><a href="/v$k/$page/bibtex">BibTeX</a> | <a href="/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/(.*)&prefix=oai_dc">OAI</a></td>#sg){
          print LOG " [BibTeX]($web/v$k/$page/bibtex) [OAI]($web/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/$page&prefix=oai_dc)| |\n"; 
          }
        }
    }
    print LOG "| |  | [返回卷目录]({{site.baseurl}}/volume/v$k.html) |";
    close LOG;  
    close DATA1;
  }

}

sub subpage_software{
  my $web = "http://www.jstatsoft.org/";
  my $path = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror"; 
  my $output = "$path/temp_file_output";
  my $md_output = "$path/jstatsoft";
  my $begin = "<table id=\"show-document\" style=\"width:100%;\">";
  my $end = "<div class=\'license\' style=\'text-align: center; margin-top: 12px; width: 100%;\'>";
  my ($content,$page,$k) = @_;
  if($content =~ m/$begin(.*)$end/sgm){
    open PLOG1,">$output" or die "Couldn't open $out_file: $!";
    print PLOG1 $1; 
    close PLOG1; 

    open DATA1, $output or die "cannot open file";
    #system "mkdir $md_output/v$k";
    
    open LOG,">$md_output/v$k/$date-$page.md" or die "Couldn't open $out_file: $!";
    print LOG "---\npublished: false\ntitle: $page\nlayout: post\nauthor: Yu\ncategories: v$k\nhidden: true\n---\n\n";
    
    print LOG "| Item | Detail | Link |\n|---:|---|---|\n";
    my $flag=0;
    while (<DATA1>) {
      my $file = $_;
      if ( $file =~ m#<td class=(?:"|')label(?:"|')>(.*):\s?</td>#sg){
        $result = $1;
        if ($result eq "Supplements"){
          print LOG "| $result | | |\n";
        }else{
          print LOG "| $result |";
        } 
      } elsif(!defined $result){
      } elsif ( $result eq "Authors") {
        if($file =~ m#<td class="content">(\D*)</td>#sg ){       
          print LOG " $1| |\n";       
        } 
      } elsif ($result eq "Title") {
        if ($file =~ m#</span><b>(.*)</b></td>#sg){
          print LOG "$1 | [download]($web/v$k/$page/paper) |\n";
        }
      } elsif ($result eq "Reference") {
        if ($file =~ m#<td class="content">(.*)<div class='dates'>(.*)</div></td>#sg){
          print LOG "$1 | |\n| | $2| | \n";
        }
      } elsif ($result eq "Type") {
        if ($file =~ m#<td class="content">(\D*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Version "){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Company "){
        if ($file =~ m#<td class="content">(.*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Paper") {
        if ($file =~ m#</span>(.*)<br/>(.*)</td>#sg){
          print LOG " $1 $2| [download]($web/v$k/$page/paper) |\n";  
        }
      } elsif ($result eq "Supplements") {
        if ($file =~ m#<a href="/v$k/$page/(.*)">download</a>]\s?(?:.*)</span>(.*)<br/>(.*)</td>#sg){ 
          print LOG "| |$2 $3|  [download]($web/v$k/$page/$1) |\n"; #
        }
      }  elsif ($result eq "Resources") {
        if ($file =~ m#<td class="content"><a href="/v$k/$page/bibtex">BibTeX</a> | <a href="/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/(.*)&prefix=oai_dc">OAI</a></td>#sg){
          print LOG " [BibTeX]($web/v$k/$page/bibtex) [OAI]($web/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/$page&prefix=oai_dc)| |\n"; 
          }
        }
    }
    print LOG "| |  | [返回卷目录]({{site.baseurl}}/volume/v$k.html) |";
    close LOG;  
    close DATA1;
  }

}



sub subpage_code{
  my $web = "http://www.jstatsoft.org";
  my $path = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror"; 
  my $output = "$path/temp_file_output";
  my $md_output = "$path/jstatsoft";
  my $begin = "<table id=\"show-document\" style=\"width:100%;\">";
  my $end = "<div class=\'license\' style=\'text-align: center; margin-top: 12px; width: 100%;\'>";
  my ($content,$page,$k) = @_;
  if($content =~ m/$begin(.*)$end/sgm){
    open PLOG1,">$output" or die "Couldn't open $out_file: $!";
    print PLOG1 $1; 
    close PLOG1; 

    open DATA1, $output or die "cannot open file";
    #system "mkdir $md_output/v$k";
    open LOG,">$md_output/v$k/$date-$page.md" or die "Couldn't open $out_file: $!";
    print LOG "---\npublished: false\ntitle: $page\nlayout: post\nauthor: Yu\ncategories: v$k\nhidden: true\n---\n\n";
    
    print LOG "| Item | Detail | Link |\n|---:|---|---|\n";
    my $flag=0;
    while (<DATA1>) {
      my $file = $_;
      if ( $file =~ m#<td class=(?:"|')label(?:"|')>(.*):\s?</td>#sg){
        $result = $1;
        if ($result eq "Supplements"){
          print LOG "| $result | | |\n";
        }else{
          print LOG "| $result |";
        } 
      } elsif(!defined $result){
      } elsif ( $result eq "Authors") {
        if($file =~ m#<td class="content">(\D*)</td>#sg ){       
          print LOG " $1| |\n";       
        } 
      } elsif ($result eq "Title") {
        if ($file =~ m#</span><b>(.*)</b></td>#sg){
          print LOG "$1 | [download]($web/v$k/$page/paper) |\n";
        }
      } elsif ($result eq "Reference") {
        if ($file =~ m#<td class="content">(.*)<div class='dates'>(.*)</div></td>#sg){
          print LOG "$1 | |\n| | $2| | \n";
        }
      } elsif ($result eq "Type") {
        if ($file =~ m#<td class="content">(\D*)</td>#sg){
          print LOG " $1| |\n";  
        }
      } elsif ($result eq "Paper") {
        if ($file =~ m#</span>(.*)<br/>(.*)</td>#sg){
          print LOG " $1 $2| [download]($web/v$k/$page/paper) |\n";  
        }
      } elsif ($result eq "Supplements") {
        if ($file =~ m#<a href="/v$k/$page/(.*)">download</a>]\s?(?:.*)</span>(.*)<br/>(.*)</td>#sg){ 
          print LOG "| |$2 $3|  [download]($web/v$k/$page/$1) |\n"; #
        }
      } elsif ($result eq "Resources") {
        if ($file =~ m#<td class="content"><a href="/v$k/$page/bibtex">BibTeX</a> | <a href="/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/(.*)&prefix=oai_dc">OAI</a></td>#sg){
          print LOG " [BibTeX]($web/v$k/$page/bibtex) [OAI]($web/oai?verb=GetRecord&identifier=oai.jstatsoft/v$k/$page&prefix=oai_dc)| |\n"; 
          }
        }
    }
    print LOG "| |  | [返回卷目录]({{site.baseurl}}/volume/v$k.html) |";
    close LOG;  
    close DATA1;
  }

}


