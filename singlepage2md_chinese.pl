#!usr/bin/perl -w


my @k="01".."64";

foreach my $k(@k){
  my $dir = "/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror/jstatsoft/v$k";
  my $dir1="/run/media/root/LIVE/Yu/Github/jstatsoft_ChineseMirror/jstatsoft_cn/v$k";
  system "mkdir $dir1";
  opendir DIR, "$dir" or die "cannot open dir $dir: $!";
  my @file= readdir DIR;
  closedir DIR;
  foreach my $file(@file){

    open DATA,"$dir/$file" or die "Couldn't open $file: $!";

    while(<DATA>){
=put
      $_=~s/Articles/论文/g;
      $_=~s/Code Snippets/代码片断/g;
      $_=~s/software reviews/软件综述/g;
      $_=~s/Book Reviews/书籍综述/g;
=cut
      $_=~s/Item/项目/g;
      $_=~s/Detail/具体内容/g;
      $_=~s/Link/链接/g;
      $_=~s/Authors/作者/g;
      $_=~s/Title/题目/g;
      $_=~s/Reference/参考资料/g;
      $_=~s/Type/类别/g;
      $_=~s/Abstract/摘要/g;
      $_=~s/\| Paper \|/\| 论文 \|/g;
      $_=~s/Supplements/补充材料/g;
      $_=~s/Resources/资源/g;
      $_=~s/Book\'s authors/作者/g;
      $_=~s/Reviewers/审稿人/g;
      $_=~s/Book\'s title /书名/g;
      $_=~s/Book\'s publisher/图书出版商/g;
      $_=~s/\| Year \|/\| 出版年份 \|/g;
      $_=~s/Version/版本/g;
      $_=~s/\[download\]/\[下载地址\]/g;
      $_=~s/Article/论文/g;
      $_=~s/Code Snippet/代码片断/g;
      $_=~s/software review/软件综述/g;
      $_=~s/\| Book Review \|/\| 书籍综述 \|/g;
      $_=~s/R source package/R软件包源代码/g;
      $_=~s/R example code from the paper/论文的示例程序/g;

      $_=~s/Submitted/提交日期/g;
      $_=~s/Accepted/接收日期/g;
      open LOG,">>$dir1/$file" or die "Couldn't open $file: $!";
      print LOG $_;
      close LOG;
    }
    close DATA; 
  }

}

