{ config, lib, pkgs, ... }:
let
  USER = builtins.getEnv "USER";
  BROWSER = "librewolf";
  myEnvVars = {
       NIX_PATH="/home/${USER}/.nix-defexpr/channels";
       TERM="xterm";
       BROWSER="${BROWSER}";
       XDG_CONFIG_HOME="/home/${USER}/.config";
       XDG_DATA_HOME="/home/${USER}/.local/share";
       ZSH_COMPDUMP = "${config.xdg.cacheHome}/zsh/zcompdump";
       EMACSDIR = "${config.xdg.configHome}/emacs";
       DOOMDIR = "${config.xdg.configHome}/doom.d";
       ZSHZ_DATA = "${config.xdg.dataHome}/zsh/zshzdb";
       XMONAD_CONFIG_HOME="${config.xdg.configHome}/xmonad";
       XMONAD_DATA_DIR="${config.xdg.configHome}/xmonad";
       XMONAD_CACHE_DIR="${config.xdg.configHome}/xmonad";
       CABAL_CONFIG="${config.xdg.configHome}/cabal/config";
       CABAL_DIR="${config.xdg.configHome}/cabal";
       CARGO_HOME="${config.xdg.dataHome}/cargo";
       GHCUP_USE_XDG_DIRS="true";
       GNUPGHOME="${config.xdg.dataHome}/gnupg";
       GTK2_RC_FILES="${config.xdg.configHome}/gtk-2.0/gtkrc";
       LESSHISTFILE="${config.xdg.cacheHome}/less/history";
       ICEAUTHORITY="${config.xdg.cacheHome}/ICEauthority";
       XCOMPOSECACHE="${config.xdg.cacheHome}/X11/compose";
       #XKB_DEFAULT_OPTIONS="ctrl:nocaps";
       #XKB_DEFAULT_LAYOUT="\"it(us)\"";
       PASSWORD_STORE_GPG_OPTS="\" --default-recipient cloud.strife@tuta.io\""
;
       MOZ_ENABLE_WAYLAND="1";
  };
in
{
  imports = [
    ./zsh.nix
  ];
   home = {
     username = "${USER}";
     homeDirectory = "/home/${USER}";
     stateVersion = "22.05";
      sessionPath = [
        "/home/${USER}/.config/emacs/bin"
        "/home/${USER}/.nix-profile/bin/"
        "/home/${USER}/.local/bin"
        "/home/${USER}/.local/bin/bw/"
     ];
     sessionVariables = myEnvVars;
   };
   programs = {
     nushell = {
       enable = true;
        extraConfig = "
 $env.config = {
   completions: {
       algorithm:  \"fuzzy\"
   }
   hooks : {
     env_change: {
         PWD: []
     }
   }
   show_banner: false
 }
 $env.config.hooks.env_change.PWD = (
     $env.config.hooks.env_change.PWD | append (source ~/.local/share/nu/nu_scripts/hooks/direnv/config.nu)
 )
use ~/.local/share/nu/nu_scripts/custom-completions/pass/pass-completions.nu *
                     ";
       extraEnv = "
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend ($env.HOME | path join \".local\" \"bin\")
    | prepend ($env.HOME | path join \".nix-profile\" \"bin\")
    | uniq
)

#$env.NU_LIB_DIRS = [
#            ($env.XDG_DATA_HOME | path join \"nu\" \"nu_scripts\")
#            ]
                  ";
       shellAliases = {
         tr="transmission-remote";
         trl="transmission-remote --list";
         tra="transmission-remote --add";
         cp="~/.local/bin/ucp -rvg";
         jobs="jobs -p";
         grep="rg";
         e="emacsclient -ct";
         s6-rc-user="s6-rc -l /tmp/s6-rc";
         cat="bat";
         yt-mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg";
         #yt-mp4="";
         k="kubectl";
         gc="git clone";
         r="rm -rvf";
         md="mkdir";
         termbin="nc termbin.com 9999";
       };
       environmentVariables = myEnvVars;

     };
     direnv = {
       enable = true;
       nix-direnv.enable = true;
     };
     emacs = {
       enable = true;
     };
     home-manager.enable = true;
     starship = {
       enable = true;
       enableZshIntegration = true;
       enableNushellIntegration = true;
       settings = {
       character = {
         success_symbol = "[\\(\\(ﬦ\\).\\(>>=\\)\\)](bold white)";
         error_symbol =   "[\\(\\(ﬦ\\).\\(=<<\\)\\)](bold white)";
        };
       };
     };
     firefox = {
       enable = true;
       profiles = {
         myprofile = {
           name = "myprofile";
           settings = {
             "media.ffmpeg.vaapi.enabled" = false;
           };
           extensions = with pkgs.nur.repos.rycee.firefox-addons;
             [
               #add-custom-search-engine
               addy_io
               browserpass
               canvasblocker
               clearurls
               cookie-autodelete
               darkreader
               decentraleyes
               disconnect
               duckduckgo-privacy-essentials
               enhancer-for-youtube
               # etag-stoppa?
               # firefox-relay?
               # hide-tabs?
               # minerblock?
               privacy-settings
               sidebery
               snowflake
               sponsorblock
               tab-session-manager
               #temporary-containers
               terms-of-service-didnt-read
               vimium
               xbrowsersync
               adnauseam
               #windscribe
             ];
         };
       }; #profiles ends here
       };#firefox ends here
     lsd.enable = true;
     bat.enable = true;

     # nushell = {
     #   enable = true;
     #   shellAliases = {
     #      cp = "ucp -rgv";
     #   };
     # };
   }; # programs ends here

}
