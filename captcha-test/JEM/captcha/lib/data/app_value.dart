class AppValue {
  static String title = 'Flutter Softcon 2021 Captcha Demo';
  static String validate = 'Validate';
  static String correct = 'Correct!';
  static String incorrect = 'Incorrect, please try again';
  static String generate = 'Generate new CAPTCHA';

  static String blackCar = 'asset/img_black_car.png';
  static List<String> blackCarValues = ['Vintage', 'Car', 'Black'];
  static Map<String, bool> blackCarOptions = {
    'Vintage': false,
    'Car': false,
    'Black': false,
    'Motorcycle': false,
  };

  static String blueCar = 'asset/img_blue_car.png';
  static List<String> blueCarValues = ['Blue', 'Kia'];
  static Map<String, bool> blueCarOptions = {
    'White': false,
    'Kia': false,
    'Blue': false,
    'Pink': false,
  };

  static String grayCar = 'asset/img_gray_car.png';
  static List<String> grayCarValues = ['Gray', 'Honda'];
  static Map<String, bool> grayCarOptions = {
    'Gray': false,
    'Kia': false,
    'Honda': false,
    'White': false,
  };

  static String orangeCar = 'asset/img_orange_car.png';
  static List<String> orangeCarValues = ['Range Rover', 'Orange'];
  static Map<String, bool> orangeCarOptions = {
    'Range Rover': false,
    'Boat': false,
    'Orange': false,
    'Jeep': false,
  };

  static String yellowCar = 'asset/img_yellow_car.png';
  static List<String> yellowCarValues = ['Car', 'Yellow', 'Audi', 'Automobile'];
  static Map<String, bool> yellowCarOptions = {
    'Car': false,
    'Yellow': false,
    'Audi': false,
    'Automobile': false,
  };
}
