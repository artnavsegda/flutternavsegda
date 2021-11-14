// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart = 2.12

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'levrana.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class GraphProductAttribute extends JsonSerializable with EquatableMixin {
  GraphProductAttribute();

  factory GraphProductAttribute.fromJson(Map<String, dynamic> json) =>
      _$GraphProductAttributeFromJson(json);

  late int iD;

  late String name;

  late String color;

  @override
  List<Object?> get props => [iD, name, color];
  @override
  Map<String, dynamic> toJson() => _$GraphProductAttributeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphProduct extends JsonSerializable with EquatableMixin {
  GraphProduct();

  factory GraphProduct.fromJson(Map<String, dynamic> json) =>
      _$GraphProductFromJson(json);

  late int iD;

  @JsonKey(unknownEnumValue: ProductType.artemisUnknown)
  ProductType? type;

  late int familyID;

  late int topCatalogID;

  late String name;

  String? picture;

  late bool isFavorite;

  late int favorites;

  List<String?>? stickerPictures;

  List<GraphProductAttribute?>? attributes;

  @override
  List<Object?> get props => [
        iD,
        type,
        familyID,
        topCatalogID,
        name,
        picture,
        isFavorite,
        favorites,
        stickerPictures,
        attributes
      ];
  @override
  Map<String, dynamic> toJson() => _$GraphProductToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphMetroStation extends JsonSerializable with EquatableMixin {
  GraphMetroStation();

  factory GraphMetroStation.fromJson(Map<String, dynamic> json) =>
      _$GraphMetroStationFromJson(json);

  late String lineName;

  late String colorLine;

  late String stationName;

  late String distance;

  @override
  List<Object?> get props => [lineName, colorLine, stationName, distance];
  @override
  Map<String, dynamic> toJson() => _$GraphMetroStationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphOpeningHours extends JsonSerializable with EquatableMixin {
  GraphOpeningHours();

  factory GraphOpeningHours.fromJson(Map<String, dynamic> json) =>
      _$GraphOpeningHoursFromJson(json);

  late int weekDay;

  int? start;

  int? finish;

  @override
  List<Object?> get props => [weekDay, start, finish];
  @override
  Map<String, dynamic> toJson() => _$GraphOpeningHoursToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphShop extends JsonSerializable with EquatableMixin {
  GraphShop();

  factory GraphShop.fromJson(Map<String, dynamic> json) =>
      _$GraphShopFromJson(json);

  late int iD;

  late String name;

  String? description;

  String? address;

  double? longitude;

  double? latitude;

  int? start;

  int? finish;

  late int regionId;

  late String regionName;

  List<String?>? pictures;

  List<GraphMetroStation?>? metroStations;

  List<GraphOpeningHours?>? openingHours;

  @override
  List<Object?> get props => [
        iD,
        name,
        description,
        address,
        longitude,
        latitude,
        start,
        finish,
        regionId,
        regionName,
        pictures,
        metroStations,
        openingHours
      ];
  @override
  Map<String, dynamic> toJson() => _$GraphShopToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphActionCard extends JsonSerializable with EquatableMixin {
  GraphActionCard();

  factory GraphActionCard.fromJson(Map<String, dynamic> json) =>
      _$GraphActionCardFromJson(json);

  late int iD;

  late String name;

  String? specialConditions;

  String? description;

  String? uRL;

  String? familyName;

  int? dateStart;

  int? dateFinish;

  String? picture;

  String? squarePicture;

  @JsonKey(unknownEnumValue: ActionType.artemisUnknown)
  ActionType? type;

  List<GraphProduct?>? products;

  List<GraphShop?>? shops;

  @override
  List<Object?> get props => [
        iD,
        name,
        specialConditions,
        description,
        uRL,
        familyName,
        dateStart,
        dateFinish,
        picture,
        squarePicture,
        type,
        products,
        shops
      ];
  @override
  Map<String, dynamic> toJson() => _$GraphActionCardToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetAction$Query extends JsonSerializable with EquatableMixin {
  GetAction$Query();

  factory GetAction$Query.fromJson(Map<String, dynamic> json) =>
      _$GetAction$QueryFromJson(json);

  GraphActionCard? getAction;

  @override
  List<Object?> get props => [getAction];
  @override
  Map<String, dynamic> toJson() => _$GetAction$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphPollAnswer extends JsonSerializable with EquatableMixin {
  GraphPollAnswer();

  factory GraphPollAnswer.fromJson(Map<String, dynamic> json) =>
      _$GraphPollAnswerFromJson(json);

  late int iD;

  late String name;

  @override
  List<Object?> get props => [iD, name];
  @override
  Map<String, dynamic> toJson() => _$GraphPollAnswerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphPoll extends JsonSerializable with EquatableMixin {
  GraphPoll();

  factory GraphPoll.fromJson(Map<String, dynamic> json) =>
      _$GraphPollFromJson(json);

  late int iD;

  late String name;

  String? comment;

  late bool isOther;

  late bool isSkip;

  late bool isMultiple;

  late bool isScale;

  int? scaleMin;

  int? scaleMax;

  List<GraphPollAnswer?>? pollAnswers;

  @override
  List<Object?> get props => [
        iD,
        name,
        comment,
        isOther,
        isSkip,
        isMultiple,
        isScale,
        scaleMin,
        scaleMax,
        pollAnswers
      ];
  @override
  Map<String, dynamic> toJson() => _$GraphPollToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPoll$Query extends JsonSerializable with EquatableMixin {
  GetPoll$Query();

  factory GetPoll$Query.fromJson(Map<String, dynamic> json) =>
      _$GetPoll$QueryFromJson(json);

  List<GraphPoll?>? getPoll;

  @override
  List<Object?> get props => [getPoll];
  @override
  Map<String, dynamic> toJson() => _$GetPoll$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphDrawLevel extends JsonSerializable with EquatableMixin {
  GraphDrawLevel();

  factory GraphDrawLevel.fromJson(Map<String, dynamic> json) =>
      _$GraphDrawLevelFromJson(json);

  late int level;

  late int position;

  late int endPosition;

  @override
  List<Object?> get props => [level, position, endPosition];
  @override
  Map<String, dynamic> toJson() => _$GraphDrawLevelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphDraw extends JsonSerializable with EquatableMixin {
  GraphDraw();

  factory GraphDraw.fromJson(Map<String, dynamic> json) =>
      _$GraphDrawFromJson(json);

  late int iD;

  late String name;

  String? description;

  String? uRL;

  int? dateStart;

  int? dateFinish;

  String? specialConditions;

  String? picture;

  String? pictureLevel;

  @JsonKey(unknownEnumValue: DrawMode.artemisUnknown)
  DrawMode? drawMode;

  List<GraphDrawLevel?>? levels;

  @override
  List<Object?> get props => [
        iD,
        name,
        description,
        uRL,
        dateStart,
        dateFinish,
        specialConditions,
        picture,
        pictureLevel,
        drawMode,
        levels
      ];
  @override
  Map<String, dynamic> toJson() => _$GraphDrawToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetDraw$Query extends JsonSerializable with EquatableMixin {
  GetDraw$Query();

  factory GetDraw$Query.fromJson(Map<String, dynamic> json) =>
      _$GetDraw$QueryFromJson(json);

  GraphDraw? getDraw;

  @override
  List<Object?> get props => [getDraw];
  @override
  Map<String, dynamic> toJson() => _$GetDraw$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphPollResult extends JsonSerializable with EquatableMixin {
  GraphPollResult();

  factory GraphPollResult.fromJson(Map<String, dynamic> json) =>
      _$GraphPollResultFromJson(json);

  late int result;

  String? errorMessage;

  late int point;

  @override
  List<Object?> get props => [result, errorMessage, point];
  @override
  Map<String, dynamic> toJson() => _$GraphPollResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetDrawTakePart$Mutation extends JsonSerializable with EquatableMixin {
  SetDrawTakePart$Mutation();

  factory SetDrawTakePart$Mutation.fromJson(Map<String, dynamic> json) =>
      _$SetDrawTakePart$MutationFromJson(json);

  GraphPollResult? setDrawTakePart;

  @override
  List<Object?> get props => [setDrawTakePart];
  @override
  Map<String, dynamic> toJson() => _$SetDrawTakePart$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetPollResult$Mutation extends JsonSerializable with EquatableMixin {
  SetPollResult$Mutation();

  factory SetPollResult$Mutation.fromJson(Map<String, dynamic> json) =>
      _$SetPollResult$MutationFromJson(json);

  GraphPollResult? setPollResult;

  @override
  List<Object?> get props => [setPollResult];
  @override
  Map<String, dynamic> toJson() => _$SetPollResult$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphPollAnswersClient extends JsonSerializable with EquatableMixin {
  GraphPollAnswersClient(
      {required this.pollID, this.pollAnswers, this.other, this.scale});

  factory GraphPollAnswersClient.fromJson(Map<String, dynamic> json) =>
      _$GraphPollAnswersClientFromJson(json);

  late int pollID;

  List<int?>? pollAnswers;

  String? other;

  int? scale;

  @override
  List<Object?> get props => [pollID, pollAnswers, other, scale];
  @override
  Map<String, dynamic> toJson() => _$GraphPollAnswersClientToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PageInfo extends JsonSerializable with EquatableMixin {
  PageInfo();

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);

  String? endCursor;

  late bool hasNextPage;

  late bool hasPreviousPage;

  String? startCursor;

  @override
  List<Object?> get props =>
      [endCursor, hasNextPage, hasPreviousPage, startCursor];
  @override
  Map<String, dynamic> toJson() => _$PageInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphProductConnection extends JsonSerializable with EquatableMixin {
  GraphProductConnection();

  factory GraphProductConnection.fromJson(Map<String, dynamic> json) =>
      _$GraphProductConnectionFromJson(json);

  int? totalCount;

  late PageInfo pageInfo;

  List<GraphProduct?>? items;

  @override
  List<Object?> get props => [totalCount, pageInfo, items];
  @override
  Map<String, dynamic> toJson() => _$GraphProductConnectionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetProducts$Query extends JsonSerializable with EquatableMixin {
  GetProducts$Query();

  factory GetProducts$Query.fromJson(Map<String, dynamic> json) =>
      _$GetProducts$QueryFromJson(json);

  GraphProductConnection? getProducts;

  @override
  List<Object?> get props => [getProducts];
  @override
  Map<String, dynamic> toJson() => _$GetProducts$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphFilter extends JsonSerializable with EquatableMixin {
  GraphFilter(
      {this.sortType,
      this.sortOrder,
      this.priceMin,
      this.priceMax,
      this.groups});

  factory GraphFilter.fromJson(Map<String, dynamic> json) =>
      _$GraphFilterFromJson(json);

  @JsonKey(unknownEnumValue: SortType.artemisUnknown)
  SortType? sortType;

  @JsonKey(unknownEnumValue: SortOrder.artemisUnknown)
  SortOrder? sortOrder;

  int? priceMin;

  int? priceMax;

  List<GraphFilterGroup?>? groups;

  @override
  List<Object?> get props => [sortType, sortOrder, priceMin, priceMax, groups];
  @override
  Map<String, dynamic> toJson() => _$GraphFilterToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphFilterGroup extends JsonSerializable with EquatableMixin {
  GraphFilterGroup({required this.iD, this.values});

  factory GraphFilterGroup.fromJson(Map<String, dynamic> json) =>
      _$GraphFilterGroupFromJson(json);

  late int iD;

  List<int?>? values;

  @override
  List<Object?> get props => [iD, values];
  @override
  Map<String, dynamic> toJson() => _$GraphFilterGroupToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphArticle extends JsonSerializable with EquatableMixin {
  GraphArticle();

  factory GraphArticle.fromJson(Map<String, dynamic> json) =>
      _$GraphArticleFromJson(json);

  int? characteristicValueID;

  int? characteristicValue2ID;

  late String value;

  @override
  List<Object?> get props =>
      [characteristicValueID, characteristicValue2ID, value];
  @override
  Map<String, dynamic> toJson() => _$GraphArticleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphAward extends JsonSerializable with EquatableMixin {
  GraphAward();

  factory GraphAward.fromJson(Map<String, dynamic> json) =>
      _$GraphAwardFromJson(json);

  late int iD;

  late String name;

  late String picture;

  @override
  List<Object?> get props => [iD, name, picture];
  @override
  Map<String, dynamic> toJson() => _$GraphAwardToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphCharacteristicValue extends JsonSerializable with EquatableMixin {
  GraphCharacteristicValue();

  factory GraphCharacteristicValue.fromJson(Map<String, dynamic> json) =>
      _$GraphCharacteristicValueFromJson(json);

  late int iD;

  late String value;

  String? comment;

  @override
  List<Object?> get props => [iD, value, comment];
  @override
  Map<String, dynamic> toJson() => _$GraphCharacteristicValueToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphCharacteristic extends JsonSerializable with EquatableMixin {
  GraphCharacteristic();

  factory GraphCharacteristic.fromJson(Map<String, dynamic> json) =>
      _$GraphCharacteristicFromJson(json);

  late int iD;

  late String name;

  @JsonKey(unknownEnumValue: CharacteristicType.artemisUnknown)
  CharacteristicType? type;

  late bool isPrice;

  List<GraphCharacteristicValue?>? values;

  @override
  List<Object?> get props => [iD, name, type, isPrice, values];
  @override
  Map<String, dynamic> toJson() => _$GraphCharacteristicToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphProductPrice extends JsonSerializable with EquatableMixin {
  GraphProductPrice();

  factory GraphProductPrice.fromJson(Map<String, dynamic> json) =>
      _$GraphProductPriceFromJson(json);

  late double price;

  double? oldPrice;

  int? characteristicValueID;

  @override
  List<Object?> get props => [price, oldPrice, characteristicValueID];
  @override
  Map<String, dynamic> toJson() => _$GraphProductPriceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphPicture extends JsonSerializable with EquatableMixin {
  GraphPicture();

  factory GraphPicture.fromJson(Map<String, dynamic> json) =>
      _$GraphPictureFromJson(json);

  late String small;

  late String full;

  int? characteristicValueID;

  @override
  List<Object?> get props => [small, full, characteristicValueID];
  @override
  Map<String, dynamic> toJson() => _$GraphPictureToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphComposition extends JsonSerializable with EquatableMixin {
  GraphComposition();

  factory GraphComposition.fromJson(Map<String, dynamic> json) =>
      _$GraphCompositionFromJson(json);

  late String description;

  String? picture;

  @override
  List<Object?> get props => [description, picture];
  @override
  Map<String, dynamic> toJson() => _$GraphCompositionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphModifier extends JsonSerializable with EquatableMixin {
  GraphModifier();

  factory GraphModifier.fromJson(Map<String, dynamic> json) =>
      _$GraphModifierFromJson(json);

  String? caption;

  @override
  List<Object?> get props => [caption];
  @override
  Map<String, dynamic> toJson() => _$GraphModifierToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphProductReview extends JsonSerializable with EquatableMixin {
  GraphProductReview();

  factory GraphProductReview.fromJson(Map<String, dynamic> json) =>
      _$GraphProductReviewFromJson(json);

  String? clientName;

  late bool self;

  late int date;

  String? text;

  late int mark;

  @override
  List<Object?> get props => [clientName, self, date, text, mark];
  @override
  Map<String, dynamic> toJson() => _$GraphProductReviewToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphProductCard extends JsonSerializable with EquatableMixin {
  GraphProductCard();

  factory GraphProductCard.fromJson(Map<String, dynamic> json) =>
      _$GraphProductCardFromJson(json);

  late int iD;

  @JsonKey(unknownEnumValue: ProductType.artemisUnknown)
  ProductType? type;

  late int familyID;

  late int topCatalogID;

  late String name;

  String? comment;

  String? description;

  String? application;

  String? composition;

  late bool isFavorite;

  late int favorites;

  List<GraphProductAttribute?>? attributes;

  List<GraphArticle?>? articles;

  List<GraphAward?>? awards;

  List<GraphCharacteristic?>? characteristics;

  List<GraphProductPrice?>? prices;

  List<GraphPicture?>? pictures;

  List<String?>? stickerPictures;

  List<GraphComposition?>? compositions;

  List<GraphProduct?>? link;

  List<GraphProduct?>? similar;

  List<GraphModifier?>? modifiers;

  List<GraphProductReview?>? reviews;

  @override
  List<Object?> get props => [
        iD,
        type,
        familyID,
        topCatalogID,
        name,
        comment,
        description,
        application,
        composition,
        isFavorite,
        favorites,
        attributes,
        articles,
        awards,
        characteristics,
        prices,
        pictures,
        stickerPictures,
        compositions,
        link,
        similar,
        modifiers,
        reviews
      ];
  @override
  Map<String, dynamic> toJson() => _$GraphProductCardToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetProduct$Query extends JsonSerializable with EquatableMixin {
  GetProduct$Query();

  factory GetProduct$Query.fromJson(Map<String, dynamic> json) =>
      _$GetProduct$QueryFromJson(json);

  GraphProductCard? getProduct;

  @override
  List<Object?> get props => [getProduct];
  @override
  Map<String, dynamic> toJson() => _$GetProduct$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GraphBasisResult extends JsonSerializable with EquatableMixin {
  GraphBasisResult();

  factory GraphBasisResult.fromJson(Map<String, dynamic> json) =>
      _$GraphBasisResultFromJson(json);

  late int result;

  @override
  List<Object?> get props => [result];
  @override
  Map<String, dynamic> toJson() => _$GraphBasisResultToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CartAdd$Mutation extends JsonSerializable with EquatableMixin {
  CartAdd$Mutation();

  factory CartAdd$Mutation.fromJson(Map<String, dynamic> json) =>
      _$CartAdd$MutationFromJson(json);

  GraphBasisResult? cartAdd;

  @override
  List<Object?> get props => [cartAdd];
  @override
  Map<String, dynamic> toJson() => _$CartAdd$MutationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SetFavoritesProduct$Mutation extends JsonSerializable
    with EquatableMixin {
  SetFavoritesProduct$Mutation();

  factory SetFavoritesProduct$Mutation.fromJson(Map<String, dynamic> json) =>
      _$SetFavoritesProduct$MutationFromJson(json);

  GraphBasisResult? setFavoritesProduct;

  @override
  List<Object?> get props => [setFavoritesProduct];
  @override
  Map<String, dynamic> toJson() => _$SetFavoritesProduct$MutationToJson(this);
}

enum ActionType {
  @JsonValue('SIMPLE')
  simple,
  @JsonValue('SHOP')
  shop,
  @JsonValue('PRODUCT')
  product,
  @JsonValue('POLL')
  poll,
  @JsonValue('DRAWING')
  drawing,
  @JsonValue('PRIZE')
  prize,
  @JsonValue('DISCOUNT')
  discount,
  @JsonValue('GIFT')
  gift,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum ProductType {
  @JsonValue('SIMPLE')
  simple,
  @JsonValue('ADDITION')
  addition,
  @JsonValue('SET')
  kw$SET,
  @JsonValue('BOX')
  box,
  @JsonValue('MODIFICATOR')
  modificator,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum DrawMode {
  @JsonValue('START')
  start,
  @JsonValue('RESULT')
  result,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum DrawTakePart {
  @JsonValue('WAIT')
  wait,
  @JsonValue('YES')
  yes,
  @JsonValue('NO')
  no,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum SortType {
  @JsonValue('DEFAULT')
  kw$DEFAULT,
  @JsonValue('NAME')
  name,
  @JsonValue('PRICE')
  price,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum SortOrder {
  @JsonValue('ASC')
  asc,
  @JsonValue('DESC')
  desc,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}
enum CharacteristicType {
  @JsonValue('TEXT')
  text,
  @JsonValue('VOLUME')
  volume,
  @JsonValue('COLOR')
  color,
  @JsonValue('SIZE')
  size,
  @JsonValue('ARTEMIS_UNKNOWN')
  artemisUnknown,
}

@JsonSerializable(explicitToJson: true)
class GetActionArguments extends JsonSerializable with EquatableMixin {
  GetActionArguments({this.actionID});

  @override
  factory GetActionArguments.fromJson(Map<String, dynamic> json) =>
      _$GetActionArgumentsFromJson(json);

  final int? actionID;

  @override
  List<Object?> get props => [actionID];
  @override
  Map<String, dynamic> toJson() => _$GetActionArgumentsToJson(this);
}

final GET_ACTION_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'getAction'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'actionID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'getAction'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'actionID'),
                  value: VariableNode(name: NameNode(value: 'actionID')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'iD'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'specialConditions'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'description'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'uRL'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'familyName'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'dateStart'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'dateFinish'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'picture'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'squarePicture'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'type'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'products'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'familyID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'topCatalogID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'picture'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'isFavorite'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'favorites'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'stickerPictures'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'attributes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'iD'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'color'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ]))
                  ])),
              FieldNode(
                  name: NameNode(value: 'shops'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'description'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'address'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'longitude'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'latitude'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'start'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'finish'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'regionId'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'regionName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'pictures'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'metroStations'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'lineName'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'colorLine'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'stationName'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'distance'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ])),
                    FieldNode(
                        name: NameNode(value: 'openingHours'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'weekDay'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'start'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'finish'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ]))
                  ]))
            ]))
      ]))
]);

class GetActionQuery extends GraphQLQuery<GetAction$Query, GetActionArguments> {
  GetActionQuery({required this.variables});

  @override
  final DocumentNode document = GET_ACTION_QUERY_DOCUMENT;

  @override
  final String operationName = 'getAction';

  @override
  final GetActionArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  GetAction$Query parse(Map<String, dynamic> json) =>
      GetAction$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetPollArguments extends JsonSerializable with EquatableMixin {
  GetPollArguments({this.actionID});

  @override
  factory GetPollArguments.fromJson(Map<String, dynamic> json) =>
      _$GetPollArgumentsFromJson(json);

  final int? actionID;

  @override
  List<Object?> get props => [actionID];
  @override
  Map<String, dynamic> toJson() => _$GetPollArgumentsToJson(this);
}

final GET_POLL_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'getPoll'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'actionID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'getPoll'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'actionID'),
                  value: VariableNode(name: NameNode(value: 'actionID')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'iD'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'comment'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'isOther'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'isSkip'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'isMultiple'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'isScale'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'scaleMin'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'scaleMax'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'pollAnswers'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ]))
            ]))
      ]))
]);

class GetPollQuery extends GraphQLQuery<GetPoll$Query, GetPollArguments> {
  GetPollQuery({required this.variables});

  @override
  final DocumentNode document = GET_POLL_QUERY_DOCUMENT;

  @override
  final String operationName = 'getPoll';

  @override
  final GetPollArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  GetPoll$Query parse(Map<String, dynamic> json) =>
      GetPoll$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetDrawArguments extends JsonSerializable with EquatableMixin {
  GetDrawArguments({this.actionID});

  @override
  factory GetDrawArguments.fromJson(Map<String, dynamic> json) =>
      _$GetDrawArgumentsFromJson(json);

  final int? actionID;

  @override
  List<Object?> get props => [actionID];
  @override
  Map<String, dynamic> toJson() => _$GetDrawArgumentsToJson(this);
}

final GET_DRAW_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'getDraw'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'actionID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'getDraw'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'actionID'),
                  value: VariableNode(name: NameNode(value: 'actionID')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'iD'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'description'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'uRL'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'dateStart'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'dateFinish'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'specialConditions'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'picture'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'pictureLevel'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'drawMode'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'levels'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'level'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'position'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'endPosition'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ]))
            ]))
      ]))
]);

class GetDrawQuery extends GraphQLQuery<GetDraw$Query, GetDrawArguments> {
  GetDrawQuery({required this.variables});

  @override
  final DocumentNode document = GET_DRAW_QUERY_DOCUMENT;

  @override
  final String operationName = 'getDraw';

  @override
  final GetDrawArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  GetDraw$Query parse(Map<String, dynamic> json) =>
      GetDraw$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SetDrawTakePartArguments extends JsonSerializable with EquatableMixin {
  SetDrawTakePartArguments({this.actionID, this.mode});

  @override
  factory SetDrawTakePartArguments.fromJson(Map<String, dynamic> json) =>
      _$SetDrawTakePartArgumentsFromJson(json);

  final int? actionID;

  @JsonKey(unknownEnumValue: DrawTakePart.artemisUnknown)
  final DrawTakePart? mode;

  @override
  List<Object?> get props => [actionID, mode];
  @override
  Map<String, dynamic> toJson() => _$SetDrawTakePartArgumentsToJson(this);
}

final SET_DRAW_TAKE_PART_MUTATION_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setDrawTakePart'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'actionID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'mode')),
            type: NamedTypeNode(
                name: NameNode(value: 'DrawTakePart'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'setDrawTakePart'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'actionID'),
                  value: VariableNode(name: NameNode(value: 'actionID'))),
              ArgumentNode(
                  name: NameNode(value: 'mode'),
                  value: VariableNode(name: NameNode(value: 'mode')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'result'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'errorMessage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'point'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ]))
      ]))
]);

class SetDrawTakePartMutation
    extends GraphQLQuery<SetDrawTakePart$Mutation, SetDrawTakePartArguments> {
  SetDrawTakePartMutation({required this.variables});

  @override
  final DocumentNode document = SET_DRAW_TAKE_PART_MUTATION_DOCUMENT;

  @override
  final String operationName = 'setDrawTakePart';

  @override
  final SetDrawTakePartArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  SetDrawTakePart$Mutation parse(Map<String, dynamic> json) =>
      SetDrawTakePart$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SetPollResultArguments extends JsonSerializable with EquatableMixin {
  SetPollResultArguments({this.actionID, this.answers});

  @override
  factory SetPollResultArguments.fromJson(Map<String, dynamic> json) =>
      _$SetPollResultArgumentsFromJson(json);

  final int? actionID;

  final List<GraphPollAnswersClient?>? answers;

  @override
  List<Object?> get props => [actionID, answers];
  @override
  Map<String, dynamic> toJson() => _$SetPollResultArgumentsToJson(this);
}

final SET_POLL_RESULT_MUTATION_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setPollResult'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'actionID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'answers')),
            type: ListTypeNode(
                type: NamedTypeNode(
                    name: NameNode(value: 'graphPollAnswersClient'),
                    isNonNull: false),
                isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'setPollResult'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'actionID'),
                  value: VariableNode(name: NameNode(value: 'actionID'))),
              ArgumentNode(
                  name: NameNode(value: 'answers'),
                  value: VariableNode(name: NameNode(value: 'answers')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'result'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'errorMessage'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'point'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ]))
      ]))
]);

