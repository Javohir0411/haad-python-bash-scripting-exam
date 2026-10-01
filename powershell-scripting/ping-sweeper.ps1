$network = Read-Host "Tarmoq IP manzilini kiriting (masalan, 192.138.10): "

$aliveHosts=@() # aliveHosts = []

for ($i=1; $i -le 255; $i++) {
    $ip = "$network.$i" # 192.138.10.3

    $result = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue # try ... except

    if ($result) {
        Write-Host "[+] $ip - aloqada" -ForegroundColor Green # print(f"[+] {ip} - aloqada")
        $aliveHosts += $ip # alivehost.append(ip)
    }
}

$aliveHosts | Out-File "aliveHosts.txt"

Write-Host ""
Write-Host "Scanning' tugadi." -ForegroundColor Green
Write-Host "Natijalar aliveHosts.txt fayliga saqlandi"

