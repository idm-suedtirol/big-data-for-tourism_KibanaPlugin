FROM nginx:1.15

COPY ./nginx/default /etc/nginx/conf.d/default.conf
COPY ./nginx/command.sh /var/command.sh

CMD [ "/var/command.sh" ]
