import socket

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

server.bind(("127.0.0.1", 4444))
server.listen(1)

print("Server 4444-portda kutmoqda...")

client, address = server.accept()

print(f"Ulandi: {address}")

client.send("HELLO FROM TEST SERVER".encode())

client.close()
server.close()