import 'package:hive/hive.dart';
part 'giornate.g.dart';

@HiveType(typeId: 1)
class Giornate extends HiveObject{
  @HiveField(0)
  String data;
  @HiveField(1)
  String inizio;
  @HiveField(2)
  String pausa_m;
  @HiveField(3)
  String fine_m;
  @HiveField(4)
  String inizio_p;
  @HiveField(5)
  String pausa_p;
  @HiveField(6)
  String fine;
  @HiveField(7)
  String totale;

  Giornate( this.data, this.inizio, this.pausa_m, this.fine_m,
    this.inizio_p, this.pausa_p, this.fine, this.totale);
}
