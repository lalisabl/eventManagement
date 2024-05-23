// ProfileModel.dart
class ProfileModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  // Add other profile attributes as needed

  ProfileModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

