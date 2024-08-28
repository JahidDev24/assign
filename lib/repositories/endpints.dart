class Endpoint {
  // Production URL
  static const BASE_URL = "https://hacker-news.firebaseio.com/v0/";

  static const GET_IDS = "${BASE_URL}topstories.json?print=pretty";
  static const GET_ITEMS = "${BASE_URL}item";
}
