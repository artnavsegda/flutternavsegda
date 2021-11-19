class GraphAuthResult {}

class GraphClientResult {}

class GraphTokenResult {}

class GraphBasisResult {}

class GraphPromocodeResult {}

class GraphPollResult {}

class GraphSupportResult {}

class GraphCartCharacteristic {
  GraphCartCharacteristic({
    required this.type,
    required this.name,
    required this.value,
  });
  String? type;
  String name;
  String value;

  GraphCartCharacteristic.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        name = json['name'],
        value = json['value'];
}

class GraphCartRow {
  GraphCartRow({
    required this.rowID,
    required this.productID,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.oldAmount,
    required this.modifiers,
    required this.comment,
    required this.picture,
    required this.message,
    required this.typeMessage,
    required this.characteristics,
  });
  int rowID;
  int productID;
  String productName;
  int quantity;
  double amount;
  double? oldAmount;
  String? modifiers;
  String? comment;
  String? picture;
  String? message;
  String? typeMessage;
  List<GraphCartCharacteristic> characteristics;

  GraphCartRow.fromJson(Map<String, dynamic> json)
      : rowID = json['rowID'],
        productID = json['productID'],
        productName = json['productName'],
        quantity = json['quantity'],
        amount = json['amount'],
        oldAmount = json['oldAmount'],
        modifiers = json['modifiers'],
        comment = json['comment'],
        picture = json['picture'],
        message = json['message'],
        typeMessage = json['typeMessage'],
        characteristics = List<GraphCartCharacteristic>.from(
            json['characteristics']
                .map((model) => GraphCartCharacteristic.fromJson(model)));
}

class GraphFilterGroup {
  GraphFilterGroup({
    required this.iD,
    this.values = const <int>{},
  });

  GraphFilterGroup.from(GraphFilterGroup original) {
    iD = original.iD;
    values = Set<int>.from(original.values);
  }

  late int iD;
  Set<int> values = <int>{};

  Map<String, dynamic> toJson() => {
        'iD': iD,
        'values': values.toList(),
      };
}

class GraphFilter {
  GraphFilter({
    this.priceMin = 0,
    this.priceMax = 0,
    this.groups = const <int, GraphFilterGroup>{},
  });

  GraphFilter.from(GraphFilter original) {
    priceMin = original.priceMin;
    priceMax = original.priceMax;
    groups = Map<int, GraphFilterGroup>.from(original.groups);
  }

  int priceMin = 0;
  int priceMax = 0;
  Map<int, GraphFilterGroup> groups = const <int, GraphFilterGroup>{};

  Map<String, dynamic> toJson() => {
        'priceMin': priceMin,
        'priceMax': priceMax,
        'groups': groups.entries.map((e) => e.value).toList()
      };
}

class GraphFilterValueView {
  GraphFilterValueView({
    required this.iD,
    required this.name,
  });
  int iD;
  String name;

  GraphFilterValueView.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'];
}

class GraphFilterGroupView {
  GraphFilterGroupView({
    required this.iD,
    required this.name,
    this.type,
    required this.values,
  });
  int iD;
  String name;
  String? type;
  List<GraphFilterValueView> values;

  GraphFilterGroupView.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        type = json['type'],
        values = List<GraphFilterValueView>.from(json['values']
            .map((model) => GraphFilterValueView.fromJson(model)));
}

class GraphFilterView {
  GraphFilterView({
    this.priceMin,
    this.priceMax,
    required this.groups,
  });
  int? priceMin;
  int? priceMax;
  List<GraphFilterGroupView> groups;

  GraphFilterView.fromJson(Map<String, dynamic> json)
      : priceMin = json['priceMin'],
        priceMax = json['priceMax'],
        groups = List<GraphFilterGroupView>.from(json['groups']
            .map((model) => GraphFilterGroupView.fromJson(model)));
}

class GraphConfiguratorItem {
  GraphConfiguratorItem({
    required this.iD,
    required this.name,
    this.picture,
  });
  int iD;
  String name;
  String? picture;

  GraphConfiguratorItem.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        picture = json['picture'];
}

class GraphConfiguratorStep {
  GraphConfiguratorStep({
    required this.iD,
    this.type,
    required this.name,
    this.description,
    required this.values,
  });
  int iD;
  String? type;
  String name;
  String? description;
  List<GraphConfiguratorItem> values;

