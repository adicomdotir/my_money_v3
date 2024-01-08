flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
google-chrome coverage/html/index.html