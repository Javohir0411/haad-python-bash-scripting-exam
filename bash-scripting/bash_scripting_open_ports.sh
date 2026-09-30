#!/usr/bin/bash

# [0-9] -> raqamlar borligi

# {1, 3} -> 1 da 3 xonali raqamlar bo'lsa

# \. -> nuqta borligini tekshirish

# (...) -> bu guruh. Ichidagi regex qismlarini bitta guruh qilib olamiz | [0-9], {1, 3} va \. bitta guruh

# {3} -> bundan oldingi guruhni 3 marotaba takrorlash degani

# [0-9]{1, 3} - IP ni oxirgi qismini tekshiradi

# $ -> matnni oxiri degani, shu yerda IP tugadi.

# ^([0-9]{1,3}\.){3}[0-9]{1,3}$ --> "matn boshidan boshlab, 1-3 ta raqamdan va nuqtadan iborat 3 ta qism bo'lsin va oxirida 1-3 tadan raqam bo'lsin va tugasin" - degani.

#_________________________________________________________________________________________________

# IFS='.' --> nuqta bilan ajratish | Pythonda .split('.')

# read --> input olish

# -ra --> -r - belgilarni maxsus belgideb hisoblamaslik | -a --> listga qo'shish

# ip_parts --> o'qilgan qiymatni shunga o'zlashtirish | ip_parts = ip.split(".")

# <<< '$ip' --> ip dagi qiymatni shu command'ga bergin degani

# IFS='.' read -ra ip_parts <<< "$ip" --> 192.168.10.241 IP manzilni nuqta bilan ajratib, listga joylash:
# ip_parts = [192, 168, 10, 241]
#_________________________________________________________________________________________________

# =~ --> moslikni tekshirish

# ^ --> regex | matn boshlanishi

# [0-9]+ matn bir nechta raqamlardan tashkil topgan bo'lishi | + --> 1 tadan ko'p degani

# $ --> matn oxiri

#if [[ $ports =~ ^[0-9]+$ ]] --> agar, matn boshidan oxirigacha bir nechta raqamdan iborat bo'lsa... | if ports.isdigits()

#_________________________________________________________________________________________________

# $ports = "20-100"

# ${ports%-*} --> portsni oxiridan boshlab, - belgisi va undan keyingi qismini olib tashlasj | 20-100 --> 20 | start=20 | start = ports.split("-")[0]

# ${ports#*-} --> portsni boshidan boshlab, - gacha bo'lgan qismini olib tashlash | 20-100 --> 100 | end = ports.split("-")[1]

#_________________________________________________________________________________________________

# timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null

# echo > /dev/tcp/$ip/$port --> berilgan IP'ning berilgan PORT raqamiga so'rov yuborib ko'rish, bahdagi xususiyat.

# bach -c "..." shu command'ni bash'da ishlatib ko'rish

# timeout 1 --> so'rov yuborish uchun 1 sekund vaqt berish

#_________________________________________________________________________________________________

#if [ $? -eq 0 ];

# $? --> oxirgi ishlatilgan command'ni status code'ni oladi. Agar status code teng bo'lsa, 0 ga...

#_________________________________________________________________________________________________



read -p "IP manzilni kiriting: " ip
read -p "Port raqamini kiriting(22,80,443 yoki 20-100): " ports #

if ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3} ]] #--> IP manzilni tekshirish 127.0.0.1
then
    echo "Xato: IP Address noto'g'ri"
    exit 1 # --> Xattolik bilan to'xtatish
fi

IFS='.' read -ra ip_parts <<< "$ip" # --> Ipni nuqta bilan ajratib, listga saqlash| ip_parts=[127, 0 ,0 ,1]

# IP addressni for orqali aylantirish
for part in "${ip_parts[@]}";
do
  if (( part < 0 || part > 255 )); # 255.255.255.255
  then
    echo "Noto'g'ri IP address kiritildi !"
    exit 1
  fi
done

if [[ $ports =~ ^[0-9]+$ ]]; # 80
then
  port_list=("$ports")

elif [[ $ports =~ ^[0-9]+(,[0-9]+)+$ ]] # 22,80,443
then

  IFS=',' read -ra port_list <<< "$ports" #--> listga joylash

elif [[ $ports =~ ^[0-9]+-[0-9]+$ ]] # 20-100
then
  start=${ports%-*} # 20-100 >> 20
  end=${ports#*-} # 20-100 -> 100

  if (( start > end ))
  then
    echo "Xato: port oralig'i noto'gri"
    exit 1
  fi

  port_list=($(seq "$start" "$end")) # port_list=[20, 21, 22...100]

else
  echo "Xato: port formati noto'gri!"
  echo "Misol: 80 yoki 22, 80, 443 yoki 20-100"
  exit 1

fi

for port in "${port_list[@]}";
do
  if (( port < 1 || port > 65535 ));
  then
    echo " Xato: $port port noto'gri"
    exit 1
  fi
done

echo
echo "Target: $ip" # Target: 127.0.0.1
echo "Scanning..."
echo

start_time=$(date +%s%N) # 1970.01.01 dan boshlab vaqtni olish

open_ports=()

for port in "${port_list[@]}";
do

  timeout 1 bash -c "echo >/dev/tcp/$ip/$port" 2> /dev/null #--> tcp orqali "ip:port" ga so'rov yuborish

  if [ $? -eq 0 ];
  then
    open_ports+=("$port")
  fi
done

end_time=$(date +%s%N)

# NATIJALARNI OLISH

echo "============================================="
echo "               SCAN RESULT"
echo "============================================="
if [ ${#open_ports[@]} -eq 0 ];
then
  echo "Ochiq port topilmadi"
else
  echo "Ochiq portlar: "

  for port in "${open_ports[@]}";
  do
    echo " - $port"
  done
fi

#   ketgan vaqtni hisoblash

elapsed=$((end_time-start_time))
echo
echo "SCAN vaqti: $((elapsed/1000000)) ms" #nanosekun --> millisekund
echo "============================================="