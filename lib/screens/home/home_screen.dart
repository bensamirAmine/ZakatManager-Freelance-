import 'package:flutter/material.dart';
import 'package:foodly_ui/A-providers/UserProvider.dart';
import 'package:foodly_ui/A-providers/ZakatProvider.dart';
import 'package:foodly_ui/screens/auth/sign_in_screen.dart';
import 'package:foodly_ui/screens/home/TransactionHistory.dart';
import 'package:foodly_ui/screens/home/UserAssetDisplay.dart';
import 'package:foodly_ui/screens/home/ZakatCarousel.dart';
import 'package:foodly_ui/screens/home/ZakatcalculatorPage.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int notificationCount = 3;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _userProvider = Provider.of<UserProvider>(context, listen: false);
      final _zakatProvider = Provider.of<ZakatProvider>(context, listen: false);

      _userProvider.loadUser(
        context,
      );
      _zakatProvider.recalculateTotals(
        context,
      );
    });
    ;
    super.initState();
  }

  Future<void> _refreshPage() async {
    await Future.delayed(const Duration(seconds: 1));
    final zakatProvider = Provider.of<ZakatProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser(context);
    await zakatProvider.recalculateTotals(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final _user = context.watch<UserProvider?>()?.user!;

    final userprovider = Provider.of<UserProvider>(context);

    final _user = userprovider.user;
    if (_user == null) {
      return Center(child: CircularProgressIndicator());
    }

    final total = _user.zakatAmount ?? 0.0;

    DateTime? nissabDate = _user.NissabAcquisitionDate; // Vérifiez sa nullité
    DateTime? zakatDueDate;
    if (nissabDate != null) {
      zakatDueDate = nissabDate.add(Duration(days: 365));
    } else {
      // Gérez le cas où la date d'acquisition est absente
      zakatDueDate =
          DateTime.now().add(Duration(days: 365)); // Exemple par défaut
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: primaryColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Column(
          children: [
            Text(
              "Zakat".toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: primaryColor),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Action lorsque l'icône est pressée
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: 35,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Adding the Drawer here
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: thirdColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Text(
                            _user.lastName + "  " + _user.firstName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Icon(Icons.email),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _user.email,
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Icon(Icons.phone),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        _user.phoneNumber,
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                // final SharedPreferences prefs =
                //     SharedPreferences.getInstance() as SharedPreferences;

                // prefs.remove('auth_token');

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SingleChildScrollView(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserRowWidget(
                    // imageUrl: 'assets/images/logo2.png',
                    userName: _user.firstName,
                  ),
                  Divider(
                    color: titleColor,
                    thickness: 0.3,
                    indent: 20,
                    endIndent: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " تمت مطابقة معايير محاسبة الزكاة من قبل هيئة شرعية متخصصة",
                        style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.add_alert,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  if (_user.zakatCalculated)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: thirdColor,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.all(16.0), // Padding interne
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Aligner à gauche
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.timer_outlined, // Icône calendrier
                                    color: inputColor,
                                    size: 25,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Your Zakat will be due on ${zakatDueDate.day}-${zakatDueDate.month}-${zakatDueDate.year}.",
                                    style: TextStyle(
                                      color: inputColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8), // Espacement vertical
                              Text(
                                _calculateRemainingTime(zakatDueDate),
                                style: TextStyle(
                                  color: Colors.grey[100],
                                  fontSize: 16,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Total To Pay  =  ${total / 40}.DT",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Center(
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: inputColor, // Fond complètement transparent
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: primaryColor, // Contour noir
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: inputColor.withOpacity(0.2), // Ombre douce
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header (Logo et titre)
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: textColor,
                                size: 40,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Your Wallet",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              // Icône de menu ou paramètre
                              Icon(
                                Icons.more_vert,
                                color: primaryColor,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          // Total montant
                          Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.bounceInOut,
                                child: Text(
                                  // ignore: unnecessary_null_comparison
                                  total != null
                                      ? "$total"
                                      : "Zakat Amount not provided",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Total Balance",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Zone de statistiques (avec graphique)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _statisticWidget(
                                  "Cash",
                                  Color.fromARGB(255, 240, 224, 105),
                                  FontAwesomeIcons.dollar),
                              _statisticWidget("Gold", Colors.orangeAccent,
                                  FontAwesomeIcons.coins),
                              _statisticWidget("Other", Colors.redAccent,
                                  FontAwesomeIcons.box),
                            ],
                          ),
                          // const SizedBox(height: 20),
                          UserAssetDisplay(user: _user),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 170, // Ajustez la hauteur si nécessaire
                    child: ZakatCalculator(),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 400, // Ajustez la hauteur si nécessaire
                      child: TransactionHistory(),
                    ),
                  ),
                  ZakatCarousel(),
                  Divider(
                    color: primaryColor,
                    thickness: 0.3,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Afficher le Bottom Sheet
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sélectionnez une organisation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: organizations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.business, color: thirdColor),
                          title: Text(organizations[index]),
                          trailing: Icon(Icons.handshake_outlined,
                              color: primaryColor, size: 20),
                          onTap: () {
                            Navigator.pop(context); // Fermer le Bottom Sheet
                            // Action à effectuer lors de la sélection
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Vous avez choisi : ${organizations[index]}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.hail_rounded,
          color: Colors.white,
        ),
        backgroundColor: primaryColor,
      ),
    );
  }
}

String _calculateRemainingTime(DateTime? zakatDueDate) {
  if (zakatDueDate == null) {
    return "La date limite de votre Zakat n'est pas définie.";
  }

  final now = DateTime.now(); // Date actuelle
  final difference =
      zakatDueDate.difference(now); // Différence entre les deux dates

  if (difference.isNegative) {
    return "Le délai pour payer votre Zakat est dépassé.";
  }

  final days = difference.inDays;
  final hours = difference.inHours % 24;
  final minutes = difference.inMinutes % 60;

  // Construire un message clair
  if (days > 0) {
    return "Il reste $days jour${days > 1 ? 's' : ''} et $hours heure${hours > 1 ? 's' : ''} avant la date de paiement.";
  } else if (hours > 0) {
    return "Il reste $hours heure${hours > 1 ? 's' : ''} et $minutes minute${minutes > 1 ? 's' : ''} avant la date de paiement.";
  } else {
    return "Il reste $minutes minute${minutes > 1 ? 's' : ''} avant la date de paiement.";
  }
}

class UserRowWidget extends StatelessWidget {
  final String userName;

  UserRowWidget({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const SizedBox(
            width: 5,
          ),
          Icon(Icons.account_box_rounded, color: primaryColor, size: 35),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              userName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "Nissab : 19,000 DT",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: titleColor, fontSize: 15),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}

Widget _statisticWidget(String title, Color color, IconData icon) {
  return Column(
    children: [
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: textColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            color: inputColor,
          ),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    ],
  );
}
