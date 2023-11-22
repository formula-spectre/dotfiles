{ config, lib, pkgs, ... }:
let
  USER = builtins.getEnv "USER";
  UID = builtins.getEnv "UID";
  XDG_RUNTIME_DIR = builtins.getEnv "XDG_RUNTIME_DIR";
  BROWSER = "firefox";
  myEnvVars = {
       #XKB_DEFAULT_LAYOUT="\"it(us)\"";
       #XKB_DEFAULT_OPTIONS="ctrl:nocaps";
       BROWSER="${BROWSER}";
       CABAL_CONFIG="${config.xdg.configHome}/cabal/config";
       CABAL_DIR="${config.xdg.configHome}/cabal";
       CARGO_HOME="${config.xdg.dataHome}/cargo";
       DBUS_SESSION_BUS_ADDRESS="unix:abstract=/formula/dbus";
       DOOMDIR = "${config.xdg.configHome}/doom.d";
       EMACSDIR = "${config.xdg.configHome}/emacs";
       GHCUP_USE_XDG_DIRS="true";
       GNUPGHOME="${config.xdg.dataHome}/gnupg";
       GOBIN="${config.xdg.dataHome}/go/bin";
       GOPATH="${config.xdg.dataHome}/go";
       GTK2_RC_FILES="${config.xdg.configHome}/gtk-2.0/gtkrc";
       ICEAUTHORITY="${config.xdg.cacheHome}/ICEauthority";
       LESSHISTFILE="${config.xdg.cacheHome}/less/history";
       MOZ_ENABLE_WAYLAND="1";
       NIX_PATH="/home/${USER}/.nix-defexpr/channels";
       NU_LIB_DIRS="[${config.xdg.dataHome}/nu]";
       PASSWORD_STORE_GPG_OPTS="\" --default-recipient cloud.strife@tuta.io\"";
       S6_ENVDIR_DIR="${config.xdg.configHome}/s6-rc/envdir";
       SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket";
       TERM="xterm";
       XCOMPOSECACHE="${config.xdg.cacheHome}/X11/compose";
       XDG_CONFIG_HOME="/home/${USER}/.config";
       XDG_CURRENT_DESKTOP="Unity";
       XDG_DATA_HOME="/home/${USER}/.local/share";
       XMONAD_CACHE_DIR="${config.xdg.configHome}/xmonad";
       XMONAD_CONFIG_HOME="${config.xdg.configHome}/xmonad";
       XMONAD_DATA_DIR="${config.xdg.configHome}/xmonad";
       #ZSHZ_DATA = "${config.xdg.dataHome}/zsh/zshzdb";
       #ZSH_COMPDUMP = "${config.xdg.cacheHome}/zsh/zcompdump";
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
     ];
     #sessionVariables = myEnvVars;
   };
   programs = {
     carapace = {
       #package = null;
       enable = true;
       enableNushellIntegration = true;
     };
     zsh.enable = true;
     nushell = {
       enable = true;
       package = pkgs.cowsay;
        extraConfig = "
 $env.config = {
   completions: {
       algorithm:  \"fuzzy\"
   }
   hooks : {
     env_change: {
         PWD: []
     }
    #  pre_prompt: [
    #     {

    #         if ( '_last_start' in $env ) {
    #             let end = date now
    #             let total = $end - $env._last_start
    #             if ($total > 1800sec) {
    #                 let total = $total | format duration sec
    #                 let body = \"given task finished in \" + $total
    #                 curl -d \"a long command has finished, check it!\" ntfy.sh/nodejs-emerge
    #                 dbus-launch notify-send \"a long command has finished\"
    #             }
    #         }
    #       },
    # ]
    # pre_execution: [
    #     { $env._last_start = (date now) }
    # ]
   }
   show_banner: false
 }
 $env.config.hooks.env_change.PWD = (
     $env.config.hooks.env_change.PWD | append (source ~/.local/share/nu/nu_scripts/hooks/direnv/config.nu)
 )
use ~/.local/share/nu/nu_scripts/custom-completions/pass/pass-completions.nu *

#custom functions
def rc.restart [svname] {
    s6-svc -r \$\"/tmp/\($env.USER)/service/(\$svname)-srv\"
}
                     ";
       extraEnv = "
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | append ($env.HOME | path join \".local\" \"share\" \"go\" \"bin\")
    | prepend ($env.HOME | path join \".local\" \"bin\")
    | append ($env.HOME | path join \".nix-profile\" \"bin\")
    | uniq
)

                  ";
       shellAliases = {
         cat="bat";
         cp="uutils cp -rvg";
         e="emacsclient -ct";
         gc="git clone";
         grep="rg";
         irssi="ssh irssi";
         jobs="jobs -p";
         k="kubectl";
         md="mkdir";
         mv="uutils mv -vg";
         du="uutils du";
         dd="uutils dd";
         r="rm -rvf";
         #s6-rc-user="s6-rc -l /tmp/${USER}/s6-rc";
         "rc.user"  =  "s6-rc -l /tmp/${USER}/s6-rc";
         "rc.start" = "s6-rc -l /tmp/${USER}/s6-rc start";
         "rc.stop"  = "s6-rc -l /tmp/${USER}/s6-rc stop";
         rc-user="s6-rc -l ${XDG_RUNTIME_DIR}/s6/s6-rc";
         termbin="nc termbin.com 9999";
         tra="transmission-remote --add";
         trl="transmission-remote --list";
         yt-mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg";
         yt-mp4="yt-dlp -S res,ext:mp4:m4a --recode mp4";
         zja="zellij a";
         tr="transmission-remote";
         zj="zellij";
         ga="git add";
       };
       environmentVariables = myEnvVars;

     };
     direnv = {
       enable = true;
       enableNushellIntegration = true;
       #package = null;
       nix-direnv.enable = true;
     };
     home-manager.enable = true;
     starship = {
       enable = true;
       #package = pkgs.cowsay;
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
       package = null;
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
               #tab-session-manager
               temporary-containers
               terms-of-service-didnt-read
               vimium
               xbrowsersync
               adnauseam
               privacy-possum
               #whatCampain
               #trackmenot
               windscribe
             ];
         };
       }; #profiles ends here
       };#firefox ends here
     #lsd.enable = true;
     #bat.enable = true;
   }; # programs ends here

}
