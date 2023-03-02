CONNECTOR_DIR := connector
CONNECTOR_CORE_DIR := $(CONNECTOR_DIR)/core
CONNECTOR_HELM_DIR := $(CONNECTOR_CORE_DIR)/src/main/helm
CONNECTOR_HELM_CHARTS_DIR := $(CONNECTOR_HELM_DIR)/connector/charts

IDENTITY_ADAPTER_DIR := identity-adapter
IDENTITY_ADAPTER_HELM_DIR := identity-adapter/src/main/helm
IDENTITY_ADAPTER_HELM_CHARTS_DIR := $(IDENTITY_ADAPTER_HELM_DIR)/identity-adapter/charts

QUERY_DIR := query
QUERY_CORE_DIR := $(QUERY_DIR)/core
QUERY_HELM_DIR := $(QUERY_CORE_DIR)/src/main/helm
QUERY_HELM_CHARTS_DIR := $(QUERY_HELM_DIR)/query/charts

RUNTIME_BUNDLE_DIR := runtime-bundle
RUNTIME_BUNDLE_CORE_DIR := $(RUNTIME_BUNDLE_DIR)/core
RUNTIME_BUNDLE_HELM_DIR := $(RUNTIME_BUNDLE_CORE_DIR)/src/main/helm
RUNTIME_BUNDLE_HELM_CHARTS_DIR := $(RUNTIME_BUNDLE_HELM_DIR)/runtime-bundle/charts

build-all: dockerize helm-package-all

dockerize: docker-push-connector docker-push-identity-adapter docker-push-query

clean: maven-clean

maven-clean:
	mvn clean

helm-package-all: helm-package-identity-adapter helm-package-query helm-package-connector helm-package-runtime-bundle

helm-lint-all: helm-lint-identity-adapter helm-lint-query helm-lint-runtime-bundle

maven-package-connector:
	cd $(CONNECTOR_DIR) && \
	mvn -Dmaven.test.skip=true package

docker-build-connector: maven-package-connector
	cd $(CONNECTOR_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-connector: docker-build-connector
	cd $(CONNECTOR_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

maven-package-identity-adapter:
	cd $(IDENTITY_ADAPTER_DIR) && \
	mvn -Dmaven.test.skip=true package

docker-build-identity-adapter: maven-package-identity-adapter
	cd $(IDENTITY_ADAPTER_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-identity-adapter: docker-build-identity-adapter
	cd $(IDENTITY_ADAPTER_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

maven-package-query:
	cd $(QUERY_DIR) && \
	mvn -Dmaven.test.skip=true package

docker-build-query: maven-package-query
	cd $(QUERY_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-query: docker-build-query
	cd $(QUERY_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

maven-package-runtime-bundle:
	cd $(RUNTIME_BUNDLE_DIR) && \
	mvn -Dmaven.test.skip=true package

docker-build-runtime-bundle: maven-package-runtime-bundle
	cd $(RUNTIME_BUNDLE_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-runtime-bundle: docker-build-runtime-bundle
	cd $(RUNTIME_BUNDLE_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

helm-lint-connector:
	cd $(CONNECTOR_HELM_CHARTS_DIR) && \
	helm lint

helm-lint-identity-adapter:
	cd $(IDENTITY_ADAPTER_HELM_CHARTS_DIR) && \
	helm lint

helm-lint-query:
	cd $(QUERY_HELM_CHARTS_DIR) && \
	helm lint


helm-lint-runtime-bundle:
	cd $(RUNTIME_BUNDLE_HELM_CHARTS_DIR) && \
	helm lint


helm-package-connector: helm-lint-connector
	cd $(CONNECTOR_HELM_DIR) && \
  helm package connector/charts

helm-package-identity-adapter: helm-lint-identity-adapter
	cd $(IDENTITY_ADAPTER_HELM_DIR) && \
	helm package identity-adapter/charts

helm-package-query: helm-lint-query
	cd $(QUERY_HELM_DIR) && \
	helm package query/charts

helm-package-runtime-bundle:
	cd $(RUNTIME_BUNDLE_HELM_DIR) && \
	helm package runtime-bundle/charts



