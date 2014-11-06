PWD=$(shell pwd)
LUAJIT_DIR=/usr/local/luajit
LUAJIT_LIB=$(LUAJIT_DIR)/lib
LUAJIT_INC=$(LUAJIT_DIR)/include/luajit-2.0
RESTY_MODULE=$(PWD)/lib/ngx_openresty
NGINX=$(PWD)/nginx/sbin/nginx

ENV=$(shell echo LUAJIT_LIB=$(LUAJIT_LIB) LUAJIT_INC=$(LUAJIT_INC))

start:
	$(NGINX) -c $(PWD)/nginx.conf -p $(PWD)

restart:
	$(NGINX) -c $(PWD)/nginx.conf -s reload -p $(PWD)

stop:
	$(NGINX) -c $(PWD)/nginx.conf -s stop -p $(PWD)

status:
	ps aux | grep nginx

install: setup
	$(ENV) && cd lib/ngx_openresty && \
		./configure --prefix=$(PWD) \
		--with-cc-opt="-O0 -I$(PCRE_LIB)/include" \
		--with-ld-opt="-L$(PCRE_LIB)/lib" \
		--with-luajit  \
		-j2
	make -C $(PWD)/lib/ngx_openresty
	make -C $(PWD)/lib/ngx_openresty install

setup:
	test -d nginx || mkdir nginx

__clean:
	test -d $(PWD)/nginx || rm -rf $(PWD)/nginx
	test -d $(PWD)/luajit || rm -rf $(PWD)/luajit
	test -d $(PWD)/lualib || rm -rf $(PWD)/lualib
	test -d $(PWD)/bin || rm -rf $(PWD)/bin

start-redis:
	redis-server redis.conf

