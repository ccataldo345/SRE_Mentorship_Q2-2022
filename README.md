## SRE Mentorship Q2 2022:  

### Networking  
- OSI Model  
- DNS  

### Docker  
```
### Exercise 1:  
Build a Docker image for a Python application and push it to DockerHub.  
			
Solution:    
 > https://github.com/ccataldo345/SRE_Mentorship_Q2-2022/tree/main/hello-world-python  
 > https://hub.docker.com/r/chris345000/hello-world-python  
```

### Build System (Continiues Integration/Continius delivery)  
- Jenkins  

```
### Exercise 2:  
Run Jenkins with Docker in static persist storage.  
Pipeline: Compile, Test, Integration Test.  
Build, Package and push to Docker Hub  
				
Solution:  
 > https://github.com/ccataldo345/jenkin-devops-microservice  
 > https://github.com/ccataldo345/jenkin-devops-microservice/blob/main/Jenkinsfile  
 > https://github.com/ccataldo345/SRE_Mentorship_Q2-2022/blob/main/Jenkins_notes.txt  
```
```		
### Exercise 3:  
Automate some steps on Jenkins:  
	- Installing plugins (Docker, Maven, Apache)  
	- Setup admin password with Docker compose env variables  
	- Global tools configuration  
						
Solution:  
> CLI login with token, install plugin, restart.
> Log in with SSH  
> Set up variables (Docker and mvn config for global build configuration):  
https://plugins.jenkins.io/configuration-as-code/  
- install plugin in Jenkins:  
- java -jar /var/jenkins_home/jenkins-cli.jar -s http://localhost:8081/ -auth @jenkins_admin-token install-plugin c onfiguration-as-code:1429.v09b_044a_c93de safe-restart  
- docker container ls (should be empty, no jenkins container is running)  
- docker container start jenkins  
- go to: Manage Jenkins > Configuration as code > Download configuration (jenkins.yaml)  
- touch /var/jenkins_home/jenkins-config.yaml (nano + paste downloaded file text jenkins.yaml)  
- Replace configuration source with Path or URL:  /var/jenkins_home/jenkins-config.yaml  
- Apply new configuration  
/// ERROR:
if the config file is not working or missing:  
- cp io.jenkins.plugins.casc.CasCGlobalConfig.xml io.jenkins.plugins.casc.CasCGlobalConfig.xml.BKP  
- rm io.jenkins.plugins.casc.CasCGlobalConfig.xml  
- docker container restart jenkins  
> https://github.com/ccataldo345/SRE_Mentorship_Q2-2022/blob/main/jenkins.yaml  
> All the settings can be done in the UI initially, then download the generated yaml file, remove the view line, and use that yaml file all the times; all settings, tools, passwrods, etc, are set there.  
```
						
### AWS basics  
- concepts of AWS  
- AWS networking  
- AWS EC2  
- AWS VPC  

### Centralized Log Management  
- ElasticSearch/AWS OpenSearch service  

### Monitoring/Alerting
- Metrics  

### Infrastructure as Code  
- Terraform
 
```
### Exercises TF 01-10:  
Write Terraform code to create in AWS: EC2, VPC, EKS, ELK.  
			
Solution:  
See folders TF 01-10 in repo.  
```