class SetPollResultMutation
    extends GraphQLQuery<SetPollResult$Mutation, SetPollResultArguments> {
  SetPollResultMutation({required this.variables});

  @override
  final DocumentNode document = SET_POLL_RESULT_MUTATION_DOCUMENT;

  @override
  final String operationName = 'setPollResult';

  @override
  final SetPollResultArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  SetPollResult$Mutation parse(Map<String, dynamic> json) =>
      SetPollResult$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetProductsArguments extends JsonSerializable with EquatableMixin {
  GetProductsArguments({required this.catalogID, this.cursor, this.filter});

  @override
  factory GetProductsArguments.fromJson(Map<String, dynamic> json) =>
      _$GetProductsArgumentsFromJson(json);

  late int catalogID;

  final String? cursor;

  final GraphFilter? filter;

  @override
  List<Object?> get props => [catalogID, cursor, filter];
  @override
  Map<String, dynamic> toJson() => _$GetProductsArgumentsToJson(this);
}

final GET_PRODUCTS_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'getProducts'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'catalogID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'cursor')),
            type: NamedTypeNode(
                name: NameNode(value: 'String'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'filter')),
            type: NamedTypeNode(
                name: NameNode(value: 'graphFilter'), isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'getProducts'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'catalogID'),
                  value: VariableNode(name: NameNode(value: 'catalogID'))),
              ArgumentNode(
                  name: NameNode(value: 'first'),
                  value: IntValueNode(value: '45')),
              ArgumentNode(
                  name: NameNode(value: 'after'),
                  value: VariableNode(name: NameNode(value: 'cursor'))),
              ArgumentNode(
                  name: NameNode(value: 'filter'),
                  value: VariableNode(name: NameNode(value: 'filter')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'totalCount'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'pageInfo'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'endCursor'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'hasNextPage'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'hasPreviousPage'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'startCursor'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'items'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'familyID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'topCatalogID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'picture'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'isFavorite'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'favorites'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'stickerPictures'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'attributes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'iD'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'color'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ]))
                  ]))
            ]))
      ]))
]);

