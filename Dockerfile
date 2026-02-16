FROM openemr/openemr:8.0.0

ENV OE_MODE=production

# Remove SSL configuration (Railway handles HTTPS)
RUN rm -f /etc/apache2/conf.d/ssl.conf 2>/dev/null || true
RUN rm -f /etc/apache2/conf.d/openemr-ssl.conf 2>/dev/null || true
RUN sed -i '/SSLCertificateFile/d' /etc/apache2/conf.d/openemr.conf 2>/dev/null || true
RUN sed -i '/SSLCertificateKeyFile/d' /etc/apache2/conf.d/openemr.conf 2>/dev/null || true
RUN sed -i '/SSLEngine on/d' /etc/apache2/conf.d/openemr.conf 2>/dev/null || true

# Ensure Apache listens on Railway dynamic port
RUN sed -i 's/Listen 80/Listen ${PORT}/g' /etc/apache2/ports.conf 2>/dev/null || true

# Suppress FQDN warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf 2>/dev/null || true

EXPOSE ${PORT}

CMD ["apache2-foreground"]
