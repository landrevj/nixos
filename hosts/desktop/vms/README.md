https://forums.gentoo.org/viewtopic-t-1071844-start-0.html
https://linkwarden.landrevj.dev/preserved/13?format=2

```ps1
# get a list of storage drivers as parameters

if ($args.Count -eq 0) {
    echo "Must indicate at least 1 storage driver name"
    exit 1
}
$rootPath = "HKLM:\SYSTEM\ControlSet001\Services\"
$tailPath = "\StartOverride"

foreach ($p in $args) {
    echo ("Checking: "+$rootPath+$p+$tailPath)
    if (Test-Path ($rootPath+$p+$tailPath)) {
        echo ($rootPath+$p+$tailPath) "exists"
        Set-ItemProperty -Name "0" -Path ($rootPath+$p+$tailPath) -Value 0
    }
}
```

store as startup powershell script with `-ExecutionPolicy BYPASS storahci viostor`