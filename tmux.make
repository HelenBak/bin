tmux new-session -s 'test' -n 'Work' \; \
    send-keys 'wkk;make' C-m \; \
    new-window -n 'Kdev'\; \
    send-keys 'kdev;make' C-m \; \
    new-window -n 'Ktest'\; \
    send-keys 'cd ~/work/kraken.test/;make' C-m \; \
    attach
