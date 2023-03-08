# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "zeruel/znix/root";
      fsType = "zfs";
      options = [ "zfsutil"];
    };
  fileSystems."/home/doctor-sex" =
    { device = "zeruel/user";
      fsType = "zfs";
      options = [ "zfsutil"];
      depends = ["/tmp"];
    };    
  fileSystems."/nix" =
    { device = "zeruel/znix/nix";
      fsType = "zfs";
      options = [ "zfsutil"];
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_480GB_20096S441701-part1";
      fsType = "vfat";
    };
  fileSystems."/tmp" =
    { device = "tmpfs";
      fsType = "tmpfs";
    };
  swapDevices = [{device = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_480GB_20096S441701-part2";}];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

