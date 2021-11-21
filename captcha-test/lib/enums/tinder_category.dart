enum TinderCategory {
  cat,
  dog,
  mountain,
}

extension GenderConversionFromInt on int {
  TinderCategory get convertFromInt {
    switch (this) {
      case 0:
        return TinderCategory.cat;
      case 1:
        return TinderCategory.dog;
      default:
        return TinderCategory.mountain;
    }
  }
}
