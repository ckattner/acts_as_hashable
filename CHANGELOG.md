# Changelog

## 1.3.3-ck (August 4, 2024)

### Changes

* Converted CI from CircleCI to Github Actions
* Restored missing LICENSE file
* Updated Rubocop per https://github.com/rubocop/rubocop/issues/10258

## 1.3.0 (September 5th, 2020)

### Additions

* Added dynamic class constantization when a string is registered for a Factory.

## 1.2.0 (June 9th, 2020)

* Bumped minimum Ruby version to >= 2.5
* Do not pass in any constructor arguments unless we have at least one key.
* Add more detail to construction errors.

## 1.1.0 (May 3rd, 2019)

* Added acts_as_hashable_factory to dynamically create objects.

## 1.0.5 (February 5th, 2019)

* Fixed equality bug in array reject block.

## 1.0.4 (January 30th, 2019)

### Maintenance Release

* Added bin/console script
* Added CHANGELOG
* Updated README with publication steps, additional testing steps
* Bumped minimum Ruby to 2.3.8
* Added Guard
