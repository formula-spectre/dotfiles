#!/bin/sh
die()
{
    echo "$1"
    exit 1
}

#check if xmobar?.hs exists
if [ ! -e ./xmobar0.hs ] && [ ! -e ./xmobar1.hs ]
then
     die "the two files are not present!"
fi


#printf '%s\n' "which one you want to compile?"
#read choice


case $1 in
    "all")
            for f in xmobar*.hs
            do
                stack ghc -- \
                           --make $f \
                           -ilib \
                           -fforce-recomp \
                           -main-is main \
                           -threaded
            done
    ;;
    "0")
        stack ghc -- \
                  --make xmobar0.hs \
                  -ilib \
                  -fforce-recomp \
                  -main-is main \
                  -threaded
    ;;
    "1")
        stack ghc -- \
                  --make xmobar1.hs \
                  -ilib \
                  -fforce-recomp \
                  -main-is main \
                  -threaded
    ;;
    "emacs")
        stack ghc -- \
                  --make xmobar-emacs.hs \
                  -ilib \
                  -fforce-recomp \
                  -main-is main \
                  -threaded
        echo "moving xmobar-emacs into ~/.local/bin"
        mv -v ./xmobar-emacs ~/.local/bin
    ;;
    "*")
        die "invalid option!"
    ;;
esac


    

    
echo "removing .hi and .o files.."
rm -v ./xmobar?.hi ./xmobar?.o
