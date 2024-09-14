import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegisterScreen extends StatelessWidget {
  // Kullanıcı adı ve şifre kontrolcüleri
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Veritabanı yardımcısı
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  // RegisterScreen sınıfının yapıcı metodu
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar başlığı
        title: const Text(
          'Register', // Başlık metni
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Başlık rengi
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 42, 50, 54), // AppBar arka plan rengi
        elevation: 4.0, // Gölgelendirme seviyesi
        centerTitle: true, // Başlığı ortala
        actions: [
          // AppBar sağ üst köşe butonları
          IconButton(
            icon: const Icon(Icons.info_outline), // Bilgi simgesi
            onPressed: () {
              // Bilgi butonuna tıklama işlemi
            },
          ),
        ],
      ),
      body: Container(
        // Ana ekran arka planı
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 4, 82, 67),
              Color.fromARGB(255, 78, 82, 43),
            ],
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.8), // Beyaz yarı saydam arka plan
              borderRadius: BorderRadius.circular(15.0), // Kenar yarıçapı
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kayıt Ol', // Başlık metni
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 42, 50, 54), // Başlık rengi
                  ),
                ),
                const SizedBox(height: 20), // Boşluk ekleme
                // Kullanıcı adı giriş alanı
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(255, 42, 50, 54)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Şifre giriş alanı
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(255, 42, 50, 54)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true, // Şifre gizleme
                ),
                const SizedBox(height: 20), // Boşluk ekleme
                // Kayıt Ol butonu
                ElevatedButton(
                  onPressed: () async {
                    // Kullanıcı adı ve şifresi alınır
                    String username = usernameController.text;
                    String password = passwordController.text;

                    // Kullanıcı adı ve şifrenin boş olup olmadığının kontrolü yapılır
                    if (username.isNotEmpty && password.isNotEmpty) {
                      // Veritabanına kullanıcı kaydı yapılır
                      await dbHelper.registerUser(username, password);
                      // Kayıt işlemi başarılıysa, geri döner
                      Navigator.pop(context);
                    } else {
                      // Kayıt işlemi başarısızsa, hata mesajı göster
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kayıt oluşturulamadı')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 42, 50, 54), // Buton arka plan rengi
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15), // Buton iç boşlukları
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Buton kenar yarıçapı
                    ),
                  ),
                  child: const Text(
                    'Kayıt Ol', // Buton metni
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
