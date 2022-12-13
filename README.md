# geoserver-multiple-datadirs

## Requirements

- [Docker](https://www.docker.com/)
- [VSCode](https://code.visualstudio.com/) with [Dev Containers](https://code.visualstudio.com/docs/devcontainers/tutorial#_install-the-extension) extension

## Usage

Clone repository and open the repository folder in VSCode and launch the development container.

> **_NOTE:_**  [GeoServer](https://github.com/geoserver/geoserver) submodule will be initialize by build process.


### Service: geoserver1

Configuration for service can be found [here](./services/geoserver1/config.env).

Build container image for service.

```bash
make build SERVICE_NAME=geoserver1
```

Run container image locally.

```bash
docker-compose up geoserver1 
```

Once the service has started, the GeoServer web management interface is available locally at http://localhost:8081/geoserver/web/.

> **_NOTE:_**  Configuration changes will be visible written to service's [data directory](services/geoserver1/data/release/)

### Service: geoserver2

Configuration for service can be found [here](./services/geoserver2/config.env).

Build container image for service.

```bash
make build SERVICE_NAME=geoserver2
```

Run container image locally.

```bash
docker-compose up geoserver2
```

Once the service has started, the GeoServer web management interface is available locally at http://localhost:8082/geoserver/web/.

> **_NOTE:_**  Configuration changes will be visible written to service's [data directory](services/geoserver2/data/release/)
