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

  boot.kernelParams = [ "modprobe.blacklist=dvb_usb_rtl28xxu" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  boot.initrd.luks.devices.crypted.device = "/dev/sda1";
  fileSystems."/".device = "/dev/mapper/crypted";

  boot.supportedFilesystems = [ "zfs" ];

  networking.hostName = "nixos-asus-i7"; # Define your hostname.

  networking.hostId = "eb2ce2d1";

  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #virtualisation.lxd.enable = true;
  virtualisation.docker.enable = true;

  # security.pki.certificateFiles = [ "/home/user/.certs/maya.crt" ];

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
  environment.systemPackages = with pkgs; [
    arduino
    atom
    audacity
    binutils
    bleachbit
    coreutils
    cubicsdr
    curl
    direnv
    docker
    #dump1090
    etcher
    filezilla
    pkgs.firefox-bin
    fish
    fldigi 
    font-awesome
    fuse
    gcc
    gcc9Stdenv
    git
    glib
    glibc
    gnumake
    gnupg 
    gparted 
    gqrx
    gwenview
    libreoffice 
    libusb
    lorri
    makeWrapper
    mc
    neofetch
    networkmanager
    networkmanagerapplet
    niv
    nmap
    oathToolkit
    okular
    patchelf
    pciutils
    p7zip
    pkgs.ledger-live-desktop
    pkgs.ledger-udev-rules
    pkgs.yubikey-manager-qt
    pkgs.yubikey-personalization-gui
    psmisc
    python27Full
    rsync
    rtl-sdr
    sdrangel
    spectacle
    syncthing
    stdenv
    tdesktop
    teamviewer
    usbutils
    unzip
    vim 
    vlc
    wget 
    wirelesstools
    wsjtx 
    zlib
    zstd
  ];

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  services.teamviewer.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.fish.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host pkgs.rtl-sdr pkgs.libusb ];

  services.udev = {
      path = [ pkgs.coreutils ];
      extraRules = ''
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="2500",MODE:="0666"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3000",MODE:="0666"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3010",MODE:="0666"
        SUBSYSTEM=="usb",ENV{DEVTYPE}=="usb_device",ATTRS{idVendor}=="1df7",ATTRS{idProduct}=="3020",MODE:="0666"
      '';
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22 1234 8443 22000];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # NFS
  #fileSystems."/mnt/files" = {
  #  device = "192.168.1.12:/mnt/72936ca8-0e24-45c5-9203-55373def96df/files/";
  #  fsType = "nfs";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  #hardware.cpu.intel.updateMicrocode = true;

  boot.initrd.kernelModules = [ "i915" ];

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
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # Enable xfce
  #services.xserver.displayManager.defaultSession = "xfce";
  #services.xserver.desktopManager.xterm.enable = false;
  #services.xserver.desktopManager.xfce.enable = true;
  # Enable Pantheon
  # services.xserver.desktopManager.pantheon.enable = true;
  # services.xserver.desktopManager.lumina.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "docker" "lxd" "wheel" "tty" "uucp" "dialout" "networkmanager" "audio" ]; # Enable ‘sudo’ for the user.
  };

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  boot.kernel.sysctl =  { "vm.swappiness" = 1; };
  
  services.fstrim.enable = true;
}

