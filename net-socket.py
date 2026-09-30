# !/usr/bin/python

import socket

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

"""
socket.AF_INET --> IPv4 bilan ishlaydi.
socket.SOCK_STREAM --> TCP connection ishlatadi
"""

s.connect(("10.13.4.248", 6666))

"""
10.13.4.248 --> IP
4444 --> PORT

Client
   │
   │ connect()
   ▼
192.168.50.101:9999
"""

print(s.recv(1024).decode())

"""
recv() --> Serverdan kelayotgan ma'lumotni o'qiydi
1024 --> Bir martta maksimal 1024 byte ma'lumot oladi

Masalan server:

You are connected.
Goodbye

Yuborgandam Pythin uni:

b'You are connected.\nGoodbye'

ko'rinishida oladi. Nega 'b', chunki bu byte ko'rinishida keladi. Uni string formatga o'tkazish kerak
U vaqtda .decode() kerak.

Saytdan keladi --> .decode() bytes to str
Saytga ketadi --> encode() str to bytes
"""

s.send("5".encode())

"""
Serverga ma'lumot yuborilyapti, yuboriladigan matn .encode() qilinyapti.
"""

print(s.recv(1024).decode())

"""
Server hisob kitob qiladi, natijani yuboriadi, uni qabul qilish uchun .decode() qilinadi.
"""
s.close()

"""
       CLIENT
         │
         │ connect
         ▼
       SERVER
         │
         │ response
         ▼
       CLIENT
         │
         │ send
         ▼
       SERVER
         │
         │ response
         ▼
       CLIENT
"""