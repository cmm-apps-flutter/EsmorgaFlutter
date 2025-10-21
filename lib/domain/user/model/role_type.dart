enum RoleType {
  user,
  admin,
}

extension RoleTypeExtension on RoleType {
  static RoleType fromString(String value) {
    try {
      switch (value.toUpperCase()) {
        case 'ADMIN':
          return RoleType.admin;
        case 'USER':
        default:
          return RoleType.user;
      }
    } catch (e) {
      return RoleType.user;
    }
  }

  String toJson() {
    switch (this) {
      case RoleType.admin:
        return 'ADMIN';
      case RoleType.user:
        return 'USER';
    }
  }
}

