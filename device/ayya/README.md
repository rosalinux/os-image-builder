The script main.sh allows to unpack ayya project and build kernel and lk components on 212.41.6.19 server.

It should be launched with option
./main.sh -option opt-args

The available options are:
-u - Unpack archive with environment source from server location
-c (kernel, lk) - Clone source code from rosalinux repository
-b (kernel, lk) - Build components
-j (number of threads)- Set number of build threads. Default is 15.
-v (user, userdebug, eng) - Set build variant option. Default is user.
-h - Help

Example usage:

main -u -c kernel -c lk -b kernel -j 10 -v userdebug

This example unpacks archive, clones kernel and lk repositories, sets number of build threads = 10,
sets build variant to userdebug and builds kernel.
