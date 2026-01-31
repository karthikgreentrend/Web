# Use official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies
RUN apt-get update \
    && apt-get install -y libicu-dev libpq-dev git unzip \
    && docker-php-ext-install intl pdo pdo_mysql opcache

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

EXPOSE 80

CMD ["apache2-foreground"]
