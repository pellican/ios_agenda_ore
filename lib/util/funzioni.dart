class Zero {
  static String zeroTime(int ora,int min){
    String o,m;
    if (ora.toString().length== 1)  o = "0"+ora.toString();
    else o = ora.toString();
    if (min.toString().length== 1)  m = "0"+min.toString();
    else m = min.toString();
    return o+":"+m;
  }
}