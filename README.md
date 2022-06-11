# fake-computer-crashed
This is a shell script that displays a fake "grub rescue>" prompt on the terminal.
Used as a prank to fool your colleagues "root file system crashes" :)

play.sh is a simple script:
1. displays "grub rescue>" and the prompt "kernel panic - not syncing: fatal exception" will be prompted after random input and Enter.
2. Intercept SIGINT signal (also CTRL+C)
3. "EXIT PASSWORD" is '2333', while input '2333' behind "grub rescue>" script exit.

play2.sh is a little more fancy than play.sh:
1. Custom "EXIT PASSWORD" function.
2. Intercept SIGINT and SIGTSTP signal (also CTRL+C and CTRL+Z), while input "EXIT PASSWORD" behind "grub rescue>" script exit.
3. A fake "Rebuilding Root File System progress" display, it set to appear randomly by default or not. and you can input 'fsck.grub' behind the "grub rescue>" to launch.
4. also have displays "grub rescue>" and the prompt "kernel panic - not syncing: fatal exception" will be prompted after random input and Enter.

./play2.sh
Usage: ./play2.sh Paramter1=[PASSWORD or --nopasswd] Parameter2 Parameter3 [Option]
Options:
--nofreb      Do not enable random fake "Rebuilding Root File System" progress display, the false progress display can be obtained by manually sending SIGUSR1.
--nopasswd    This Patamter Must at Paramter1,  "PASSWORD" as a "EXIT_KEYWORD" Do not enable "PASSWORD" and without trap SIGINT&SIGTSTP. Default parameter if "PASSWORD" not exist.
--help        List this help.

Note: Parameter 2 and Parameter 3 control the frequency of false progress bars. Parameter 2 is the lower limit. Parameter 3 is the upper limit. They must be set together. They are numbers and the unit is seconds. The default value is 30 60.
