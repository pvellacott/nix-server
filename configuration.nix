# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pooseyhub";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
 
 services.openssh = {
    enable = true;
    ports = [ 22 ]; #TODO change port and make secret
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # rememba...
  # /srv/media/movies, /srv/media/tv, /srv/media/music.
  systemd.tmpfiles.rules = [
    "d /srv/media 2775 phil media -"
    "d /srv/media/downloads 2775 phil media -"
    "d /srv/media/movies 2775 phil media -"
    "d /srv/media/tv 2775 phil media -"
  ];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "server role" = "standalone server";
        "workgroup" = "WORKGROUP";
        "server string" = "pooseyhub";
        "netbios name" = "pooseyhub";
        "security" = "user";
        "map to guest" = "Bad User";
        "follow symlinks" = "yes";
      };
      media = {
        "path" = "/srv/media";
        "browseable" = "yes";
        "read only" = "no";
        "valid users" = "phil";
        "force group" = "media";
        "create mask" = "0664";
        "directory mask" = "2775";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    group = "media";
    webuiPort = 8080;
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;
    allowedHosts = "*";
    settings = {
      title = "Ghil Server";
      theme = "dark";
      color = "slate";
    };
    services = [
      {
        "Media" = [
          {
            "Jellyfin" = {
              href = "http://pooseyhub:8096";
              description = "Movies, TV, and music";
              icon = "jellyfin.png";
            };
          }
        ];
      }
      {
        "Downloadurs" = [
          {
            "Sonarr" = {
              href = "http://pooseyhub:8989";
              description = "TV show automation";
              icon = "sonarr.png";
            };
          }
          {
            "Radarr" = {
              href = "http://pooseyhub:7878";
              description = "Movie automation";
              icon = "radarr.png";
            };
          }
          {
            "Prowlarr" = {
              href = "http://pooseyhub:9696";
              description = "Indexer management";
              icon = "prowlarr.png";
            };
          }
          {
            "qBittorrent" = {
              href = "http://pooseyhub:8080";
              description = "Torrent downloads";
              icon = "qbittorrent.png";
            };
          }
        ];
      }
    ];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "pooseyhub.home" = {
        locations."/".proxyPass = "http://127.0.0.1:8082";
      };
      "pooseyhub" = {
        locations."/".proxyPass = "http://127.0.0.1:8082";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 80 7878 8080 8096 8989 9696 ];
  users.groups.media = {};
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.phil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "media" ];
  };
      
  system.stateVersion = "26.05"; # Did you read the comment?

}
