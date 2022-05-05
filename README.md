# Kubernetes DB Load Test

This is a sample application to add data to a database. It's a simple tool that consists of three components: 
* MySQL Database
* Application which exposes a REST API to store blogposts
* Load generator

## DISCLAIMER

**The purpose of this repository is to act as a demo for deploying a small workload on Kubernetes and generate load that results in data being added to a MySQL database.  This is not a production application and should only be used in test environments or environments to test out certain scenarios.** 

## Usage

**Prerequisites**

* Access to a container registry and the necessary permissions to upload images
* Access to a Kubernetes cluster and the necessary RBAC permissions to deploy pods.
* Kubernetes cluster can access the container registry to download the images.
* Have your local `kubectl` installation authenticated with the cluster.

**Initial Steps**

Create a file named `.envrc` in both the [loadgenerator](./loadgenerator) and [app](./app) directory.  Initialise the following environment variables in each file:
* `loadgenerator/.envrc`: `LOAD_GENERATOR_IMAGE_NAME`
* `app/.envrc`: `BLOG_IMAGE_NAME`

They should point to the fully qualified name of the container image, including the full URL to the container registry.  For example, if you have an Artifact Registry in Europe West1, the container image name should look like this: `europe-west1-docker.pkg.dev/[PROJECT_ID]/[REGISTRY_NAME]/[CONTAINER_IMAGE_NAME]`.

Both the application and the load generator use a multi-stage docker build to download the dependencies, build and package the application in a container image.

**Deploy**

Open a terminal in the root folder of this directory and run the following command:

```shell
# Deploy application resources
./build.sh
```

This will run the following commands in the sub-directories:
1. [app](./app): `make build/docker`
2. [loadgenerator](./loadgenerator): `make build/docker`
3. [deployment](./deployment): `./deploy.sh`

The deployment creates the following resources on the cluster:
- Namespace
- Secret to store the MySQL root password, MySQL user password and user identity to authenticate with the MySQL server.
- Service and Deployment for MySQL, incl. a `PersistentVolumeClaim`.
- Service and Deployment for the application
- Deployment for the load generator

Technically, you don't need to expose the application on a Service of type `LoadBalancer`.  If you want to keep internal traffic, you can change the Service type to `ClusterIP`, which will only expose the application to Pods running in the cluster.


**Important Note**

The process uses the command `git describe --always --dirty` as the container image tag.  This means that if you have local edits that are not committed, this will result in different tags.  It's therefore important that you go through the above steps for each directory, every time you make a change to one of the directories.  Ideally, this is done as part of a CI/CD process, but that's not the intent of this repository. 
