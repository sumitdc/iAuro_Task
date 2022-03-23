# NodeAPI Task POCs

### AWS Instance Level

```bash
Create 2 AWS Instance i.e, API Server and Jenkins Server
1) API Server Installation
Install Docker, Docker-Compose, AWS-CLI, Nginx, Letsencrypt

2) Jenkins Server Installation
Setup Jenkins and install a appropriate plugin, Install JAVA, Docker, AWS-CLI, Nginx, Letsencrypt
```

### AWS ECR and IAM User Level

```bash
Create an ECR respository for Docker image to be store
Create an IAM User for same ECR repository and configure on both the servers
```

### API Server Level

```bash
Create an docker-compose.yml and docker-compose.service file and also create a symbolic link of docker-comppose.service file in /etc/systemd/system folder location inside a server
```
```bash
Create an SSL certificate with below commands,
sudo apt-get install certbot
sudo service nginx stop
sudo letsencrypt certonly --standalone -d iauro.com
sudo service nginx start
```
```bash
Create an custom nginx-proxy file in /etc/nginx/sites-available/ folder and also create their symbolic link in /etc/nginx/sites-enabled folder location.
NOTE:- Nginx Proxy given in a code name as "iauro.com"
```
```bash
Create an awsecr-login.sh file for login with ECR to push an image on API server
```
### JENKINS Server Level

```bash
Once the installation done, bind the API server instance port 22 with Jenkins Public IP
Use the Jenkins URL which we set in nginx proxy as a domain name
Create a new job as a free-style project
Add a git repository and respective branch
Click on Poll SCM and set the cron as * * * * *
Select the Executable shell and run the bash script which is present in Git repository name as deploy.sh file, with the container-name as a argument
Finally, Click on Apply & Save
```