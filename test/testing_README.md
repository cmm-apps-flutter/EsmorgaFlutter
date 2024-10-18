For execute the tests with coverage use

`flutter test --coverage`

Then a /coverage folder will be created with a .info file.

Install lcov to generate a html report
`brew install lcov`

Then transform the .info file to an html report

`genhtml coverage/lcov.info -o coverage/html`

Finally open the html file