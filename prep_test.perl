#!/opt/bin/perl

#########################################################################################
#                                                                                       #
#	prep_test.perl: prepare for test						#
#                                                                                       #
#       author: t. isobe (tisobe@cfa.harvard.edu)                                       #
#                                                                                       #
#       last update: Mar 13, 2013                                                       #
#                                                                                       #
#########################################################################################
#
#--- check whether this is a test case
#

$comp_test = $ARGV[0];
chomp $comp_test;

#
#---- read directories
#
open(FH, "/data/mta/Script/Cusmail_linux/house_keeping/dir_list_test");

while(<FH>){
    chomp $_;
    @atemp = split(/\s+/, $_);
    ${$atemp[0]} = $atemp[1];
}
close(FH);

system("mkdir $test_dir");
system("mkdir $cmail_dir");
system("mkdir $arch_dir");
system("mkdir $secondary_dir");
system("mkdir $test_dir/mails/");
system("cp $house_keeping/Test_prep/mail_archive* $test_dir/mails/");
system("cp /data/mta4/CUS/www/MAIL/ARCHIVE/2013FEB/* $cmail_dir");
