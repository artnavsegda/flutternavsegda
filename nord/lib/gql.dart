class GraphNotification {
  GraphNotification({
    required this.type,
    required this.date,
    this.caption,
    this.text,
    this.orderID,
    this.productID,
    this.shopID,
    this.actionID,
    this.catalogID,
  });
  String type;
  int date;
  String? caption;
  String? text;
  int? orderID;
  int? productID;
  int? shopID;
  int? actionID;
  int? catalogID;

  GraphNotification.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        date = json['date'],
        caption = json['caption'],
        text = json['text'],
        orderID = json['orderID'],
        productID = json['productID'],
        shopID = json['shopID'],
        actionID = json['actionID'],
        catalogID = json['catalogID'];
}

class GraphOrderResult {
  GraphOrderResult({
    required this.result,
    this.errorMessage,
    this.bankURL,
    required this.orderID,
    required this.gotoCart,
  });

  int result;
  String? errorMessage;
  String? bankURL;
  int orderID;
  bool gotoCart;

  GraphOrderResult.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        errorMessage = json['errorMessage'],
        bankURL = json['bankURL'],
        orderID = json['orderID'],
        gotoCart = json['gotoCart'];
}

class GraphCartItemOnly {
  GraphCartItemOnly({
    required this.productID,
    required this.quantity,
  });
  int productID;
  num quantity;
  Map<String, dynamic> toJson() => {
        'productID': productID,
        'quantity': quantity,
      };
}

class GraphFullOrder {
  GraphFullOrder({
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusName,
    required this.possibleCancel,
    required this.price,
    required this.discount,
    required this.deliveryPrice,
    required this.paidPoints,
    required this.receivePoints,
    required this.address,
    this.wishes = const [],
    this.purchases = const [],
  });

  int orderId;
  DateTime date;
  String status;
  String statusName;
  bool possibleCancel;
  num price;
  num discount;
  num deliveryPrice;
  int paidPoints;
  int receivePoints;
  String address;
  double? latitude;
  double? longitude;
  String? clientComment;
  String? dispecherComment;
  String? oFDUrl;
  int? reviewID;
  int? reviewMark;
  String? reviewText;
  List<GraphWish> wishes;
  List<GraphCartRow> purchases;

  GraphFullOrder.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'],
        date = DateTime.parse(json['date']),
        status = json['status'],
        statusName = json['statusName'],
        possibleCancel = json['possibleCancel'],
        price = json['price'],
        discount = json['discount'],
        deliveryPrice = json['deliveryPrice'],
        paidPoints = json['paidPoints'],
        receivePoints = json['receivePoints'],
        address = json['address'],
        wishes = List<GraphWish>.from(
            json['wishes'].map((model) => GraphWish.fromJson(model))),
        purchases = List<GraphCartRow>.from(
            json['purchases'].map((model) => GraphCartRow.fromJson(model)));
}

class GraphModifier {
  GraphModifier({
    this.caption,
    this.isRequired,
    this.quantity,
    required this.products,
  });

  String? caption;
  bool? isRequired;
  int? quantity;
  List<GraphProduct> products;

  GraphModifier.fromJson(Map<String, dynamic> json)
      : caption = json['caption'],
        isRequired = json['required'],
        quantity = json['quantity'],
        products = List<GraphProduct>.from(
            json['products'].map((model) => GraphProduct.fromJson(model)));
}

class GraphOrder {
  GraphOrder({
    required this.orderId,
    required this.date,
    required this.status,
    this.statusName,
    required this.possibleCancel,
    required this.price,
    required this.paidPoints,
    required this.receivePoints,
    this.address,
    this.caption,
  });

  int orderId;
  DateTime date;
  String status;
  String? statusName;
  bool possibleCancel;
  num price;
  int paidPoints;
  int receivePoints;
  String? address;
  String? caption;

  GraphOrder.fromJson(Map<String, dynamic> json)
      : orderId = json['orderId'],
        date = DateTime.parse(json['date']),
        status = json['status'],
        statusName = json['statusName'],
        possibleCancel = json['possibleCancel'],
        price = json['price'],
        paidPoints = json['paidPoints'],
        receivePoints = json['receivePoints'],
        address = json['address'],
        caption = json['caption'];
}

