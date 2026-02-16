FROM openemr/openemr:8.0.0

ENV OE_MODE=production

# Disable SSL (Railway handles HTTPS)
RUN sed -i '/SSLCertificateFile/d' /etc/apache2/conf.d/openemr.conf || true
RUN sed -i '/SSLCertificateKeyFile/d' /etc/apache2/conf.d/openemr.conf || true
RUN sed -i '/SSLEngine on/d' /etc/apache2/conf.d/openemr.conf || true

# Remove ssl module if exists
RUN rm -f /etc/apache2/conf.d/ssl.conf || true

# Ensure Apache listens on Railway dynamic port
RUN sed -i 's/Listen 80/Listen ${PORT}/g' /etc/apache2/ports.conf || true
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE ${PORT}

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
