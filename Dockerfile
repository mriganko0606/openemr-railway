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
# Switch to root to ensure we can modify config files
USER root

COPY run_railway.sh /usr/local/bin/run_railway.sh
RUN chmod +x /usr/local/bin/run_railway.sh

ENTRYPOINT ["/usr/local/bin/run_railway.sh"]
