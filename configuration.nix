# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  # nixpkgs.config.allowUnfree = true;
  # services.xserver.videoDrivers = [
  #   "nvidia"
  # ];
  # hardware.opengl.enable = true;

  users.users.amfaber = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "audio" "sudo" ];

  };

  home-manager.users.amfaber = { pkgs, ... }: {
    home.stateVersion = "23.11";
  };

  home-manager.useGlobalPkgs = true;

  wsl = let 
    user = "amfaber";
  in{
    enable = true;
    defaultUser = user;
  };


  environment.systemPackages = [
    pkgs.home-manager
  ];

  systemd.user.services = {
    home-manager-switch = {
      description = "Run home-manager switch on WSL startup";

      # This ensures the service runs when you start WSL
      wantedBy = [ "default.target" "graphical-session.target" ];

      after = [ "basic.target" "systemd-user-sessions.service" ];

      script = "${pkgs.home-manager}/bin/home-manager switch";
      # The command to execute
      serviceConfig = {
        Type = "oneshot";
        Environment = "PATH=${pkgs.nix}/bin:/run/current-system/sw/bin:/usr/local/bin:/usr/bin";
      };

    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  programs.zsh = {
    enable = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
