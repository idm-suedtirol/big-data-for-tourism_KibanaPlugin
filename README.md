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
    [Apache NiFi](https://nifi.apache.org/) is an application that automate the flow of data between systems. The application reads the files that were stored in a folder where the data are uploaded using SFTP and enrichs them deconding some information:

    - Geolocation 
    - Country-code decoding
    - Information related to the hotel classification.

    At the end inserts the extracted informations into elasticsearch and moves the file in a folder where are stored the processed files.
    The user that upload the file into the folder can also delete the information uploading a file whith the info to be deleted into a dedicated folder.

- **Elasticsearch**:
    Elasticsearch acts as the database for the project. Receives the info from nifi; the data stored in elasticsearch are avaliable to the user throght kibana dashboards. In the project is used the Elasticloud version of elastic because is able to define the access level to the data using ACL and manage user and roles.

- **Kibana**:
    Kibana shows the ingested data using dashboard with visualize widget like piecard, histogram, data table etc.
    The kibana istances store the config information in a separate index (to avoid conflicts with the kibana istance che is avaliable in ElasticCloud).
    In the project are defined 2 istances of kibana (one for guest users and the other for admin users).
    The user used in the two istances are defined in elasticsearch with two different level of access to the data.

    *Instance 1 - Admin Instance:*
    To access to this istance the user have to insert username and password; the user that have access to this istance are able to modify the existing dashboards and visualize and create new ones; they are also enabled to access to the data store in elasticsearch and run query to insert, update and delete the data index and create, modify and delete the indices in elasticsearch.

    *Instance 2 - Guest Instance:*
    The Istance 2 is used to publish the data, the user can access to this istance and to the dashboard without writing any credential.
    The access is read only and only for the dashboards in a full-screen mode: when the user access to the istances sees the list of the dashboard avaliable; following the link access to the dashboard and can see the data. The guest user can access only to the dashboard; access to kibana in fullscreen mode and can't change manually the filter of the dashboards.
    
- **Ngnix**:
    Who access to the Guest istance hasn't to insert any credential to see the dashboards. To achieve this we put a reverse proxy in front of the guest istance using ngnix: the reverse put in the header of every request set to the guest istance of kibana the username and the password of the guest user encoded in base64; in this way the guest user is logged in the kibana istance when writes the url exposed by nginix.

## Getting started

These instructions will get you a copy of the project up and running
on your local machine for development and testing purposes.

### Prerequisites

To build the project, the following prerequisites must be met:

- [Docker](https://docker.com/)
- [Elastic Cloud](https://cloud.elastic.co/)

### Setup

Setup a cluster in Elastic Cloud and configure the following two user: 

**Admin user:**
- Goto Management/Users/Create new user
- Insert username, password, fullname email address
- Set role as superuser

**Guest user:**
- Goto Management/Users/Create new user
- Insert Username, password, fullname email address
- Set role as guest, kibana_dashboard_only_user

### Configure

Copy the file `.env.example` to `.env` and adjust the settings.

### Run

Running the project:

```bash
docker-compose up --build
```

## Deployment

### Guest Instance (port 5601)

1. Install Kibana 6.4.3

2. Adjust the Kibana settings under `/etc/kibana/kibana.yml` by setting the following values to the Elastic Cloud URL and the admin user credentials:

    ```
    elasticsearch.url: "<url_elastic>"
    elasticsearch.username: "<user>"
    elasticsearch.password: "<pwd>"
    ```

3. Install the following plugins from this repository:

    ```
    /usr/share/kibana/bin/kibana-plugin install file:///../date_picker_vis-1.0.0.zip 
    /usr/share/kibana/bin/kibana-plugin install file:///../dashboard_read_mode-1.0.0.zip 
    /usr/share/kibana/bin/kibana-plugin install file:///../dashboard_fullscreen-1.0.0.zip
    /usr/share/kibana/bin/kibana-plugin install file:///../dashboard_edit_filters-1.0.0.zip
    ```

### Admin Instance (port 5611)

1. Install Kibana 6.4.3

2. Adjust the Kibana settings under `/etc/kibana/kibana.yml` by setting the following values to the Elastic Cloud URL and the admin user credentials:

    ```
    elasticsearch.url: "<url_elastic>"
    elasticsearch.username: "<user>"
    elasticsearch.password: "<pwd>"
    ```

3. Install the following plugins from this repository:

    ```
    /usr/share/kibana/bin/kibana-plugin install file:///../date_picker_vis-1.0.0.zip 
    ```

### Nginx

1. Install Nginx

2. Add the site configuration with the following content:

    ```
    server {
        listen 80 default_server;
        server_name  localhost;

        location / {
            proxy_redirect off;
            proxy_set_header Authorization "Basic <token>";
            proxy_pass http://<url>;
        }
    }
    ```

    Note: Make sure to replace <url> with the URL pointing to the guest Kibana instance and <token> with a base64 encode string of the username and the password in the following format: <username>:<password>

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
