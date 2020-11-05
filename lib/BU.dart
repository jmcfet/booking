
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'BU.g.dart';


enum TimeInterval{
  @JsonValue("hour") hour,
  @JsonValue("halfHour")halfHour,
  @JsonValue("fifteenMins")fifteenMins
}
enum TypeBooking{
@JsonValue("Booked")Booked,
@JsonValue("Booking")Booking,
@JsonValue("editing")editing,
@JsonValue("Free")Free,
@JsonValue("Watered")Watered,
@JsonValue("Maintainence")Maintainence
}
@JsonSerializable()
class BU{
  int entity;
  bool bProcessed;
  bool bDoubles;
  bool bBooked;
  TimeInterval interval;
  TypeBooking type;
  int bookingStart;
  int slotNumStart;
  int numSlots;
  int num;
  List<String>  ids ;


  BU(this.entity,this.bDoubles,this.type,this.interval,this.slotNumStart,this.numSlots){
    this.bProcessed = false;
    this.num = 0;
    ids = new List<String>();
  }

  factory BU.fromJson(Map<String, dynamic> json) =>
      _$BUFromJson(json);
  Map<String, dynamic> toJson() => _$BUToJson(this);

}