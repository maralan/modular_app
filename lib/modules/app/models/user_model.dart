class AppUser {
  final String uid;
  final String email;
  final String? name;
  final String? birthDate;
  final String? gender;
  final String? civilStatus;
  final String? provider;
  final String? photoUrl;
  final String? createdAt;

  AppUser({
    required this.uid,
    required this.email,
    this.name,
    this.birthDate,
    this.gender,
    this.civilStatus,
    this.provider,
    this.photoUrl,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'civilStatus': civilStatus,
      'provider': provider,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'], 
      email: map['email'],
      name: map['name'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      civilStatus: map['civilStatus'],
      provider: map['provider'],
      photoUrl: map['photoUrl'],
      createdAt: map['createdAt'],
    );
  }
}