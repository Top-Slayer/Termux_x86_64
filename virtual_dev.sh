if [ "$1" == "setup" ]; then
	if [ -z "$2" ]; then
		echo "Missing virtual ISO"
		echo "Link: https://alpinelinux.org/downloads/"
	else
		qemu-system-x86_64 -smp 4 -m 2048 \
			-drive file=alpine.qcow2,if=virtio \
			-netdev user,id=n1,hostfwd=tcp::2222-:22 \
			-device virtio-net,netdev=n1 \
			-cdrom $2 -boot d \
			-nographic
	fi
elif [ "$1" == "boot" ]; then
	qemu-system-x86_64 -smp 4 -m 2048 \
		-drive file=alpine.qcow2,if=virtio \
		-cpu qemu64 \
		-netdev user,id=n1,hostfwd=tcp::2222-:22 \
		-device virtio-net,netdev=n1 \
		-nographic
elif [ "$1" == "img" ]; then
	if [ -z "$2" ]; then
		echo "Allocate some storage space"
	else
		qemu-img create -f qcow2 alpine.qcow2 $2
	fi
else
	echo "Use some argument: "
	echo "$0 img <n>"
	echo "$0 setup <iso>"
	echo "$0 boot"
 echo "Example:"
 echo "- $0 img 3G"
 echo "- $0 setup alpine.iso"
 echo "- $0 boot"
fi
