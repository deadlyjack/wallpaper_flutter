extension StringExtension on String{
  String capitalize([int index = 0]){
    final String start = index == 0 ? '' : this.substring(0, index-1);
    final String middle = this[index].toUpperCase();
    final String end = this.substring(index+1);
    return "$start$middle$end";
  }
}