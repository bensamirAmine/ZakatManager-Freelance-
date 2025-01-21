class User {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String? address;
  final DateTime? birthdate;
  final String avatar;
  final String? about;
  final bool banned;
  final bool etatDelete;
  final bool verified;
  final String role;
  final double? balance;
  final double? goldWeight;
  final double? goldPricePerGram;
  final bool zakatCalculated;
  final double? zakatAmount;
  final DateTime? NissabAcquisitionDate;
  final List<dynamic> transactionHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.address,
    this.birthdate,
    this.avatar = 'defaultAvatar.png',
    this.about,
    this.banned = false,
    this.etatDelete = false,
    this.verified = false,
    this.role = 'USER',
    this.balance = 0.0,
    this.goldWeight,
    this.goldPricePerGram,
    this.zakatCalculated = false,
    this.zakatAmount,
    this.NissabAcquisitionDate,
    this.transactionHistory = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      userName: json['userName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      address: json['address'] as String?,
      birthdate:
          json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      avatar: json['avatar'] as String? ?? 'defaultAvatar.png',
      about: json['about'] as String?,
      banned: json['banned'] as bool? ?? false,
      etatDelete: json['etatDelete'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
      role: json['role'] as String? ?? 'USER',
      balance: (json['balance'] as num?)?.toDouble(),
      goldWeight: (json['goldWeight'] as num?)?.toDouble(),
      goldPricePerGram: (json['goldPricePerGram'] as num?)?.toDouble(),
      zakatCalculated: json['zakatCalculated'] as bool? ?? false,
      zakatAmount: (json['zakatAmount'] as num?)?.toDouble(),
      NissabAcquisitionDate: json['NissabAcquisitionDate'] != null
          ? DateTime.parse(json['NissabAcquisitionDate'])
          : null,
      transactionHistory: json['transactionHistory'] as List<dynamic>? ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'address': address,
      'birthdate': birthdate?.toIso8601String(),
      'avatar': avatar,
      'about': about,
      'banned': banned,
      'etatDelete': etatDelete,
      'verified': verified,
      'role': role,
      'balance': balance,
      'goldWeight': goldWeight,
      'goldPricePerGram': goldPricePerGram,
      'zakatCalculated': zakatCalculated,
      'NissabAcquisitionDate': NissabAcquisitionDate,
      'zakatAmount': zakatAmount,
      'transactionHistory': transactionHistory,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
