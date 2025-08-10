class FilterOptions {
  bool isFavorite;
  int isSubscrip;

  FilterOptions({this.isFavorite = false, this.isSubscrip = 0});
  void reset() {
    this.isFavorite = false;
    this.isSubscrip = 0;
  }
}
