class FilterOptions {
  bool isFavorite;
  int isSubscrip;
  double rating;

  FilterOptions({
    this.isFavorite = false,
    this.isSubscrip = 0,
    this.rating = 0,
  });
  void reset() {
    this.isFavorite = false;
    this.isSubscrip = 0;
    this.rating = 0;
  }
}
