FROM openemr/openemr:8.0.0

ENV OE_MODE=production

# Disable SSL (Railway handles HTTPS)
RUN sed -i '/SSLCertificateFile/d' /etc/apache2/conf.d/openemr.conf || true
RUN sed -i '/SSLCertificateKeyFile/d' /etc/apache2/conf.d/openemr.conf || true
RUN sed -i '/SSLEngine on/d' /etc/apache2/conf.d/openemr.conf || true

# Remove ssl module if exists
RUN rm -f /etc/apache2/conf.d/ssl.conf || true

# Ensure Apache listens on Railway dynamic port at runtime
# and start Apache using the correct Alpine command
CMD sed -i "s/Listen 80/Listen ${PORT:-80}/g" /etc/apache2/httpd.conf && \
    sed -i "s/Listen 80/Listen ${PORT:-80}/g" /etc/apache2/ports.conf || true && \
    exec httpd -D FOREGROUND