class GraphNewOrder {
  GraphNewOrder({
    this.shopID,
    this.deliveryAddressID,
    required this.deliveryDate,
    required this.deliveryTimeID,
    required this.deliveryExpress,
    required this.bankCardID,
    this.paymentData,
    this.paidPoints = 0,
    this.clientComment,
    required this.wishes,
  });

  int? shopID;
  int? deliveryAddressID;
  String deliveryDate;
  int deliveryTimeID;
  bool deliveryExpress;
  String bankCardID;
  String? paymentData;
  int paidPoints;
  String? clientComment;
  List<int> wishes;

  Map<String, dynamic> toJson() => {
        'shopID': shopID,
        'deliveryAddressID': deliveryAddressID,
        'deliveryDate': deliveryDate,
        'deliveryTimeID': deliveryTimeID,
        'deliveryExpress': deliveryExpress,
        'bankCardID': bankCardID,
        'paymentData': paymentData,
        'paidPoints': paidPoints,
        'clientComment': clientComment,
        'wishes': wishes,
      };
}

class GraphTypeDeliveryOrder {
  GraphTypeDeliveryOrder({
    this.shopID,
    this.deliveryAddressID,
  });

  int? shopID;
  int? deliveryAddressID;

  GraphTypeDeliveryOrder.fromJson(Map<String, dynamic> json)
      : shopID = json['shopID'],
        deliveryAddressID = json['deliveryAddressID'];
}

class GraphTerm {
  GraphTerm({
    required this.left,
    required this.right,
  });

  String left;
  String right;

  GraphTerm.fromJson(Map<String, dynamic> json)
      : left = json['left'],
        right = json['right'];
}

class GraphOrderTime {
  GraphOrderTime({
    required this.iD,
    required this.name,
    required this.todayDisabled,
  });

  int iD;
  String name;
  bool todayDisabled;

  GraphOrderTime.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        todayDisabled = json['todayDisabled'];
}

class GraphOrderDate {
  GraphOrderDate({
    required this.date,
    required this.disabled,
  });

  String date;
  bool disabled;

  GraphOrderDate.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        disabled = json['disabled'];
}

class GraphDeliveryInfo {
  GraphDeliveryInfo({
    required this.express,
    required this.price,
    required this.expressPrice,
    this.message,
    required this.terms,
  });

  bool express;
  int price;
  int expressPrice;
  String? message;
  List<GraphTerm> terms;

  GraphDeliveryInfo.fromJson(Map<String, dynamic> json)
      : express = json['express'],
        price = json['price'],
        expressPrice = json['expressPrice'],
        message = json['message'],
        terms = List<GraphTerm>.from(
            json['terms'].map((model) => GraphTerm.fromJson(model)));
}

class GraphSlots {
  GraphSlots({
    required this.dates,
    required this.times,
    required this.expressTimes,
  });

  List<GraphOrderDate> dates;
  List<GraphOrderTime> times;
  List<GraphOrderTime> expressTimes;

  GraphSlots.fromJson(Map<String, dynamic> json)
      : dates = List<GraphOrderDate>.from(
            json['dates'].map((model) => GraphOrderDate.fromJson(model))),
        times = List<GraphOrderTime>.from(
            json['times'].map((model) => GraphOrderTime.fromJson(model))),
        expressTimes = List<GraphOrderTime>.from(json['expressTimes']
            .map((model) => GraphOrderTime.fromJson(model)));
}

class GraphWish {
  GraphWish({
    required this.iD,
    required this.name,
  });

  int iD;
  String name;

  GraphWish.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'];
}

class GraphBasket {
  GraphBasket({
    required this.payment,
    required this.amount,
    required this.discount,
    required this.availablePoints,
    required this.bankCards,
    required this.wishes,
    required this.rows,
    required this.slots,
    required this.deliveryInfo,
    required this.state,
  });

  num payment;
  num amount;
  num discount;
  int availablePoints;
  List<GraphBankCard> bankCards;
  List<GraphWish> wishes;
  List<GraphCartRow> rows;
  GraphSlots slots;
  GraphDeliveryInfo? deliveryInfo;
  String state;

