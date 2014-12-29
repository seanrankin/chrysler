Chrysler
======
> Whenever there is a hard job to be done I assign it to a lazy man; he is sure to find an easy way of doing it.

> ~ Walter Chrysler

Recently I've found myself provisioning new rails apps on an almost daily basis to either test an idea out or build a quick proof of concept. Maybe it's not all that hard to generate and deploy your basic Rails app these days -- but it can be tedious if you have to do it over and over. 

The goal of this project was a simple (< 100 line) script that just about anyone could digest and understand prior to runnin. 

Based on the same concept as projects like Rails Wizards (http://www.railswizard.org), this Rails Application Template provisions an app with the basics (Bootstrap, HAML, etc.) and deploys your shiney new project to Heroku.


Install
-------

Carefully review the script then run:

```
rails new app-name --database=postgresql -m https://raw.githubusercontent.com/seanrankin/chrysler/master/chrysler.rb

```

Requirements
------------

1. You'll need a basic Rails development enviroment setup.
2. Assumes you have a Heroku account (and the CLI tools installed).

To Do
------------

1. Add (conditionaly) Devise and a base user model.
2. What else goes into almost every Rails app you build?

Contributing
------------

Feel free to contribute and submit a pull request or log something in issues.

License
-------

Laptop is © 2014 Internet Wonderboy, Inc. It is free software, and may be
redistributed under the terms specified in the LICENSE file.
