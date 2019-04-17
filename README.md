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
    Instance 1 - Admin Instance: 
    To access to this istance the user have to insert username and password; the user that have access to this istance are able to modify the existing dashboards and visualize and create new ones; they are also enabled to access to the data store in elasticsearch and run query to insert, update and delete the data index and create, modify and delete the indices in elasticsearch.

    Instance 2 - Guest Instance: 
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
- 
Configure the user in elasticloud, 

login into elasticloud and create the users for the 2 kibana istances:

Admin user
Goto Management/Users/Create new user
insert Username, password, fullname email address
set role as superuser

Guest user
Goto Management/Users/Create new user
insert Username, password, fullname email address
set role as guest, kibana_dashboard_only_user

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

### Install Nifi (port 8080) 

*Create user to run nifi*
adduser seacom

cd /usr/share/

*Download  nifi tar.gz*
wget http://archive.apache.org/dist/nifi/1.8.0/nifi-1.8.0-bin.tar.gz

*Extract the file* 
tar -xvf /home/seacom/installazione/nifi/nifi-1.8.0-bin.tar.gz

*Copy the configuration to run_as*
cp /home/seacom/installazione/nifi/bootstrap.conf /usr/share/nifi-1.7.1/conf/boostrap.conf

*Create the folder to store the encrichment csv*
*Copy the csv for the enrichment*

*Change file and folder ownership*
chown -R seacom:seacom nifi-1.8.0

cd /usr/share/nifi-1.8.0/bin

*Install nifi as service*
./nifi.sh install

*Enable service on boot*
systemctl enable nifi

*Start the service*
systemctl start nifi

Open the nifi interface at http://<ip>:8080/nifi

Upload the template
Create a new flow from the uploaded template

Configure the nifi flow

Right click the flow group "IDM", select variables, set the variable value
- es_url (elasticsearch url) http://<ip_elastic>:9200/
- es_user (elasticsearch user admin) 
- es_password (elasticsearch user admin password)
- enrich_path (the path where are stored the csv files for the enrichment)
- folder_path (base path for the ingestion)  

A detailed installation and deployment instruction ...

### Guest Instance (port 5601)
*Download the kibana deb package and install it*
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.3-amd64.deb
dpkg -i kibana-6.4.3-amd64.deb

*Copy the configuration*
cp /home/seacom/installazione/kibana/kibana.yml /etc/kibana/kibana.yml

*Set elastic url, elastic user, elastic password in the file changing the fields (admin user):*
elasticsearch.url: "<url_elastic>"
elasticsearch.username: "<user>"
elasticsearch.password: "<pwd>"

*Enable the service on boot*
systemctl enable kibana

*Install the plugins*
cd /usr/share/kibana/bin

./kibana-plugin install file:///home/seacom/installazione/kibana/date_picker_vis-1.0.0.zip 
./kibana-plugin install file:///home/seacom/installazione/kibana/dashboard_read_mode-1.0.0.zip 
./kibana-plugin install file:///home/seacom/installazione/kibana/dashboard_fullscreen-1.0.0.zip
./kibana-plugin install file:///home/seacom/installazione/kibana/dashboard_edit_filters-1.0.0.zip
...

### Admin Instance (port 5611)

cd opt

*Download  kibana tar.gz*
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.3-linux-x86_64.tar.gz

*Extact the file*
tar -xzf kibana-6.4.3-linux-x86_64.tar.gz

*Rename the kibana folder*
mv kibana-6.4.3-linux-x86_64 kibana

*Copy the istance configuration in the /etc folder (if you start the istance as service)*
cp /home/seacom/installazione/kibana/kibana_admin.yml /etc/kibana/kibana_admin.yml
Set elastic url, elastic user, elastic password in the file
elasticsearch.url: "<url_elastic>"
elasticsearch.username: "<user>"
elasticsearch.password: "<pwd>"

*Copy the configuration in the config folder (if you what to start the istance from command line)*
cp /home/seacom/installazione/kibana/kibana_admin.yml /opt/kibana/config/kibana.yml
Set elastic url, elastic user, elastic password in the file
elasticsearch.url: "<url_elastic>"
elasticsearch.username: "<user>"
elasticsearch.password: "<pwd>"

*Copy the service configuration file*
cp /home/seacom/installazione/kibana/kibana_admin /etc/systemd/system/kibana_admin.service

*Reload the service configuration*
systemctl daemon-reload 

*Enable the service on boot*
systemctl enable kibana_admin

*Install the date picker plugin*
cd /opt/kibana/bin/
./kibana-plugin install file:///home/seacom/installazione/kibana/date_picker_vis-1.0.0.zip 

*Start the service*
systemctl start kibana_admin

## Nginx
*Install from ubuntu distro*
apt install nginx

*Copy the config*
cp /home/seacom/installazione/nginx/default /etc/nginx/sites-available/default

*Set the auth token*
Calculate base64 for username:password of the guest user and write it in the file in the following row of the config file:

 proxy_set_header Authorization "Basic <auth_token>";

*Enable service on boot*
systemctl enable nginx

*Start the service*
systemctl start nginx

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
