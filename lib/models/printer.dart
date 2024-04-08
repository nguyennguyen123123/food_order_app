import 'package:json_annotation/json_annotation.dart';

part 'printer.g.dart';

@JsonSerializable()
class Printer {
  final String? id;
  final String? name;
  final String? ip;
  final String? port;

  Printer({
    this.id,
    this.name,
    this.ip,
    this.port,
  });

  Map<String, dynamic> toJson() => _$PrinterToJson(this);

  Map toMap(Printer food) => _$PrinterToJson(this);

  factory Printer.fromJson(Map<String, dynamic> json) => _$PrinterFromJson(json);
}