  GraphConfiguratorStep.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        name = json['name'],
        description = json['description'],
        values = List<GraphConfiguratorItem>.from(json['values']
            .map((model) => GraphConfiguratorItem.fromJson(model)));
}

class PageInfo {
  PageInfo({
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });
  bool hasNextPage;
  bool hasPreviousPage;
  String? startCursor;
  String? endCursor;

  PageInfo.fromJson(Map<String, dynamic> json)
      : hasNextPage = json['hasNextPage'],
        hasPreviousPage = json['hasPreviousPage'],
        startCursor = json['startCursor'],
        endCursor = json['endCursor'];
}

class GraphProductEdge {
  GraphProductEdge({
    required this.cursor,
    required this.node,
  });
  String cursor;
  GraphProduct node;

  GraphProductEdge.fromJson(Map<String, dynamic> json)
      : cursor = json['cursor'],
        node = GraphProduct.fromJson(json['node']);
}

class GraphProductConnection {
  GraphProductConnection({
    this.totalCount,
    required this.pageInfo,
    required this.edges,
    required this.items,
  });
  int? totalCount;
  PageInfo pageInfo;
  List<GraphProductEdge>? edges;
  List<GraphProduct> items;

  GraphProductConnection.fromJson(Map<String, dynamic> json)
      : totalCount = json['totalCount'],
        pageInfo = PageInfo.fromJson(json['pageInfo']),
        edges = json['edges'] != null
            ? List<GraphProductEdge>.from(
                json['edges'].map((model) => GraphProductEdge.fromJson(model)))
            : null,
        items = List<GraphProduct>.from(
            json['items'].map((model) => GraphProduct.fromJson(model)));
}

class GraphPollAnswer {
  GraphPollAnswer({
    required this.iD,
    required this.name,
  });
  int iD;
  String name;
  GraphPollAnswer.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'];
}

class GraphPoll {
  GraphPoll({
    required this.iD,
    required this.name,
    this.comment,
    required this.isOther,
    required this.isSkip,
    required this.isMultiple,
    required this.isScale,
    this.scaleMin,
    this.scaleMax,
    required this.pollAnswers,
  });
  int iD;
  String name;
  String? comment;
  bool isOther;
  bool isSkip;
  bool isMultiple;
  bool isScale;
  int? scaleMin;
  int? scaleMax;
  List<GraphPollAnswer> pollAnswers;

  GraphPoll.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        comment = json['comment'],
        isOther = json['isOther'],
        isSkip = json['isSkip'],
        isMultiple = json['isMultiple'],
        isScale = json['isScale'],
        scaleMin = json['scaleMin'],
        scaleMax = json['scaleMax'],
        pollAnswers = List<GraphPollAnswer>.from(json['pollAnswers']
            .map((model) => GraphPollAnswer.fromJson(model)));
}

class PollAnswersClient {
  PollAnswersClient({
    this.scale = 0,
    this.pollAnswers = const <int>{},
    this.other = "",
    required this.pollID,
  });
  int scale;
  Set<int> pollAnswers;
  String other;
  int pollID;

  Map<String, dynamic> toJson() => {
        'pollID': pollID,
        'pollAnswers': pollAnswers.toList(),
        'other': other,
        'scale': scale,
      };
}

class GraphTopBlock {
  GraphTopBlock({
    required this.iD,
    required this.name,
    required this.products,
  });
  int iD;
  String name;
  List<GraphProduct> products;

  GraphTopBlock.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        products = List<GraphProduct>.from(
            json['products'].map((model) => GraphProduct.fromJson(model)));
}

class GraphOpeningHours {
  GraphOpeningHours({
    required this.weekDay,
    this.start,
    this.finish,
  });
  int weekDay;
  int? start;
  int? finish;

  GraphOpeningHours.fromJson(Map<String, dynamic> json)
      : weekDay = json['weekDay'],
        start = json['start'],
        finish = json['finish'];
}

class GraphMetroStation {
  GraphMetroStation({
    required this.lineName,
    required this.colorLine,
    required this.stationName,
    required this.distance,
  });
  String lineName;
  String colorLine;
  String stationName;
  String distance;

  GraphMetroStation.fromJson(Map<String, dynamic> json)
      : lineName = json['lineName'],
        colorLine = json['colorLine'],
        stationName = json['stationName'],
        distance = json['distance'];
}

