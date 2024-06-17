# new-reef-revelations
unboxing docker scout capabilities

A quest to discover [Docker Scout](https://www.docker.com/products/docker-scout/) and [Docker Build Cloud](https://www.docker.com/products/build-cloud/) while exploring new capabilities of [Docker Desktop](https://www.docker.com/products/business/) and [Docker Hub](https://www.docker.com/products/docker-hub/). <br>

There are new enhancements for docker scout link Notifications and [Metrics Exporter](https://docs.docker.com/scout/metrics-exporter/)

# Overview
Source - The application consists of a basic ExpressJS server and uses an intentionally old version of Express and Alpine base image.<br>

# Prerequisites
Source - To get started, there are few prerequisites to get the full value of Docker Business<br>
Create a [Docker ID]([https://docs.docker.com/scout/quickstart](https://hub.docker.com/signup), if you do not already have one, and [log in to Hub](https://id.docker.com/login).<br>
If you don’t have Docker Desktop installed, [get started](https://www.docker.com/get-started/)<br>
The demo makes use of [DockerScout](https://scout.docker.com/), [DockerHub](https://hub.docker.com/), [Docker CloudBuild](https://build.docker.com/) and [DockerDesktop](docker-desktop://dashboard/build)<br>
Setup docker [scout-cli](https://github.com/docker/scout-cli)<br>
Clone your target Repo  <br>

# Getting Started<br>
Let build, enable scout for our repo, then push the image<br>

1a. Build the image, naming it to match the organization you will push it to, and tag it as v1:<br>

example: docker build -t demonstrationorg/docker-scout-conveyor:v1 .<br>

To make use of docker build cloud<br>

example: docker buildx build --builder cloud-salestestorg-se-cloud-builder --tag demonstrationorg/docker-scout-conveyor:v1 .<br>

1b. Use CI to Build Image and View Scout Info: <br>


2. Create and push the repository on Docker Hub: <br>

3. Enable Docker Scout
docker scout repo enable --org {InsertmyOrg} {InsertmyOrg}/{InsertImageName}:{InsertImageTag}
example: docker scout repo enable --org demonstrationorg demonstrationorg/scout-demo:v1

Upon enabling the repository, you can Manage repositories in the Docker Scout Dashboard?
  → https://scout.docker.com/org/{InsertmyOrg}/settings/repos
  → https://scout.docker.com/org/demonstrationorg/settings/repos

4. Analyze the image vulnerabilities and Remediate as needed

# Software Bill Of Materials (SBOM)
To generate a human-readable list, RUN docker scout sbom --format list docker-new-reef-revelations

# Docker Scout Notifications (SLACK)
You can integrate Docker Scout with Slack by creating a Slack webhook and adding it to the Docker Scout Dashboard.
After configuring the integration, Docker Scout sends notifications about changes to policy compliance and vulnerability exposure for your repositories, to the Slack channels associated with the webhook.


# Docker Build Cloud
The demo can make use of a docker build cloud 
docker buildx build --builder cloud-salestestorg-se-cloud-builder --tag demonstrationorg/scout-cloud-build:v1 .
example: docker buildx build --builder cloud-salestestorg-se-cloud-builder --tag demonstrationorg/scout-cloud-build:v1 . <br>

# Docker Run
docker run scout-demo:v1 <br>

# Docker Desktop
View build details: docker-desktop://dashboard/build/{insertDockerBuildCloudBuilder}/linux-arm64/yqy1m8bqmiqocq5twdly66p6e <br>
View build details: docker-desktop://dashboard/build/cloud-salestestorg-se-cloud-builder/linux-arm64/yqy1m8bqmiqocq5twdly66p6e <br>

# Docker Scout

View a summary of image vulnerabilities and recommendations <br>
→ docker scout quickview <br>
View vulnerabilities <br>
  → docker scout cves local://demonstrationorg/scout-demo-service-python:v1
View base image update recommendations 
  → docker scout recommendations local://demonstrationorg/scout-demo-service-python:v1
Include policy results in your quickview by supplying an organization <br>
  → docker scout quickview local://demonstrationorg/scout-demo-service-python:v1 --org demonstrationorg
 <br>
  → docker scout policy local://demonstrationorg/scout-demo-example-voting-app:v1 --org demonstrationorg
This repository contains a python application and Dockerfile to demonstrate the use of Docker Scout to analyze and remediate CVEs in a container image. <br>



# Docker Scout - 
Incorprate a GitHub Action to run the Docker Scout CLI as part of your workflows.


