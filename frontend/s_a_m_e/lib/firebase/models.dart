class Symptom {
  final String name;

  Symptom({
    required this.name,
  });

  Symptom.fromJson(Map<String, dynamic> json) : name = json['name'];
}

class Category {
  final String name;
  final List<String> symptoms;

  Category({required this.name, required this.symptoms});

  Category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        symptoms = json['symptoms'] ?? [];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class Diagnosis {
  final String name;
  final String definition;
  final List<String> symptoms;
  final List<String> signs;

  Diagnosis(
      {required this.name,
      required this.symptoms,
      required this.signs,
      required this.definition});

  Diagnosis.fromJson(Map<String, dynamic> json)
      : definition = json['definition'],
        name = json['name'],
        symptoms = json['symptoms'],
        signs = json['signs'];
}

class UserClass {
  final String email;
  String firstName;
  String lastName;
  String role;
  String? profilePicture;
  bool activeRequest;
  String requestReason;
  List<String> messages;

  UserClass({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.profilePicture,
    this.activeRequest = false,
    this.requestReason = '',
    List<String>? messages,
  }) : messages = messages ?? [];
  // {required this.email,
  // required this.firstName,
  // required this.lastName,
  // required this.role,
  // this.activeRequest = false,
  // this.requestReason = ''}

  // );

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'] ?? 'user',
      profilePicture: json['profilePicture'],
      activeRequest: json['activeRequest'] ?? false,
      requestReason: json['requestReason'] ?? '',
      messages: json['messages'] != null
          ? List<String>.from(json['messages'])
          : [], // Parse messages from JSON
    );
  }
}
