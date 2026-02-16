FROM openemr/openemr:8.0.0

# Set production mode
ENV OE_MODE=production

# Railway provides a dynamic PORT variable.
# We reconfigure Apache to listen on that port instead of 80.

RUN sed -i 's/Listen 80/Listen ${PORT}/g' /etc/httpd/conf/httpd.conf 2>/dev/null || true
RUN sed -i 's/Listen 80/Listen ${PORT}/g' /usr/local/apache2/conf/httpd.conf 2>/dev/null || true

# Ensure Apache binds to all interfaces
RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf 2>/dev/null || true
RUN echo "ServerName localhost" >> /usr/local/apache2/conf/httpd.conf 2>/dev/null || true

# Expose Railway port
EXPOSE ${PORT}

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
