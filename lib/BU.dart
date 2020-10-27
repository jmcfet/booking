enum TimeInterval{
  hour,
  halfHour,
  fifteenMins
}
enum TypeBooking{
  Booked,
  Booking,
  editing,
  Free,
  Watered,
  Maintainence
}
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
   Map<int, String> ids ;
   set idvalues (Map<int, String> ids){
     this.ids  =  ids;
   }
  BU(this.entity,this.bDoubles,this.type,this.interval,this.slotNumStart,this.numSlots){
    this.bProcessed = false;
    this.num = 0;
    ids = {0: '', 1: '', 2: '',3:''};
  }



}