  GraphBasket.fromJson(Map<String, dynamic> json)
      : payment = json['payment'],
        amount = json['amount'],
        discount = json['discount'],
        availablePoints = json['availablePoints'],
        bankCards = List<GraphBankCard>.from(
            json['bankCards'].map((model) => GraphBankCard.fromJson(model))),
        wishes = List<GraphWish>.from(
            json['wishes'].map((model) => GraphWish.fromJson(model))),
        rows = List<GraphCartRow>.from(
            json['rows'].map((model) => GraphCartRow.fromJson(model))),
        slots = GraphSlots.fromJson(json['slots']),
        deliveryInfo = json['deliveryInfo'] == null
            ? null
            : GraphDeliveryInfo.fromJson(json['deliveryInfo']),
        state = json['state'];
}

class GraphSettingsResult {
  GraphSettingsResult({
    this.senderID,
    required this.privacyPolicy,
    required this.sMSTimer,
    required this.rulesHelpGroupID,
    required this.pointInviteFriend,
    required this.ordersFriends,
    this.yandexApiKey,
    this.phone,
    this.language,
    this.iOSApplication,
    this.androidApplication,
    this.eMail,
    this.eMailOrder,
    this.socialNetwork_Instagram,
    this.socialNetwork_Facebook,
    this.socialNetwork_VK,
    this.socialNetwork_OK,
    this.socialNetwork_Telegram,
    required this.appleGooglePay,
    required this.bonusPay,
    required this.startType,
  });

  String? senderID;
  String privacyPolicy;
  int sMSTimer;
  int rulesHelpGroupID;
  int pointInviteFriend;
  int ordersFriends;
  String? yandexApiKey;
  int? phone;
  String? language;
  String? iOSApplication;
  String? androidApplication;
  String? eMail;
  String? eMailOrder;
  String? socialNetwork_Instagram;
  String? socialNetwork_Facebook;
  String? socialNetwork_VK;
  String? socialNetwork_OK;
  String? socialNetwork_Telegram;
  bool appleGooglePay;
  bool bonusPay;
  String startType;

  GraphSettingsResult.fromJson(Map<String, dynamic> json)
      : senderID = json['senderID'],
        privacyPolicy = json['privacyPolicy'],
        sMSTimer = json['sMSTimer'],
        rulesHelpGroupID = json['rulesHelpGroupID'],
        pointInviteFriend = json['pointInviteFriend'],
        ordersFriends = json['ordersFriends'],
        yandexApiKey = json['yandexApiKey'],
        phone = json['phone'],
        language = json['language'],
        iOSApplication = json['iOSApplication'],
        androidApplication = json['androidApplication'],
        eMail = json['queseMailtion'],
        eMailOrder = json['eMailOrder'],
        socialNetwork_Instagram = json['socialNetwork_Instagram'],
        socialNetwork_Facebook = json['socialNetwork_Facebook'],
        socialNetwork_VK = json['socialNetwork_VK'],
        socialNetwork_OK = json['socialNetwork_OK'],
        socialNetwork_Telegram = json['socialNetwork_Telegram'],
        appleGooglePay = json['appleGooglePay'],
        bonusPay = json['bonusPay'],
        startType = json['startType'];
}

class GraphLoyaltyTier {
  GraphLoyaltyTier({
    required this.iD,
    required this.active,
    required this.name,
    this.description,
    required this.pointOrder,
    required this.condition,
    this.message,
    this.picture,
  });

  int iD;
  bool active;
  String name;
  String? description;
  int pointOrder;
  int condition;
  String? message;
  String? picture;

  GraphLoyaltyTier.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        active = json['active'],
        name = json['name'],
        description = json['description'],
        pointOrder = json['pointOrder'],
        condition = json['condition'],
        message = json['message'],
        picture = json['picture'];
}

class GraphClientInfo {
  GraphClientInfo({
    required this.clientGUID,
    this.phone,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.eMail,
    this.greenMode,
  });

  String clientGUID;
  int? phone;
  String? name;
  String? dateOfBirth;
  String? gender;
  String? eMail;
  bool? greenMode;

  Map<String, dynamic> toJson() => {
        'clientGUID': clientGUID,
        'phone': phone,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'eMail': eMail,
        'greenMode': greenMode,
      };
}

class GraphFAQ {
  GraphFAQ({
    required this.question,
    required this.answer,
  });

  String question;
  String answer;

  GraphFAQ.fromJson(Map<String, dynamic> json)
      : question = json['question'],
        answer = json['answer'];
}

class GraphFAQQuestion {
  GraphFAQQuestion({
    required this.iD,
    required this.question,
  });

