{ config, lib, pkgs, ... }:
let
  USER = builtins.getEnv "USER";
  BROWSER = "librewolf";
in
{
   home = {
     username = "${USER}";
     homeDirectory = "/home/${USER}";
     stateVersion = "22.05";
      sessionPath = [
        "/home/${USER}/.config/emacs/bin"
        "/home/${USER}/.nix-profile/bin/"
        "/home/${USER}/.local/bin"
     ];
     sessionVariables = {
       NIX_PATH="/home/${USER}/.nix-defexpr/channels";
       #PATH="$PATH:/home/${USER}/.nix-profile/bin/:/home/${USER}/.local/bin/";
       TERM="xterm";
       BROWSER="${BROWSER}";
       XDG_CONFIG_HOME="/home/${USER}/.config";
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
       XKB_DEFAULT_OPTIONS="ctrl:nocaps";
       XKB_DEFAULT_LAYOUT="it(us)";
       PASSWORD_STORE_GPG_OPTS="--default-recipient cloud.strife@tuta.io";
     };
   };
   programs = {
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
             "browser.newtabpage.pinned" = [{
               title = "NixOS";
               url = "https://nixos.org";
             }];
           };
           extensions = with pkgs.nur.repos.rycee.firefox-addons;
             [
               add-custom-search-engine
               anonaddy
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
               temporary-containers
               terms-of-service-didnt-read
               vimium
               xbrowsersync
               windscribe
             ];
         };
       }; #profiles ends here     };#firefox ends here
     lsd.enable = true;
     bat.enable = true;
     zsh = {
       completionInit = "autoload -U compinit && compinit -u";
       envExtra = ''
 source /etc/profile
 export XDG_CACHE_HOME="$HOME/.cache"
 export XDG_CONFIG_HOME="$HOME/.config"
 export XDG_DATA_HOME="$HOME/.local/share"

                  '';
       profileExtra = ''
if [  "$(tty)" = "/dev/tty1" ] ; then
  mkdir -p /tmp/''${USER}/{service,s6-log}
  touch /tmp/''${USER}/s6-log/current
  mkfifo /tmp/''${USER}/s6-log/logfifo
  setsid -f \
      fdmove -c 3 2 \
          redirfd -wnb 1 "/tmp/''${USER}/s6-log/logfifo" \
          fdmove -c 2 1  \
              s6-envdir ~/.config/s6u/envdir \
              s6-svscan -X3 /tmp/''${USER}/service
  [ -d /tmp/''${USER}/s6-rc ] ||
    redirfd -w 1 "/tmp/''${USER}/s6-log/logfifo" \
        s6-rc-init -c ''${HOME}/.config/s6u/rc/compiled -l /tmp/''${USER}/s6-rc /tmp/''${USER}/service
fi
                      '';
       dotDir = ".config/zsh.nix";
       defaultKeymap = "emacs";
       history = {
         size = 10000;
         save = 10000;
         path = "${config.xdg.dataHome}/zsh_history";
         ignoreDups = true;
         ignoreSpace = true;
         ignorePatterns = [ "rm *" "kill *" "transmission*" "pkill *"];
         share = true;
       };
       enable = true;
       enableAutosuggestions = true;
       enableCompletion = true;
       enableSyntaxHighlighting = true;
       autocd = true;
       shellAliases = {
         r="rm -rvf";
         cp="cp -rv";
         jobs="jobs -p";
         ls="lsd -F --color=never";
         grep="rg";
         md="mkdir -p";
         e="emacsclient -ct";
         s6-rc-user="s6-rc -l /tmp/\$\{USER\}/s6-rc";
         cat="bat";
         termbin="nc termbin.com 9999";
         yt-mp3="youtube-dl -x --audio-format mp3 --prefer-ffmpeg";
         yt-mp4="";
         k="kubectl";
         ll="ls -l";
         l1="ls -1";
       };
        initExtraFirst = (
  "
 [[ $TERM == \"tramp\" ]] && unsetopt zle && PS1=\'$ \' && return
 [[ $TERM == \"dumb\" ]] && unsetopt zle && PS1=\'$ \' && return
  "
       );
       initExtra = (
         "
 source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
 source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
 source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
 source ${pkgs.nix-zsh-completions}/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh
 #source ${pkgs.fzf}/share/fzf/completion.zsh
 #source ${pkgs.fzf}/share/fzf/key-bindings.zsh
 source /usr/share/fzf/key-bindings.zsh
 #source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
 source /usr/share/zsh/site-functions/fzf-tab.zsh
 source ${pkgs.zsh-fzf-tab}/share/fzf-tab/lib/zsh-ls-colors/ls-colors.zsh
 source ${pkgs.deer}/share/zsh/site-functions/deer
 source \$\{ZDOTDIR\}/functions
 setopt globdots
        "
 #export PS1=\"%?%B ﬦ %n @ %~ >>=%b \"
 #       "
       );
       plugins = [
         {
           name = "zsh-auto-notify";
           file = "auto-notify.plugin.zsh";
           src = builtins.fetchGit {
             url = "https://github.com/MichaelAquilina/zsh-auto-notify";
           };
         }
       ];
     }; # zsh ends ehre

     # fzf = {
     #   enable = true;
     #   enableZshIntegration = true;
     #};
   }; # programs ends here

   xdg = {configFile."zsh.nix/functions".text = ''
 agent() {
   eval $(ssh-agent)
   ssh-add "$HOME/.ssh/id_ed25519" }

 function cd() {
    emulate -LR zsh
    builtin cd $@ &&
    lsd -F --color=never --group-dirs=first -A }

 function popd(){
   emulate -LR zsh
   builtin popd $@ &&
   lsd -F --color=never --group-dirs=first -A }

 function pushd(){
   emulate -LR zsh
   builtin pushd $@ &&
   lsd -F --color=never --group-dirs=first -A }

 function z(){
   emulate -LR zsh
   z $@ &&
   ls -F --color=never --group-directories-first -A }

 curlhab () { curl -X POST \
     --header "Content-Type: text/plain" \
     --header "Accept: application/json" -d "$2" "http://192.168.1.6:8080/rest/items/$1"}

 clearcaches(){
   echo "execlineb -Pc 'if { sync } pipeline { echo 3 } tee /proc/sys/vm/drop_caches'"
   doas execlineb -Pc 'if { sync } pipeline { echo 3 } tee /proc/sys/vm/drop_caches' }

 aura (){
      printf "reminder: aura does not support doas yet, so i'm using sudo..\n"
      /usr/bin/sudo aura --unsuppress $* }
 '';

   };
 }
