#!/usr/bin/perl -w

use strict;
use warnings;

my $usage = "Usage:\t$0 <run|pass|output|remote>\n";

my $numArgs = $#ARGV + 1;

if($numArgs != 1)
    {die $usage}

sub handleOutput
{
    my $ret;
    my $mode = $_[0];

    print "$mode";

    my $xrandr = `xrandr`;

    my $primDisp = `xrandr | grep -w primary`;
    my $scndDisp = `xrandr | grep -w connected | grep -v primary`;
    my $discDisp = `xrandr | grep -w disconnected`;

    my ($primID) = ($primDisp =~ /^(.*?)\s/);
    my ($scndID) = ($scndDisp =~ /^(.*?)\s/);
    my ($discID) = ($discDisp =~ /^(.*?)\s/);

    if ($mode =~ m/Laptop/)
    {
        $ret = `echo $primID | xargs -I DISP xrandr --output DISP -off"`;
        $ret = `xrandr --output $primID --auto`;
    }
    elsif ($mode eq "Desktop")
    {  
        my $cntrID = @{[$scndID =~ m/\w+/g]}[0];
        my $riteID = @{[$scndID =~ m/\w+/g]}[1];
        $ret = `xrandr --output $primID --off`;
        $ret = `xrandr --output $cntrID --primary --auto`;
        $ret = `xrandr --output $riteID --right-of $cntrID --auto`;
    }
    elsif ($mode eq "Primary")
    {  
        $ret = `echo $discID | xargs -I DISP xrandr --output DISP --off`;
        $ret = `echo $scndID | xargs -I DISP xrandr --output DISP --off`;
        $ret = `xrandr --output $primID --auto`;
    }
    elsif ($mode eq "Dock")
    {
        my $cntrID = @{[$scndID =~ m/\w+/g]}[0];
        my $riteID = @{[$scndID =~ m/\w+/g]}[1];
        $ret = `xrandr --output $primID --auto`;
        $ret = `xrandr --output $cntrID --right-of $primID --auto`;
        $ret = `xrandr --output $riteID --right-of $cntrID --auto`;
        
    }
    elsif ($mode eq "Mirror")
    {  
        $ret = `xrandr --output $primID --auto`;
        my ($primRes) = ($primDisp =~ /(\d+x\d+)/);
        $ret = `echo $scndID | xargs -I DISP xrandr --output DISP --same-as $primID --scale-from $primRes --auto`;
        print "$primRes";
    }
    elsif ($mode eq "Extend")
    {  
        $ret = `xrandr --output $primID --auto`;
        $ret = `echo $scndID | xargs -I DISP xrandr --output DISP --left-of $primID --auto`;
    }
    else
        {die "No such mode: $mode\n";}
}

sub connect2Server
{
    my $server = $_[0];
    my $sshCMD = "ssh -Y";
    my $x2gCMD = "x2goclient";
    my $rdpCMD = "xfreerdp +clipboard /sound:sys:pulse /microphone:sys:pulse /size:1900x1150";

    my $ip;
    my $usr;
    my $cmd;

    if ($server eq "dlsys-titan")
    {
        $ip = "134.103.192.238";
        $usr = "ynk";
        $cmd = $sshCMD . " " . $usr . "@" . $ip;
    }
    elsif ($server eq "ed-rpi-uhlmann")
    {
        $ip = "134.103.69.161";
        $usr = "ynk";
        $cmd = $sshCMD . " " . $usr . "@" . $ip;
    }
    elsif ($server eq "oscar")
    {
        $ip = "134.103.69.32";
        $usr = "uhlmann";
        $cmd = $sshCMD . " " . $usr . "@" . $ip;
    }
    elsif ($server eq "rbz-centos-cad")
    {
        $ip = "134.103.69.45";
        $usr = "uhlmanny";
        $cmd = $sshCMD . " " . $usr . "@" . $ip;
    }
    elsif ($server eq "rbz-centos-srv03")
    {
        $ip = "134.103.69.28";
        $usr = "uhlmanny";
        $cmd = $sshCMD . " " . $usr . "@" . $ip;
    }
    elsif ($server eq "rbz-w2k16-cad")
    {
        $ip = "134.103.69.46";
        $usr = "uhlmanya";
        $cmd = $rdpCMD . " /u:" . $usr . " /v:" . $ip;
    }
    elsif ($server eq "rbz-w2k19-srv02")
    {
        $ip = "134.103.69.22";
        $usr = "uhlmanya";
        $cmd = $rdpCMD . " /u:" . $usr . " /v:" . $ip;
    }
    else
        {die "No such server: $server\n";}

    my $remCMD = "xterm -t $server -e sh -c $cmd";
    $remCMD =~ s/xterm/st/g if !system("which st");
    $remCMD =~ s/xterm|st/alacritty/g if !system("which alacritty");

    #chomp($remCMD);
    exec $cmd;
}

my @dmenuArgs = ( "-nb  '#1d1d1f'"
                , "-nf  '#cfcfd2'"
                , "-sb  '#3c3c40'"
                , "-sf  '#dedee0'"
                , "-nhb '#1d1d1f'"
                , "-nhf '#51001d'"
                , "-shb '#3c3c40'"
                , "-shf '#7a002b'"
                , "-bw 2 -l 5 -h 25 -x 390 -y 150 -w 600 -i"
                , "-fn 'FantasqueSansMono Nerd Font:size=15'"
                );

my $option = $ARGV[0];

if ($option eq "run")
{
    unshift(@dmenuArgs, "dmenu_run");
    my $cmd = join(" ", @dmenuArgs);
    exec $cmd;
}
elsif ($option eq "pass")
{
    push(@dmenuArgs,  "-p 'Select Service:'");
    unshift(@dmenuArgs, "passmenu");
    my $cmd = join(" ", @dmenuArgs);
    exec $cmd;
}
elsif ($option eq "output")
{
    my $outputs = '"Primary\nLaptop\nDesktop\nMirror\nExtend\nDock"';
    push(@dmenuArgs,  "-p 'Select Output:'");
    unshift(@dmenuArgs, "echo $outputs | dmenu");
    my $cmd = join(" ", @dmenuArgs);
    my $res = `$cmd`;
    if ($res)
    {
        chomp($res);
        handleOutput($res);
    }
}
elsif ($option eq "remote")
{
    my $servers = '"dlsys-titan\ned-rpi-uhlmann\nrbz-centos-srv03\nrbz-centos-cad\noscar\nrbz-w2k16-cad\nrbz-w2k19-srv02"';
    push(@dmenuArgs,  "-p 'Select Server:'");
    unshift(@dmenuArgs, "echo $servers | dmenu");
    my $cmd = join(" ", @dmenuArgs);
    my $res = `$cmd`;
    if ($res)
    { 
        chomp($res);
        connect2Server($res);
    }
}
else 
{ 
    print "Don't know how to handle $option\n";
    die $usage;
}

exit 0;
