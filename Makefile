ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

CONNECTOR_DIR := connector
CONNECTOR_CORE_DIR := $(CONNECTOR_DIR)/core
CONNECTOR_HELM_DIR := $(CONNECTOR_CORE_DIR)/src/main/helm
CONNECTOR_HELM_CHARTS_DIR := $(CONNECTOR_HELM_DIR)/connector/charts
CONNECTOR_TARGET_HELM_DIR := $(CONNECTOR_CORE_DIR)/target/helm

IDENTITY_ADAPTER_DIR := identity-adapter
IDENTITY_ADAPTER_HELM_DIR := identity-adapter/src/main/helm
IDENTITY_ADAPTER_HELM_CHARTS_DIR := $(IDENTITY_ADAPTER_HELM_DIR)/identity-adapter/charts
IDENTITY_ADAPTER_TARGET_HELM_DIR := $(IDENTITY_ADAPTER_DIR)/target/helm

QUERY_DIR := query
QUERY_CORE_DIR := $(QUERY_DIR)/core
QUERY_HELM_DIR := $(QUERY_CORE_DIR)/src/main/helm
QUERY_HELM_CHARTS_DIR := $(QUERY_HELM_DIR)/query/charts
QUERY_TARGET_HELM_DIR := $(QUERY_DIR)/target/helm

RUNTIME_BUNDLE_DIR := runtime-bundle
RUNTIME_BUNDLE_CORE_DIR := $(RUNTIME_BUNDLE_DIR)/core
RUNTIME_BUNDLE_HELM_DIR := $(RUNTIME_BUNDLE_CORE_DIR)/src/main/helm
RUNTIME_BUNDLE_HELM_CHARTS_DIR := $(RUNTIME_BUNDLE_HELM_DIR)/runtime-bundle/charts
RUNTIME_BUNDLE_TARGET_HELM_DIR := $(RUNTIME_BUNDLE_CORE_DIR)/target/helm

HELM_CHECKOUT_TARGET_DIR := $(ROOT_DIR)/target
HELM_REPO_TARGET_DIR := $(ROOT_DIR)/target/NEDSS-BusinessProcessManagement-Core
HELM_REPO_TARGET_HELM_CHARTS_DIR := $(HELM_REPO_TARGET_DIR)/helm-charts
HELM_REPO_TARGET_INDEX_YAML_FILE = $(HELM_REPO_TARGET_HELM_CHARTS_DIR)/index.yaml

all: build-all docker-push-all helm-repo-index-merge-all

build-all: maven-package-all docker-build-all helm-package-all

helm-repo-index-merge-all: helm-repo-index-merge-connector helm-repo-index-merge-identity-adapter helm-repo-index-merge-query helm-repo-index-merge-runtime-bundle

docker-push-all: docker-push-connector docker-push-identity-adapter docker-push-query

docker-build-all: docker-build-connector docker-build-identity-adapter docker-build-query docker-build-runtime-bundle

maven-package-all:
	mvn -Dmaven.test.skip=true package

clean-all: maven-clean

helm-package-all: helm-package-identity-adapter helm-package-query helm-package-connector helm-package-runtime-bundle

helm-lint-all: helm-lint-identity-adapter helm-lint-query helm-lint-runtime-bundle

