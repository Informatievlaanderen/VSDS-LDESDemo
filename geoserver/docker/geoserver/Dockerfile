FROM kartoza/geoserver

USER geoserveruser
COPY ./data/. /opt/geoserver/data_dir/
USER root
RUN chown -R geoserveruser:geoserverusers /opt/geoserver/data_dir
