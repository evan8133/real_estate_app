class Place {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String placeId;
  final String type;

  Place({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.placeId,
    required this.type,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      type: json['types'][0],
      address: json['vicinity'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      placeId: json['place_id'],
    );
  }
}
