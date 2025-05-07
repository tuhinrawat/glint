class GangMember {
  final String name;
  final int age;
  final String gender;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  GangMember({
    required this.name,
    required this.age,
    required this.gender,
    this.email,
    this.phone,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'gender': gender,
    'email': email,
    'phone': phone,
    'avatarUrl': avatarUrl,
  };

  factory GangMember.fromJson(Map<String, dynamic> json) => GangMember(
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    email: json['email'],
    phone: json['phone'],
    avatarUrl: json['avatarUrl'],
  );
}

class Gang {
  final String id;
  final String name;
  final List<GangMember> members;

  Gang({
    required this.id,
    required this.name,
    required this.members,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'members': members.map((m) => m.toJson()).toList(),
  };

  factory Gang.fromJson(Map<String, dynamic> json) => Gang(
    id: json['id'],
    name: json['name'],
    members: (json['members'] as List).map((m) => GangMember.fromJson(m)).toList(),
  );
} 