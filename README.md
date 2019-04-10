Big Data For Tourism - Kibana
=============================

This repository is a sub project of the Big Data For Toursim project, which is a analytics platform for analyzing South Tyrols tourism data.

## Table of contents

- [Overview](#overview)
- [Gettings started](#getting-started)
- [Deployment](#deployment)
- [Information](#information)

## Overview

The Big Data For Toursim project exists of the following parts:

- **Uploader**:
    The uploader is a web application, where allowed users can access a secured area and upload CSV files containing tourism data. The uploader will then store these CSV file in a provided SFTP folder from the Apache NiFi server.

    The repository of the uploader can be found [here](https://github.com/noi-techpark/big-data-for-tourism).

- **Apache NiFi**:
    [Apache NiFi](https://nifi.apache.org/) is an application ... The applications reads the files that were stored in the SFTP folder and trasforms them ...

- **Elasticsearch**:
    Elasticsearch acts as the database for the project.

- **Kibana**:
    Instance 1 - Admin Instance: Who uses this? What can the users do?
    Instance 2 - Guest Instance: Who uses this? What can the users do?
    ...

## Getting started

These instructions will get you a copy of the project up and running
on your local machine for development and testing purposes.

### Prerequisites

To build the project, the following prerequisites must be met:

- [Docker](https://docker.com/)

### Source code

Get a copy of the repository:

```bash
git clone https://github.com/noi-techpark/big-data-for-tourism_KibanaPlugin.git
```

Change directory:

```bash
ToDo: cd big-data-for-tourism_KibanaPlugin/
```

### Configure

Copy the file `.env.example` to `.env` and adjust the settings.

### Run

Running the project:

```bash
docker-compose up --build
```

## Deployment

A detailed installation and deployment instruction ...

### Admin Instance

...

1. Install Kibana
2. Install Plugins
    - Plugin 1
    - Plugin 2
3. ...

### Guest Instance

...

1. Install Kibana
2. Install Plugins
    - Plugin 1
    - Plugin 2
3. ...

## Information

### Support

For support, please contact [info@opendatahub.bz.it](mailto:info@opendatahub.bz.it).

### Contributing

If you'd like to contribute, please follow the following instructions:

- Fork the repository.

- Checkout a topic branch from the `development` branch.

- Make sure the tests are passing.

- Create a pull request against the `development` branch.

### Documentation

More documentation can be found at [https://opendatahub.readthedocs.io/en/latest/index.html](https://opendatahub.readthedocs.io/en/latest/index.html).

### License

The code in this project is licensed under the Mozilla Public License 2.0 license. See the LICENSE.md file for more information.
