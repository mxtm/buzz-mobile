import 'dart:math';

class BeeMovieQuotes {
  List<String> quotes = [
    "I'm a pollen jock! And its a perfect fit, all I gotta do are the sleeves!",
    "According to all known laws of aviation, there is no way a bee should be able to fly.",
    "Bees have never afraid to change the world. I mean, what about Bee Columbus, Bee Ghandi, Bee-Jesus?",
    "- My only interest is flowers.\n- You know, our last queen was elected with that very slogan.",
    "This is your queen? That's a guy in women's clothes! That's a \'drag\' queen!",
    "My nerves are fried from riding on this emotional rollarcoaster!",
    "Flying is exhausting. Why don't you humans just run everywhere, isn't that faster?",
    "We're the only ones who make honey, pollinate flowers, and dress like this!",
    "Mr. Benson Bee, I'm going to ask what I think the entire court here would like to know... what exactly is your relationship to that woman?",
    "Barry I told you, stop flying in the house!",
    "\'Tournament of Roses\'. Roses can't do sports.",
    "Three day's of college... I'm glad I took that one day off in the middle and just hiked around the hive."
  ];

  String toString() {
    final _random = new Random();
    return '\"' + quotes[_random.nextInt(quotes.length)] + '\"';
  }
}
