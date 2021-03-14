# OSX GVT-D
Guide to pass iGPU to MacOS KVM guest.

## Procedure

#### 1. Fetch necessary files from [i915ovmfPkg](https://github.com/patmagauran/i915ovmfPkg) repo.

- Use precompiled `i915ovmf.rom` from releases OR build yourself.
- Some system needs FwCFG, see: https://github.com/patmagauran/i915ovmfPkg/wiki/Qemu-FwCFG-Workaround.
- Place all this 3 files (i.e. `i915ovmf.rom`, `opregion.bin`, `bdsmSize.bin`) in `i915ovmf` directory of this repo.
- **Note:** This driver lacks the support for HDMI :(, eDP works out of the box! Try your luck.!!

#### 2. Configure OpenCore.

- Configure OpenCore / EFI directory as per your requirement.
- Build it:

  ```bash
  ./opencore-rebuild.sh
  ```

- Place `BaseSystem.img` and `mac_hdd_ng.img` to root of this repo.

#### 3. Prepare iGPU for passthrough

- Grab PCI ID:

  ```bash
  lspci -D -nn
  ```

- Find your iGPU PCI ID and place it inside `boot.sh`.
- Boot it:

  ```bash
  # This script will unbind iGPU from the host and make it ready for passthrough.
  # After that it will run `opencore-boot-pt.sh` which is runs `qemu` command to boot OSX.
  # On shutdown it will rebind the iGPU to the host.

  # TIP: Running this on ssh session will helps us a lot to debug the issue.
  ./boot.sh
  ```

## Notes
- During iGPU passthrough qemu will write this,
  ```
  qemu-system-x86_64: -device vfio-pci,host=0000:00:02.0,id=hostdev0,bus=pcie.0,addr=0x2,romfile=i915ovmf.rom: IGD device 0000:00:02.0 cannot support legacy mode due to existing devices at address 1f.0
  ```
  but ignore that warning.
 - We just need to make sure that iGPU placed by Qemu should match the location defined in `config.plist`, If this thing is correct you will be good to go!!

## What is working

- QE/CI.!!

## Known issues

- Chrome / Electron based applications causes freeze (GPU hang/reset) or crashes the guest.

## Credits

- OVMF Driver: https://github.com/patmagauran/i915ovmfPkg
- OSX-KVM for providing OSX setup and tools: https://github.com/kholia/OSX-KVM
- GVT-D guide: https://github.com/intel/gvt-linux/wiki/GVTd_Setup_Guide
