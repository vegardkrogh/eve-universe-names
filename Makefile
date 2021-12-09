dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

.DEFAULT_GOAL := run

build:
	docker build -t $(APP_NAME) .

run:
	docker run -i -t --rm --name="$(APP_NAME)" $(APP_NAME)
