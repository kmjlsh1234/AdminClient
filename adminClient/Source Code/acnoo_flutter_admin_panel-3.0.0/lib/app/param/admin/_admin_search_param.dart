class AdminSearchParam{

  // keyword search
  final String searchType;
  final String searchValue;

  final int page;
  final int limit;

  AdminSearchParam(this.searchType, this.searchValue, this.page, this.limit);

  //object To Json
  Map<String, dynamic> toJson() =>{
    'searchType': searchType,
    'searchValue': searchValue,
    'page': page,
    'limit': limit
  };
}