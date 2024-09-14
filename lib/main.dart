import 'package:flutter/material.dart';
import 'package:gozdetarifler/database_helper.dart';
import 'package:gozdetarifler/register_screen.dart';
import 'package:gozdetarifler/kategoriler.dart'; // Kategoriler sayfasının import edilmesi

void main() {
  // Flutter uygulamasının başlatılması için gerekli olan bağlamın başlatılması
  WidgetsFlutterBinding.ensureInitialized();
  // Veritabanı yardımcı sınıfının örneği oluşturulur
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  // Veritabanındaki tüm verilerin kaldırılması
  databaseHelper.getRemoveAll();
  // Başlangıç tariflerinin veritabanına eklenmesi
  databaseHelper.addInitialRecipes();
  // Uygulamanın başlatılması
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ana uygulama bileşeninin oluşturulması
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Kullanıcı adı ve şifre kontrolcüleri
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Veritabanı yardımcısı
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    // Ana bileşenin oluşturulması
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tariflere Git',
          style: TextStyle(
            color: Color.fromARGB(255, 236, 233, 232),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 170, 179, 175),
      ),
      body: Container(
        // Arka plan resminin eklenmesi
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/resim5.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Başlık metni
              const Text(
                'Gözde Tarifler',
                style: TextStyle(
                  fontFamily: 'baslikFont',
                  fontSize: 60,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 71, 50, 43),
                ),
              ),
              const SizedBox(height: 20),
              // Kullanıcı adı giriş alanı
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 42, 33, 30),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide(width: 2)),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide(width: 4)),
                ),
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 25,
                ),
              ),
              // Şifre giriş alanı
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Şifre',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 42, 33, 30),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide(width: 2)),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide(width: 4)),
                ),
                obscureText: true,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const SizedBox(height: 20),
              // Giriş yap butonu
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String password = passwordController.text;

                  var user = await dbHelper.loginUser(username, password);
                  if (user != null) {
                    // Giriş başarılı, kategoriler sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Kategoriler(userName: username),
                      ),
                    );
                  } else {
                    // Giriş başarısız, hata mesajı gösterme
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Giriş yapılamadı')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 170, 179, 175),
                  elevation: 5,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Giriş Yap',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              // Kayıt ol butonu
              TextButton(
                onPressed: () async {
                  // Kayıt ol sayfasına yönlendirme
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
