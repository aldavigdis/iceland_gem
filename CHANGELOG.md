## Version 0.2

### API-level changes

* Calling postcode related methods directly from the Iceland module, for example `Iceland.all_postal_codes` has been depreciated. Use the `Iceland::PostalCodes` class instead.
* The kennitala class has been replaced with the more appropriately namespaced `Iceland::Kennitala` class. There is no deprecation involved.

### Development dependencies

* Updating all development dependencies to their newest version.
* `codeclimate-test-reporter` is among breaking releases, requiring changes to the `spec_helper`.
* Removing overcommit as it is fucking annoying

### Tests

* Splitting specs into different files by functionality.

### Minor changes

* Updating specs and documentation to reflect the depreciation of `Fixnum` in ruby 2.4.
