# Reboot directly to Windows
# Inspired by http://askubuntu.com/questions/18170/how-to-reboot-into-windows-from-ubuntu
reboot_to_windows ()
{
    windows_title=$(grep -i windows /boot/grub/grub.cfg | cut -d "'" -f 2)
    sudo grub-reboot "$windows_title" && sudo reboot
}
alias reboot-to-windows='reboot_to_windows'
alias projects="ls -A1 ~/Projects"
alias dsatcl="docker run --rm -it -v ~/Projects/dsatcl:/data datasciencetoolbox/dsatcl2e"
