FROM kibana:6.4.3

COPY ./date_picker_vis-1.0.0.zip /tmp/date_picker_vis-1.0.0.zip

RUN kibana-plugin install file:///tmp/date_picker_vis-1.0.0.zip
