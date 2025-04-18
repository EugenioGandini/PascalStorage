import './time_unit.dart';

class ShareConfiguration {
  final int quantity;
  final TimeUnit timeUnit;
  final String? password;

  ShareConfiguration({
    required this.quantity,
    required this.timeUnit,
    this.password,
  });

  Map<String, dynamic> toJson() {
    var newQuantity = quantity;
    var newTimeUnit = timeUnit;

    if (timeUnit == TimeUnit.months) {
      newTimeUnit = TimeUnit.days;
      newQuantity = newQuantity * 30;
    }

    if (timeUnit == TimeUnit.years) {
      newTimeUnit = TimeUnit.days;
      newQuantity = newQuantity * 365;
    }

    return {
      "expires": newQuantity.toString(),
      "unit": newTimeUnit.name,
      "password": password ?? "",
    };
  }

  ShareConfiguration copyWith({
    int? quantity,
    TimeUnit? timeUnit,
    String? password,
  }) {
    return ShareConfiguration(
      quantity: quantity ?? this.quantity,
      timeUnit: timeUnit ?? this.timeUnit,
      password: password,
    );
  }
}
