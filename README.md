# big-data-for-tourism_KibanaPlugin

# Install Kibana for guest users (port 5601)

Note: the kibana’s configuration for the 2 istances are in the index .kibana_admin

*Download the kibana deb package and install it*
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.3-amd64.deb
dpkg -i kibana-6.4.3-amd64.deb

*Copy the configuration*
cp /home/seacom/installazione/kibana/kibana.yml /etc/kibana/kibana.yml

*Enable the service on boot*
systemctl enable kibana

*Install the plugins*
cd /usr/share/kibana/bin

./kibana-plugin install file:///home/seacom/installazione/kibana/date_picker_vis-1.0.0.zip 
./kibana-plugin install file:///home/seacom/installazione/kibana/dashboard_read_mode-1.0.0.zip 
./kibana-plugin install file:///home/seacom/installazione/kibana/dashboard_fullscreen-1.0.0.zip
./kibana-plugin install file:///home/seacom/installazione/kibana/dashboard_edit_filters-1.0.0.zip

*Start the service*
systemctl start kibana

# Install the kibana’s management version (port 5611)

cd opt

*Download  kibana tar.gz*
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.4.3-linux-x86_64.tar.gz

*Extact the file*
tar -xzf kibana-6.4.3-linux-x86_64.tar.gz

*Rename the kibana folder*
mv kibana-6.4.3-linux-x86_64 kibana

*Copy the istance configuration in the /etc folder (if you start the istance as service)*
cp /home/seacom/installazione/kibana/kibana_admin.yml /etc/kibana/kibana_admin.yml

*Copy the configuration in the config folder (if you what to start the istance from command line)*
cp /home/seacom/installazione/kibana/kibana_admin.yml /opt/kibana/config/kibana.yml

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


# Install ngnix (port 80) #

*Install from ubuntu distro*
apt install nginx

*Copy the config*
cp /home/seacom/installazione/nginx/default /etc/nginx/sites-available/default

*Enable service on boot*
systemctl enable nginx

*Start the service*
systemctl start nginx
