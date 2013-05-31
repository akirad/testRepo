use strict;
use warnings;

my $dir = $ARGV[0];
if(! -d $dir){
    die "Invalid argument.";
}
$dir =~ s|\\|/|g; # Just in case.

my @fileList;
getFileList($dir, \@fileList);

foreach my $file (@fileList){
    chomp($file);
    if(-f $file){
        open(IN, $file);
        binmode IN; # If not, all linefeeds are changed to "LF" inside Perl.

        my $lineNum=1;
        foreach my $line (<IN>){
            if($line !~ /\r\n$/){
                print("$file has LF in line $lineNum.\n");
            }
            $lineNum++;
        }
    }
}


sub getFileList{
    my $dir = shift;
    my $ref_fileList = shift; # for output.
    
    opendir(DIR, $dir);
    my @fileList = readdir(DIR);
    closedir(DIR);
    
    foreach my $file (sort @fileList){
        if(($file =~ /^\.{1,2}$/) || ($file =~ /\.orig$/)){
            next;
        }
        
        if( -d "$dir/$file"){
            getFileList("$dir/$file", $ref_fileList);
        }
        else{
            push(@$ref_fileList, "$dir/$file");
        }
    }
}
