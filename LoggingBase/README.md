#  

capture $(xcrun simctl spawn booted launchctl print system | grep UIKitApplication:ff.s | awk '{print $1}') > log.txt


capture() {
    sudo dtrace -p "$1" -qn '
        syscall::write*:entry
        /pid == $target && arg0 == 1/ {
            printf("%s", copyinstr(arg1, arg2));
        }
    '
}


