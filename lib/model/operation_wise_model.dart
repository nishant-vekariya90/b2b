class OperationWiseModel {
  final String icon;
  final String title;
  final String? code;
  final int? rank;
  final bool? isAccess;
  final bool? isShowUI;

  OperationWiseModel({
    required this.icon,
    required this.title,
    this.code,
    this.rank,
    this.isAccess,
    this.isShowUI,
  });
}
