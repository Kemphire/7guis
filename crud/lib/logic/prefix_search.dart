import 'package:fuzzywuzzy/fuzzywuzzy.dart';

List<String> topFiveMatchingNames(List<List<String>> names, String query) {
  var top5 =
      extractTop(
        query: query,
        choices: [for (var i = 0; i < names.length; i++) names[i].join(", ")],
        limit: 5,
        cutoff: 60,
      ).map((element) => element.choice).toList();
  return top5;
}
