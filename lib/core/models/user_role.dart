enum UserRole {
  superAdmin,
  admin,
  regionalManager,
  areaManager,
  mr;

  String get label {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.admin:
        return 'Admin';
      case UserRole.regionalManager:
        return 'Regional Manager';
      case UserRole.areaManager:
        return 'Area Manager';
      case UserRole.mr:
        return 'Medical Representative';
    }
  }

  bool get isAdmin => this == superAdmin || this == admin;

  bool get isManager =>
      this == superAdmin ||
      this == admin ||
      this == regionalManager ||
      this == areaManager;

  bool get canApprove => this != mr;

  bool get canManageUsers => isAdmin;

  bool get canManageProducts => isAdmin;

  bool get canManageTerritories => isAdmin;

  bool get canViewAllReports => this != mr;

  bool get canAssignTargets =>
      this == superAdmin || this == admin || this == regionalManager;

  bool get canCreateCampaigns =>
      this == superAdmin || this == admin || this == regionalManager;

  bool get canAllocateSamples =>
      this == superAdmin || this == admin || this == regionalManager;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value,
      orElse: () => UserRole.mr,
    );
  }
}
