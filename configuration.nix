# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;  

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "tpm-rng" "acpi_call" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  #boot.initrd.luks.devices.crypted.device = "/dev/sda1";
  #fileSystems."/".device = "/dev/mapper/crypted";

  networking.hostName = "nixosx-230"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ]; # blacklist this module

  services.avahi.enable = true;
  services.avahi.openFirewall = true;

  services.tlp.enable = true;
  #services.hdapsd.enable = true;

  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #virtualisation.lxd.enable = true;
  virtualisation.docker.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # nixpkgs.config.allowBroken = true;
  environment.systemPackages = with pkgs; [
    avahi
    binutils
    cmake
    cubicsdr
    curl 
    dump1090
    etcher
    firefox
    fldigi 
    git 
    gnupg 
    gqrx
    gr-osmosdr
    gwenview
    inxi
    libreoffice
    libreoffice 
    libusb 
    gcc
    gcc9Stdenv
    gnumake
    mc 
    neofetch
    oathToolkit 
    okular 
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.ledger-live-desktop
    pkgs.ledger-udev-rules
    pkgs.rtl-sdr 
    pkgs.yubikey-manager-qt
    pkgs.yubikey-personalization-gui
    pulseeffects
    qpaeq
    qradiolink
    rtl-sdr
    sdrangel
    soapysdr-with-plugins
    spectacle 
    syncthing
    tdesktop
    unzip 
    vim 
    vlc 
    wget 
    wsjtx 

  ];
  
  services.udev = {

      packages = [ pkgs.rtl-sdr pkgs.libusb ]; # (there might be other packages that require udev here too)
      path = [ pkgs.coreutils ];
      extraRules = ''
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="2500",MODE:="0666"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3000",MODE:="0666"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3010",MODE:="0666"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3020",MODE:="0666"
      '';
    };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 1234 5353 8080 9000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.cpu.intel.updateMicrocode = true;

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkbVariant = "intl";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.synaptics.palmDetect = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "lxd" "cdrom" "tty" "uucp" "docker" "wheel" "audio" "dialout" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  boot.kernel.sysctl =  { "vm.swappiness" = 1; };
  
  services.fstrim.enable = true;

}
