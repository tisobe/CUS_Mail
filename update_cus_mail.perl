#!/opt/bin/perl

#########################################################################################
#											#
#	update_cus_mail.perl: move an old cus email to archive and clean up a current	#
#			      directory							#
#											#
#	author: t. isobe (tisobe@cfa.harvard.edu)					#
#											#
#	last update: Apr 01, 2014							#
#											#
#########################################################################################
#
#--- check whether this is a test case
#

$comp_test = $ARGV[0];
chomp $comp_test;

#
#---- read directories
#
if($comp_test =~ /test/i){
	open(FH, "/data/mta/Script/Cusmail/house_keeping/dir_list_test");
}else{
	open(FH, "/data/mta/Script/Cusmail/house_keeping/dir_list");
}

while(<FH>){
    chomp $_;
    @atemp = split(/\s+/, $_);
    ${$atemp[0]} = $atemp[1];
}
close(FH);


#
#--- get today's date
#
if($comp_test =~ /test/i){
	$year  = 2013;
	$month = 3;
	$umon  = 2;
}else{
	($usec, $umin, $uhour, $umday, $umon, $uyear, $uwday, $uyday, $uisdst)= localtime(time);

	$year   = 1900   + $uyear;
	$month  = $umon  + 1;
}

#
#--- change month from number to letters
#

mo_no_to_lett($month);

$cmo_up = $month_up;
$cmo_lo = $month_lo;
$cmo_fl = $month_fl;

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

$lmo_up = $month_up;
$lmo_lo = $month_lo;
$lmo_fl = $month_fl;
	
#
#--- check 2 months ago
#

$pmonth = $lmonth -1;
if($pmonth == 0){
	$pmonth = 12;
	$pyear  = $lyear -1;
}else{
	$pyear  = $lyear;
}

mo_no_to_lett($pmonth);
$pmo_up = $month_up;
$pmo_lo = $month_lo;
$pmo_fl = $month_fl;

#
#--- create a new directory for the last month's archive
#

$a_dir = "$arch_dir"."$lyear"."$lmo_up";
system("mkdir $a_dir");

$b_dir = "$march_dir".'.'."$lmo_lo";
#
#--- check whether b_dir is created, if not skip hypermail part
##
$dchk  = "$march_dir".'*';
$input = `ls $dchk`;
if($input =~ /$b_dir/){
    $chk = 1;
}else{
    $chk = 0;
}

if($chk == 1){
    system("$op_dir/hypermail -m $b_dir -d $a_dir -c $house_keeping/hypermail.config");
}

#
#--- clean up the last month's mail; save them in SECONDARY_SAVE.
#

$c_dir = "$secondary_dir"."$lyear"."$lmo_up".'/';
system("mkdir $c_dir");
system("mv $cmail_dir/*.html $c_dir");
system("mv $cmail_dir/a*     $c_dir");
system("gzip -r $c_dir/*");

#
#--- check the new email for this month
#

system("$op_dir/hypermail -m $march_dir -d $cmail_dir -c $hosue_keeping/hypermail.config");

#
#--- add new lines to the html page
#

system("cp $arch_dir/index.html $arch_dir/index.html~");
open(FH, "$arch_dir/index.html");

@save = ();

$current = '<li><a href="../."><b> Current Month: '."$cmo_fl $year".'</b></a></li>';
$test    = '<li><a href="./'."$pyear$pmo_up".'"><b> '."$pmo_fl $pyear".'</b></a>></li>';
$line    = '<li><a href="./'."$lyear$lmo_up".'"><b> '."$lmo_fl $lyear".'</b></a>></li>';

while(<FH>){
	chomp $_;
#	if($_ =~ /$test/){
	if($_ =~ /$pyear/ && $_ =~ /$pmo_up/i){
		push(@save, $_);
		if($lmonth != 1){
			push(@save, $line);
		}
	}elsif($_ =~ /Current Month:/){
		push(@save, $current);
		if($lmonth == 1){
			$tline = '<hr>';
			$new1 = '<h3> '."$year".'<h3>';
            $new2 = '<ul>';
            $new3 = '</ul>';
			push(@save, $tline);
			push(@save, $new1);
			push(@save, $new2);
			push(@save, $line);
			push(@save, $new3);
		}
	}else{
		push(@save, $_);
	}
}
close(FH);

open(OUT, "> $arch_dir/index.html");
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
