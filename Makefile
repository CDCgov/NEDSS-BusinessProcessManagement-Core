CLOUD_CONNECTOR_HELM_DIR := activity-cloud-connector/src/main/helm
IDENTITY_ADAPTER_HELM_DIR := activiti-cloud-identity-adapter/src/main/helm
QUERY_HELM_DIR := activiti-cloud-query/starter/src/main/helm
CLOUD_CONNECTOR_HELM_CHARTS_DIR := $(CLOUD_CONNECTOR_HELM_DIR)/
IDENTITY_ADAPTER_HELM_CHARTS_DIR := $(IDENTITY_ADAPTER_HELM_DIR)/activiti-cloud-identity-adapter/charts
QUERY_HELM_CHARTS_DIR := $(QUERY_HELM_DIR)/activiti-cloud-query/charts

lint-identity-adapter:
	cd $(IDENTITY_ADAPTER_HELM_CHARTS_DIR) && \
	helm lint

lint-query:
	cd $(QUERY_HELM_CHARTS_DIR) && \
	helm lint


package-connector: lint-connector
	cd $(CONNECTOR_HELM_DIR) && \
  helm package activiti-cloud-connecto/charts

package-identity-adapter: lint-identity-adapter
	cd $(IDENTITY_ADAPTER_HELM_DIR) && \
	helm package activiti-cloud-identity-adapter/charts

package-runtime-bundle:
	cd $(RUNTIME_BUNDLE_HELM_DIR) && \
	helm package activiti-cloud-runtime-bundle/charts

package-query: lint-query
	cd $(QUERY_HELM_DIR) && \
	helm package activiti-cloud-query/charts

lint: lint-identity-adapter

package: package-identity-adapter package-query package-connector package-runtime-bundle
