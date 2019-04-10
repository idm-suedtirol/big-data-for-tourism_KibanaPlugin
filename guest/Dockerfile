FROM kibana:6.4.3

COPY ./date_picker_vis-1.0.0.zip /tmp/date_picker_vis-1.0.0.zip
COPY ./dashboard_read_mode-1.0.0.zip /tmp/dashboard_read_mode-1.0.0.zip
COPY ./dashboard_fullscreen-1.0.0.zip /tmp/dashboard_fullscreen-1.0.0.zip

RUN kibana-plugin install file:///tmp/date_picker_vis-1.0.0.zip
RUN kibana-plugin install file:///tmp/dashboard_read_mode-1.0.0.zip
RUN kibana-plugin install file:///tmp/dashboard_fullscreen-1.0.0.zip
