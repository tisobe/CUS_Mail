#!/usr/bin/perl

#########################################################################################
#											#
#	update_cus_mail_dec.perl: move an old cus email to archive and clean up 	#
#			      Dec directory						#
#                             this one is needed to be run on Dec 31, 23:45 so that we	#
#			      do not lose much data from Dec...				#
#											#
#	author: t. isobe (tisobe@cfa.harvard.edu)					#
#											#
#	last update: Jun 05, 2008							#
#											#
#########################################################################################

#
#--- get today's date
#

($usec, $umin, $uhour, $umday, $umon, $uyear, $uwday, $uyday, $uisdst)= localtime(time);

$year   = 1900   + $uyear;
$month  = $umon + 1;

#
#--- this script must be run only Dec 31
#

if($month < 12){
	exit 1;
}
if($uyday < 365){
	exit 1;
}

#
#--- change month from number to letters
#

mo_no_to_lett($month);

$lmo_up = $month_up;
$lmo_lo = $month_lo;
$lmo_fl = $month_fl;

#
#--- find out the last month
#

if($umon == 0){
	$lmonth = 12;
	$lyear = $year -1;
}else{
	$lmonth = $umon;
	$lyear  = $year;
}

mo_no_to_lett($lmonth);

$pmo_up = $month_up;
$pmo_lo = $month_lo;
$pmo_fl = $month_fl;
	

#
#--- create a new directory for the last month's archive
#


$a_dir = '/data/mta4/CUS/www/MAIL/ARCHIVE/'."$lyear"."$lmo_up";
system("mkdir $a_dir");

$b_dir = '/arc/cus/mail_archive';

system("/usr/local/bin/hypermail -m $b_dir -d $a_dir -c /home/cus/HYPERMAIL/hypermail.config");

#
#--- clean up the last month's mail, and save them in SECONDARY_SAVE
#

$c_dir = '/data/mta4/CUS/www/MAIL/SECONDARY_SAVE/'."$lyear"."$lmo_up".'/';
system("mkdir $c_dir");
system("cp     /data/mta4/CUS/www/MAIL/*.html $c_dir");
system("cp -r  /data/mta4/CUS/www/MAIL/a*     $c_dir");

system("/usr/local/bin/hypermail -m /arc/cus/mail_archive -d /data/mta4/CUS/www/MAIL -c /home/cus/HYERMAIL/hypermail.config");

#
#--- add new lines to the html page
#

system("cp /data/mta4/CUS/www/MAIL/ARCHIVE/index.html /data/mta4/CUS/www/MAIL/ARCHIVE/index.html~");
open(FH, "/data/mta4/CUS/www/MAIL/ARCHIVE/index.html~");

@save = ();

$current = '<LI><A HREF="../."><STRONG> Current Month: '."$cmo_fl $year".'</STRONG></A>';
$test    = '<LI><A HREF="./'."$pyear$pmo_up".'"><STRONG> '."$pmo_fl $pyear".'</STRONG></A>';
$line    = '<LI><A HREF="./'."$lyear$lmo_up".'"><STRONG> '."$lmo_fl $lyear".'</STRONG></A>';

while(<FH>){
	chomp $_;
	if($_ =~ /$test/){
		push(@save, $_);
		if($lmonth != 1){
			push(@save, $line);
		}
	}elsif($_ =~ /Current Month:/){
		push(@save, $current);
		if($lmonth == 1){
			$tline = '<hr>';
			$new1 = '<h3> '."$year".'<h3>';
			push(@save, $tline);
			push(@save, $new1);
			push(@save, $line);
		}
	}else{
		push(@save, $_);
	}
}
close(FH);

open(OUT, "> /data/mta4/CUS/www/MAIL/ARCHIVE/index.html");
foreach $ent (@save){
	print OUT "$ent\n";
}
close(OUT);
	

##################################################################
### convert month in number to month name in letters        ######
##################################################################

sub mo_no_to_lett {
	($no_month) = @_;
	if($no_month == 1){
		$month_up = 'JAN';
		$month_lo = 'Jan';
		$month_fl = 'January';
	}elsif($no_month == 2){
		$month_up = 'FEB';
		$month_lo = 'Feb';
		$month_fl = 'February';
	}elsif($no_month == 3){
		$month_up = 'MAR';
		$month_lo = 'Mar';
		$month_fl = 'March';
	}elsif($no_month == 4){
		$month_up = 'APR';
		$month_lo = 'Apr';
		$month_fl = 'April';
	}elsif($no_month == 5){
		$month_up = 'MAY';
		$month_lo = 'May';
		$month_fl = 'May';
	}elsif($no_month == 6){
		$month_up = 'JUN';
		$month_lo = 'Jun';
		$month_fl = 'June';
	}elsif($no_month == 7){
		$month_up = 'JUL';
		$month_lo = 'Jul';
		$month_fl = 'July';
	}elsif($no_month == 8){
		$month_up = 'AUG';
		$month_lo = 'Aug';
		$month_fl = 'August';
	}elsif($no_month == 9){
		$month_up = 'SEP';
		$month_lo = 'Sep';
		$month_fl = 'September';
	}elsif($no_month == 10){
		$month_up = 'OCT';
		$month_lo = 'Oct';
		$month_fl = 'October';
	}elsif($no_month == 11){
		$month_up = 'NOV';
		$month_lo = 'Nov';
		$month_fl = 'November';
	}elsif($no_month == 12){
		$month_up = 'DEC';
		$month_lo = 'Dec';
		$month_fl = 'December';
	}
}