class GetProductsQuery
    extends GraphQLQuery<GetProducts$Query, GetProductsArguments> {
  GetProductsQuery({required this.variables});

  @override
  final DocumentNode document = GET_PRODUCTS_QUERY_DOCUMENT;

  @override
  final String operationName = 'getProducts';

  @override
  final GetProductsArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  GetProducts$Query parse(Map<String, dynamic> json) =>
      GetProducts$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class GetProductArguments extends JsonSerializable with EquatableMixin {
  GetProductArguments({required this.productID});

  @override
  factory GetProductArguments.fromJson(Map<String, dynamic> json) =>
      _$GetProductArgumentsFromJson(json);

  late int productID;

  @override
  List<Object?> get props => [productID];
  @override
  Map<String, dynamic> toJson() => _$GetProductArgumentsToJson(this);
}

final GET_PRODUCT_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'getProduct'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'productID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'getProduct'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'productID'),
                  value: VariableNode(name: NameNode(value: 'productID')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'iD'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'type'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'familyID'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'topCatalogID'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'comment'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'description'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'application'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'composition'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'isFavorite'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'favorites'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'attributes'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'color'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'articles'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'characteristicValueID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'characteristicValue2ID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'value'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'awards'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'picture'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'characteristics'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'isPrice'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'values'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'iD'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'value'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'comment'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ]))
                  ])),
              FieldNode(
                  name: NameNode(value: 'prices'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'price'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'oldPrice'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'characteristicValueID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'pictures'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'small'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'full'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'characteristicValueID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'stickerPictures'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'compositions'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'description'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'picture'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'link'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'familyID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'topCatalogID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'picture'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'isFavorite'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'favorites'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'stickerPictures'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'attributes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'iD'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'color'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ]))
                  ])),
              FieldNode(
                  name: NameNode(value: 'similar'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'iD'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'familyID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'topCatalogID'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'picture'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'isFavorite'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'favorites'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'stickerPictures'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'attributes'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(selections: [
                          FieldNode(
                              name: NameNode(value: 'iD'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null),
                          FieldNode(
                              name: NameNode(value: 'color'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null)
                        ]))
                  ])),
              FieldNode(
                  name: NameNode(value: 'modifiers'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'caption'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'reviews'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'clientName'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'self'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'date'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'text'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'mark'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ]))
            ]))
      ]))
]);

