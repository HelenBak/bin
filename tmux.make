tmux new-session -s 'test' -n 'Work' \; \
    send-keys 'wkk;make' \; \
    new-window -n 'Kdev'\; \
    send-keys 'kdev;make' \; \
    new-window -n 'Ktest'\; \
    send-keys 'cd ~/work/kraken.test/;make' \; \
    attach
