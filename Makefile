VET_REPORT = vet.report
TEST_REPORT = tests.xml
GOARCH = amd64

PACKAGE=github.com/dyhpoon/testargo
BUILD_DIR=${GOPATH}/src/${PACKAGE}
DIST_DIR=${GOPATH}/src/${PACKAGE}/dist
CURRENT_DIR=$(shell pwd)
BUILD_DIR_LINK=$(shell readlink ${BUILD_DIR})

VERSION=$(shell cat ${BUILD_DIR}/VERSION)
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

LDFLAG = -ldflags "-X ${PACKAGE}.Version=${VERSION} -X ${PACKAGE}.Revision=${COMMIT} -X ${PACKAGE}.Branch=${BRANCH}"

# Build the project
all: lint

cli:
	cd ${BUILD_DIR}; \
	go build -i ${LDFLAG} -o ${DIST_DIR}/argo ./cli ; \
	cd - >/dev/null

workflow:
	cd ${BUILD_DIR}; \
	go build -i ${LDFLAG} -o ${DIST_DIR}/workflow-controller ./workflow; \
	cd - >/dev/null

workflow-image: workflow
	cd ${BUILD_DIR}; \
	docker build -f Dockerfile-workflow-controller . ;\
	cd - >/dev/null

link:
	BUILD_DIR=${BUILD_DIR}; \
	BUILD_DIR_LINK=${BUILD_DIR_LINK}; \
	CURRENT_DIR=${CURRENT_DIR}; \
	if [ "$${BUILD_DIR_LINK}" != "$${CURRENT_DIR}" ]; then \
		echo "Fixing symlinks for build"; \
		rm -f $${BUILD_DIR}; \
		ln -s $${CURRENT_DIR} $${BUILD_DIR}; \
	fi

test:
	cd ${BUILD_DIR}; \
	go test ./...
	cd - >/dev/null

lint:
	cd ${BUILD_DIR}; \
	gometalinter.v2 --config gometalinter.json ./... ; \
	cd - >/dev/null

fmt:
	cd ${BUILD_DIR}; \
	go fmt $$(go list ./... | grep -v /vendor/); \
	cd - >/dev/null

clean:
	-rm -rf ${DIST_DIR}

.PHONY: builder cli cli-linux cli-darwin workflow workflow-image lint test fmt clean