  int iD;
  String question;

  GraphFAQQuestion.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        question = json['question'];
}

class GraphFAQGroup {
  GraphFAQGroup({
    required this.iD,
    required this.name,
    required this.questions,
  });

  int iD;
  String name;
  List<GraphFAQQuestion> questions;

  GraphFAQGroup.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        questions = List<GraphFAQQuestion>.from(
            json['questions'].map((model) => GraphFAQQuestion.fromJson(model)));
}

class GraphDevice {
  GraphDevice({
    required this.gUID,
    this.buildApp,
    required this.bundleID,
    this.oSVersion,
    this.pushNotificationToken,
    this.oSType,
  });

  String gUID;
  String? buildApp;
  String bundleID;
  String? oSVersion;
  String? pushNotificationToken;
  String? oSType;

  Map<String, dynamic> toJson() => {
        'gUID': gUID,
        'buildApp': buildApp,
        'bundleID': bundleID,
        'oSVersion': oSVersion,
        'pushNotificationToken': pushNotificationToken,
        'oSType': oSType,
      };
}

class GraphSupport {
  GraphSupport({
    required this.iD,
    required this.date,
    this.text,
    this.managerID,
    this.manager,
    required this.isPhoto,
  });

  int iD;
  DateTime date;
  String? text;
  int? managerID;
  String? manager;
  bool isPhoto;

  GraphSupport.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        date = DateTime.parse(json['date']),
        text = json['text'],
        managerID = json['managerID'],
        manager = json['manager'],
        isPhoto = json['isPhoto'];
}

class GraphAuthResult {
  GraphAuthResult({
    required this.token,
    this.senderID,
    required this.privacyPolicy,
    required this.sMSTimer,
    required this.rulesHelpGroupID,
    required this.pointInviteFriend,
    required this.ordersFriends,
    this.yandexApiKey,
    this.phone,
    this.language,
    this.iOSApplication,
    this.androidApplication,
    this.eMail,
    this.eMailOrder,
    this.socialNetwork_Instagram,
    this.socialNetwork_Facebook,
    this.socialNetwork_VK,
    this.startType,
  });

  String token;
  String? senderID;
  String privacyPolicy;
  int sMSTimer;
  int rulesHelpGroupID;
  int pointInviteFriend;
  int ordersFriends;
  String? yandexApiKey;
  int? phone;
  String? language;
  String? iOSApplication;
  String? androidApplication;
  String? eMail;
  String? eMailOrder;
  String? socialNetwork_Instagram;
  String? socialNetwork_Facebook;
  String? socialNetwork_VK;
  String? startType;

  GraphAuthResult.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        senderID = json['senderID'],
        privacyPolicy = json['privacyPolicy'],
        sMSTimer = json['sMSTimer'],
        rulesHelpGroupID = json['rulesHelpGroupID'],
        pointInviteFriend = json['pointInviteFriend'],
        ordersFriends = json['ordersFriends'],
        yandexApiKey = json['yandexApiKey'],
        phone = json['phone'],
        language = json['language'],
        iOSApplication = json['iOSApplication'],
        androidApplication = json['androidApplication'],
        eMail = json['eMail'],
        eMailOrder = json['eMailOrder'],
        socialNetwork_Instagram = json['socialNetwork_Instagram'],
        socialNetwork_Facebook = json['socialNetwork_Facebook'],
        socialNetwork_VK = json['socialNetwork_VK'],
        startType = json['startType'];
}

class GraphCheckUser {
  GraphCheckUser({
    required this.code,
    this.step,
  });

  String code;
  String? step;

  Map<String, dynamic> toJson() => {
        'code': code,
        'step': step,
      };
}

class GraphClientResult {
  GraphClientResult({
    required this.result,
    this.errorMessage,
    this.clientGUID,
    this.token,
    this.nextStep,
  });

  int result;
  String? errorMessage;
  String? clientGUID;
  String? token;
  String? nextStep;

  GraphClientResult.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        errorMessage = json['errorMessage'],
        clientGUID = json['clientGUID'],
        token = json['token'],
        nextStep = json['nextStep'];
}

class GraphTokenResult {
  GraphTokenResult({
    required this.result,
    this.errorMessage,
    this.token,
  });

  int result;
  String? errorMessage;
  String? token;

  GraphTokenResult.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        errorMessage = json['errorMessage'],
        token = json['token'];
}

