enum UserRole { owner, staff }

class RoleSettings {
  final UserRole role;

  const RoleSettings({this.role = UserRole.owner});

  RoleSettings copyWith({UserRole? role}) {
    return RoleSettings(role: role ?? this.role);
  }

  Map<String, dynamic> toMap() => {
        'role': role.name,
      };

  factory RoleSettings.fromMap(Map<String, dynamic> map) {
    return RoleSettings(
      role: map['role'] == 'staff'
          ? UserRole.staff
          : UserRole.owner,
    );
  }
}