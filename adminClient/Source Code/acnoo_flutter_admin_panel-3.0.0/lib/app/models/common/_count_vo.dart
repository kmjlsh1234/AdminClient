class CountVo{
  final int count;

  CountVo({required this.count});

  factory CountVo.fromJson(Map<String, dynamic> json){
    return CountVo(
        count: json['count']
    );
  }
}