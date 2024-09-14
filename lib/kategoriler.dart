import 'package:flutter/material.dart';
import 'tatlilar.dart';
import 'corbalar.dart';
import 'salata.dart';

class Kategoriler extends StatelessWidget {
  final String userName;

  const Kategoriler({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leziz Tarifler',
          style: TextStyle(
            color: Color.fromARGB(255, 131, 161, 180), // Başlık metni rengi
          ),
        ),
        backgroundColor:
            const Color.fromARGB(255, 63, 137, 167), // AppBar arka plan rengi
        actions: [
          // Kullanıcı adını sağ tarafa ekler
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Text(
              userName
                  .toUpperCase(), // Kullanıcı adını büyük harflerle gösterir
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        // Arka plan için gradyan renkleri
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 202, 218, 231), // Üst sağ köşe rengi
              Color.fromARGB(255, 135, 134, 134), // Alt sol köşe rengi
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Kategori resmini gösteren container
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/resim2.bmp'), // Resim dosyasının yolu.
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 66, 35, 35),
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(
                  height: 10), // Buton ve resim arasında boşluk bırakır.
              ElevatedButton(
                onPressed: () {
                  // Çorba kategorisine gider
                  // Burada butona basıldığında gerçekleşecek işlemler yazar.
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CorbaTarifleriSayfasi()));
                },
                child: const Text('Çorbalar'),
              ),
              const SizedBox(height: 10), // İki buton arasında boşluk bırakır.
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/resim3.bmp'), // Resim dosyasının yolu.
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 122, 121, 121),
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(
                  height: 10), // Buton ve resim arasında boşluk bırakır.
              ElevatedButton(
                onPressed: () {
                  // Salata kategorisine gider.
                  // Burada butona basıldığında gerçekleşecek işlemleri yazar.
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SalataTarifleriSayfasi()));
                },
                child: const Text('Salatalar'),
              ),
              const SizedBox(
                  height: 10), // Buton ve resim arasında boşluk bırakır.
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/resim1.bmp'), // Tatlılar kategorisine ait resim
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: const Color.fromARGB(255, 75, 158, 210),
                    width: 2,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Tatlılar kategorisine gider
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TatliTarifleriSayfasi()));
                },
                child: const Text('Tatlılar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
