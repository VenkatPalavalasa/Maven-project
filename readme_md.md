# Automated CI/CD Pipeline for Maven Web Application with Jenkins and Docker

An end-to-end DevOps project demonstrating automated building, containerization, and deployment of a Java Maven web application using Jenkins, Docker, and Apache Tomcat on an AWS Ubuntu EC2 instance.

---

## 🛠️ Tech Stack
* **Source Control:** Git & GitHub
* **Build Tool:** Apache Maven (`M3`)
* **CI/CD Automation:** Jenkins (Declarative Pipeline)
* **Containerization:** Docker & Tomcat
* **Cloud Infrastructure:** AWS EC2 (Ubuntu)

---

## 🚀 Step-by-Step Implementation Guide

### Step 1: Jenkins Server Setup in Linux VM
Connect to your AWS EC2 Ubuntu instance using MobaXterm and run the following commands:

#### 1. Install Java
```bash
sudo apt update
sudo apt install fontconfig openjdk-21-jre
java -version
```

#### 2. Install Jenkins
```bash
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update -y
sudo apt install jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

* **AWS Security Group Requirement:** Open port `8080`.
* **Access Jenkins:** `http://<your-public-IP>:8080`
* **Unlock Jenkins Admin Password:**
  ```bash
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```

---

### Step 2: Install and Configure Docker
```bash
curl -fsSL get.docker.com | /bin/bash
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl restart jenkins
sudo docker version
newgrp docker
```

---

### Step 3: Dockerfile Configuration
Create a `Dockerfile` in the root of your repository:

```dockerfile
FROM tomcat:latest
MAINTAINER Venkat <venkat@axisbank.com>
EXPOSE 8080
COPY target/my-webapp.war /usr/local/tomcat/webapps/my-webapp.war
```

---

### Step 4: Jenkins Declarative Pipeline Script
Create a new Pipeline job in Jenkins and use the following script:

```groovy
pipeline {
    agent any
    tools{
        maven 'M3'
    }
    stages {
        stage('clone') {
            steps {
                git branch: 'main', url: 'https://github.com/VenkatPalavalasa/Maven-project.git'
            }
        }
        stage('Maven build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Docker image') {
            steps {
                sh 'docker build -t venkatit/mavenapp .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker stop venkatc || true'
                sh 'docker rm venkatc || true'
                sh 'docker run -d -p 9090:8080 --name venkatc venkatit/mavenapp'
            }
        }
    }
}
```

---

### Step 5: Accessing the Application
* **AWS Security Group Requirement:** Open port `9090`.
* **Application URL:**
  ```text
  http://<your-public-IP>:9090/my-webapp/
  ```