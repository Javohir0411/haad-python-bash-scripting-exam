import socket
import logging

logging.basicConfig(level=logging.INFO)

ip = input("IP manzilni kiriting: ")
port = input("PORT raqamini kiriting: ")
logging.info(f"Yuborilgan IP: {ip}, PORT: {port}")
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
    port = int(port)
    if not (1 <= port <= 65535):
        logging.info("Noto'g'ri PORT raqami yuborildi, e'tiborli bo'ling !")
        raise ValueError

    s.settimeout(5)

    logging.info(f"\n{ip}:{port} ga ulanilmoqda...\n")

    s.connect((ip, port))
    banner = s.recv(1024).decode("utf-8", errors='ignore')

    print(f"\n================= BANNER =================\n")
    print(banner.strip())
    print(f"\n===========================================")

except ValueError:
    print("[!] Port 1-65535 oralig'idagi son bo'lishi kerak.")

except socket.timeout:
    print("[!] Ulanish vaqti tugadi (Timeout).")

except ConnectionRefusedError:
    print("[!] Ulanish rad etildi. Port yopiq bo'lishi mumkin.")

except socket.gaierror:
    print("[!] IP manzil noto'g'ri.")

except Exception as e:
    print(f"[!] Xatolik: {e}")
finally:
    s.close()
