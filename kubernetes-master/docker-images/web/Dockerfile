FROM centos
RUN yum install httpd -y
EXPOSE 80
COPY index.html /var/www/html/index.html
#COPY student.conf /etc/httpd/conf.d/student.conf
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD /startup.sh