class GraphShop {
  GraphShop({
    required this.iD,
    required this.name,
    this.description,
    this.address,
    this.longitude,
    this.latitude,
    this.start,
    this.finish,
    required this.regionId,
    required this.regionName,
    required this.pictures,
    required this.metroStations,
    required this.openingHours,
  });
  int iD;
  String name;
  String? description;
  String? address;
  double? longitude;
  double? latitude;
  int? start;
  int? finish;
  int regionId;
  String regionName;
  List<String> pictures;
  List<GraphMetroStation> metroStations;
  List<GraphOpeningHours> openingHours;

  GraphShop.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        description = json['description'],
        address = json['address'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        start = json['start'],
        finish = json['finish'],
        regionId = json['regionId'],
        regionName = json['regionName'],
        pictures = List<String>.from(json['pictures']),
        metroStations = List<GraphMetroStation>.from(json['metroStations']
            .map((model) => GraphMetroStation.fromJson(model))),
        openingHours = List<GraphOpeningHours>.from(json['openingHours']
            .map((model) => GraphOpeningHours.fromJson(model)));
}

class GraphAction {
  GraphAction({
    required this.iD,
    required this.name,
    this.dateStart,
    this.dateFinish,
    this.picture,
    this.squarePicture,
  });
  int iD;
  String name;
  int? dateStart;
  int? dateFinish;
  String? picture;
  String? squarePicture;

  GraphAction.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        dateStart = json['dateStart'],
        dateFinish = json['dateFinish'],
        picture = json['picture'],
        squarePicture = json['squarePicture'];
}

class GraphActionCard {
  GraphActionCard({
    required this.iD,
    required this.name,
    this.specialConditions,
    this.description,
    this.uRL,
    this.familyName,
    this.dateStart,
    this.dateFinish,
    this.picture,
    this.squarePicture,
    this.type,
    required this.products,
    required this.shops,
  });
  int iD;
  String name;
  String? specialConditions;
  String? description;
  String? uRL;
  String? familyName;
  int? dateStart;
  int? dateFinish;
  String? picture;
  String? squarePicture;
  String? type;
  List<GraphProduct> products;
  List<GraphShop> shops;

  GraphActionCard.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        specialConditions = json['specialConditions'],
        description = json['description'],
        uRL = json['uRL'],
        familyName = json['familyName'],
        dateStart = json['dateStart'],
        dateFinish = json['dateFinish'],
        picture = json['picture'],
        squarePicture = json['squarePicture'],
        type = json['type'],
        products = List<GraphProduct>.from(
            json['products'].map((model) => GraphProduct.fromJson(model))),
        shops = List<GraphShop>.from(
            json['shops'].map((model) => GraphShop.fromJson(model)));
}

class GraphMessage {
  GraphMessage({
    required this.iD,
    this.caption,
    this.text,
    this.button,
    this.uRL,
  });
  int iD;
  String? caption;
  String? text;
  String? button;
  String? uRL;

  GraphMessage.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        caption = json['caption'],
        text = json['text'],
        button = json['button'],
        uRL = json['uRL'];
}

class GraphActionShort {
  GraphActionShort({
    required this.iD,
    required this.name,
  });
  int iD;
  String name;
  GraphActionShort.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'];
}

class GraphOrderShort {
  GraphOrderShort({
    required this.orderId,
    required this.dateOrder,
    required this.priceOrder,
    required this.address,
  });
  int orderId;
  int dateOrder;
  int priceOrder;
  String address;
  GraphOrderShort.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'],
        dateOrder = json['dateOrder'],
        priceOrder = json['priceOrder'],
        address = json['address'];
}

class GraphReaction {
  GraphReaction({
    this.type,
    this.order,
    this.action,
    this.message,
  });
  String? type;
  GraphOrderShort? order;
  GraphActionShort? action;
  GraphMessage? message;
  GraphReaction.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        order = json['order'],
        action = json['action'],
        message = GraphMessage.fromJson(json['message']);
}

class GraphCatalog {
  GraphCatalog({
    required this.iD,
    required this.name,
    this.picture,
    this.totalCount,
    this.childs,
  });
  int iD;
  String name;
  String? picture;
  int? totalCount;
  List<GraphCatalog>? childs;
  GraphCatalog.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        picture = json['picture'],
        totalCount = json['totalCount'],
        childs = json['childs'] != null
            ? List<GraphCatalog>.from(
                json['childs'].map((model) => GraphCatalog.fromJson(model)))
            : null;
}

class GraphClientFullInfo {
  GraphClientFullInfo({
    required this.clientGUID,
    this.phone,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.eMail,
    required this.confirmedPhone,
    required this.confirmedEMail,
    required this.isPassword,
    required this.points,
    required this.orders,
    this.picture,
    this.codeInviteFriend,
  });
  String clientGUID;
  int? phone;
  String? name;
  String? dateOfBirth;
  String? gender;
  String? eMail;
  bool confirmedPhone;
  bool confirmedEMail;
  bool isPassword;
  int points;
  int orders;
  String? picture;
  String? codeInviteFriend;

