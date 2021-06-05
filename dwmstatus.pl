#!/usr/bin/perl

sub getWifiState()
{
    $RET = `nmcli dev wifi`;
    @ITEMS = split(/\s+/, $RET);
    $COUNT = 0;
    $SIG = 0;

    foreach $I (@ITEMS)
    {
        if($I eq "*") 
        {
            $SIG = $ITEMS[$COUNT+6];
            if($SIG != "BARS")
                {last;}
        }
        $COUNT = $COUNT + 1;
    }
    
    $BAR = "";
    
    if($SIG > 75)
        {$BAR = "";}
    elsif($SIG > 50)
        {$BAR = "";}
    elsif($SIG > 25)
        {$BAR = "";}
    else
        {$BAR = "";}
    
    return $BAR . $SIG . "% | ";
}

sub getVolume()
{
    $VOL = `amixer sget Master`;
    $VOL =~ m/\d+\%/;
        {return "" . $& . " | ";} 
}

sub getBattery()
{
    $AC = `acpitool`;
    @LINES = split /\n/, $AC;
    $PERC = "";
    foreach $L (@LINES)
    {
        if($L =~ m/\d+.\d+/)
        {
            $PERC = $&;
            if($PERC > 75.0)
                {$PERC = " " . $PERC;} 
            elsif($PERC > 50.0)
                {$PERC = " " . $PERC;}
            elsif($PERC > 25.0)
                {$PERC = " " . $PERC;}
            else
                {$PERC = " " . $PERC;}
        }
        elsif($L =~ m/AC/ && $L =~ m/online/)
            {$PERC = " " . $PERC;}
    }
    return $PERC . " | ";
}

while(true)
{
    $DATE = `date +"%F %H:%M:%S"`;
    $WIFI = getWifiState();
    $VOLU = getVolume();
    $BATT = getBattery();
    @STATUS = ($DATE, $WIFI, $VOLU, $BATT);
    # print "$STATUS[0] $STATUS[1] $STATUS[2] $STATUS[3]";
    `xsetroot -name "$STATUS[3] $STATUS[2] $STATUS[1] $STATUS[0]"`;
    sleep(1)
}

