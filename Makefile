CONNECTOR_HELM_DIR := connector/core/src/main/helm
IDENTITY_ADAPTER_HELM_DIR := identity-adapter/src/main/helm
QUERY_HELM_DIR := query/core/src/main/helm
RUNTIME_BUNDLE_HELM_DIR := runtime-bundle/core/src/main/helm

CONNECTOR_HELM_CHARTS_DIR := $(CONNECTOR_HELM_DIR)/connector/charts
IDENTITY_ADAPTER_HELM_CHARTS_DIR := $(IDENTITY_ADAPTER_HELM_DIR)/identity-adapter/charts
QUERY_HELM_CHARTS_DIR := $(QUERY_HELM_DIR)/query/charts
RUNTIME_BUNDLE_HELM_CHARTS_DIR := $(RUNTIME_BUNDLE_HELM_DIR)/runtime-bundle/charts

lint-connector:
	cd $(CONNECTOR_HELM_CHARTS_DIR) && \
	helm lint

lint-identity-adapter:
	cd $(IDENTITY_ADAPTER_HELM_CHARTS_DIR) && \
	helm lint

lint-query:
	cd $(QUERY_HELM_CHARTS_DIR) && \
	helm lint

lint-rutime-bundle:
	cd $(RUNTIME_BUNDLE_HELM_CHARTS_DIR) && \
	helm lint


package-connector: lint-connector
	cd $(CONNECTOR_HELM_DIR) && \
  helm package connector/charts

package-identity-adapter: lint-identity-adapter
	cd $(IDENTITY_ADAPTER_HELM_DIR) && \
	helm package identity-adapter/charts

package-query: lint-query
	cd $(QUERY_HELM_DIR) && \
	helm package query/charts

package-runtime-bundle:
	cd $(RUNTIME_BUNDLE_HELM_DIR) && \
	helm package runtime-bundle/charts


lint: lint-identity-adapter lint-query lint runtime-bundle

package: package-identity-adapter package-query package-connector package-runtime-bundle