  GraphClientFullInfo.fromJson(Map<String, dynamic> json)
      : clientGUID = json['clientGUID'],
        phone = json['phone'],
        name = json['name'],
        dateOfBirth = json['dateOfBirth'],
        gender = json['gender'],
        eMail = json['eMail'],
        confirmedPhone = json['confirmedPhone'],
        confirmedEMail = json['confirmedEMail'],
        isPassword = json['isPassword'],
        points = json['points'],
        orders = json['orders'],
        picture = json['picture'],
        codeInviteFriend = json['codeInviteFriend'];
}

class GraphCharacteristicsValue {
  GraphCharacteristicsValue({
    required this.iD,
    required this.value,
    this.comment,
  });
  int iD;
  String value;
  String? comment;

  GraphCharacteristicsValue.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        value = json['value'],
        comment = json['comment'];
}

class GraphCharacteristics {
  GraphCharacteristics({
    required this.iD,
    required this.name,
    this.type,
    required this.isPrice,
    required this.values,
  });
  int iD;
  String name;
  String? type;
  bool isPrice;
  List<GraphCharacteristicsValue> values;

  GraphCharacteristics.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        type = json['type'],
        isPrice = json['isPrice'],
        values = List<GraphCharacteristicsValue>.from(json['values']
            .map((model) => GraphCharacteristicsValue.fromJson(model)));
}

class GraphProductAttribute {
  GraphProductAttribute({
    required this.iD,
    required this.name,
    required this.color,
  });
  int iD;
  String name;
  String color;

  GraphProductAttribute.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        color = json['color'];
}

class GraphProduct {
  GraphProduct({
    required this.iD,
    this.type,
    required this.familyID,
    required this.topCatalogID,
    required this.name,
    this.picture,
    required this.isFavorite,
    required this.favorites,
    required this.stickerPictures,
    required this.attributes,
  });
  int iD;
  String? type;
  int familyID;
  int topCatalogID;
  String name;
  String? picture;
  bool isFavorite;
  int favorites;
  List<String> stickerPictures;
  List<GraphProductAttribute> attributes;

  GraphProduct.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        familyID = json['familyID'],
        topCatalogID = json['topCatalogID'],
        name = json['name'],
        picture = json['picture'],
        isFavorite = json['isFavorite'],
        favorites = json['favorites'],
        stickerPictures = List<String>.from(json['stickerPictures']),
        attributes = List<GraphProductAttribute>.from(json['attributes']
            .map((model) => GraphProductAttribute.fromJson(model)));
}

class GraphProductPrice {
  GraphProductPrice({
    required this.price,
    this.oldPrice,
    this.characteristicValueID,
  });
  double price;
  double? oldPrice;
  int? characteristicValueID;

  GraphProductPrice.fromJson(Map<String, dynamic> json)
      : price = json['price'],
        oldPrice = json['oldPrice'],
        characteristicValueID = json['characteristicValueID'];
}

class GraphPicture {
  GraphPicture({
    required this.small,
    required this.full,
    this.characteristicValueID,
  });
  String small;
  String full;
  int? characteristicValueID;

  GraphPicture.fromJson(Map<String, dynamic> json)
      : small = json['small'],
        full = json['full'],
        characteristicValueID = json['characteristicValueID'];
}

class GraphComposition {
  GraphComposition({
    required this.description,
    this.picture,
  });
  String description;
  String? picture;

  GraphComposition.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        picture = json['picture'];
}

class GraphProductReview {
  GraphProductReview({
    this.clientName,
    required this.self,
    required this.date,
    this.text,
    required this.mark,
  });
  String? clientName;
  bool self;
  int date;
  String? text;
  int mark;

