{ config, lib, pkgs, ... }:

{
  xdg = {
    #define envdir
    configFile."s6/envdir/DBUS_SESSION_BUS_ADRESS".text = ''unix:abstract=/doctor-sex/dbus'';
    configFile."s6/envdir/DISPLAY".text = '':1'';
    configFile."s6/envdir/DOOMDIR".text = ''/home/doctor-sex/.config/doom.d'';
    configFile."s6/envdir/EMACSDIR".text = ''/home/doctor-sex/.config/emacs'';
    configFile."s6/envdir/HOME".text = ''/home/doctor-sex'';
    configFile."s6/envdir/LANG".text = ''en_US.UTF-8'';
    configFile."s6/envdir/UUID".text = ''1000'';
    configFile."s6/envdir/USER".text = ''doctor-sex'';
    configFile."s6/envdir/XAUTHORITY".text = ''/home/doctor-sex/.local/share/sx/xauthority'';
    configFile."s6/envdir/XDG_CONFIG_HOME".text = ''/home/doctor-sex/.config'';
    configFile."s6/envdir/XDG_DATA_HOME".text = ''/home/doctor-sex/.local/share'';
    configFile."s6/envdir/XDG_RUNTIME_DIR".text = ''/run/user/1000'';

    #pipewire service
    configFile."s6/sv/pipewire-srv/notification-fd".text = "3";
    configFile."s6/sv/pipewire-srv/producer-for".text = "pipewire-log";
    configFile."s6/sv/pipewire-srv/run".text = ''
${pkgs.execline}/bin/execlineb -P
backtick -E USER { id -un }
s6-envdir /home/''${USER}/.config/s6u/envdir
fdmove -c 2 1 ${pkgs.pipewire}/bin/pipewire
'';
    #pipewire-log service
    configFile."/s6/sv/pipewire-log/consumer-for".text = ''
pipewire-srv
pipewire-pulse-srv
wireplumber-srv
'';
    configFile."/s6/sv/pipewire-log/notification-fd".text = "3";
    configFile."/s6/sv/pipewire-log/pipeline-name".text= "pipewire";
    configFile."/s6/sv/pipewire-log/run".text = ''
${pkgs.execline}/bin/execlineb -P
backtick -E USER { id -un }
importas USER USER
fdmove -c 2 1 /home/''${USER}/..config/s6/user-logger pipewire
'';
    configFile."/s6/sv/pipewire-log/type".text = "longrun";

    #pipewire-pulse service
    configFile."s6/sv/pipewire-pulse-srv/notification-fd".text = "3";
    configFile."s6/sv/pipewire-pulse-srv/producer-for".text = "pipewire-log";
    configFile."s6/sv/pipewire-pulse-srv/run".text = ''
${pkgs.execline}/bin/execlineb -P
backtick -E USER { id -un }
s6-envdir /home/''${USER}/.config/s6u/envdir
fdmove -c 2 1 ${pkgs.pipewire}/bin/pipewire -c pipewire-pulse.conf
'';

    #wireplumber service
    configFile."s6/sv/wireplumber-srv/notification-fd".text = "3";
    configFile."s6/sv/wireplumber-srv/producer-for".text = "pipewire-log";
    configFile."s6/sv/wireplumber-srv/run".text = ''
${pkgs.execline}/bin/execlineb -P
backtick -E USER { id -un }
s6-envdir /home/''${USER}/.config/s6u/envdir
fdmove -c 2 1 ${pkgs.wireplumber}/bin/wireplumber
'';

    #emacs service
    configFile."s6/sv/emacs-srv/notification-fd".text = "3";
    configFile."s6/sv/emacs-srv/producer-for".text = "emacs-log";
    configFile."s6/sv/emacs-srv/run".text = ''
${pkgs.execline}/bin/execlineb -P
backtick -E USER { id -un }
s6-envdir /home/''${USER}/.config/s6u/envdir
fdmove -c 2 1 ${pkgs.emacs}/bin/emacs --fd-daemon
'';
    #emacs-log service
    configFile."/s6/sv/emacs-log/consumer-for".text = "emacs-srv";
    configFile."/s6/sv/emacs-log/notification-fd".text = "3";
    configFile."/s6/sv/emacs-log/pipeline-name".text= "emacs";
    configFile."/s6/sv/emacs-log/run".text = ''
${pkgs.execline}/bin/execlineb -P
backtick -E USER { id -un }
importas USER USER
fdmove -c 2 1 /home/''${USER}/..config/s6/user-logger emacs
'';
    configFile."/s6/sv/emacs-log/type".text = "longrun";


    #define a helper script to update the db
    configFile."s6/s6-db-usr-up".text = ''
#!${pkgs.bash}/bin/bash
DATAPATH="''${XDG_CONFIG_HOME}/s6"
RCPATH="''${DATAPATH}/rc"
DBPATH="''${RCPATH}/compiled"
SVPATH="''${DATAPATH}/sv"
SVDIRS="/tmp/''${USER}/s6-rc/servicedirs"
TIMESTAMP=$(date +%s)

if ! s6-rc-compile "''${DBPATH}"-"''${TIMESTAMP}" "''${SVPATH}"; then
    echo "Error compiling database. Please double check the ''${SVPATH} directories."
    exit 1
fi

if [ -e "/tmp/''${USER}/s6-rc" ]; then
    for dir in "''${SVDIRS}"/*; do
        if [ -e "''${dir}/down" ]; then
            s6-svc -x "''${dir}"
        fi
    done
    s6-rc-update -l "/tmp/''${USER}/s6-rc" "''${DBPATH}"-"''${TIMESTAMP}"
fi

if [ -d "''${DBPATH}" ]; then
    ln -sf "''${DBPATH}"-"''${TIMESTAMP}" "''${DBPATH}"/compiled && mv -f "''${DBPATH}"/compiled "''${RCPATH}"
else
    ln -sf "''${DBPATH}"-"''${TIMESTAMP}" "''${DBPATH}"
fi

echo "==> Switched to a new database for ''${USER}."
echo "    Remove any old unwanted/unneeded database directories in ''${RCPATH}."

                                         '';
  };
}
