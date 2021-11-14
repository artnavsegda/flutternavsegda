// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'levrana.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GraphProductAttribute _$GraphProductAttributeFromJson(
        Map<String, dynamic> json) =>
    GraphProductAttribute()
      ..iD = json['iD'] as int
      ..name = json['name'] as String
      ..color = json['color'] as String;

Map<String, dynamic> _$GraphProductAttributeToJson(
        GraphProductAttribute instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'color': instance.color,
    };

GraphProduct _$GraphProductFromJson(Map<String, dynamic> json) => GraphProduct()
  ..iD = json['iD'] as int
  ..type = $enumDecodeNullable(_$ProductTypeEnumMap, json['type'],
      unknownValue: ProductType.artemisUnknown)
  ..familyID = json['familyID'] as int
  ..topCatalogID = json['topCatalogID'] as int
  ..name = json['name'] as String
  ..picture = json['picture'] as String?
  ..isFavorite = json['isFavorite'] as bool
  ..favorites = json['favorites'] as int
  ..stickerPictures = (json['stickerPictures'] as List<dynamic>?)
      ?.map((e) => e as String?)
      .toList()
  ..attributes = (json['attributes'] as List<dynamic>?)
      ?.map((e) => e == null
          ? null
          : GraphProductAttribute.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GraphProductToJson(GraphProduct instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'type': _$ProductTypeEnumMap[instance.type],
      'familyID': instance.familyID,
      'topCatalogID': instance.topCatalogID,
      'name': instance.name,
      'picture': instance.picture,
      'isFavorite': instance.isFavorite,
      'favorites': instance.favorites,
      'stickerPictures': instance.stickerPictures,
      'attributes': instance.attributes?.map((e) => e?.toJson()).toList(),
    };

const _$ProductTypeEnumMap = {
  ProductType.simple: 'SIMPLE',
  ProductType.addition: 'ADDITION',
  ProductType.kw$SET: 'SET',
  ProductType.box: 'BOX',
  ProductType.modificator: 'MODIFICATOR',
  ProductType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GraphMetroStation _$GraphMetroStationFromJson(Map<String, dynamic> json) =>
    GraphMetroStation()
      ..lineName = json['lineName'] as String
      ..colorLine = json['colorLine'] as String
      ..stationName = json['stationName'] as String
      ..distance = json['distance'] as String;

Map<String, dynamic> _$GraphMetroStationToJson(GraphMetroStation instance) =>
    <String, dynamic>{
      'lineName': instance.lineName,
      'colorLine': instance.colorLine,
      'stationName': instance.stationName,
      'distance': instance.distance,
    };

GraphOpeningHours _$GraphOpeningHoursFromJson(Map<String, dynamic> json) =>
    GraphOpeningHours()
      ..weekDay = json['weekDay'] as int
      ..start = json['start'] as int?
      ..finish = json['finish'] as int?;

Map<String, dynamic> _$GraphOpeningHoursToJson(GraphOpeningHours instance) =>
    <String, dynamic>{
      'weekDay': instance.weekDay,
      'start': instance.start,
      'finish': instance.finish,
    };

GraphShop _$GraphShopFromJson(Map<String, dynamic> json) => GraphShop()
  ..iD = json['iD'] as int
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..address = json['address'] as String?
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..start = json['start'] as int?
  ..finish = json['finish'] as int?
  ..regionId = json['regionId'] as int
  ..regionName = json['regionName'] as String
  ..pictures =
      (json['pictures'] as List<dynamic>?)?.map((e) => e as String?).toList()
  ..metroStations = (json['metroStations'] as List<dynamic>?)
      ?.map((e) => e == null
          ? null
          : GraphMetroStation.fromJson(e as Map<String, dynamic>))
      .toList()
  ..openingHours = (json['openingHours'] as List<dynamic>?)
      ?.map((e) => e == null
          ? null
          : GraphOpeningHours.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GraphShopToJson(GraphShop instance) => <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'start': instance.start,
      'finish': instance.finish,
      'regionId': instance.regionId,
      'regionName': instance.regionName,
      'pictures': instance.pictures,
      'metroStations': instance.metroStations?.map((e) => e?.toJson()).toList(),
      'openingHours': instance.openingHours?.map((e) => e?.toJson()).toList(),
    };

GraphActionCard _$GraphActionCardFromJson(Map<String, dynamic> json) =>
    GraphActionCard()
      ..iD = json['iD'] as int
      ..name = json['name'] as String
      ..specialConditions = json['specialConditions'] as String?
      ..description = json['description'] as String?
      ..uRL = json['uRL'] as String?
      ..familyName = json['familyName'] as String?
      ..dateStart = json['dateStart'] as int?
      ..dateFinish = json['dateFinish'] as int?
      ..picture = json['picture'] as String?
      ..squarePicture = json['squarePicture'] as String?
      ..type = $enumDecodeNullable(_$ActionTypeEnumMap, json['type'],
          unknownValue: ActionType.artemisUnknown)
      ..products = (json['products'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProduct.fromJson(e as Map<String, dynamic>))
          .toList()
      ..shops = (json['shops'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : GraphShop.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GraphActionCardToJson(GraphActionCard instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'specialConditions': instance.specialConditions,
      'description': instance.description,
      'uRL': instance.uRL,
      'familyName': instance.familyName,
      'dateStart': instance.dateStart,
      'dateFinish': instance.dateFinish,
      'picture': instance.picture,
      'squarePicture': instance.squarePicture,
      'type': _$ActionTypeEnumMap[instance.type],
      'products': instance.products?.map((e) => e?.toJson()).toList(),
      'shops': instance.shops?.map((e) => e?.toJson()).toList(),
    };

const _$ActionTypeEnumMap = {
  ActionType.simple: 'SIMPLE',
  ActionType.shop: 'SHOP',
  ActionType.product: 'PRODUCT',
  ActionType.poll: 'POLL',
  ActionType.drawing: 'DRAWING',
  ActionType.prize: 'PRIZE',
  ActionType.discount: 'DISCOUNT',
  ActionType.gift: 'GIFT',
  ActionType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GetAction$Query _$GetAction$QueryFromJson(Map<String, dynamic> json) =>
    GetAction$Query()
      ..getAction = json['getAction'] == null
          ? null
          : GraphActionCard.fromJson(json['getAction'] as Map<String, dynamic>);

Map<String, dynamic> _$GetAction$QueryToJson(GetAction$Query instance) =>
    <String, dynamic>{
      'getAction': instance.getAction?.toJson(),
    };

GraphPollAnswer _$GraphPollAnswerFromJson(Map<String, dynamic> json) =>
    GraphPollAnswer()
      ..iD = json['iD'] as int
      ..name = json['name'] as String;

Map<String, dynamic> _$GraphPollAnswerToJson(GraphPollAnswer instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
    };

GraphPoll _$GraphPollFromJson(Map<String, dynamic> json) => GraphPoll()
  ..iD = json['iD'] as int
  ..name = json['name'] as String
  ..comment = json['comment'] as String?
  ..isOther = json['isOther'] as bool
  ..isSkip = json['isSkip'] as bool
  ..isMultiple = json['isMultiple'] as bool
  ..isScale = json['isScale'] as bool
  ..scaleMin = json['scaleMin'] as int?
  ..scaleMax = json['scaleMax'] as int?
  ..pollAnswers = (json['pollAnswers'] as List<dynamic>?)
      ?.map((e) => e == null
          ? null
          : GraphPollAnswer.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GraphPollToJson(GraphPoll instance) => <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'comment': instance.comment,
      'isOther': instance.isOther,
      'isSkip': instance.isSkip,
      'isMultiple': instance.isMultiple,
      'isScale': instance.isScale,
      'scaleMin': instance.scaleMin,
      'scaleMax': instance.scaleMax,
      'pollAnswers': instance.pollAnswers?.map((e) => e?.toJson()).toList(),
    };

GetPoll$Query _$GetPoll$QueryFromJson(Map<String, dynamic> json) =>
    GetPoll$Query()
      ..getPoll = (json['getPoll'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : GraphPoll.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GetPoll$QueryToJson(GetPoll$Query instance) =>
    <String, dynamic>{
      'getPoll': instance.getPoll?.map((e) => e?.toJson()).toList(),
    };

GraphDrawLevel _$GraphDrawLevelFromJson(Map<String, dynamic> json) =>
    GraphDrawLevel()
      ..level = json['level'] as int
      ..position = json['position'] as int
      ..endPosition = json['endPosition'] as int;

Map<String, dynamic> _$GraphDrawLevelToJson(GraphDrawLevel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'position': instance.position,
      'endPosition': instance.endPosition,
    };

GraphDraw _$GraphDrawFromJson(Map<String, dynamic> json) => GraphDraw()
  ..iD = json['iD'] as int
  ..name = json['name'] as String
  ..description = json['description'] as String?
  ..uRL = json['uRL'] as String?
  ..dateStart = json['dateStart'] as int?
  ..dateFinish = json['dateFinish'] as int?
  ..specialConditions = json['specialConditions'] as String?
  ..picture = json['picture'] as String?
  ..pictureLevel = json['pictureLevel'] as String?
  ..drawMode = $enumDecodeNullable(_$DrawModeEnumMap, json['drawMode'],
      unknownValue: DrawMode.artemisUnknown)
  ..levels = (json['levels'] as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : GraphDrawLevel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$GraphDrawToJson(GraphDraw instance) => <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'description': instance.description,
      'uRL': instance.uRL,
      'dateStart': instance.dateStart,
      'dateFinish': instance.dateFinish,
      'specialConditions': instance.specialConditions,
      'picture': instance.picture,
      'pictureLevel': instance.pictureLevel,
      'drawMode': _$DrawModeEnumMap[instance.drawMode],
      'levels': instance.levels?.map((e) => e?.toJson()).toList(),
    };

const _$DrawModeEnumMap = {
  DrawMode.start: 'START',
  DrawMode.result: 'RESULT',
  DrawMode.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GetDraw$Query _$GetDraw$QueryFromJson(Map<String, dynamic> json) =>
    GetDraw$Query()
      ..getDraw = json['getDraw'] == null
          ? null
          : GraphDraw.fromJson(json['getDraw'] as Map<String, dynamic>);

Map<String, dynamic> _$GetDraw$QueryToJson(GetDraw$Query instance) =>
    <String, dynamic>{
      'getDraw': instance.getDraw?.toJson(),
    };

GraphPollResult _$GraphPollResultFromJson(Map<String, dynamic> json) =>
    GraphPollResult()
      ..result = json['result'] as int
      ..errorMessage = json['errorMessage'] as String?
      ..point = json['point'] as int;

Map<String, dynamic> _$GraphPollResultToJson(GraphPollResult instance) =>
    <String, dynamic>{
      'result': instance.result,
      'errorMessage': instance.errorMessage,
      'point': instance.point,
    };

SetDrawTakePart$Mutation _$SetDrawTakePart$MutationFromJson(
        Map<String, dynamic> json) =>
    SetDrawTakePart$Mutation()
      ..setDrawTakePart = json['setDrawTakePart'] == null
          ? null
          : GraphPollResult.fromJson(
              json['setDrawTakePart'] as Map<String, dynamic>);

Map<String, dynamic> _$SetDrawTakePart$MutationToJson(
        SetDrawTakePart$Mutation instance) =>
    <String, dynamic>{
      'setDrawTakePart': instance.setDrawTakePart?.toJson(),
    };

SetPollResult$Mutation _$SetPollResult$MutationFromJson(
        Map<String, dynamic> json) =>
    SetPollResult$Mutation()
      ..setPollResult = json['setPollResult'] == null
          ? null
          : GraphPollResult.fromJson(
              json['setPollResult'] as Map<String, dynamic>);

Map<String, dynamic> _$SetPollResult$MutationToJson(
        SetPollResult$Mutation instance) =>
    <String, dynamic>{
      'setPollResult': instance.setPollResult?.toJson(),
    };

GraphPollAnswersClient _$GraphPollAnswersClientFromJson(
        Map<String, dynamic> json) =>
    GraphPollAnswersClient(
      pollID: json['pollID'] as int,
      pollAnswers: (json['pollAnswers'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList(),
      other: json['other'] as String?,
      scale: json['scale'] as int?,
    );

Map<String, dynamic> _$GraphPollAnswersClientToJson(
        GraphPollAnswersClient instance) =>
    <String, dynamic>{
      'pollID': instance.pollID,
      'pollAnswers': instance.pollAnswers,
      'other': instance.other,
      'scale': instance.scale,
    };

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) => PageInfo()
  ..endCursor = json['endCursor'] as String?
  ..hasNextPage = json['hasNextPage'] as bool
  ..hasPreviousPage = json['hasPreviousPage'] as bool
  ..startCursor = json['startCursor'] as String?;

Map<String, dynamic> _$PageInfoToJson(PageInfo instance) => <String, dynamic>{
      'endCursor': instance.endCursor,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'startCursor': instance.startCursor,
    };

GraphProductConnection _$GraphProductConnectionFromJson(
        Map<String, dynamic> json) =>
    GraphProductConnection()
      ..totalCount = json['totalCount'] as int?
      ..pageInfo = PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>)
      ..items = (json['items'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProduct.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GraphProductConnectionToJson(
        GraphProductConnection instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'pageInfo': instance.pageInfo.toJson(),
      'items': instance.items?.map((e) => e?.toJson()).toList(),
    };

GetProducts$Query _$GetProducts$QueryFromJson(Map<String, dynamic> json) =>
    GetProducts$Query()
      ..getProducts = json['getProducts'] == null
          ? null
          : GraphProductConnection.fromJson(
              json['getProducts'] as Map<String, dynamic>);

Map<String, dynamic> _$GetProducts$QueryToJson(GetProducts$Query instance) =>
    <String, dynamic>{
      'getProducts': instance.getProducts?.toJson(),
    };

GraphFilter _$GraphFilterFromJson(Map<String, dynamic> json) => GraphFilter(
      sortType: $enumDecodeNullable(_$SortTypeEnumMap, json['sortType'],
          unknownValue: SortType.artemisUnknown),
      sortOrder: $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder'],
          unknownValue: SortOrder.artemisUnknown),
      priceMin: json['priceMin'] as int?,
      priceMax: json['priceMax'] as int?,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphFilterGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GraphFilterToJson(GraphFilter instance) =>
    <String, dynamic>{
      'sortType': _$SortTypeEnumMap[instance.sortType],
      'sortOrder': _$SortOrderEnumMap[instance.sortOrder],
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
      'groups': instance.groups?.map((e) => e?.toJson()).toList(),
    };

const _$SortTypeEnumMap = {
  SortType.kw$DEFAULT: 'DEFAULT',
  SortType.name: 'NAME',
  SortType.price: 'PRICE',
  SortType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

const _$SortOrderEnumMap = {
  SortOrder.asc: 'ASC',
  SortOrder.desc: 'DESC',
  SortOrder.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GraphFilterGroup _$GraphFilterGroupFromJson(Map<String, dynamic> json) =>
    GraphFilterGroup(
      iD: json['iD'] as int,
      values:
          (json['values'] as List<dynamic>?)?.map((e) => e as int?).toList(),
    );

Map<String, dynamic> _$GraphFilterGroupToJson(GraphFilterGroup instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'values': instance.values,
    };

GraphArticle _$GraphArticleFromJson(Map<String, dynamic> json) => GraphArticle()
  ..characteristicValueID = json['characteristicValueID'] as int?
  ..characteristicValue2ID = json['characteristicValue2ID'] as int?
  ..value = json['value'] as String;

Map<String, dynamic> _$GraphArticleToJson(GraphArticle instance) =>
    <String, dynamic>{
      'characteristicValueID': instance.characteristicValueID,
      'characteristicValue2ID': instance.characteristicValue2ID,
      'value': instance.value,
    };

GraphAward _$GraphAwardFromJson(Map<String, dynamic> json) => GraphAward()
  ..iD = json['iD'] as int
  ..name = json['name'] as String
  ..picture = json['picture'] as String;

Map<String, dynamic> _$GraphAwardToJson(GraphAward instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'picture': instance.picture,
    };

GraphCharacteristicValue _$GraphCharacteristicValueFromJson(
        Map<String, dynamic> json) =>
    GraphCharacteristicValue()
      ..iD = json['iD'] as int
      ..value = json['value'] as String
      ..comment = json['comment'] as String?;

Map<String, dynamic> _$GraphCharacteristicValueToJson(
        GraphCharacteristicValue instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'value': instance.value,
      'comment': instance.comment,
    };

GraphCharacteristic _$GraphCharacteristicFromJson(Map<String, dynamic> json) =>
    GraphCharacteristic()
      ..iD = json['iD'] as int
      ..name = json['name'] as String
      ..type = $enumDecodeNullable(_$CharacteristicTypeEnumMap, json['type'],
          unknownValue: CharacteristicType.artemisUnknown)
      ..isPrice = json['isPrice'] as bool
      ..values = (json['values'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphCharacteristicValue.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GraphCharacteristicToJson(
        GraphCharacteristic instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'name': instance.name,
      'type': _$CharacteristicTypeEnumMap[instance.type],
      'isPrice': instance.isPrice,
      'values': instance.values?.map((e) => e?.toJson()).toList(),
    };

const _$CharacteristicTypeEnumMap = {
  CharacteristicType.text: 'TEXT',
  CharacteristicType.volume: 'VOLUME',
  CharacteristicType.color: 'COLOR',
  CharacteristicType.size: 'SIZE',
  CharacteristicType.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

GraphProductPrice _$GraphProductPriceFromJson(Map<String, dynamic> json) =>
    GraphProductPrice()
      ..price = (json['price'] as num).toDouble()
      ..oldPrice = (json['oldPrice'] as num?)?.toDouble()
      ..characteristicValueID = json['characteristicValueID'] as int?;

Map<String, dynamic> _$GraphProductPriceToJson(GraphProductPrice instance) =>
    <String, dynamic>{
      'price': instance.price,
      'oldPrice': instance.oldPrice,
      'characteristicValueID': instance.characteristicValueID,
    };

GraphPicture _$GraphPictureFromJson(Map<String, dynamic> json) => GraphPicture()
  ..small = json['small'] as String
  ..full = json['full'] as String
  ..characteristicValueID = json['characteristicValueID'] as int?;

Map<String, dynamic> _$GraphPictureToJson(GraphPicture instance) =>
    <String, dynamic>{
      'small': instance.small,
      'full': instance.full,
      'characteristicValueID': instance.characteristicValueID,
    };

GraphComposition _$GraphCompositionFromJson(Map<String, dynamic> json) =>
    GraphComposition()
      ..description = json['description'] as String
      ..picture = json['picture'] as String?;

Map<String, dynamic> _$GraphCompositionToJson(GraphComposition instance) =>
    <String, dynamic>{
      'description': instance.description,
      'picture': instance.picture,
    };

GraphModifier _$GraphModifierFromJson(Map<String, dynamic> json) =>
    GraphModifier()..caption = json['caption'] as String?;

Map<String, dynamic> _$GraphModifierToJson(GraphModifier instance) =>
    <String, dynamic>{
      'caption': instance.caption,
    };

GraphProductReview _$GraphProductReviewFromJson(Map<String, dynamic> json) =>
    GraphProductReview()
      ..clientName = json['clientName'] as String?
      ..self = json['self'] as bool
      ..date = json['date'] as int
      ..text = json['text'] as String?
      ..mark = json['mark'] as int;

Map<String, dynamic> _$GraphProductReviewToJson(GraphProductReview instance) =>
    <String, dynamic>{
      'clientName': instance.clientName,
      'self': instance.self,
      'date': instance.date,
      'text': instance.text,
      'mark': instance.mark,
    };

GraphProductCard _$GraphProductCardFromJson(Map<String, dynamic> json) =>
    GraphProductCard()
      ..iD = json['iD'] as int
      ..type = $enumDecodeNullable(_$ProductTypeEnumMap, json['type'],
          unknownValue: ProductType.artemisUnknown)
      ..familyID = json['familyID'] as int
      ..topCatalogID = json['topCatalogID'] as int
      ..name = json['name'] as String
      ..comment = json['comment'] as String?
      ..description = json['description'] as String?
      ..application = json['application'] as String?
      ..composition = json['composition'] as String?
      ..isFavorite = json['isFavorite'] as bool
      ..favorites = json['favorites'] as int
      ..attributes = (json['attributes'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProductAttribute.fromJson(e as Map<String, dynamic>))
          .toList()
      ..articles = (json['articles'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphArticle.fromJson(e as Map<String, dynamic>))
          .toList()
      ..awards = (json['awards'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : GraphAward.fromJson(e as Map<String, dynamic>))
          .toList()
      ..characteristics = (json['characteristics'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphCharacteristic.fromJson(e as Map<String, dynamic>))
          .toList()
      ..prices = (json['prices'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProductPrice.fromJson(e as Map<String, dynamic>))
          .toList()
      ..pictures = (json['pictures'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphPicture.fromJson(e as Map<String, dynamic>))
          .toList()
      ..stickerPictures = (json['stickerPictures'] as List<dynamic>?)
          ?.map((e) => e as String?)
          .toList()
      ..compositions = (json['compositions'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphComposition.fromJson(e as Map<String, dynamic>))
          .toList()
      ..link = (json['link'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProduct.fromJson(e as Map<String, dynamic>))
          .toList()
      ..similar = (json['similar'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProduct.fromJson(e as Map<String, dynamic>))
          .toList()
      ..modifiers = (json['modifiers'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphModifier.fromJson(e as Map<String, dynamic>))
          .toList()
      ..reviews = (json['reviews'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphProductReview.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GraphProductCardToJson(GraphProductCard instance) =>
    <String, dynamic>{
      'iD': instance.iD,
      'type': _$ProductTypeEnumMap[instance.type],
      'familyID': instance.familyID,
      'topCatalogID': instance.topCatalogID,
      'name': instance.name,
      'comment': instance.comment,
      'description': instance.description,
      'application': instance.application,
      'composition': instance.composition,
      'isFavorite': instance.isFavorite,
      'favorites': instance.favorites,
      'attributes': instance.attributes?.map((e) => e?.toJson()).toList(),
      'articles': instance.articles?.map((e) => e?.toJson()).toList(),
      'awards': instance.awards?.map((e) => e?.toJson()).toList(),
      'characteristics':
          instance.characteristics?.map((e) => e?.toJson()).toList(),
      'prices': instance.prices?.map((e) => e?.toJson()).toList(),
      'pictures': instance.pictures?.map((e) => e?.toJson()).toList(),
      'stickerPictures': instance.stickerPictures,
      'compositions': instance.compositions?.map((e) => e?.toJson()).toList(),
      'link': instance.link?.map((e) => e?.toJson()).toList(),
      'similar': instance.similar?.map((e) => e?.toJson()).toList(),
      'modifiers': instance.modifiers?.map((e) => e?.toJson()).toList(),
      'reviews': instance.reviews?.map((e) => e?.toJson()).toList(),
    };

GetProduct$Query _$GetProduct$QueryFromJson(Map<String, dynamic> json) =>
    GetProduct$Query()
      ..getProduct = json['getProduct'] == null
          ? null
          : GraphProductCard.fromJson(
              json['getProduct'] as Map<String, dynamic>);

Map<String, dynamic> _$GetProduct$QueryToJson(GetProduct$Query instance) =>
    <String, dynamic>{
      'getProduct': instance.getProduct?.toJson(),
    };

GraphBasisResult _$GraphBasisResultFromJson(Map<String, dynamic> json) =>
    GraphBasisResult()..result = json['result'] as int;

Map<String, dynamic> _$GraphBasisResultToJson(GraphBasisResult instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

CartAdd$Mutation _$CartAdd$MutationFromJson(Map<String, dynamic> json) =>
    CartAdd$Mutation()
      ..cartAdd = json['cartAdd'] == null
          ? null
          : GraphBasisResult.fromJson(json['cartAdd'] as Map<String, dynamic>);

Map<String, dynamic> _$CartAdd$MutationToJson(CartAdd$Mutation instance) =>
    <String, dynamic>{
      'cartAdd': instance.cartAdd?.toJson(),
    };

SetFavoritesProduct$Mutation _$SetFavoritesProduct$MutationFromJson(
        Map<String, dynamic> json) =>
    SetFavoritesProduct$Mutation()
      ..setFavoritesProduct = json['setFavoritesProduct'] == null
          ? null
          : GraphBasisResult.fromJson(
              json['setFavoritesProduct'] as Map<String, dynamic>);

Map<String, dynamic> _$SetFavoritesProduct$MutationToJson(
        SetFavoritesProduct$Mutation instance) =>
    <String, dynamic>{
      'setFavoritesProduct': instance.setFavoritesProduct?.toJson(),
    };

GetActionArguments _$GetActionArgumentsFromJson(Map<String, dynamic> json) =>
    GetActionArguments(
      actionID: json['actionID'] as int?,
    );

Map<String, dynamic> _$GetActionArgumentsToJson(GetActionArguments instance) =>
    <String, dynamic>{
      'actionID': instance.actionID,
    };

GetPollArguments _$GetPollArgumentsFromJson(Map<String, dynamic> json) =>
    GetPollArguments(
      actionID: json['actionID'] as int?,
    );

Map<String, dynamic> _$GetPollArgumentsToJson(GetPollArguments instance) =>
    <String, dynamic>{
      'actionID': instance.actionID,
    };

GetDrawArguments _$GetDrawArgumentsFromJson(Map<String, dynamic> json) =>
    GetDrawArguments(
      actionID: json['actionID'] as int?,
    );

Map<String, dynamic> _$GetDrawArgumentsToJson(GetDrawArguments instance) =>
    <String, dynamic>{
      'actionID': instance.actionID,
    };

SetDrawTakePartArguments _$SetDrawTakePartArgumentsFromJson(
        Map<String, dynamic> json) =>
    SetDrawTakePartArguments(
      actionID: json['actionID'] as int?,
      mode: $enumDecodeNullable(_$DrawTakePartEnumMap, json['mode'],
          unknownValue: DrawTakePart.artemisUnknown),
    );

Map<String, dynamic> _$SetDrawTakePartArgumentsToJson(
        SetDrawTakePartArguments instance) =>
    <String, dynamic>{
      'actionID': instance.actionID,
      'mode': _$DrawTakePartEnumMap[instance.mode],
    };

const _$DrawTakePartEnumMap = {
  DrawTakePart.wait: 'WAIT',
  DrawTakePart.yes: 'YES',
  DrawTakePart.no: 'NO',
  DrawTakePart.artemisUnknown: 'ARTEMIS_UNKNOWN',
};

SetPollResultArguments _$SetPollResultArgumentsFromJson(
        Map<String, dynamic> json) =>
    SetPollResultArguments(
      actionID: json['actionID'] as int?,
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GraphPollAnswersClient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SetPollResultArgumentsToJson(
        SetPollResultArguments instance) =>
    <String, dynamic>{
      'actionID': instance.actionID,
      'answers': instance.answers?.map((e) => e?.toJson()).toList(),
    };

GetProductsArguments _$GetProductsArgumentsFromJson(
        Map<String, dynamic> json) =>
    GetProductsArguments(
      catalogID: json['catalogID'] as int,
      cursor: json['cursor'] as String?,
      filter: json['filter'] == null
          ? null
          : GraphFilter.fromJson(json['filter'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetProductsArgumentsToJson(
        GetProductsArguments instance) =>
    <String, dynamic>{
      'catalogID': instance.catalogID,
      'cursor': instance.cursor,
      'filter': instance.filter?.toJson(),
    };

GetProductArguments _$GetProductArgumentsFromJson(Map<String, dynamic> json) =>
    GetProductArguments(
      productID: json['productID'] as int,
    );

Map<String, dynamic> _$GetProductArgumentsToJson(
        GetProductArguments instance) =>
    <String, dynamic>{
      'productID': instance.productID,
    };

CartAddArguments _$CartAddArgumentsFromJson(Map<String, dynamic> json) =>
    CartAddArguments(
      productID: json['productID'] as int,
      characteristicValueIds: (json['characteristicValueIds'] as List<dynamic>?)
          ?.map((e) => e as int?)
          .toList(),
    );

Map<String, dynamic> _$CartAddArgumentsToJson(CartAddArguments instance) =>
    <String, dynamic>{
      'productID': instance.productID,
      'characteristicValueIds': instance.characteristicValueIds,
    };

SetFavoritesProductArguments _$SetFavoritesProductArgumentsFromJson(
        Map<String, dynamic> json) =>
    SetFavoritesProductArguments(
      productID: json['productID'] as int,
    );

Map<String, dynamic> _$SetFavoritesProductArgumentsToJson(
        SetFavoritesProductArguments instance) =>
    <String, dynamic>{
      'productID': instance.productID,
    };
