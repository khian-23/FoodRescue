class FoodListingModel {
  FoodListingModel({
    required this.id,
    required this.ownerUid,
    required this.ownerName,
    required this.title,
    required this.description,
    required this.quantity,
    required this.pickupLocation,
    required this.availableUntil,
    required this.status,
    required this.claimedByUid,
    required this.claimedByName,
  });

  final String id;
  final String ownerUid;
  final String ownerName;
  final String title;
  final String description;
  final String quantity;
  final String pickupLocation;
  final String availableUntil;
  final String status;
  final String claimedByUid;
  final String claimedByName;

  factory FoodListingModel.fromMap(Map<String, dynamic> map) {
    return FoodListingModel(
      id: map['id'] as String? ?? '',
      ownerUid: map['ownerUid'] as String? ?? '',
      ownerName: map['ownerName'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      quantity: map['quantity'] as String? ?? '',
      pickupLocation: map['pickupLocation'] as String? ?? '',
      availableUntil: map['availableUntil'] as String? ?? '',
      status: map['status'] as String? ?? 'open',
      claimedByUid: map['claimedByUid'] as String? ?? '',
      claimedByName: map['claimedByName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerUid': ownerUid,
      'ownerName': ownerName,
      'title': title,
      'description': description,
      'quantity': quantity,
      'pickupLocation': pickupLocation,
      'availableUntil': availableUntil,
      'status': status,
      'claimedByUid': claimedByUid,
      'claimedByName': claimedByName,
    };
  }

  FoodListingModel copyWith({
    String? id,
    String? ownerUid,
    String? ownerName,
    String? title,
    String? description,
    String? quantity,
    String? pickupLocation,
    String? availableUntil,
    String? status,
    String? claimedByUid,
    String? claimedByName,
  }) {
    return FoodListingModel(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      ownerName: ownerName ?? this.ownerName,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      availableUntil: availableUntil ?? this.availableUntil,
      status: status ?? this.status,
      claimedByUid: claimedByUid ?? this.claimedByUid,
      claimedByName: claimedByName ?? this.claimedByName,
    );
  }
}
