# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.9]

* Bug fix - After build the Imports.ps1 file was being left in the artifacts folder. It will now be removed after build is completed.
* Bug fix - when AWS CI/CD was chosen and an S3 bucket was provided for module install the modules were not correctly downloading to the build container. Fixed temp path issue and bucket name quotes added.
* Bug fix - Build file when running in 5.1 was not honoring the "*.ps1" filter and would pick up files like ps1xml. Changed to a regex so that both 5.1 and higher versions work. This was causing ps1xml files to merged into the psm1 during build.
* Bug fix - Fixed Module name not being replaced in SampleInfraTest.Tests.ps1

## [0.8.5]

* Corrected bug where AWS CI/CD choice was not correctly populating S3 bucketname for install_modules.ps1
* Bumped module references to latest versions

## [0.8.4]

* Added Manifest File to Invoke-Build buildheader
* Added Manifest version to Invoke-Build buildheader
* Corrected bug in Catesta's build process that wasn't displaying Manifest info in the buildheader

## [0.8.3]

* Moved Infrastructure tests from pre-build to post build
  * Included sample Infrastructure test that references artifacts location for import for post-build import.
* Corrected spelling error in Tests folder: Infrastrcuture to Infrastructure

## [0.8.0]

* Initial release.
