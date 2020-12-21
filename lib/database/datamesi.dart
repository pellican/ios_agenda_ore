import 'package:hive/hive.dart';
part 'datamesi.g.dart';
@HiveType(typeId: 2)
class Mesi extends HiveObject{
  @HiveField(0)
  String data;
  @HiveField(1)
  String lavorato;
  @HiveField(2)
  String pagato;
  @HiveField(3)
  String resto;

  Mesi(this.data,this.lavorato,this.pagato,this.resto);


}