class GraphBasisResult {
  GraphBasisResult({
    required this.result,
    this.errorMessage,
  });

  int result;
  String? errorMessage;

  GraphBasisResult.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        errorMessage = json['errorMessage'];
}

class GraphPromocodeResult {
  GraphPromocodeResult({
    required this.result,
    this.errorMessage,
    this.type,
    this.productID,
  });

  int result;
  String? errorMessage;
  String? type;
  int? productID;

  GraphPromocodeResult.fromJson(Map<String, dynamic> json)
      : result = json['result'],
        errorMessage = json['errorMessage'],
        type = json['type'],
        productID = json['productID'];
}

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

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'value': value,
      };

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
    this.oldAmount,
    this.modifiers,
    this.comment,
    this.picture,
    this.message,
    this.typeMessage,
    required this.characteristics,
  });
  int rowID;
  int productID;
  String productName;
  num quantity;
  num amount;
  num? oldAmount;
  String? modifiers;
  String? comment;
  String? picture;
  String? message;
  String? typeMessage;
  List<GraphCartCharacteristic> characteristics;

  Map<String, dynamic> toJson() => {
        'rowID': rowID,
        'productID': productID,
        'productName': productName,
        'quantity': quantity,
        'amount': amount,
        'oldAmount': oldAmount,
        'modifiers': modifiers,
        'comment': comment,
        'picture': picture,
        'message': message,
        'typeMessage': typeMessage,
        'characteristics': characteristics,
      };

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
    this.sortType,
    this.sortOrder,
    this.priceMin,
    this.priceMax,
    this.groups = const <int, GraphFilterGroup>{},
  });

  GraphFilter.from(GraphFilter original) {
    sortType = original.sortType;
    sortOrder = original.sortOrder;
    priceMin = original.priceMin;
    priceMax = original.priceMax;
    groups = Map<int, GraphFilterGroup>.from(original.groups);
  }

  String? sortType;
  String? sortOrder;
  int? priceMin;
  int? priceMax;
  Map<int, GraphFilterGroup> groups = const <int, GraphFilterGroup>{};

  Map<String, dynamic> toJson() => {
        'sortType': sortType,
        'sortOrder': sortOrder,
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

  Map<String, dynamic> toJson() => {
        'weekDay': weekDay,
        'start': start,
        'finish': finish,
      };
}

class GraphMetroStation {
  GraphMetroStation({
    required this.iD,
    required this.lineName,
    required this.colorLine,
    required this.stationName,
    this.distance,
    this.regionID,
  });
  int iD;
  String lineName;
  String colorLine;
  String stationName;
  String? distance;
  int? regionID;

  GraphMetroStation.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        lineName = json['lineName'],
        colorLine = json['colorLine'],
        stationName = json['stationName'],
        distance = json['distance'],
        regionID = json['regionID'];

  Map<String, dynamic> toJson() => {
        'iD': iD,
        'lineName': lineName,
        'colorLine': colorLine,
        'stationName': stationName,
        'distance': distance,
        'regionID': regionID,
      };
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
  String? name;
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

  Map<String, dynamic> toJson() => {
        'iD': iD,
        'name': name,
        'description': description,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'start': start,
        'finish': finish,
        'regionId': regionId,
        'regionName': regionName,
        'pictures': pictures,
        'metroStations': metroStations,
        'openingHours': openingHours,
      };
}

class GraphAction {
  GraphAction({
    required this.iD,
    required this.name,
    this.dateStart,
    this.dateFinish,
    this.picture,
  });
  int iD;
  String name;
  int? dateStart;
  int? dateFinish;
  String? picture;

  GraphAction.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        dateStart = json['dateStart'],
        dateFinish = json['dateFinish'],
        picture = json['picture'];
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
    required this.products,
  });
  int iD;
  String name;
  List<GraphProduct> products;
  GraphCatalog.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        products = List<GraphProduct>.from(
            json['products'].map((model) => GraphProduct.fromJson(model)));
}

class GraphDeliveryAddress {
  GraphDeliveryAddress({
    required this.iD,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.description,
  });

  int iD;
  String address;
  double longitude;
  double latitude;
  String? description;

  GraphDeliveryAddress.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        address = json['address'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'iD': iD,
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'description': description,
      };
}