  GraphProductReview.fromJson(Map<String, dynamic> json)
      : clientName = json['clientName'],
        self = json['self'],
        date = json['date'],
        text = json['text'],
        mark = json['mark'];
}

class GraphProductCard {
  GraphProductCard({
    required this.iD,
    this.type,
    required this.familyID,
    required this.topCatalogID,
    required this.name,
    this.comment,
    this.description,
    this.application,
    this.composition,
    required this.isFavorite,
    required this.favorites,
    required this.attributes,
    required this.characteristics,
    required this.prices,
    required this.pictures,
    required this.stickerPictures,
    required this.compositions,
    required this.link,
    required this.similar,
    required this.reviews,
  });
  int iD;
  String? type;
  int familyID;
  int topCatalogID;
  String name;
  String? comment;
  String? description;
  String? application;
  String? composition;
  bool isFavorite;
  int favorites;
  List<GraphProductAttribute> attributes;
  List<GraphCharacteristics> characteristics;
  List<GraphProductPrice> prices;
  List<GraphPicture> pictures;
  List<String> stickerPictures;
  List<GraphComposition> compositions;
  List<GraphProduct> link;
  List<GraphProduct> similar;
  List<GraphProductReview> reviews;

  GraphProductCard.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        familyID = json['familyID'],
        topCatalogID = json['topCatalogID'],
        name = json['name'],
        isFavorite = json['isFavorite'],
        favorites = json['favorites'],
        attributes = List<GraphProductAttribute>.from(json['attributes']
            .map((model) => GraphProductAttribute.fromJson(model))),
        characteristics = List<GraphCharacteristics>.from(
            json['characteristics']
                .map((model) => GraphCharacteristics.fromJson(model))),
        prices = List<GraphProductPrice>.from(
            json['prices'].map((model) => GraphProductPrice.fromJson(model))),
        pictures = List<GraphPicture>.from(
            json['pictures'].map((model) => GraphPicture.fromJson(model))),
        stickerPictures = List<String>.from(json['stickerPictures']),
        compositions = List<GraphComposition>.from(json['compositions']
            .map((model) => GraphComposition.fromJson(model))),
        link = List<GraphProduct>.from(
            json['link'].map((model) => GraphProduct.fromJson(model))),
        similar = List<GraphProduct>.from(
            json['similar'].map((model) => GraphProduct.fromJson(model))),
        reviews = List<GraphProductReview>.from(
            json['reviews'].map((model) => GraphProductReview.fromJson(model)));
}

const String getAction = r'''
query getAction($actionID: Int) {
  getAction(actionID: $actionID) {
    iD
    name
    specialConditions
    description
    uRL
    familyName
    dateStart
    dateFinish
    picture
    squarePicture
    type
    products {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
    shops {
      iD
      name
      description
      address
      longitude
      latitude
      start
      finish
      regionId
      regionName
      pictures
      metroStations {
        lineName
        colorLine
        stationName
        distance
      }
      openingHours {
        weekDay
        start
        finish
      }
    }
  }
}
''';

const String getPoll = r'''
query getPoll($actionID: Int)
{
  getPoll(actionID: $actionID) {
    iD
    name
    comment
    isOther
    isSkip
    isMultiple
    isScale
    scaleMin
    scaleMax
    pollAnswers {
      iD
      name
    }
  }
}
''';

const String setPollResult = r'''
mutation setPollResult($actionID: Int, $answers: [graphPollAnswersClient]) {
  setPollResult(actionID: $actionID, answers: $answers) {
    result
    errorMessage
    point
  }
}
''';

const String friendFind = r'''
query friendFind($gUIDorPhone: String) {
  friendFind(gUIDorPhone: $gUIDorPhone)
  {
    name
    picture
  }
}
''';

const String friendTransfer = r'''
mutation friendTransfer($gUIDorPhone: String, $points: Int)
{
  friendTransfer(gUIDorPhone: $gUIDorPhone, points: $points)
  {
    result
    errorMessage
  }
}
''';

const String getCatalog = r'''
query getCatalog {
  getCatalog {
    iD
    name
    totalCount
    childs {
      name
      iD
      totalCount
      childs {
        name
        iD
        totalCount
        childs {
          name
          iD
          totalCount
        }
      }
    }
  }
}
''';

const String getProducts = r'''
query getProducts($catalogID: Int!, $cursor: String, $filter: graphFilter) {
  getProducts(catalogID: $catalogID, first: 45, after: $cursor, filter: $filter)
  {
    totalCount
    pageInfo {
      endCursor
      hasNextPage
      hasPreviousPage
      startCursor
    }
    items {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
  }
}
''';

const String getFilters = r'''
query getFilters($catalogID: Int)
{
  getFilters(catalogID: $catalogID)
  {
    priceMin
    priceMax
    groups {
    	iD
      name
      type
      values {
        iD
        name
      }
  	}
  }
}
''';

const String getConfigurator = r'''
query getConfigurator
{
  getConfigurator {
    iD
    type
    name
    description
    values {
      iD
      name
      picture
    }
  }
}
''';

const String getConfiguratorProducts = r'''
query getConfiguratorProducts($configuratorItemIds: [Int], $cursor: String)
{
  getConfiguratorProducts(first: 4, configuratorItemIds: $configuratorItemIds, after: $cursor) {
		totalCount
    pageInfo {
      endCursor
      hasNextPage
      hasPreviousPage
      startCursor
    }
    items {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
  }
}
''';

const String authenticate = r'''
mutation authenticate($gUID: String!, $bundleID: String!, $oSType: graphOSTypeEnum!) {
  authenticate(device: {gUID: $gUID, bundleID: $bundleID, oSType: $oSType}) 
  {
    token
  }
}
''';

const String editClient = r'''
mutation editClient($clientGUID: String!, $name: String, $eMail: String, $phone: Long, $dateOfBirth: DateTime, $gender: GenderType) {
  editClient(clientInfo: { clientGUID: $clientGUID, name: $name, eMail: $eMail, phone: $phone, dateOfBirth: $dateOfBirth, gender: $gender}) {
    result
    errorMessage
  }
}
''';

const String getActions = r'''
query getActions {
  getActions {
    iD
    name
    picture
  }
}
''';

const String getTopBlocks = r'''
query getTopBlocks {
  getTopBlocks
  {
    iD
    name
    products {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
  }
}
''';

const String loginClient = r'''
mutation loginClient($clientPhone: Long!) {
  loginClient(clientPhone: $clientPhone) {
    result
    errorMessage
    clientGUID
    token
    nextStep
  }
}
''';

const String checkClient = r'''
mutation checkClient($code: String!){
  checkClient(checkUser: {step: SMS_CONFIRMED_PHONE, code: $code}) {
    result
    errorMessage
    token
  }
}
''';

const String checkPassword = r'''
mutation checkPassword($password: String!){
  checkClient(checkUser: {step: PASSWORD, code: $password}) {
    result
    errorMessage
    token
  }
}
''';

const String getSupport = r'''
query getSupport {
  getSupport {
    iD
    date
    text
    managerID
  }
}
''';

const String addSupport = r'''
mutation addSupport($message: String)
{
  addSupport(message: $message)
  {
    result
    errorMessage
    iD
  }
}
''';

const String getProduct = r'''
query getProduct($productID: Int!) {
  getProduct(productID: $productID)
  {
    iD
    type
    familyID
    topCatalogID
    name
    comment
    description
    application
    composition
    isFavorite
    favorites
    attributes {
      iD
      name
      color
    }
    articles {
      characteristicValueID
      characteristicValue2ID
      value
    }
    awards {
      iD
      name
      picture
    }
    characteristics {
      iD
      name
      type
      isPrice
      values {
        iD
        value
        comment
      }
    }
    prices {
      price
      oldPrice
      characteristicValueID
    }
    pictures {
      small
      full
      characteristicValueID
    }
    stickerPictures
    compositions {
      description
      picture
    }
    link {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
    similar {
      iD
      type
      familyID
      topCatalogID
      name
      picture
      isFavorite
      favorites
      stickerPictures
      attributes {
        iD
        name
        color
      }
    }
    modifiers {
      caption
    }
    reviews {
      clientName
      self
      date
      text
      mark
    }
  }
}
''';

const String addReviewProduct = r'''
mutation addReviewProduct($productID: Int, $mark: Int, $text: String)
{
  addReviewProduct(productID: $productID, mark: $mark, text: $text) {
    result
    errorMessage
  }
}
''';

const String cartAdd = r'''
mutation cartAdd($productID: Int!, $characteristicValueIds: [Int]) {
  cartAdd(cartItem: {productID: $productID, quantity: 1, characteristicValueIds: $characteristicValueIds}) {
    result
  }
}
''';

const String setFavoritesProduct = r'''
mutation setFavoritesProduct($productID: Int!) {
  setFavoritesProduct(productId: $productID) {
    result
  }
}
''';

const String cartEdit = r'''
mutation cartEdit($rowID: Int, $quantity: Int) {
  cartEdit(rowID: $rowID, quantity: $quantity) {
    result
    errorMessage
  }
}
''';

const String getCart = r'''
query getCart {
  getCart {
    rowID
    productID
    productName
    quantity
    amount
    oldAmount
    modifiers
    comment
    picture
    message
    typeMessage
    characteristics {
      type
      name
      value
    }
  }
}
''';

const String getFavoritesProducts = r'''
query getFavoritesProducts {
  getFavoritesProducts {
    iD
    type
    familyID
    topCatalogID
    name
    picture
    isFavorite
    favorites
    stickerPictures
    attributes {
      iD
      name
      color
    }
  }
}
''';

const String cartDelete = r'''
mutation cartDelete($rowIDs: [Int]) {
  cartDelete(rowIDs: $rowIDs) {
    result
    errorMessage
  }
}
''';

const String setFavoritesProducts = r'''
mutation setFavoritesProducts($productIds: [Int]) {
  setFavoritesProducts(productIds: $productIds) {
    result
    errorMessage
  }
}
''';

const String delFavoritesProducts = r'''
mutation delFavoritesProducts($productIds: [Int]) {
  delFavoritesProducts(productIds: $productIds) {
    result
    errorMessage
  }
}
''';

const String getClientInfo = r'''
query getClientInfo {
  getClientInfo {
    clientGUID,
    name,
    phone,
    dateOfBirth,
    gender,
    eMail,
    confirmedPhone,
    confirmedEMail
    isPassword,
    points,
    orders,
    picture,
    codeInviteFriend
  }
}
''';

const String promocodeActivation = r'''
mutation promocodeActivation($promoCode: String)
{
  promocodeActivation(promoCode: $promoCode) {
    result
    errorMessage
  }
}
''';

const String setPassword = r'''
mutation setPassword($password: String)
{
  setPassword(password: $password)
  {
    result
    errorMessage
  }
}
''';

const String logoffClient = r'''
mutation logoffClient
{
  logoffClient
  {
    result
    errorMessage
    token
  }
}
''';

const String forgotPassword = r'''
mutation forgotPassword
{
  forgotPassword
  {
    result
    errorMessage
  }
}
''';

const String getFAQGroups = r'''
query getFAQGroups {
  getFAQGroups {
    iD
    name
    questions {
      iD
      question
    }
  }
}
''';

const String getFAQ = r'''
query getFAQ($fAQQuestionID: Int) {
  getFAQ(fAQQuestionID: $fAQQuestionID) {
    question
    answer
  }
}
''';

const String eMailConfirmRepeat = r'''
mutation eMailConfirmRepeat {
  eMailConfirmRepeat {
    result
    errorMessage
  }
}
''';

const String getDraw = r'''
query getDraw($actionID: Int)
{
  getDraw(actionID: $actionID)
  {
    iD
    name
    description
    uRL
    dateStart
    dateFinish
    specialConditions
    picture
    pictureLevel
    drawMode
    levels {
      level
      position
      endPosition
    }
  }
}
''';

const String setDrawTakePart = r'''
mutation setDrawTakePart($actionID: Int, $mode: DrawTakePart)
{
  setDrawTakePart(actionID: $actionID, mode: $mode)
  {
    result
    errorMessage
    point
  }
}
''';

const String getReactions = r'''
query getReactions {
  getReactions {
    type
    order {
      orderId
      dateOrder
      priceOrder
      address
    }
    action {
      iD
      name
    }
    message {
      iD
      caption
      text
      button
      uRL
    }
  }
}
''';

const String openReactionMessage = r'''
mutation openReactionMessage($messageID: Int) {
  openReactionMessage(messageID: $messageID) {
    result
    errorMessage
  }
}
''';

const String findProducts = r'''
query findProducts($searchBox: String) {
  findProducts(searchBox: $searchBox) {
    iD
    type
    familyID
    topCatalogID
    name
    picture
    isFavorite
    favorites
    stickerPictures
    attributes {
      iD
      name
      color
    }
  }
}
''';
