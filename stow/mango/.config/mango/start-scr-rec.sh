pidof -q gpu-screen-recorder && notify-send -t 1500 -u high "Recording Screen" && sleep 0.5 && exit 0
video="$HOME/Videos/$(date +"Video_%Y-%m-%d_%H-%M-%S.mp4")"
gpu-screen-recorder -w screen -f 60 -a default_output -o "$video"