class GraphNewDeliveryAddress {
  GraphNewDeliveryAddress({
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.description,
  });

  String address;
  double longitude;
  double latitude;
  String? description;

  GraphNewDeliveryAddress.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        longitude = json['longitude'],
        latitude = json['latitude'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'address': address,
        'longitude': longitude,
        'latitude': latitude,
        'description': description,
      };
}

class GraphBankCard {
  GraphBankCard({
    required this.iD,
    required this.mask,
    this.picture,
  });
  String iD;
  String mask;
  String? picture;
  GraphBankCard.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        mask = json['mask'],
        picture = json['picture'];
}

class GraphClientFullInfo {
  GraphClientFullInfo({
    required this.clientGUID,
    this.phone,
    this.name,
    this.dateOfBirth,
    this.gender,
    this.eMail,
    this.greenMode,
    required this.confirmedPhone,
    required this.qRSufix,
    required this.confirmedEMail,
    required this.isPassword,
    required this.points,
    required this.orders,
    this.picture,
    this.codeInviteFriend,
    this.bonusCardBack,
    this.bonusCardBack2x,
    this.bonusCardBack3x,
    required this.deliveryAddresses,
    required this.bankCards,
    required this.filterType,
    this.filterDeliveryAddressId,
    this.filterShopId,
    this.filterMessage,
    this.loyaltyTierId,
    this.loyaltyTierPointOrder,
    this.loyaltyTierPictureCard,
  });
  String clientGUID;
  int? phone;
  String? name;
  String? dateOfBirth;
  String? gender;
  String? eMail;
  bool? greenMode;
  bool confirmedPhone;
  String qRSufix;
  bool confirmedEMail;
  bool isPassword;
  int points;
  int orders;
  String? picture;
  String? codeInviteFriend;
  String? bonusCardBack;
  String? bonusCardBack2x;
  String? bonusCardBack3x;
  List<GraphDeliveryAddress> deliveryAddresses;
  List<GraphBankCard> bankCards;
  String filterType;
  int? filterDeliveryAddressId;
  int? filterShopId;
  String? filterMessage;
  int? loyaltyTierId;
  int? loyaltyTierPointOrder;
  String? loyaltyTierPictureCard;

  GraphClientFullInfo.fromJson(Map<String, dynamic> json)
      : clientGUID = json['clientGUID'],
        phone = json['phone'],
        name = json['name'],
        dateOfBirth = json['dateOfBirth'],
        gender = json['gender'],
        eMail = json['eMail'],
        greenMode = json['greenMode'],
        confirmedPhone = json['confirmedPhone'],
        qRSufix = json['qRSufix'],
        confirmedEMail = json['confirmedEMail'],
        isPassword = json['isPassword'],
        points = json['points'],
        orders = json['orders'],
        picture = json['picture'],
        codeInviteFriend = json['codeInviteFriend'],
        bonusCardBack = json['bonusCardBack'],
        bonusCardBack2x = json['bonusCardBack2x'],
        bonusCardBack3x = json['bonusCardBack3x'],
        deliveryAddresses = List<GraphDeliveryAddress>.from(
            json['deliveryAddresses']
                .map((model) => GraphDeliveryAddress.fromJson(model))),
        bankCards = List<GraphBankCard>.from(
            json['bankCards'].map((model) => GraphBankCard.fromJson(model))),
        filterType = json['filterType'],
        filterDeliveryAddressId = json['filterDeliveryAddressId'],
        filterShopId = json['filterShopId'],
        filterMessage = json['filterMessage'],
        loyaltyTierId = json['loyaltyTierId'],
        loyaltyTierPointOrder = json['loyaltyTierPointOrder'],
        loyaltyTierPictureCard = json['loyaltyTierPictureCard'];
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
    this.stickerPictures,
    this.attributes,
    required this.prices,
  });
  int iD;
  String? type;
  int familyID;
  int topCatalogID;
  String name;
  String? picture;
  bool isFavorite;
  int favorites;
  List<String>? stickerPictures;
  List<GraphProductAttribute>? attributes;
  List<GraphProductPrice> prices;

  GraphProduct.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        familyID = json['familyID'],
        topCatalogID = json['topCatalogID'],
        name = json['name'],
        picture = json['picture'],
        isFavorite = json['isFavorite'],
        favorites = json['favorites'],
        stickerPictures = json['stickerPictures'] == null
            ? null
            : List<String>.from(json['stickerPictures']),
        attributes = json['attributes'] == null
            ? null
            : List<GraphProductAttribute>.from(json['attributes']
                .map((model) => GraphProductAttribute.fromJson(model))),
        prices = List<GraphProductPrice>.from(
            json['prices'].map((model) => GraphProductPrice.fromJson(model)));
}

