String addOrdinalIndicator(String day) {
  if (day.endsWith('1') && day != '11') {
    return '${day}st';
  } else if (day.endsWith('2') && day != '12') {
    return '${day}nd';
  } else if (day.endsWith('3') && day != '13') {
    return '${day}rd';
  } else {
    return '${day}th';
  }
}