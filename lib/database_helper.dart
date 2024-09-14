import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Veritabanı işlemlerini yöneten yardımcı sınıf
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  // Veritabanına erişim sağlayan asenkron bir fonksiyon
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Veritabanı henüz oluşturulmadıysa, yeni bir veritabanı oluşturur
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Veritabanı dosyasının yolunu belirler
    String path = join(await getDatabasesPath(), 'recipes.db');
    // Veritabanını açar veya oluşturur
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
      // Veritabanı oluşturulurken çalışacak fonksiyon
    );
  }

  // Veritabanı oluşturulduğunda çağrılan fonksiyon
  Future<void> _createDatabase(Database db, int version) async {
    // "recipes" adında bir tablo oluşturur
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY,
        name TEXT,
        ingredients TEXT,
        instructions TEXT,
        category TEXT,
        imageUrl TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');
  }

  // Yeni bir tarifi veritabanına ekleyen fonksiyon
  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    Database db = await instance.database;
    // "recipes" tablosuna veri ekler
    return await db.insert('recipes', recipe);
  }

  // Belirli bir kategoriye ait tarifleri getiren fonksiyon
  Future<List<Map<String, dynamic>>> getRecipesByCategory(
      String category) async {
    Database db = await instance.database;
    // Belirli bir kategoriye ait tarifleri "category" sütununa göre filtreler ve getirir.
    return await db
        .query('recipes', where: 'category = ?', whereArgs: [category]);
  }

  // Veritabanına başlangıç ​​tariflerini ekleyen fonksiyon
  void addInitialRecipes() async {
    // DatabaseHelper örneği oluşturulur
    DatabaseHelper dbHelper = DatabaseHelper.instance;

    List<Map<String, dynamic>> recipes = [
      {
        'name': 'Yayla Çorbası',
        'ingredients':
            '1 fincan pirinç (Türk kahvesi fincanı), 7 su bardağı su, 1 su bardağı yoğurt, 1 yumurta, Yarım fincandan biraz fazla un (Türk kahvesi fincanı), 3 yemek kaşığı sıvı yağ, 2 yemek kaşığı tereyağı, Tuz',
        'instructions':
            'Su, sıvı yağ, tuz ve pirinçler tencereye alınır. Pirinçler yumuşayıncaya kadar kaynatılır. Ayrı bir kasede yoğurt, yumurta ve un, 1 su bardağına yakın su ile birlikte iyice çırpılır. Pirinçler yumuşayınca hızlıca karıştırarak yoğurtlu karışım çorbaya eklenir. Kaynayana kadar karıştırılır. Kaynayınca kısık ateşte 10-15 dk kaynatılır. Ara sıra karıştırmayı ihmal etmeyin. Çorbamız piştikten sonra altı kapatılır. Çorba kaselere alınır. Ayrı bir yerde tereyağı kızdırılarak nane ile karıştırılır. Ve kaselerdeki çorbaların üzerinde gezdirilir. Kalan naneli tereyağını tenceredeki çorbaya koyup karıştırın. Mis kokulu yayla çorbamız servise hazır.',
        'category': 'Çorba',
        'imageUrl':
            'https://cdn.ye-mek.net/App_UI/Img/out/650/2018/05/lokanta-usulu-yayla-corbasi-resimli-yemek-tarifi(15).jpg'
      },
      {
        'name': 'Mercimek Çorbası',
        'ingredients':
            '1 su bardağı kırmızı mercimek, 1 adet büyük boy soğan, 1 adet havuç, 1 adet patates, 1 yemek kaşığı un, 1 yemek kaşığı tereyağı, 1 yemek kaşığı domates salçası, Tuz, Karabiber, Pul biber',
        'instructions':
            'Mercimek iyice yıkanır ve tencereye alınır. Üzerine su eklenerek haşlanır. Ayrı bir tavada tereyağı eritilir ve un eklenerek kavrulur. Soğan ve diğer sebzeler doğranır ve tencereye eklenir. Sebzeler yumuşayana kadar pişirilir. Pişen sebzelerin üzerine domates salçası eklenir ve karıştırılır. Haşlanan mercimekler de tencereye eklenir. Tuz ve baharatlar eklenerek karıştırılır. Son olarak blender ile çorba pürüzsüz hale gelene kadar karıştırılır. Sıcak servis yapılır.',
        'category': 'Çorba',
        'imageUrl':
            'https://cdn.yemek.com/mncrop/940/625/uploads/2014/06/mercimek-corbasi-yemekcom.jpg'
      },
      {
        'name': 'Domates Çorbası',
        'ingredients':
            '5 adet domates, 1 adet büyük boy soğan, 2 diş sarımsak, 1 yemek kaşığı tereyağı, 1 yemek kaşığı un, 4 su bardağı su veya tavuk suyu, Tuz, Karabiber, Kıyılmış taze nane veya maydanoz (isteğe bağlı)',
        'instructions':
            'Domatesler yıkanıp kabukları soyulur ve doğranır. Soğan ve sarımsaklar ince ince doğranır. Tencerede tereyağı eritilir ve soğanlar yumuşayana kadar kavrulur. Ardından sarımsaklar eklenir ve kokusu çıkana kadar kavrulmaya devam edilir. Doğranmış domatesler tencereye eklenir ve birkaç dakika pişirilir. Üzerine su veya tavuk suyu eklenir. Tuz ve karabiber eklenerek karıştırılır. Çorba kaynamaya başlayınca altı kısılır ve yaklaşık olarak 20-25 dakika daha pişirilir. Pişen çorba ocaktan alınır ve blender veya çırpıcı ile pürüzsüz hale gelene kadar karıştırılır. Servis yapmadan önce üzerine isteğe bağlı olarak kıyılmış taze nane veya maydanoz ekleyebilirsiniz. Sıcak servis yapılır.',
        'category': 'Çorba',
        'imageUrl':
            'https://image.hurimg.com/i/hurriyet/75/750x422/5f0da1ea67b0a81050bfb21b.jpg'
      },
      {
        'name': 'İrmik Helvası',
        'ingredients':
            '1 su bardağı irmik, 1 su bardağı şeker, 1 su bardağı süt, 1 su bardağı su, 1 çay bardağı sıvı yağ, Yarım çay bardağı hindistan cevizi (isteğe bağlı)',
        'instructions':
            'İlk olarak sıvı yağ ve irmik tavaya alınıp kısık ateşte kavurulur. Üzerine şekeri ekleyip şeker eriyene kadar karıştırılır. Şeker eriyince tencere ocaktan alınıp, üzerine sıcak su ve sıcak süt eklenir. Sürekli karıştırarak pişirilir. Pişen helva, hindistan cevizi ile süslenir ve sıcak servis edilir.',
        'category': 'Tatli',
        'imageUrl':
            'https://i.nefisyemektarifleri.com/2018/09/10/birebir-olculu-nefis-irmik-helvasi-2-600x400.jpg'
      },
      {
        'name': 'Trileçe',
        'ingredients':
            '1 su bardağı irmik, 1 su bardağı un, 1 su bardağı toz şeker, 1 su bardağı süt, 1 su bardağı yoğurt, 1 su bardağı sıvı yağ, 1 paket kabartma tozu, 1 paket vanilya, 1 su bardağı hindistan cevizi, 2 su bardağı süt (trileçe sosu için), 1 kutu (360ml) tatlı kondansı, 2 yemek kaşığı toz şeker',
        'instructions':
            'Geniş bir karıştırma kabına irmik, un, toz şeker, süt, yoğurt, sıvı yağ, kabartma tozu ve vanilyayı ekleyin. Homojen bir karışım elde edene kadar iyice çırpın. Hazırladığınız karışımı yağlanmış bir fırın kabına dökün ve önceden ısıtılmış 180 derece fırında üzeri kızarana kadar pişirin. Fırından çıkardıktan sonra kekin üzerine birkaç delik açın. Diğer tarafta bir sos tenceresinde 2 su bardağı süt, tatlı kondansı ve toz şekeri karıştırarak ısının. Kaynamaya başlayınca ocaktan alın ve trileçenin üzerine dökün. Trileçenin üzeri tamamen sosla kaplanana kadar yayın. Hindistan cevizi ile süsleyin. Oda sıcaklığında soğuduktan sonra buzdolabına kaldırın ve en az 2 saat dinlendirin. Dilimleyerek servis yapın.',
        'category': 'Tatli',
        'imageUrl':
            'https://yalovasutlusu.com/wp-content/uploads/2021/02/t25_0903202002cbc251-600x337.jpg'
      },
      {
        'name': 'Revani',
        'ingredients':
            '3 adet yumurta, 1 su bardağı toz şeker, 1 su bardağı irmik, 1 su bardağı un, 1 su bardağı süt, 1 su bardağı sıvı yağ, 1 paket kabartma tozu, Yarım limonun suyu',
        'instructions':
            'Bir karıştırma kabında yumurta ve toz şekeri mikser ile iyice çırpın. Ardından irmik, un, süt, sıvı yağ, kabartma tozu ve limon suyunu ekleyip homojen bir karışım elde edene kadar çırpın. Hazırladığınız karışımı yağlanmış bir fırın kabına dökün. Önceden ısıtılmış 180 derece fırında üzeri kızarana kadar pişirin. Fırından çıkardıktan sonra soğuması için bekletin. Soğuyan revaniyi dilimleyerek servis yapın. Üzerine isteğe bağlı olarak pudra şekeri serpebilirsiniz.',
        'category': 'Tatli',
        'imageUrl':
            'https://iasbh.tmgrup.com.tr/c1258e/821/464/0/0/1274/720?u=https://isbh.tmgrup.com.tr/sbh/2021/10/21/revani-tatlisi-tarifi-puf-noktalari-ile-lezzetli-ve-nefis-revani-nasil-yapilir-1634824035579.jpg'
      },
      {
        'name': 'Mevsim Salatası',
        'ingredients':
            '1 adet marul, 2 adet domates, 1 adet salatalık, 1 adet havuç, 1 adet kırmızı biber, 1 adet yeşil biber, 1/2 demet taze maydanoz, 1/2 demet taze dereotu, 1/2 limonun suyu, 3 yemek kaşığı zeytinyağı, Tuz, Karabiber',
        'instructions':
            'Marul yaprakları iyice yıkanıp süzülür ve geniş bir salata kabına alınır. Domatesler ve salatalık doğranır ve marulun üzerine eklenir. Havuç rendelenir ve salataya eklenir. Kırmızı biber ve yeşil biber doğranarak salataya katılır. Taze maydanoz ve dereotu ince doğranır ve diğer malzemelerin üzerine serpiştirilir. Limon suyu, zeytinyağı, tuz ve karabiber bir kasede karıştırılır ve salatanın üzerine dökülür. Salata servis edilmeden önce hafifçe karıştırılır. Dilimlenmiş ekmeğin yanında servis yapılır.',
        'category': 'Salata',
        'imageUrl':
            'https://tasdelenkebap.com.tr/uploads/images/category_coban-salata_63cfba0e347f4.webp'
      },
      {
        'name': 'Akdeniz Salatası',
        'ingredients':
            '1 adet marul, 2 adet salatalık, 2 adet domates, 1 adet kırmızı biber, 1 adet yeşil biber, 1/2 demet taze nane, 1/2 demet taze kişniş, 1/4 su bardağı zeytinyağı, 2 yemek kaşığı limon suyu, Tuz, Karabiber',
        'instructions':
            'Marul yaprakları yıkanıp doğranır ve salata kasesine alınır. Salatalıklar ve domatesler dilimlenir ve marulun üzerine eklenir. Kırmızı biber ve yeşil biber doğranarak salataya katılır. Taze nane ve kişniş ince doğranır ve diğer malzemelerin üzerine serpiştirilir. Ayrı bir kapta zeytinyağı, limon suyu, tuz ve karabiber karıştırılarak salatanın üzerine dökülür. Salata servis edilmeden önce hafifçe karıştırılır. Yanında zeytinyağı ve limon ile servis yapılır.',
        'category': 'Salata',
        'imageUrl':
            'https://d17wu0fn6x6rgz.cloudfront.net/img/w/tarif/ogt/beyaz-peynirli-akdeniz-salatasi.webp'
      },
      {
        'name': 'Cevizli Roka Salatası',
        'ingredients':
            '1 demet taze roka, 1 su bardağı ceviz içi, 100 gram beyaz peynir, 2 yemek kaşığı nar ekşisi, 3 yemek kaşığı zeytinyağı, Tuz',
        'instructions':
            'Taze roka yaprakları iyice yıkanıp süzülür ve servis tabağına alınır. Üzerine ceviz içi ve ufalanmış beyaz peynir serpilir. Ayrı bir kapta nar ekşisi, zeytinyağı ve tuz karıştırılarak sos hazırlanır. Hazırlanan sos salatanın üzerine dökülür. Salata servis edilmeden önce hafifçe karıştırılır. Dilimlenmiş ekmeğin yanında servis yapılır.',
        'category': 'Salata',
        'imageUrl':
            'https://i.nefisyemektarifleri.com/2018/05/04/cevizli-roka-salatasi-3.jpg'
      },
    ];

    // Tarifleri veritabanına ekleyelim
    for (var recipe in recipes) {
      await dbHelper.insertRecipe(recipe);
    }

    // print('Initial recipes added to the database.');
  }

  // Belirli bir kategoriye göre tarifleri getiren fonksiyon
  Future<List<Map<String, dynamic>>> getDessertRecipes(var categoryName) async {
    Database db = await instance.database;
    return await db
        .query('recipes', where: 'category = ?', whereArgs: [categoryName]);
  }

// Tüm veritabanı kayıtlarını silen fonksiyon
  Future<int> getRemoveAll() async {
    Database db = await instance.database;
    // "recipes" tablosundaki tüm verileri siler
    return await db.delete("recipes");
  }

  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db
        .insert('users', {'username': username, 'password': password});
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
