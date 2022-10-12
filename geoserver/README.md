# Demo of GIPOD data in GeoServer

## Setup
* Start the docker stack
```
docker-composer up
```
This will start Apache NiFi, PostreSQL and GeoServer.
Next, load the demo data pipeline in Apache NiFi

* Go to the [NiFi web interface](http://localhost:8080/nifi/)

* Load the process group from the file '[Gipod2GeoServer.json](Gipod2GeoServer.json)'.
 ![tutorial-step](docs/0.png)
 ![tutorial-step](docs/1.png)

* Configure the process group by clicking the cogwheel under the 'Operate' pane.
 ![tutorial-step](docs/2.png)

* Now configure the database pool settings.
 ![tutorial-step](docs/3.png)

* Select the properties tab, and click the 'password' property. Make sure this matches the PostgreSQL password set in [docker-compose.yml](docker-compose.yml).
 ![tutorial-step](docs/4.png)

* Enable the database pool service.
 ![tutorial-step](docs/5.png)
 ![tutorial-step](docs/6.png)
* Enter the process group by either dubble clicking, or right-click + 'Enter group'
 ![tutorial-step](/ocs/7.png)

* Click start in the Operate pane, to start all processors.
 ![tutorial-step](docs/8.png)

* The database is now being populated with Gipod hindrances. This process can take quite some time.

## GeoServer endpoint

The endpoint is available at http://localhost:8002/geoserver/gipod-ldes/wms

## Power BI dashboard
Open Power BI file and sync datasets with PostGIS db tables

![image](https://user-images.githubusercontent.com/15192194/195372192-973e3136-03f0-44d2-87f0-4fb74a321c4a.png)
