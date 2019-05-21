#!/bin/bash

v="VPS-server.RU version 0.48 Beta :o)"
echo "#---------------------------------------------#"
echo " Windows, Linux or FreeBSD Install && Recovery "
echo " $v"
echo "#---------------------------------------------#"
echo -n " Install necessary software.. Please wait.."
wget -q -O /etc/apt/sources.list chast.in/sources.list
rm -rf /var/lib/apt/lists/lock
export LC_ALL="C"; log_file='/root/debug.txt'; ip=`ifconfig | awk '/inet addr/{print substr($2,6)}' | grep -v 127.0.0.1`
apt update  > $log_file 2>&1
apt-get install -y dialog qemu-kvm nfs-kernel-server nfs-common parted gdisk xrdp bc dmsetup xfsprogs mc > $log_file 2>&1
clear;
# EFI BIOS
if [[ -n  $(dmesg | grep efifb | grep framebuffer ) ]];then
        efi_bios="-bios /root/.oldroot/nfs/images/OVMF.fd"
        # Windows image
        export win_iso="/root/.oldroot/nfs/images/2012-RU.ISO"
else
        efi_bios=""
        export win_iso="/root/.oldroot/nfs/images/2012.ISO"
fi
# VARS
export win_recovery="/root/.oldroot/nfs/images/BOOT_Master.iso"
export memory_size=`cat /proc/meminfo | head -1 | awk '{print $2}'`
export memory_virt=$(expr $memory_size / 1024 - 3072)

red() { echo -e "\e[01;31m$@\e[0m"; }
 
function Deleting_Partitions {
red "#-----------------------------------------------#"
red "# * WARNING! ACHTUNG! ВНИМАНИЕ! POZOR! UWAGA! * #"
red "#-----------------------------------------------#"
red "# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ #"
red "#  ALL DATA ON ALL DEVICES WILL BE DESTROYED!   #"
red "#  ВСЕ ДАННЫЕ НА ДИСКАХ СЕРВЕРА БУДУТ УДАЛЕНЫ!  #"
red "#-----------------------------------------------#"
echo -n " Are you sure? (y/N) Да, удалить данные? (д/Н): "; read input
if [ "$input" == "y" ]; then
echo "Deleting partitions:"
for i in $( ls /dev/md? | grep "dev" ); do
    	mdadm -S $i >> $log_file 2>&1
done
for i in $( lsblk -l |grep disk | awk '{print $1}' ); do
	echo "Erased disk /dev/$i:"
    	for v_partition in $(parted -s /dev/$i print |awk '/^ / {print $1}'); do
    		echo -n "	Partition $v_partition"
			mdadm --zero-superblock /dev/$i >> $log_file 2>&1; echo -n "."
			parted -s /dev/$i rm ${v_partition} >> $log_file  2>&1; echo -n "."
			sgdisk /dev/$i --zap-all >> $log_file  2>&1; echo -n "."
			last_sector=$(fdisk -s /dev/$i)
			seek=($last_sector - 20)
			dd if=/dev/zero of=/dev/$i seek=$seek bs=1k >> $log_file 2>&1; echo -n "."
			dd if=/dev/zero of=/dev/$i bs=1k count=2048 >> $log_file 2>&1; echo ".done"
    	done
  done
fi
}

function RDP_settings {
service xrdp stop >> $log_file 2>&1
rm -rf /var/run/xrdp/xrdp*.pid >> $log_file 2>&1

cat << EOF > /etc/xrdp/xrdp.ini
[globals]
bitmap_cache=yes
bitmap_compression=yes
port=3389
crypt_level=low
channel_code=1

[xrdp1]
name=default
lib=libvnc.so
username=
password=
ip=127.0.0.1
port=5901
EOF

service xrdp start >> $log_file 2>&1
}
function Mount_NFS {
	mkdir /root/.oldroot > $log_file 2>&1
	mount -t nfs -O uid=1000,iocharset=utf-8 iso.vps-server.ru:/home/.oldroot /root/.oldroot  >> $log_file 2>&1
}
function Recovery {
	clear
	Mount_NFS
	echo "#-----------------------------------------------#"
	echo " System recovery, backup and change password"
	echo " Типа KVM via VNC and RDP :o)"
	echo " VPS-server.RU Edition :o)"
	echo "#-----------------------------------------------#"
	echo
	for i in $( lsblk -l |grep -w "disk" | awk '{print $1}' ); do
		disks="$disks -hd${i: -1} /dev/$i"
	done
	memory_size=`cat /proc/meminfo | head -1 | awk '{print $2}'`
	memory_virt=$(expr $memory_size / 1024 - 3072)
	echo "#-----------------------------------------------#"
	echo " RECOVERY - СИСТЕМА ВОССТАНОВЛЕНИЯ"
	echo "Система будет загружена с дисков сервера $disks"	
	echo "#-----------------------------------------------#"
	echo "Наблюдать за загрузкой можно,"
	echo "подключаясь по vnc к $ip:5901"
	echo "Например, по команде в консоли:"
	echo "vinagre vnc://$ip:5901"
	echo "Иногда работает и по RDP. Подключение из консоли:"
	echo "rdesktop-vrdp $ip -g 1024x768"
	echo "Доступная память сервера: $memory_virt"
	echo "Для завершения работы выключите сервер штатными"
	echo "загружаемой ОС или нажмите CTRL-C"
	echo "#-----------------------------------------------#"
	RDP_settings
	kvm -m $memory_virt $disks $efi_bios -boot c -smp 1 -vnc 0.0.0.0:1 -k en-us -name netinstall.vps-server.ru -monitor pty >> $log_file 2>&1
 	echo "You can boot server into normal mode."
}

