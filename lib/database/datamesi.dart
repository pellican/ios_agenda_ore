import 'package:hive/hive.dart';
part 'datamesi.g.dart';
@HiveType(typeId: 2)
class Mesi extends HiveObject{
  @HiveField(0)
  String anno;
  @HiveField(1)
  int ore;
  @HiveField(2)
  int min;
  @HiveField(3)
  String pagato;
  @HiveField(4)
  String resto;

  Mesi(this.anno,this.ore,this.min,this.pagato,this.resto);


}