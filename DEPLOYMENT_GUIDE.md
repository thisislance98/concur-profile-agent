# FastAPI Deployment Guide for SAP Cloud Foundry

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Project Setup](#project-setup)
4. [Application Development](#application-development)
5. [Configuration Files](#configuration-files)
6. [Local Testing](#local-testing)
7. [Cloud Foundry Deployment](#cloud-foundry-deployment)
8. [Testing Deployed Application](#testing-deployed-application)
9. [Application Management](#application-management)
10. [Troubleshooting](#troubleshooting)
11. [Advanced Topics](#advanced-topics)

## Introduction

This guide provides a complete walkthrough for deploying FastAPI applications to SAP Business Technology Platform (BTP) using Cloud Foundry. FastAPI is a modern, fast web framework for building APIs with Python 3.7+ that provides automatic API documentation and high performance.

### What You'll Build
- A FastAPI hello world service with multiple endpoints
- Automatic API documentation via Swagger UI
- Health check endpoint for monitoring
- Production-ready deployment on SAP BTP

## Prerequisites

### 1. SAP BTP Account Setup
- Access to a BTP Subaccount
- Cloud Foundry Environment enabled
- A space within the Cloud Foundry environment

### 2. Required Entitlements
Ensure your BTP Subaccount has the following entitlements:

| Name | Technical Name | Plan | Quota |
|------|----------------|------|-------|
| Cloud Foundry Runtime | APPLICATION_RUNTIME | MEMORY | At least 1GB |
| Authorization and Trust Management Service | xsuaa | application | At least 1 |

### 3. Local Development Tools
- **Python 3.10+** installed on your machine
- **Cloud Foundry CLI** ([Download here](https://docs.cloudfoundry.org/cf-cli/install-go-cli.html))
- **Git** (optional, for version control)
- **Text editor** or IDE (VS Code, PyCharm, etc.)

### 4. Verify CF CLI Installation
```bash
cf --version
# Should return: cf version 7.x.x+...
```

## Project Setup

### 1. Create Project Directory
```bash
mkdir fastapi-cf-deployment
cd fastapi-cf-deployment
```

### 2. Set Up Python Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On macOS/Linux:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### 3. Install FastAPI Dependencies
```bash
pip install fastapi==0.104.1 uvicorn==0.24.0 pydantic==2.5.0
```

## Application Development

### 1. Create the Main Application File (`app.py`)

```python
import os
from fastapi import FastAPI

# Create FastAPI instance
app = FastAPI(title="Hello World API", version="1.0.0")

@app.get("/")
def read_root():
    """Root endpoint returning a hello world message"""
    return {"message": "Hello World from FastAPI on SAP Cloud Foundry!"}

@app.get("/health")
def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "FastAPI Hello World"}

@app.get("/hello/{name}")
def say_hello(name: str):
    """Personalized hello endpoint"""
    return {"message": f"Hello {name}!"}

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)
```

### 2. Key FastAPI Features in This Example

- **Automatic Documentation**: FastAPI generates interactive API docs
- **Type Hints**: Using Python type hints for validation
- **Path Parameters**: Dynamic routing with `{name}` parameter
- **Environment Variables**: Reading `PORT` from environment
- **Health Endpoint**: Essential for Cloud Foundry health monitoring

## Configuration Files

### 1. Requirements File (`requirements.txt`)

```text
fastapi==0.104.1
uvicorn==0.24.0
pydantic==2.5.0
```

**Purpose**: Specifies Python dependencies for Cloud Foundry buildpack

### 2. Procfile

```text
web: uvicorn app:app --host 0.0.0.0 --port $PORT
```

**Purpose**: Tells Cloud Foundry how to start your application

### 3. Runtime Specification (`runtime.txt`)

```text
python-3.10.x
```

**Purpose**: Specifies Python version for the buildpack

### 4. Cloud Foundry Manifest (`manifest.yml`)

```yaml
---
applications:
- name: fastapi-hello-world
  memory: 256M
  disk_quota: 512M
  instances: 1
  buildpacks:
    - python_buildpack
  command: uvicorn app:app --host 0.0.0.0 --port $PORT
  env:
    PYTHONPATH: .
  services: []
```

**Key Configuration Options**:
- `name`: Application name in Cloud Foundry
- `memory`: RAM allocation (adjust based on needs)
- `disk_quota`: Storage allocation
- `instances`: Number of app instances
- `buildpacks`: Specifies Python buildpack
- `command`: Override start command
- `env`: Environment variables
- `services`: Bound services (databases, etc.)

### 5. Optional: CF Ignore File (`.cfignore`)

```text
venv/
__pycache__/
*.pyc
.env
.git/
README.md
*.log
```

**Purpose**: Excludes files from deployment package

## Local Testing

### 1. Start the Application Locally

```bash
# Method 1: Direct Python execution
python app.py

# Method 2: Using uvicorn directly
uvicorn app:app --reload --host 0.0.0.0 --port 8000
```

### 2. Test Endpoints

```bash
# Test root endpoint
curl http://localhost:8000
# Expected: {"message":"Hello World from FastAPI on SAP Cloud Foundry!"}

# Test health endpoint
curl http://localhost:8000/health
# Expected: {"status":"healthy","service":"FastAPI Hello World"}

# Test parameterized endpoint
curl http://localhost:8000/hello/John
# Expected: {"message":"Hello John!"}

# View API documentation
open http://localhost:8000/docs
```

### 3. Verify Project Structure

```
fastapi-cf-deployment/
├── app.py
├── requirements.txt
├── Procfile
├── runtime.txt
├── manifest.yml
├── .cfignore (optional)
└── venv/ (local only)
```

## Cloud Foundry Deployment

### 1. Login to Cloud Foundry

```bash
# Set API endpoint (replace with your BTP endpoint)
cf api https://api.cf.eu12.hana.ondemand.com

# Login with SSO
cf login --sso

# Or login with username/password
cf login
```

### 2. Verify Target Environment

```bash
cf target
```

Should display:
- API endpoint
- User
- Organization
- Space

### 3. Deploy Application

```bash
# Deploy using manifest.yml
cf push

# Or deploy with custom name
cf push my-custom-app-name
```

### 4. Monitor Deployment

The deployment process includes:
1. **Uploading files** (your app code)
2. **Staging** (buildpack creates container)
3. **Starting** (launches your application)

### 5. Deployment Output Example

```
Pushing app fastapi-hello-world to org myorg / space dev...
Applying manifest file manifest.yml...
Packaging files to upload...
Uploading files...
Staging app and tracing logs...
   -----> Python Buildpack version 1.8.37
   -----> Installing python 3.10.17
   -----> Running Pip Install
   Successfully installed fastapi uvicorn pydantic...
Waiting for app fastapi-hello-world to start...

name:              fastapi-hello-world
requested state:   started
routes:            fastapi-hello-world.cfapps.eu12.hana.ondemand.com
instances:         1/1
memory usage:      256M
```

## Testing Deployed Application

### 1. Basic Endpoint Testing

```bash
# Get your app URL from cf push output or:
cf apps

# Test deployed application
curl https://your-app-name.cfapps.eu12.hana.ondemand.com

# Test health endpoint
curl https://your-app-name.cfapps.eu12.hana.ondemand.com/health

# Test parameterized endpoint
curl https://your-app-name.cfapps.eu12.hana.ondemand.com/hello/CloudFoundry
```

### 2. API Documentation Access

- **Swagger UI**: `https://your-app-name.cfapps.eu12.hana.ondemand.com/docs`
- **ReDoc**: `https://your-app-name.cfapps.eu12.hana.ondemand.com/redoc`
- **OpenAPI JSON**: `https://your-app-name.cfapps.eu12.hana.ondemand.com/openapi.json`

### 3. Performance Testing

```bash
# Simple load test with curl
for i in {1..10}; do
  curl -w "Time: %{time_total}s\n" -o /dev/null -s \
  https://your-app-name.cfapps.eu12.hana.ondemand.com
done
```

## Application Management

### 1. Common CF Commands

```bash
# View all applications
cf apps

# Check application details
cf app fastapi-hello-world

# View recent logs
cf logs fastapi-hello-world --recent

# Stream live logs
cf logs fastapi-hello-world

# Scale application
cf scale fastapi-hello-world -i 2 -m 512M

# Restart application
cf restart fastapi-hello-world

# Stop application
cf stop fastapi-hello-world

# Start application
cf start fastapi-hello-world

# Delete application
cf delete fastapi-hello-world
```

### 2. Environment Variables

```bash
# Set environment variable
cf set-env fastapi-hello-world DEBUG true

# View environment variables
cf env fastapi-hello-world

# Unset environment variable
cf unset-env fastapi-hello-world DEBUG

# Restart after env changes
cf restart fastapi-hello-world
```

### 3. Application Health Monitoring

Cloud Foundry automatically monitors your app using:
- **HTTP health checks** on your app's port
- **Process health checks** for the running process

Ensure your app responds to HTTP requests for proper health monitoring.

## Troubleshooting

### 1. Common Deployment Issues

#### Build Failures
```bash
# View detailed staging logs
cf logs fastapi-hello-world --recent | grep -A 10 -B 10 "ERROR"

# Common causes:
# - Missing requirements.txt
# - Wrong Python version in runtime.txt
# - Syntax errors in app.py
```

#### Application Won't Start
```bash
# Check application logs
cf logs fastapi-hello-world --recent

# Common causes:
# - Port binding issues (ensure app listens on $PORT)
# - Missing dependencies
# - Application crashes on startup
```

#### Memory Issues
```bash
# Check memory usage
cf app fastapi-hello-world

# Increase memory allocation
cf scale fastapi-hello-world -m 512M
```

### 2. Debugging Tips

#### Enable Debug Mode
```python
# In app.py, add debug mode for development
app = FastAPI(title="Hello World API", version="1.0.0", debug=True)
```

#### Add Logging
```python
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.get("/")
def read_root():
    logger.info("Root endpoint accessed")
    return {"message": "Hello World from FastAPI on SAP Cloud Foundry!"}
```

#### Environment Variable Debugging
```python
@app.get("/env")
def show_env():
    return {
        "port": os.environ.get("PORT", "Not set"),
        "pythonpath": os.environ.get("PYTHONPATH", "Not set"),
        "vcap_application": os.environ.get("VCAP_APPLICATION", "Not set")
    }
```

### 3. Performance Optimization

#### Use Multiple Workers
```yaml
# In manifest.yml
command: uvicorn app:app --host 0.0.0.0 --port $PORT --workers 4
```

#### Optimize Memory Usage
```yaml
# In manifest.yml
memory: 512M  # Adjust based on actual usage
```

## Advanced Topics

### 1. Adding Database Services

#### PostgreSQL Example
```yaml
# In manifest.yml
services:
  - my-postgres-service

# Create service
cf create-service postgresql-db trial my-postgres-service

# Bind to app
cf bind-service fastapi-hello-world my-postgres-service
```

#### Database Connection in Code
```python
import os
import json
from sqlalchemy import create_engine

def get_database_url():
    vcap_services = os.environ.get('VCAP_SERVICES')
    if vcap_services:
        services = json.loads(vcap_services)
        postgres = services.get('postgresql-db', [])
        if postgres:
            credentials = postgres[0]['credentials']
            return credentials['uri']
    return "sqlite:///./local.db"  # Fallback for local dev

engine = create_engine(get_database_url())
```

### 2. Authentication with XSUAA

```yaml
# In manifest.yml
services:
  - my-xsuaa-service

# Create XSUAA service
cf create-service xsuaa application my-xsuaa-service -c xs-security.json
```

### 3. Custom Domains

```bash
# Map custom domain
cf map-route fastapi-hello-world custom-domain.com --hostname api

# View routes
cf routes
```

### 4. Blue-Green Deployment

```bash
# Deploy new version alongside old
cf push fastapi-hello-world-green

# Test green version
curl https://fastapi-hello-world-green.cfapps.eu12.hana.ondemand.com

# Switch traffic
cf map-route fastapi-hello-world-green cfapps.eu12.hana.ondemand.com --hostname fastapi-hello-world
cf unmap-route fastapi-hello-world cfapps.eu12.hana.ondemand.com --hostname fastapi-hello-world

# Remove old version
cf delete fastapi-hello-world
cf rename fastapi-hello-world-green fastapi-hello-world
```

### 5. Multi-Environment Setup

Create environment-specific manifests:

**manifest-dev.yml**:
```yaml
applications:
- name: fastapi-hello-world-dev
  memory: 256M
  instances: 1
  env:
    ENVIRONMENT: development
```

**manifest-prod.yml**:
```yaml
applications:
- name: fastapi-hello-world-prod
  memory: 512M
  instances: 3
  env:
    ENVIRONMENT: production
```

Deploy to specific environments:
```bash
cf push -f manifest-dev.yml   # Development
cf push -f manifest-prod.yml  # Production
```

## Conclusion

You now have a complete guide for deploying FastAPI applications to SAP Cloud Foundry. This setup provides:

- ✅ **Modern API Framework**: FastAPI with automatic documentation
- ✅ **Production Ready**: Proper configuration for Cloud Foundry
- ✅ **Scalable**: Easy horizontal and vertical scaling
- ✅ **Monitorable**: Health checks and logging
- ✅ **Maintainable**: Clear project structure and configuration

### Next Steps

1. **Add Business Logic**: Extend your FastAPI app with real functionality
2. **Database Integration**: Connect to PostgreSQL or other databases
3. **Authentication**: Implement XSUAA or other auth services
4. **API Versioning**: Plan for API evolution
5. **Monitoring**: Set up application monitoring and alerting
6. **CI/CD**: Automate deployment with pipelines

### Useful Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Cloud Foundry CLI Reference](https://cli.cloudfoundry.org/en-US/v7/)
- [SAP BTP Documentation](https://help.sap.com/docs/btp)
- [Python Buildpack Documentation](https://docs.cloudfoundry.org/buildpacks/python/)

Happy deploying! 🚀 