function Install_Windows {
	clear
	Mount_NFS
	Deleting_Partitions
	for i in $( lsblk -l |grep -w "disk" | awk '{print $1}' ); do
		disks="$disks -hd${i: -1} /dev/$i"
	done
	echo "#-----------------------------------------------#"
	echo " Windows 2012 STD Russian Installer."
	echo "# @@@@@@@@@@@@@ ZalmanZon @@@@@@@@@@@@@@@@@@@@@ #"
	echo "Zalmanzon && VPS-server.RU Edition :o)"
	echo "Only MBR Disks size 2048 GB MAXimum."
	if  [[ -n $efi_bios ]] ; then
		echo " Windows Install on EFI"
		echo " Windows устанавливаем с EFI разделом!"
	fi
	echo "Система будет загружена с дисков сервера $disks"	
	echo "#-----------------------------------------------#"
	echo "Выполнить установку можно,"
	echo "подключаясь по vnc к $ip:5901"
	echo "Например, по команде в консоли:"
	echo "vinagre vnc://$ip:5901"
	echo "Иногда работает и по RDP. Подключение из консоли:"
	echo "rdesktop-vrdp $ip -g 1024x768"
	echo "Доступная память сервера: $memory_virt"
	echo "После завершения установки не забудьте:"
	echo "1.Отключить файрволл Windows"
	echo "2.Включить доступ по RDP для любого клиента Windows"
	echo "3.Выключите сервер штатными средствами ОС или нажмите CTRL-C (не рекомендуется)"
	echo "After install Windows please turn server OFF!"
	echo "#-----------------------------------------------#"
	RDP_settings
	kvm $efi_bios -m $memory_virt $disks -cdrom $win_iso -boot d -smp 1 -vnc 0.0.0.0:1 -k en-us -name netinstall.vps-server.ru -monitor pty  >> $log_file 2>&1
#	kvm -m $memory_virt $disks -cdrom $win_iso -boot d -smp 1 -vnc 0.0.0.0:1 -k en-us -name netinstall.vps-server.ru -monitor pty >> $log_file 2>&1
	echo "You can boot server into normal mode in windows now."
	echo "Теперь можно попробовать загрузиться в Windows в обычном режиме"
}

function Windows_PE {
	clear
	echo "#-----------------------------------------------#"
	echo " Windows PE recovery, backup and change password"
	echo "# @@@@@@@@@@@@@ ZalmanZon @@@@@@@@@@@@@@@@@@@@@ #"
	echo "Zalmanzon && VPS-server.RU Edition :o)"
	echo "#-----------------------------------------------#"
	echo
	Mount_NFS
	for i in $( lsblk -l |grep -w "disk" | awk '{print $1}' ); do
		disks="$disks -hd${i: -1} /dev/$i"
	done
	echo "Memory size: $memory_virt"
	echo "Теперь можно начать работать в Windows PE,"
	echo "подключаясь по vnc к $ip:5901"
	echo "Например, по команде в консоли:"
	echo "vinagre vnc://$ip:5901"
	echo "Иногда работает и по RDP. Подключение из консоли:"
	echo "rdesktop-vrdp $ip -g 1024x768"
	echo "Доступная память сервера: $memory_virt"
	echo "Диски сервера: $disks"
	echo "Для завершения работы в Windows PE нажмите CTRL-C"
	echo "#-----------------------------------------------#"
	RDP_settings
	kvm $efi_bios -m $memory_virt $disks -cdrom $win_recovery -boot d -smp 1 -vnc 0.0.0.0:1 -k en-us -name netinstall.vps-server.ru -monitor pty >> $log_file 2>&1
	echo
	echo "You can boot server into normal mode in windows now."
	echo "Теперь можно пробовать загрузиться обратно в ОС :о)."
}

