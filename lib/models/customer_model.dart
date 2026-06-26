class CustomerModel {

  String name;

  double pending;

  bool isFavourite;

  /// ⭐ Favourite भाज्या + qty + unit
  List<Map<String, dynamic>> defaultVegList;

  // ================= DATE =================

  DateTime addedDate;

  DateTime? editedDate;

  DateTime? selectedDate;

  CustomerModel({

    required this.name,

    required this.pending,

    this.isFavourite = false,

    List<Map<String, dynamic>>? defaultVegList,

    required this.addedDate,

    this.editedDate,

    this.selectedDate,

  }) : defaultVegList = defaultVegList ?? [];

  // ================= TO MAP =================

  Map<String, dynamic> toMap() {

    return {

      'name': name,

      'pending': pending,

      'isFavourite': isFavourite,

      'defaultVegList': defaultVegList,

      'addedDate':
          addedDate.toIso8601String(),

      'editedDate':
          editedDate?.toIso8601String(),

      'selectedDate':
          selectedDate?.toIso8601String(),
    };
  }

  // ================= FROM MAP =================

  factory CustomerModel.fromMap(
    Map<String, dynamic> map,
  ) {

    return CustomerModel(

      name: map['name'] ?? '',

      pending:
          (map['pending'] ?? 0)
              .toDouble(),

      isFavourite:
          map['isFavourite'] ?? false,

      defaultVegList:
          List<Map<String, dynamic>>.from(
            map['defaultVegList'] ?? [],
          ),

      addedDate:
          DateTime.tryParse(
                map['addedDate'] ?? '',
              ) ??
              DateTime.now(),

      editedDate:
          map['editedDate'] != null
              ? DateTime.tryParse(
                  map['editedDate'],
                )
              : null,

      selectedDate:
          map['selectedDate'] != null
              ? DateTime.tryParse(
                  map['selectedDate'],
                )
              : null,
    );
  }
}