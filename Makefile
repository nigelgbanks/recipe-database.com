IMAGE=recipe-database.com
TAG=latest

default: build

build:
	docker build . -t $(IMAGE):$(TAG)

dev:
	docker build --target dev -t $(IMAGE):dev .

test:
	docker build --target test -t $(IMAGE):test .

yarn: dev
	docker run --rm -ti -v $(PWD)/package.json:/app/package.json -v $(PWD)/yarn.lock:/app/yarn.lock --entrypoint yarn $(IMAGE):dev $(filter-out $@,$(MAKECMDGOALS))

%:
	@:

.PHONY: build dev test yarn