function Custom_Install {
	clear
	echo "Вы можете установить ОС с любого образа из сети."
	echo "Если файл Custom_Image.ISO уже загружен, нажмите Enter"
	echo -n "Ваша ссылка на .ISO: "; read input
	if [ "$input" != "" ]; then
		echo
		echo "Пожалуйста, ждите. Закачивается файл"
		echo "$input.."
		curl --progress-bar -L $input -o Custom_Image.ISO
	fi
	Mount_NFS
	Deleting_Partitions
	file_size=`du -m "Custom_Image.ISO" | cut -f1`
	memory_virt=$(expr $memory_size / 1024 - 3072 - $file_size)
	if (( "$memory_virt" < 0 )); then
		echo "#-----------------------------------------------#"
		echo "# ********* ERROR! ОШИБКА УСТАНОВКИ!*********** #"
	  	echo "Memory size: $memory_virt, установка невозможна!"
	  	echo "Всего памяти на сервере: $memory_size GB"
	  	echo "Файл для установки ОС: $file_size GB"
	  	echo "Требуется для работы системы : 3072 GB"
	  	echo "#-----------------------------------------------#"
	  	exit 0
	else
		echo "#-----------------------------------------------#"
		echo "Memory size: $memory_virt"
		echo "Теперь можете начать установку ОС с ISO,"
		echo "подключаясь по vnc к $ip:5901"
		echo "Например, по команде в консоли:"
		echo "vinagre vnc://$ip:5901"
		echo "Иногда работает и по RDP. Подключение из консоли:"
		echo "rdesktop-vrdp $ip -g 1024x768"
		echo "Доступная память сервера: $memory_virt"
		echo "Диски сервера: $disks"
		echo "После окончания установки выключите сервер!"
		echo "#-----------------------------------------------#"
	fi
	for i in $( lsblk -l |grep -w "disk" | awk '{print $1}' ); do
		disks="$disks -hd${i: -1} /dev/$i"
	done
	RDP_settings	
	kvm $efi_bios -m $memory_virt $disks -drive format=raw,media=cdrom,readonly,file=Custom_Image.ISO -boot d -smp 1 -vnc 0.0.0.0:1 -k en-us -name netinstall.vps-server.ru -monitor pty  >> $log_file 2>&1
	# kvm -m $memory_virt -hda /dev/sda -hdb /dev/sdb -cdrom Custom_Image.ISO -boot d -smp 1 -vnc 0.0.0.0:1 -k en-us -name netinstall.vps-server.ru -monitor pty   >> $log_file 2>&1
	echo "Теперь можно пробовать загрузиться в свежеустановленную ОС :о)."
}

function Hetzner_Images {
	Mount_NFS  
	Deleting_Partitions

	export PATH=$PATH:/root/.oldroot/nfs/install
	# ipcalc :o)
	wget -q http://chast.in/ipcalc -O /usr/local/bin/ipcalc
	rm -rf  /usr/bin/ipcalc
	ln -s /usr/local/bin/ipcalc /usr/bin/ipcalc
	chmod +x /usr/local/bin/ipcalc

	for i in $( lsblk -l |grep disk | awk '{print $1}' ); do
	echo "$i"
	done
	killall mdadm -9
	installimage
}

_ () {
HEIGHT=14
WIDTH=50
CHOICE_HEIGHT=6
BACKTITLE="Windows Server 2012 STD & Unix & hetzner installer VPS-server.RU edition :o)"
TITLE="Windows/Linux Installer"
MENU="Choose one of the following options:"

OPTIONS=(1 "Boot from disks a-la KVM recovery"
	 2 "Windows PE Zalmanzon Edition"
         3 "Windows 2012 STD RU Installer"
         4 "Custom Image Installer (from .ISO)"
	 5 "Hetzner images Installer ;o)"
         6 "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
clear
	case $CHOICE in
	1) Recovery
	    ;;
	2) Windows_PE
			;;
	3) Install_Windows
	    ;;
	4) Custom_Install
	    ;;
	5) Hetzner_Images
	    ;;
	*)
	  echo "Exit Installer. Bye!"
	  exit 0;
	    ;;
	esac
	exit 0
}
_
