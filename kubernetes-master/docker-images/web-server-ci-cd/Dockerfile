FROM centos
RUN yum install httpd -y
RUN echo "<h1>Hello v7</h1>" >/var/www/html/index.html
CMD /usr/sbin/httpd -DFOREGROUND 
