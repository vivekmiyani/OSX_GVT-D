# Set your iGPU pci id (fetched from lspci)
IGPU_PCIID=8086:XXXX

modprobe vfio_pci
modprobe vfio
echo 0000:00:02.0 > /sys/bus/pci/devices/0000:00:02.0/driver/unbind
echo $IGPU_PCIID > /sys/bus/pci/drivers/vfio-pci/remove_id
echo $IGPU_PCIID > /sys/bus/pci/drivers/vfio-pci/new_id
modprobe -r i915

sleep 2

./opencore-boot.sh

sleep 2

modprobe -r vfio_pci
modprobe -r vfio
modprobe i915