class GetProductQuery
    extends GraphQLQuery<GetProduct$Query, GetProductArguments> {
  GetProductQuery({required this.variables});

  @override
  final DocumentNode document = GET_PRODUCT_QUERY_DOCUMENT;

  @override
  final String operationName = 'getProduct';

  @override
  final GetProductArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  GetProduct$Query parse(Map<String, dynamic> json) =>
      GetProduct$Query.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class CartAddArguments extends JsonSerializable with EquatableMixin {
  CartAddArguments({required this.productID, this.characteristicValueIds});

  @override
  factory CartAddArguments.fromJson(Map<String, dynamic> json) =>
      _$CartAddArgumentsFromJson(json);

  late int productID;

  final List<int?>? characteristicValueIds;

  @override
  List<Object?> get props => [productID, characteristicValueIds];
  @override
  Map<String, dynamic> toJson() => _$CartAddArgumentsToJson(this);
}

final CART_ADD_MUTATION_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'cartAdd'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'productID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: []),
        VariableDefinitionNode(
            variable:
                VariableNode(name: NameNode(value: 'characteristicValueIds')),
            type: ListTypeNode(
                type: NamedTypeNode(
                    name: NameNode(value: 'Int'), isNonNull: false),
                isNonNull: false),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'cartAdd'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'cartItem'),
                  value: ObjectValueNode(fields: [
                    ObjectFieldNode(
                        name: NameNode(value: 'productID'),
                        value:
                            VariableNode(name: NameNode(value: 'productID'))),
                    ObjectFieldNode(
                        name: NameNode(value: 'quantity'),
                        value: IntValueNode(value: '1')),
                    ObjectFieldNode(
                        name: NameNode(value: 'characteristicValueIds'),
                        value: VariableNode(
                            name: NameNode(value: 'characteristicValueIds')))
                  ]))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'result'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ]))
      ]))
]);

