# Wiki To Wiki Converter

[![Build Status](https://img.shields.io/jenkins/s/https/jenkins.vacs.fr/Atlas.svg)](http://jenkins.vacs.fr/job/Atlas/)
[![License](https://img.shields.io/badge/license-APACHE2-blue.svg)](LICENSE)
![Commits](https://img.shields.io/github/commits-since/stcarrez/wi2wic/1.0.0.svg)

Wi2wic is a small server application written in Ada that provides the following REST operations:

* import some HTML content and convert it in a Wiki syntax,
* convert a Wiki text from one syntax to another,
* render a Wiki text in HTML.

To build `wi2wic` you will need the following projects:

* Ada Servlet   (https://github.com/stcarrez/ada-servlet)
* Ada Util      (https://github.com/stcarrez/ada-util)
* Ada Wiki      (https://github.com/stcarrez/ada-wiki)
* Ada EL        (https://github.com/stcarrez/ada-el)
* Ada Security  (https://github.com/stcarrez/ada-security)

Wi2wic relies on the following external projects:

* AWS      (https://libre.adacore.com/libre/tools/aws/)
* XMLAda   (https://libre.adacore.com/libre/tools/xmlada/)

Before building and configuring Wi2wic, you should have configured,
built and installed all of the above projects.

# Building Wi2wic

To configure Wi2wic, use the following command:
```
   ./configure
```
Then, build the application:
```
   make
```

# Running Wi2wic

You will then start the application as follows:
```
   bin/wi2wic-server
```

and point your browser to http://localhost:8080/wi2wic/index.html

# Docker

A docker container is available for those who want to try Atlas without installing
and building all required packages.  To use the Atlas docker container you can
run the following commands:

```
   sudo docker pull ciceron/atlas
   sudo docker run --name atlas -p 8080:8080 ciceron/atlas
```

and then point your browser to http://localhost:8080/atlas/index.html

To stop the running application you will use:
```
   sudo docker stop atlas
   sudo docker rm atlas
```

## Structure of the server

The server consists of several Ada packages that are generated from
the OpenAPI specification.

| Source file | Package | Description |
| ------------ | ------------- | ------------- |
| src/wi2wic.ads|Wi2wic|The server root package declaration |
| src/wi2wic-rest.ads|Wi2wic.Rest|The server declaration and instantiation|
| src/wi2wic-rest.adb|Wi2wic.Rest|The server implementation (empty stubs)|
| src/wi2wic-server.adb|Wi2wic.Server|The server main procedure|


