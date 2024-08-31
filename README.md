# Wiki To Wiki Converter

[![Build Status](https://img.shields.io/endpoint?url=https://porion.vacs.fr/porion/api/v1/projects/wi2wic/badges/build.json)](https://porion.vacs.fr/porion/projects/view/wi2wic/summary)
[![License](https://img.shields.io/badge/license-APACHE2-blue.svg)](LICENSE)
[![Commits](https://img.shields.io/github/commits-since/stcarrez/wi2wic/1.0.0.svg)]
[![Docker](https://badgen.net/docker/pulls/ciceron/wi2wic)](https://hub.docker.com/r/ciceron/wi2wic/)

Wi2wic is a small server that allows to convert HTML in Wiki text such as Markdown, MediaWiki, Dotclear or Creole.
It can also convert one Wiki syntax to another.  It can be used to:

* Migrate HTML page in Markdown or another Wiki,
* Convert Wiki page in HTML,
* Convert HTML documentation in Markdown or another Wiki,
* Cleanup a complex and noisy HTML page

The server is written in Ada and provides the following REST operations:

* import some HTML content and convert it in a Wiki syntax,
* convert a Wiki text from one syntax to another,
* render a Wiki text in HTML.

You can try Wi2wic on https://wi2wic.vacs.fr/wi2wic/index.html

It was created as a demo site for [Ada Wiki](https://github.com/stcarrez/ada-wiki).

# Building Wi2wic

To build `wi2wic` you will need [Alire](https://github.com/alire-project/alire).

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

# Security

The server can download a URL through the */wi2wic/import* API entry point.
The server only accepts *http://* and *https://* URL.  The server should
be run from a docker container or similar restricted environment in order
to protect malicious URL.

# Limitations

The HTML parser and converter is able to read and parse invalid HTML but
some structures are not convertable to some Wiki syntax.

The HTML to Wiki converter does not read the CSS and therefore cannot
convert correctly some HTML that has specific presentation through their CSS.
The interpretation of HTML+CSS is left to the reader as an exercise
(Hint: use the [Ada parser for CSS files](https://github.com/stcarrez/ada-css))