helm-repo-index-merge-query: git-pull-helm-repo helm-package-query
	helm repo index $(QUERY_TARGET_HELM_DIR) --merge $(HELM_REPO_TARGET_INDEX_YAML_FILE) --url https://cdcgov.github.io/NEDSS-BusinessProcessManagement-Core/helm-charts
	cp $(QUERY_TARGET_HELM_DIR)/index.yaml $(HELM_REPO_TARGET_INDEX_YAML_FILE)
	cp $(QUERY_TARGET_HELM_DIR)/*.tgz $(HELM_REPO_TARGET_HELM_CHARTS_DIR) && \
 	cd $(HELM_REPO_TARGET_DIR) && git add . && git commit -a -m "Adding helm package" && git push


helm-repo-index-merge-runtime-bundle: git-pull-helm-repo helm-package-runtime-bundle
	helm repo index $(RUNTIME_BUNDLE_TARGET_HELM_DIR) --merge $(HELM_REPO_TARGET_INDEX_YAML_FILE) --url https://cdcgov.github.io/NEDSS-BusinessProcessManagement-Core/helm-charts
	cp $(RUNTIME_BUNDLE_TARGET_HELM_DIR)/index.yaml $(HELM_REPO_TARGET_INDEX_YAML_FILE)
	cp $(RUNTIME_BUNDLE_TARGET_HELM_DIR)/*.tgz $(HELM_REPO_TARGET_HELM_CHARTS_DIR) && \
 	cd $(HELM_REPO_TARGET_DIR) && git add . && git commit -a -m "Adding helm package" && git push

helm-repo-index-merge-identity-adapter: git-pull-helm-repo helm-package-identity-adapter
	helm repo index $(IDENTITY_ADAPTER_TARGET_HELM_DIR) --merge $(HELM_REPO_TARGET_INDEX_YAML_FILE) --url https://cdcgov.github.io/NEDSS-BusinessProcessManagement-Core/helm-charts
	cp $(IDENTITY_ADAPTER_TARGET_HELM_DIR)/index.yaml $(HELM_REPO_TARGET_INDEX_YAML_FILE)
	cp $(IDENTITY_ADAPTER_TARGET_HELM_DIR)/*.tgz $(HELM_REPO_TARGET_HELM_CHARTS_DIR) && \
 	cd $(HELM_REPO_TARGET_DIR) && git add . && git commit -a -m "Adding helm package" && git push

helm-repo-index-merge-connector: git-pull-helm-repo helm-package-connector
	helm repo index $(CONNECTOR_TARGET_HELM_DIR) --merge $(HELM_REPO_TARGET_INDEX_YAML_FILE) --url https://cdcgov.github.io/NEDSS-BusinessProcessManagement-Core/helm-charts
	cp $(CONNECTOR_TARGET_HELM_DIR)/index.yaml $(HELM_REPO_TARGET_INDEX_YAML_FILE)
	cp $(CONNECTOR_TARGET_HELM_DIR)/*.tgz $(HELM_REPO_TARGET_HELM_CHARTS_DIR) && \
 	cd $(HELM_REPO_TARGET_DIR) && git add . && git commit -a -m "Adding helm package" && git push

git-pull-helm-repo: | $(HELM_REPO_TARGET_DIR)
	cd $(HELM_REPO_TARGET_DIR) && \
	git pull origin gh-pages

$(HELM_REPO_TARGET_DIR): | $(HELM_CHECKOUT_TARGET_DIR)
	cd $(HELM_CHECKOUT_TARGET_DIR) && \
	git clone --branch gh-pages git@github.com:CDCgov/NEDSS-BusinessProcessManagement-Core.git

$(HELM_CHECKOUT_TARGET_DIR):
	mkdir $(HELM_CHECKOUT_TARGET_DIR)

docker-build-connector: maven-package-connector
	cd $(CONNECTOR_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-connector: docker-build-connector
	cd $(CONNECTOR_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

docker-build-identity-adapter: maven-package-identity-adapter
	cd $(IDENTITY_ADAPTER_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-identity-adapter: docker-build-identity-adapter
	cd $(IDENTITY_ADAPTER_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

docker-build-query: maven-package-query
	cd $(QUERY_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:build

docker-push-query: docker-build-query
	cd $(QUERY_CORE_DIR) && \
	mvn -Dmaven.test.skip=true docker:push

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
  helm package connector/charts --destination $(ROOT_DIR)/$(CONNECTOR_TARGET_HELM_DIR)

helm-package-identity-adapter: helm-lint-identity-adapter
	cd $(IDENTITY_ADAPTER_HELM_DIR) && \
	helm package identity-adapter/charts --destination $(ROOT_DIR)/$(IDENTITY_ADAPTER_TARGET_HELM_DIR)

helm-package-query: helm-lint-query
	cd $(QUERY_HELM_DIR) && \
	helm package query/charts --destination $(ROOT_DIR)/$(QUERY_TARGET_HELM_DIR)

helm-package-runtime-bundle: helm-lint-runtime-bundle
	cd $(RUNTIME_BUNDLE_HELM_DIR) && \
	helm package runtime-bundle/charts --destination $(ROOT_DIR)/$(RUNTIME_BUNDLE_TARGET_HELM_DIR)

maven-clean:
	mvn clean

maven-package-connector:
	cd $(CONNECTOR_DIR) && \
	mvn -Dmaven.test.skip=true package

maven-package-identity-adapter:
	cd $(IDENTITY_ADAPTER_DIR) && \
	mvn -Dmaven.test.skip=true package

maven-package-query:
	cd $(QUERY_DIR) && \
	mvn -Dmaven.test.skip=true package

maven-package-runtime-bundle:
	cd $(RUNTIME_BUNDLE_DIR) && \
	mvn -Dmaven.test.skip=true package



