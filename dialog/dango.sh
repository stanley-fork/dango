#!/bin/bash
echo "


         ○●
         ●●
         ●○
  ●○○○●○ ●●   ●○○○●●○●   ●○ ○○○●○●      ●○○○●○ ○●    ●○○○●○●
●●     ○●○●         ○●●  ●●○     ●○●  ●●     ○●●   ●●       ●●
●○       ●○   ●○●●○○○●●  ●●       ●●  ●○      ○●●  ●○       ○●
 ●●     ○●●  ●●      ●○  ●○       ●○  ●●     ○●●   ●●       ●●
  ○●○●●○ ●●   ○●○○○○ ●○  ○●       ○●    ○●○●○○●○     ○○●●●●○ 
                                       ●○      ●●
                                         ●●○○○○
" 

if ! command -v gnugo &> /dev/null; then
echo "A one time install of GNU Go is neccesary to continue"   
        sudo pacman -S gnugo      ||    
        sudo apt install gnugo    ||
        sudo yum install gnugo    ||
        sudo pkg install gnugo    ||
        sudo zypper install gnugo ||  
        sudo install gnugo        ||
echo "GNU Go has failed to install, please search on your distro's package manager, or consult it's wiki."
else sleep 1
fi

# Default settings

ruleset=--japanese-rules
rules=Japanese
level=10
color=black
komi="6.5"
outdir=$HOME/.cache/dango/"$(date +%F) $(date +%X)"
size=19
theme=Modern
config=default
                
mkdir $HOME/.cache/dango
mkdir $HOME/.config/dango

# Load user's saved presets
[[ -f ~/.config/dango/config ]] && . ~/.config/dango/config && is_config=Loaded

if [ -n "$outdir"] # Checks if output is loaded from config
then out=Yes
else out=No
fi


clear
while true; do

dialog --backtitle "Dango"  --menu "Select an entry to edit, enter to start game" 0 0 0  "Rule set" "$rules" "Color" "$color" "Komi" "$komi" "AI Strength" "$level" "Board size" "$size x $size" "Save Game?" "$out" "Theme" "$theme" "Config options" "$is_config"



        while true; do
        case $option in
        1) echo "Chose Japanese or Chinese ruleset " 
                select rules in Japanese Chinese; do 
                case $rules in
                Japanese) ruleset="--japanese-rules"; break;;
                Chinese)  ruleset="--chinese-rules";  break;;
                esac
                done
                clear;
                break;;
        2) echo "Choose a color"
                select color in black white; do clear
                break 2
                done;;
        3) read -r -p "Chose a number of komi "      komi; clear; break;;
        4) read -r -p "Select an AI strength: " level; 
                if   [ $level -ge 11 ]; then
                echo "Please choose a value less than 10"
                elif [ $level -eq 0  ]; then
                echo "Please choose a value greater than 0"
                else clear; break;        
                fi;;

        5) read -r -p "Chose a board size: " size; clear; break;;
        6) read -r -p "Chose path to save game: " outdir ;
                if [ -n "$outdir" ]; # Unsaved games are cached 
                then out=Yes && echo "Game will be saved to: $outdir"; 
                else out=No  && echo "Game will not be saved.";
                fi;
                sleep 2;
                clear;
                break;;
        7) echo "Choose a theme"
                echo "Color is only fully supported on rxvt"
                echo -e "
                
 5 . . . . .    5 · · · · ·   \e[30;43m 5 · · · · · \e[0m
 4 . . . O .    4 · · · ○ ·   \e[30;43m 4 · · · \e[97;43m● \e[30;43m· \e[0m
 3 . . . O .    3 · · · ○ ·   \e[30;43m 3 · · · \e[97;43m● \e[30;43m· \e[0m
 2 . X . . .    2 · ● · · ·   \e[30;43m 2 · ● · · · \e[0m
 1 . . X . .    1 · · ● · ·   \e[30;43m 1 · · ● · · \e[0m
   A B C D E      A B C D E   \e[30;43m   A B C D E \e[0m

    Classic        Modern         Color
                
"
                select theme in Classic Modern Color; do
                case $theme in
                Classic) break;;
                Modern) break;;
                Color) break;;
                esac
                done;
                clear;
                break;;
        8) echo Save current config, or restore default?
        select con in Save Default; do
        case $con in
        
              Save) mkdir -p ~/.config/dango
              touch ~/.config/dango/config
        echo "ruleset=$ruleset
              color=$color
              komi=$komi
              level=$level
              size=$size
              outdir=$outdir
              theme=$theme" > ~/.config/dango/config

        echo "Current settings saved"
        sleep 1
        break;;
        
               Default) rm  ~/.config/dango/config
               [[ -f "~/.config/dango/config" ]] &&
               rm  ~/.config/dango/config
               . "$(dirname $(readlink -f $0))" && is_config=Default
               break;;
        esac
        done 
        clear;
        break;;
        
        "") break 2;;
        q|:q|exit) exit; break;;
        esac
done # End of Dialog
done # End of menu

clear

#Start Gnu Go, dependant on selected color, default=modern

case $theme in
        Classic) gnugo --mode ascii --boardsize $size --komi $komi --level $level --color $color --outfile "$outdir" ;;
        
        Modern) gnugo --mode ascii --boardsize $size --komi $komi --level $level --color $color --outfile "$outdir" | sed 

                
                ;;
        
        Color) gnugo | sed -e 's/(/\x1b[32;43m(\x1b[0m/g;s/)/\x1b[32;43m)\x1b[0m/g;s/X /\x1b[30;43m● \x1b[0m/g;s/O/\x1b[97;43m●\x1b[0m/g;s/\./\x1b[30;43m·\x1b[0m/g;s/+/\x1b[30;43m+\x1b[0m/g;s/ /\x1b[30;43m \x1b[0m/g;s/[1-9]/\x1b[30;43m&\x1b[0m/g;s/[1-9][0-9]/\x1b[30;43m&\x1b[0m/g'
                ;;

esac

echo "Play again? (y/n)" 
read YN
case $YN in
y|Y|yes) sh "$0";;
n|N|No) break;;
esac

clear
echo "See you"
sleep 1
exit

# menu options

# save location

gnugo |
sed -e 's/(/\e[32;43m(\e[0m/g' |
sed -e 's/)/\e[32;43m)\e[0m/g'

sed -e s/X /\e[30;43m● \e[0m/g |
sed -e s/O/\e[97;43m●\e[0m/g |
sed -e s/\./\e[30;43m·\e[0m/g |
sed -e s/+/\e[30;43m+\e[0m/g |
sed -e s/ /\e[30;43m \e[0m/g |
sed -e s/[1-9]/\e[30;43m&\e[0m/g |
sed -e s/[1-9][0-9]/\e[30;43m&\e[0m/g' |




#gnugo | sed -e 's/(/\x1b[32;43m(\x1b[0m/g;s/)/\x1b[32;43m)\x1b[0m/g;s/X /\x1b[30;43m● \x1b[0m/g;s/O/\x1b[97;43m●\x1b[0m/g;s/\./\x1b[30;43m·\x1b[0m/g;s/+/\x1b[30;43m+\x1b[0m/g;s/ /\x1b[30;43m \x1b[0m/g;s/[1-9]/\x1b[30;43m&\x1b[0m/g;s/[1-9][0-9]/\x1b[30;43m&\x1b[0m/g'