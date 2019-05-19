

String stringifyNumber(int number) {
    String postfix;
    switch (number % 10) {
      case 1:
        postfix = 'st';
        break;
      case 2:
        postfix = 'nd';
        break;
      case 3:
        postfix = 'rd';
        break;
      default:
        postfix = 'th';
        break;
    }
    return '$number$postfix';
  }