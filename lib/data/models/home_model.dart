class HomeModel {
  final Map<String, dynamic> data;

  HomeModel({required this.data});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(data: json);
  }
}
