import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(
    const MaterialApp(
      home: NewWidget(),
    ),
  );
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
  });

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  List<String> words = [
    '1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final res = genStrings(letters, 7);
              setState(() {
                words = res;
              });
            },
            child: const Text('Clicked'),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Text(words[index]);
              },
              itemCount: words.length,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> genStrings(Set<String> alphaSet, int n) {
  List<String> allStrings = [];

  void genStringsHelper(String strSoFar, int nRemaining) {
    if (nRemaining == 0) {
      allStrings.add(strSoFar);
      return;
    }
    for (String c in alphaSet) {
      if (strSoFar.isNotEmpty && strSoFar[strSoFar.length - 1] != c) {
        genStringsHelper(strSoFar + c, nRemaining - 1);
      }
    }
  }

  genStringsHelper('', n);
  return allStrings;
}

final letters = {
  'ا',
  'پ',
  'ت',
  'س',
  'ل',
  'م',
  'ن',
  'ی',
};
