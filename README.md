# 🌟 Drosera Node Auto-Installer 🌟

Repositori ini menyediakan skrip instalasi otomatis untuk menyiapkan node Drosera. Ikuti petunjuk di bawah ini untuk menginstal dan mengonfigurasi node menggunakan skrip yang disediakan.

## 🛠️ Prasyarat

- 💻 VPS yang menjalankan Ubuntu (disarankan versi 20.04 atau 22.04).
- 🔑 Akses root atau pengguna dengan hak sudo.
- 🌐 Koneksi internet yang stabil.
- 🧠 Pengetahuan dasar tentang perintah terminal.

## 🚀 Langkah-Langkah Instalasi

### 1. Mulai Sesi Screen 🖥️
Untuk memastikan proses instalasi tetap berjalan meskipun sesi SSH Anda terputus, gunakan perintah `screen` untuk membuat sesi yang persisten.

Jalankan perintah berikut untuk memulai sesi screen baru dengan nama `dresora`:
```bash
screen -S dresora
```
Ini akan membuka sesi screen baru di mana Anda dapat menjalankan skrip instalasi.

### 2. Catatan Tentang Penggunaan Screen 📋

**Mengapa menggunakan `screen`?** Ini memungkinkan instalasi tetap berjalan di latar belakang jika sesi terminal Anda terganggu (misalnya, karena masalah jaringan).

#### Perintah Dasar Screen:
- 🔄 **Keluar dari sesi**: Tekan `Ctrl + A`, lalu `D` untuk keluar dan kembali ke terminal utama. Sesi akan tetap berjalan.
- ↩️ **Kembali ke sesi**: Jalankan `screen -r dresora` untuk kembali ke sesi `dresora`.
- 📜 **Daftar semua sesi screen**: Jalankan `screen -ls` untuk melihat semua sesi aktif.
- ❌ **Keluar dari sesi**: Setelah selesai, ketik `exit` di dalam sesi screen untuk menutupnya.

Jika `screen` belum diinstal, Anda dapat menginstalnya dengan:
```bash
sudo apt install screen
```

### 3. Jalankan Skrip Auto-Installer 🛠️
Di dalam sesi screen `dresora`, jalankan perintah berikut untuk mengunduh dan menjalankan skrip auto-installer langsung dari GitHub:
```bash
curl -fsSL https://raw.githubusercontent.com/idnodefiqul/Auto-Install-Node-Dresora/main/autodresora.sh | bash
```
Perintah ini akan:
- 📥 Mengunduh skrip `autodresora.sh` dari repositori.
- ⚙️ Menjalankannya di terminal Anda, menginstal semua dependensi yang diperlukan, dan mengonfigurasi node Drosera.

### 4. Ikuti Instruksi Skrip 📝
Skrip ini bersifat interaktif dan akan meminta input selama proses eksekusi, seperti:
- 🧑‍💻 Nama pengguna dan email GitHub.
- 🔐 Private key untuk deployment.
- 💼 Alamat wallet ETH operator.
- ✅ Konfirmasi untuk melanjutkan setelah menyetor Bloom Boost ETH di Holesky.

Ikuti petunjuk di layar dengan hati-hati untuk menyelesaikan instalasi. Skrip ini akan:
- 📦 Menginstal dependensi (Docker, Foundry, Bun, dll.).
- 🛠️ Mengonfigurasi node Drosera dan CLI operator.
- 🔄 Menyiapkan layanan systemd untuk node.
- 🔒 Mengonfigurasi firewall.

### 5. Pasca-Instalasi ✅
Setelah skrip selesai, akan ditampilkan perintah-perintah berguna untuk memantau node:

- **Cek log**:
  ```bash
  journalctl -u drosera.service -f
  ```
- **Cek status**:
  ```bash
  sudo systemctl status drosera
  ```

**Catatan**: Jika status menunjukkan kesalahan atau tidak ada log yang ditampilkan, coba reboot VPS dengan:
```bash
sudo reboot
```

Jika Anda keluar dari sesi screen selama instalasi, kembali ke sesi dengan:
```bash
screen -r dresora
```

## 🛡️ Pemecahan Masalah

- ⚠️ **Kesalahan skrip**: Jika skrip gagal (misalnya, karena perintah yang hilang seperti `droseraup` atau `foundryup`), pastikan Anda menjalankannya di sesi screen dan periksa `PATH`:
  ```bash
  echo $PATH
  source /root/.bashrc
  ```
- 🌐 **Masalah jaringan**: Jika perintah `curl` gagal, periksa koneksi internet Anda dan coba lagi.
- 🖥️ **Masalah screen**: Jika Anda tidak dapat kembali ke sesi, daftar semua sesi dengan `screen -ls` dan pastikan sesi `dresora` aktif.

## 🤝 Dukungan
Untuk masalah atau pertanyaan, buka isu di repositori ini atau hubungi pemelihara.

🎉 Selamat menjalankan node!

---

© 2025 oleh Node Fiqul. Hak cipta dilindungi.
