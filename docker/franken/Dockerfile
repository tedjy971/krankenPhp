FROM dunglas/frankenphp:latest-builder AS builder

# Copy xcaddy in the builder image
COPY --from=caddy:builder /usr/bin/xcaddy /usr/bin/xcaddy

# CGO must be enabled to build FrankenPHP
ENV CGO_ENABLED=1 XCADDY_SETCAP=1 XCADDY_GO_BUILD_FLAGS="-ldflags '-w -s'"
RUN xcaddy build \
	--output /usr/local/bin/frankenphp \
	--with github.com/dunglas/frankenphp=./ \
	--with github.com/dunglas/frankenphp/caddy=./caddy/ \
	# Mercure and Vulcain are included in the official build, but feel free to remove them
	--with github.com/dunglas/mercure/caddy \
	--with github.com/dunglas/vulcain/caddy
	# Add extra Caddy modules here

FROM dunglas/frankenphp AS runner

RUN install-php-extensions \
	pdo_mysql \
	gd \
	intl \
	zip \
	opcache

#Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Replace the official binary by the one contained your custom modules
COPY --from=builder /usr/local/bin/frankenphp /usr/local/bin/frankenphp