# Required argument(s)
SERVICE_NAME ?= $(error SERVICE_NAME is undefined)
include services/$(SERVICE_NAME)/config.env
# Required environment variable(s)
GEOSERVER_CONFIG_ID ?= $(error GEOSERVER_CONFIG_ID is undefined)
GEOSERVER_VERSION ?= $(error GEOSERVER_VERSION is undefined)
TOMCAT_IMAGE_TAG ?= $(error TOMCAT_IMAGE_TAG is undefined)
# Other argument(s)/environment variable(s)
GEOSERVER_DIR = "$(CURDIR)/geoserver.git"
USER_GID = $(shell id -g)
USER_UID = $(shell id -u)

build: geoserver_init geoserver_version_checkout build_geoserver build_tomcat geoserver_reset

build_geoserver:
	@mvn \
		--batch-mode \
		--file $(GEOSERVER_DIR)/src/pom.xml \
		-DconfigDirectory=$(CURDIR)/services/$(SERVICE_NAME)/data \
		-DconfigId=$(GEOSERVER_CONFIG_ID) \
		-Dmaven.test.skip=true \
		-DskipTests \
		-P $(GEOSERVER_EXTENSIONS) \
		clean package
	
build_tomcat:
	@docker-compose build \
		--build-arg SERVICE_NAME=$(SERVICE_NAME) \
		--build-arg TOMCAT_IMAGE_TAG=$(TOMCAT_IMAGE_TAG) \
		--build-arg USER_GID=$(USER_GID) \
		--build-arg USER_UID=$(USER_UID) \
		$(SERVICE_NAME)

geoserver_init geoserver_reset:
	@git submodule update --init --remote

geoserver_version_checkout: geoserver_init
	@git submodule foreach '[ "${PATH}" = "$(GEOSERVER_DIR)" ] || git checkout $(GEOSERVER_VERSION)'

mvn_cache_reset:
	@rm -rf ${HOME}/.m2/repository

push_ecr:
	@echo docker-compose push $(SERVICE_NAME)