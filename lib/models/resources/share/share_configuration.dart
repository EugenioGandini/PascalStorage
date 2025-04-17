class ShareConfiguration {
  final int quantity;
  final String timeUnit;
  final String? password;

  ShareConfiguration({
    required this.quantity,
    required this.timeUnit,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "expires": quantity.toString(),
      "unit": timeUnit.toString(),
      "password": password ?? "",
    };
  }
}
