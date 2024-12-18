enum ContentType { video, article }

// Method to convert enum to string using switch case
String enumToString(ContentType contentType) {
  switch (contentType) {
    case ContentType.video:
      return 'video';
    case ContentType.article:
      return 'article';
  }
}

// Method to convert string to enum using switch case
ContentType? stringToEnum(String value) {
  switch (value) {
    case 'video':
      return ContentType.video;
    case 'article':
      return ContentType.article;
    default:
      return null; // Return null if no match found
  }
}
