
# TaskFlow – CI/CD Using Jenkins and Terraform

TaskFlow is a simple task management web application developed to demonstrate CI/CD automation using Jenkins and Infrastructure as Code (IaC) using Terraform.

The project automates application checkout, dependency installation, testing, and deployment to AWS EC2.

## Tech Stack

- **Frontend:** HTML, CSS
- **Backend:** Python, Flask
- **Testing:** Pytest
- **Version Control:** Git, GitHub
- **CI/CD:** Jenkins (Docker)
- **Infrastructure as Code:** Terraform
- **Cloud:** AWS EC2 (Amazon Linux 2023)
- **Deployment:** SSH, SCP, systemd

## Project Structure

```text
TaskFlow-CICD/
├── app.py
├── requirements.txt
├── test_app.py
├── Jenkinsfile
├── README.md
├── templates/
│   └── index.html
├── static/
│   └── style.css
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── .gitignore
```

## Application Features

- View and add tasks.
- Mark tasks as completed or undo completion.
- Delete tasks.
- Simple responsive web interface.

## Jenkins CI/CD Pipeline

The Jenkins pipeline consists of four main stages:

1. **Checkout:** Retrieves source code from GitHub.
2. **Build:** Creates a Python virtual environment and installs dependencies.
3. **Test:** Executes automated tests using Pytest.
4. **Deploy:** Transfers application files to EC2, installs dependencies, and restarts the application service.

Jenkins runs inside a Docker container and is accessible at `http://localhost:8080`.

## Terraform Infrastructure

Terraform provisions the following AWS resources:

- Default VPC and subnet lookup.
- Security Group with restricted SSH and application access.
- Amazon Linux 2023 EC2 instance.

### Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

To remove resources after the demonstration:

```bash
terraform destroy
```

## Application Deployment

The application runs on EC2 using a systemd service.

Access it through:

```text
http://<EC2-PUBLIC-IP>:5000
```

## CI/CD Workflow

1. Push application changes to GitHub.
2. Trigger the Jenkins pipeline.
3. Jenkins checks out the latest code.
4. Dependencies are installed and tests are executed.
5. If tests pass, the application is deployed to EC2.
6. Jenkins restarts the application service.

## Conclusion

This project demonstrates automated application building, testing, and deployment using Jenkins, along with AWS infrastructure provisioning through Terraform. It provides practical exposure to essential DevOps and CI/CD concepts.