class GraphProductPrice {
  GraphProductPrice({
    required this.price,
    this.oldPrice,
    this.characteristicValueID,
  });
  num price;
  num? oldPrice;
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

class GraphAward {
  GraphAward({
    required this.iD,
    required this.name,
    required this.picture,
  });

  int iD;
  String name;
  String picture;

  GraphAward.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        name = json['name'],
        picture = json['picture'];
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
    required this.awards,
    required this.modifiers,
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
  List<GraphAward> awards;
  List<GraphModifier> modifiers;

  GraphProductCard.fromJson(Map<String, dynamic> json)
      : iD = json['iD'],
        type = json['type'],
        familyID = json['familyID'],
        topCatalogID = json['topCatalogID'],
        name = json['name'],
        comment = json['comment'],
        description = json['description'],
        application = json['application'],
        composition = json['composition'],
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
            json['reviews'].map((model) => GraphProductReview.fromJson(model))),
        awards = List<GraphAward>.from(
            json['awards'].map((model) => GraphAward.fromJson(model))),
        modifiers = List<GraphModifier>.from(
            json['modifiers'].map((model) => GraphModifier.fromJson(model)));
}

const String getLoyaltyTiers = r'''
query getLoyaltyTiers {
  getLoyaltyTiers {
    iD
    active
    name
    description
    pointOrder
    condition
    message
    picture
  }
}
''';

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
      prices {
        price
        oldPrice
        characteristicValueID
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
query getProducts($deliveryAddressID: Int, $shopID: Int) {
  getProducts(typeDeliveryOrder: {deliveryAddressID: $deliveryAddressID, shopID: $shopID})
  {
    name
    iD
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
      prices {
        price
        oldPrice
        characteristicValueID
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
      prices {
        price
        oldPrice
        characteristicValueID
      }
    }
  }
}
''';

const String authenticate = r'''
mutation authenticate($gUID: String!, $buildApp: String, $bundleID: String!, $oSVersion: String, $pushNotificationToken: String, $oSType: graphOSTypeEnum) {
  authenticate(device: {gUID: $gUID, buildApp: $buildApp, bundleID: $bundleID, oSVersion: $oSVersion, pushNotificationToken: $pushNotificationToken, oSType: $oSType}) 
  {
    token
    senderID
    privacyPolicy
    sMSTimer
    rulesHelpGroupID
    pointInviteFriend
    ordersFriends
    yandexApiKey
    phone
    language
    iOSApplication
    androidApplication
    eMail
    eMailOrder
    socialNetwork_Instagram
    socialNetwork_Facebook
    socialNetwork_VK
    startType
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
  getActions
  {
    iD
    name
    dateStart
    dateFinish
    picture
  }
}
''';

const String getTopBlocks = r'''
query getTopBlocks($deliveryAddressID: Int, $shopID: Int) {
  getTopBlocks(typeDeliveryOrder: {deliveryAddressID: $deliveryAddressID, shopID: $shopID})
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
      prices {
        price
        oldPrice
        characteristicValueID
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
mutation checkClient($step: StepType, $code: String!){
  checkClient(checkUser: {step: $step, code: $code}) {
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
    manager,
    isPhoto,
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
      prices {
        price
        oldPrice
        characteristicValueID
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
      prices {
        price
        oldPrice
        characteristicValueID
      }
    }
    modifiers {
      caption
      required
      quantity
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
        prices {
          price
          oldPrice
          characteristicValueID
        }
      }
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
mutation cartAdd($productID: Int!, $characteristicValueIds: [Int], $modifiers: [graphCartItemOnly]) {
  cartAdd(cartItem: {productID: $productID, quantity: 1, characteristicValueIds: $characteristicValueIds, modifiers: $modifiers}) {
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
mutation cartEdit($rowID: Long, $quantity: Decimal) {
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
    prices {
      price
      oldPrice
      characteristicValueID
    }
  }
}
''';

const String cartDelete = r'''
mutation cartDelete($rowIDs: [Long]) {
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
    qRSufix,
    confirmedEMail
    isPassword,
    points,
    orders,
    picture,
    codeInviteFriend,
    bonusCardBack,
    bonusCardBack2x,
    bonusCardBack3x,
    deliveryAddresses {
      iD,
      address,
      longitude,
      latitude,
      description,
    },
    bankCards {
      iD,
      mask,
      picture,
    },
    filterType,
    filterDeliveryAddressId,
    filterShopId,
    filterMessage,
    loyaltyTierId,
    loyaltyTierPointOrder,
    loyaltyTierPictureCard,
  }
}
''';

const String promocodeActivation = r'''
mutation promocodeActivation($promoCode: String)
{
  promocodeActivation(promoCode: $promoCode) {
    result
    errorMessage
    type,
    productID
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
    prices {
      price
      oldPrice
      characteristicValueID
    }
  }
}
''';

const String cartClear = r'''
mutation cartClear {
  cartClear {
    result
    errorMessage
  }
}
''';

const String getShops = r'''
query getShops {
  getShops {
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
    isPickup
    pictures
    metroStations {
      iD
      lineName
      colorLine
      stationName
      distance
      regionID
    }
    openingHours {
      weekDay
      start
      finish
    }
  }
}
''';

const String newCodeSMS = r'''
mutation newCodeSMS {
  newCodeSMS {
    result
    errorMessage
  }
}
''';

const String getSettings = r'''
query getSettings {
  getSettings {
    senderID
    privacyPolicy
    sMSTimer
    rulesHelpGroupID
    pointInviteFriend
    ordersFriends
    yandexApiKey
    phone
    language
    iOSApplication
    androidApplication
    eMail
    eMailOrder
    socialNetwork_Instagram
    socialNetwork_Facebook
    socialNetwork_VK
    socialNetwork_OK
    socialNetwork_Telegram
    appleGooglePay
    bonusPay
    startType
  }
}
''';

const String getBasket = r'''
query getBasket($deliveryAddressID: Int, $shopID: Int) {
  getBasket(typeDeliveryOrder: {deliveryAddressID: $deliveryAddressID, shopID: $shopID}) {
    payment
    amount
    discount
    availablePoints
    bankCards {
      iD
      mask
      picture
    }
    wishes {
      iD
      name
    }
    rows {
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
    slots {
      dates {
        date
        disabled
      }
      times {
        iD
        name
        todayDisabled
      }
      expressTimes {
        iD
        name
        todayDisabled
      }
    }
    deliveryInfo {
      express
      price
      expressPrice
      message
      terms {
        left
        right
      }
    }
    state
  }
}
''';

const String addDeliveryAddress = r'''
mutation addDeliveryAddress($newAddress: graphNewDeliveryAddress) {
  addDeliveryAddress(newAddress: $newAddress) {
    result
    errorMessage
  }
}
''';

const String getOrders = r'''
query getOrders {
  getOrders {
    orderId
    date
    status
    statusName
    possibleCancel
    price
    paidPoints
    receivePoints
    address
    caption
  }
}
''';

const String getOrder = r'''
query getOrder($orderID: Long) {
  getOrder(orderID: $orderID) {
    orderId
    date
    status
    statusName
    possibleCancel
    price
    discount
    deliveryPrice
    paidPoints
    receivePoints
    address
    latitude
    longitude
    clientComment
    dispecherComment
    oFDUrl
    reviewID
    reviewMark
    reviewText
    wishes {
      iD
      name
    }
    purchases {
      rowID
      productID
      productName
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
}
''';

const String addOrder = r'''
mutation addOrder($order: graphNewOrder) {
  addOrder(order: $order)
  {
    result
    errorMessage
    bankURL
    orderID
    gotoCart
  }
}
''';

const String cancelOrder = r'''
mutation cancelOrder($orderID: Long) {
  cancelOrder(orderID: $orderID)
  {
    result
    errorMessage
  }
}
''';

const String getNotifications = r'''
query getNotifications {
  getNotifications {
    type
    date
    caption
    text
    orderID
    productID
    shopID
    actionID
    catalogID
  }
}
''';

const String delDeliveryAddress = r'''
mutation delDeliveryAddress($addressID: Int) {
  delDeliveryAddress(addressID: $addressID) {
    result
    errorMessage
  }
}
''';