class CartAddMutation extends GraphQLQuery<CartAdd$Mutation, CartAddArguments> {
  CartAddMutation({required this.variables});

  @override
  final DocumentNode document = CART_ADD_MUTATION_DOCUMENT;

  @override
  final String operationName = 'cartAdd';

  @override
  final CartAddArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  CartAdd$Mutation parse(Map<String, dynamic> json) =>
      CartAdd$Mutation.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class SetFavoritesProductArguments extends JsonSerializable
    with EquatableMixin {
  SetFavoritesProductArguments({required this.productID});

  @override
  factory SetFavoritesProductArguments.fromJson(Map<String, dynamic> json) =>
      _$SetFavoritesProductArgumentsFromJson(json);

  late int productID;

  @override
  List<Object?> get props => [productID];
  @override
  Map<String, dynamic> toJson() => _$SetFavoritesProductArgumentsToJson(this);
}

final SET_FAVORITES_PRODUCT_MUTATION_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setFavoritesProduct'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'productID')),
            type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'setFavoritesProduct'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'productId'),
                  value: VariableNode(name: NameNode(value: 'productID')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'result'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ]))
      ]))
]);

class SetFavoritesProductMutation extends GraphQLQuery<
    SetFavoritesProduct$Mutation, SetFavoritesProductArguments> {
  SetFavoritesProductMutation({required this.variables});

  @override
  final DocumentNode document = SET_FAVORITES_PRODUCT_MUTATION_DOCUMENT;

  @override
  final String operationName = 'setFavoritesProduct';

  @override
  final SetFavoritesProductArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  SetFavoritesProduct$Mutation parse(Map<String, dynamic> json) =>
      SetFavoritesProduct$Mutation.fromJson(json);
}
