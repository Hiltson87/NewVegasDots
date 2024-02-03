#! /bin/bash
#bar="_▏▎▍▌▋▊▉██"
bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# make sure to clean pipe
pipe="/tmp/cava.fifo2"
if [ -p $pipe ]; then
    unlink $pipe
fi
mkfifo $pipe

# write cava config
config_file="/tmp/cavaWayMic"
echo "
[general]
bars = 6
[input]
method = pulse
source = 2233
[output]
method = raw
raw_target = $pipe
data_format = ascii
ascii_max_range = 7
" > $config_file

# run cava in the background
cava -p $config_file &

# reading data from fifo
while read -r cmd; do
    echo $cmd | sed $dict
done < $pipe
