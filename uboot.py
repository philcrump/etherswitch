#!/usr/bin/env python

import sys
import socket
import threading

# Directions:
# uboot will come up as 192.168.1.1
# your pc needs to be on 192.168.1.2, with port 6666/udp open
# 
# To boot the AR150 into uboot:
# Connect ethernet to the WAN port
# Hold the reset button as you plug the power in
# Hold the reset button until the red LED flashes 9 times and the middle green LED comes back on a second time

# Run this script, pressing 'enter' should yield a '> ' prompt
# Type 'help' for list of uboot commands
# Type 'httpd' to start webpage to upload new firmware

UDP_IP = "192.168.1.1"
UDP_PORT = 6666

class ReceiverThread(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.sock = socket.socket(socket.AF_INET, # Internet
                             socket.SOCK_DGRAM) # UDP
        self.sock.bind(("0.0.0.0", UDP_PORT))
        self.sock.settimeout(5)
        self.running = True

    def stop(self):
        self.running = False

    def run(self):
        while self.running:
            try:
                data, addr = self.sock.recvfrom(1024) # buffer size is 1024 bytes
                sys.stdout.write(data)
                sys.stdout.flush()
            except socket.timeout:
                pass

rx = ReceiverThread()
rx.start()

try:
    while True:
        in_text = raw_input()

        sock = socket.socket(socket.AF_INET, # Internet
                             socket.SOCK_DGRAM) # UDP
        sock.sendto(in_text + "\r\n", (UDP_IP, UDP_PORT))

except:
    rx.stop()
