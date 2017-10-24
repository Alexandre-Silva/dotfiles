# 1. Supervise command (run every 2s)
watch "ls -larth"

# 2. Kill program using one port
sudo fuser -k 8000/tcp

# 3. Limit memory usage for following commands
ulimit -Sv 1000       # 1000 KBs = 1 MB

# 4. Rename selected files using a regular expression
rename 's/\.bak$/.txt/' *.bak

# 5. Get full path of file
readlink -f file.txt

# 6. List contents of tar.gz and extract only one file
tar tf file.tgz
tar xf file.tgz filename

# 7. List files by size
ls -lS

# 8. Nice trace route
mtr google.com

# 9. Find files tips
find . -size 20c             # By file size (20 bytes)
find . -name "*.gz" -delete  # Delete files
find . -exec echo {} \;      # One file by line
./file1
./file2
./file3
find . -exec echo {} \+      # All in the same line
./file1 ./file2 ./file3

# 10. Print text /ad infinitum/
yes
yes hello

# 11. Who is logged in?
w

# 12. Prepend line number
ls | nl

# 13. Grep with Perl like syntax (allows chars like \t)
grep -P "\t"

# 14. Cat backwards (starting from the end)
tac file

# 15. Check permissions of each directory to a file
#It is useful to detect permissions errors, for example when configuring a web server.

namei -l /path/to/file.txt

# 16. Run command every time a file is modified
while inotifywait -e close_write document.tex
do
make
done

# 17. Copy to clipboard
cat file.txt | xclip -selection clipboard

# 18. Spell and grammar check in Latex
# You may need to install the following: sudo apt-get install diction texlive-extra-utils
detex file.tex | diction -bs

# 19. Check resources' usage of command
/usr/bin/time -v ls

# 20. Randomize lines in file
cat file.txt | sort -R
cat file.txt | sort -R | head  # Pick a random sambple

# Even better (suggested by xearl in Hacker news):
shuf file.txt

# 21. Keep program running after leaving SSH session

# If the program doesn't need any interaction:
nohup ./script.sh &

# If you need to enter some input manually and then want to leave:
./script.sh
<Type any input you want>
<Ctrl-Z>          # send process to sleep
jobs -l           # find out the job id
disown -h jobid   # disown job
bg                # continue running in the background

# 22. Run a command for a limited time
timeout 10s ./script.sh

# Restart every 30 minutes
while true; do timeout 30m ./script.sh; done

# 23. Combine lines from two sorted files
comm file1 file2

# Prints these three columns:
#
# 1. Lines unique to =file1=.
# 2. Lines unique to =file2=.
# 3. Lines both in =file1= and =file2=.
#
# With options =-1, -2, -3=, you can remove each of these columns.

# 24. Split long file in files with same number of lines
split -l LINES -d file.txt output_prefix

# 25. Flush swap partition
# If a program eats too much memory, the swap can get filled with the rest
# of the memory and when you go back to normal, everything is slow. Just
# restart the swap partition to fix it:
sudo swapoff -a
sudo swapon -a

# 26. Fix ext4 file system with problems with its superblock
sudo fsck.ext4 -f -y /dev/sda1
sudo fsck.ext4 -v /dev/sda1
sudo mke2fs -n /dev/sda1
sudo e2fsck -n <first block number of previous list> /dev/sda1

# 27. Create empty file of given size
fallocate -l 1G test.img

# 28. Manipulate PDFs from the command line
# To join, shuffle, select, etc. =pdftk= is a great tool:
pdftk *.pdf cat output all.pdf        # Join PDFs together
pdftk A=in.pdf cat A5 output out.pdf  # Extract page from PDF

# You can also manipulate the content with =cpdf=:

cpdf -draft in.pdf -o out.pdf      # Remove images
cpdf -blacktext in.pdf -o out.pdf  # Convert all text to black color

# 29. Monitor the progress in terms of generated output
# Write random data, encode it in base64 and monitor how fast it
# is being sent to /dev/null
cat /dev/urandom | base64 | pv -lbri2 > /dev/null

# pv options:
#   -l,  lines
#   -b,  total counter
#   -r,  show rate
#   -i2, refresh every 2 seconds
