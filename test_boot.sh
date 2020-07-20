#qemu-system-x86_64  -m 2G -nographic -serial stdio -monitor none -drive if=none,id=stick,file=/dev/sdc -device nec-usb-xhci,id=xhci, -device usb-storage,bus=xhci.0,drive=stick
qemu-system-x86_64  -m 2G -drive if=none,id=stick,file=/dev/sdc -device nec-usb-xhci,id=xhci, -device usb-storage,bus=xhci.0,drive=stick
