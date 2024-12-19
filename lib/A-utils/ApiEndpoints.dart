// ignore: file_names
class ApiEndpoints {
  // ignore: constant_identifier_names
  // static const ip_adress = '192.168.1.126';
  // ignore: constant_identifier_names
  // static const ip_adress = '192.168.1.68';

  static const ip_adress = '192.168.1.126';
  // static const ip_adress = '192.168.1.36';

//______________________________ AUTH URL'S API ______________________________
  static const userlogin = 'http://$ip_adress:1919/auth/login';
  static const profile = 'http://$ip_adress:1919/user/profile';
  static const getHistorique =
      'http://$ip_adress:1919/zakat/individual/getHistorique';
  static const setTransaction =
      'http://$ip_adress:1919/zakat/individual/setTransaction';

  static const livreurlogin = 'http://$ip_adress:1919/livreur/Login/';
  static const verif_google_login = 'http://$ip_adress:1919/Check_Google_Login';

  // ignore: non_constant_identifier_names
  final String AdminbaseUrl = 'http://$ip_adress:1919/admin';
  // ignore: constant_identifier_names
  static const String UserbaseUrl = 'http://$ip_adress:1919/';

//______________________________ IMAGE URL'S API ______________________________

  // ignore: constant_identifier_names
  static const String ImageRestaurantURL =
      "http://$ip_adress:1919/images/restaurants/";
  // ignore: constant_identifier_names
  static const String ImageMenuURL = "http://$ip_adress:1919/images/menu/";
  // ignore: constant_identifier_names
  static const String ImagesupplementURL =
      "http://$ip_adress:1919/images/supplements/";

//______________________________ GLOBAL URL'S API ______________________________
  // Restaurant-related endpoints
  static const String fetchRestaurants =
      'http://$ip_adress:1919/restaurant/FetchRestaurant';
  static const String restaurantDetails =
      'http://$ip_adress:1919/restaurant/restaurantDetails';
  static const String likerestaurant =
      'http://$ip_adress:1919/restaurant/likeRestaurant';
  static const String dislikeRestaurants =
      'http://$ip_adress:1919/restaurant/DislikeRestaurant';
  static const String checkUserLike =
      'http://$ip_adress:1919/restaurant/checkUserLike';
  // Menu-related endpoints
  static const String fetchMenuDetails =
      'http://$ip_adress:1919/menu/FetchMenuDetails';
  static const String likeMenu = 'http://$ip_adress:1919/menu/LikeMenu';
  // ignore: constant_identifier_names
  static const String DislikeMenu = 'http://$ip_adress:1919/menu/DislikeMenu';
  static const String checkUserLikeMenu =
      'http://$ip_adress:1919/menu/checkUserLike';
  static const String addItemToPanier =
      'http://$ip_adress:1919/restaurant/panier/addItemToPanier';

  static const String getUserOrdersByRestaurant =
      'http://$ip_adress:1919/restaurant/panier/getUserOrdersByRestaurant';
  static const String totalUserOrdersByRestaurant =
      'http://$ip_adress:1919/restaurant/panier/TotalUserOrdersByRestaurant';

  static const String getUserOrders =
      'http://$ip_adress:1919/restaurant/panier/getUserOrders';

  static const String deleteItem =
      'http://$ip_adress:1919/restaurant/panier/deleteItem';

  static const String updateItem =
      'http://$ip_adress:1919/restaurant/panier/updateItem';
  static const String get_restID_by_panier_item =
      'http://$ip_adress:1919/restaurant/panier/get_restID_by_panier_item';
  static const String getAllSupplement =
      'http://$ip_adress:1919/restaurant/boisson/getAllSupplement';
  // ____________________________ COMMANDE ROUTES ______________________
  static const String setCommande =
      'http://$ip_adress:1919/commande/SetCommande';
  static const String getnearbyOrders =
      'http://$ip_adress:1919/commande/getnearbyOrders';
  static const String getOderDetails =
      'http://$ip_adress:1919/commande/OderDetails';

  // __________________ Livreur routes _________________

  static const String setCurrentLocationforDelivery =
      'http://$ip_adress:1919/setCurrentLocationforDelivery';
}
