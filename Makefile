.PHONY: install build up ub bash

install i:
	rm -f .pw/.gitkeep
	rm -f .pw/.gitattributes

	git clone git://github.com/processwire/processwire.git -b dev .pw

	rm -rf .pw/.git
	rm -f .pw/.DS_Store
	cp -R .pw/* wwww
	rm -rf .pw

	cp php/php.ini www

	make build

up u:
	docker-compose up

up.build ub:
	docker-compose up --build

build b:
	docker-compose build

bash sh s:
	docker run --rm -it \
	-v ${PWD}/log:/var/log/yaws \
	-v ${PWD}/www:/var/www \
	-v ${PWD}/yaws:/usr/local/etc/yaws \
	--entrypoint sh \
	-p 8080:8080 \
	yaws_pw