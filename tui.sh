#!/usr/bin/env bash

# Colors
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
bold=$(tput bold)
reset=$(tput sgr0)

# Cursor Control
hide() {
  tput civis
}

show() {
  tput cnorm
}

# Screen dimensions
rows=$(tput lines)
cols=$(tput cols)

# Cleanup
cleanup() {
  clear
  show
  exit 0
}

trap cleanup EXIT INT TERM HUP

# Menu items
MENU=("Option 1: Update System"
      "Option 2: List files"
      "Option 3: Custom command"
      "Exit")

# Draw header
draw_header() {
  clear
  tput cup 0 0
  echo "${bold}${blue}=== Simple Bash TUI Skeleton ===${reset}"
  echo
}

# Draw menu
draw_menu() {
  for i in "${!MENU[@]}"; do
    if [[ $i -eq $1 ]]; then
      echo "  ${yellow}❯ ${MENU[$i]}${reset}"
    else
      echo "    ${MENU[$i]}"
    fi
  done
}

# Main loop
main() {
  local choice=0
  while true; do
    hide
    draw_header
    draw_menu $choice

    # Read single key
    read -rsn1 key
    case $key in
      A) # Up arrow
        ((choice--))
        ((choice<0)) && choice=$((${#MENU[@]}-1))
        ;;
      B) # Down arrow
        ((choice++))
        ((choice>=${#MENU[@]})) && choice=0
        ;;
      "") # Enter key
        case $choice in
          0) clear; echo "${green}Update System:${reset}"; yay -Syu; read -p "Press Enter...";;
          1) clear; echo "${green}Files:${reset}"; ls -lh; read -p "Press Enter...";;
          2) clear; echo "${green}Running custom command...${reset}"; echo "Replace me"; read -p "Press Enter...";;
          3) cleanup;;
        esac
        ;;
    esac
  done
}

# Main execution
main
