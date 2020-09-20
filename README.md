# Wiki To Wiki Converter

[![Build Status](https://img.shields.io/jenkins/s/https/jenkins.vacs.fr/Bionic-Wi2wic.svg)](https://jenkins.vacs.fr/job/Bionic-Wi2wic/)
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

A docker container is available for those who want to try Wi2wic without installing
and building all required packages.  To use the Wi2wic docker container you can
run the following commands:

```
   sudo docker pull ciceron/wi2wic
   sudo docker run --name wi2wic -p 8080:8080 ciceron/wi2wic
```

and then point your browser to http://localhost:8080/wi2wic/index.html

To stop the running application you will use:
```
   sudo docker stop wi2wic
   sudo docker rm wi2wic
```

If you want to build locally the docker image, you can use:

```
   sudo docker build -t wi2wic -f docker/Dockerfile .
```

## Structure of the server

The server consists of several Ada packages:

| Source file | Package | Description |
| ------------ | ------------- | ------------- |
| src/wi2wic.ads|Wi2wic|The server root package declaration |
| src/wi2wic-rest.ads|Wi2wic.Rest|The server declaration and instantiation|
| src/wi2wic-rest.adb|Wi2wic.Rest|The server REST API implementation|
| src/wi2wic-server.adb|Wi2wic.Server|The server main procedure|


