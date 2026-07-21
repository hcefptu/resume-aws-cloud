# ☁️ Cloud Resume Challenge - Backend & Infrastructure as Code (IaC)

![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Serverless-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=FF9900)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.9-3776AB?style=for-the-badge&logo=python&logoColor=white)

An automated, serverless backend infrastructure built for the **Cloud Resume Challenge**, fully provisioned via **Infrastructure as Code (Terraform)** and deployed using an automated **CI/CD Pipeline (GitHub Actions)**.

---

## 🚀 Live Endpoints

* 🌐 **Live Website (CloudFront CDN):** [https://d2h0q7wi62zlmv.cloudfront.net](https://d2h0q7wi62zlmv.cloudfront.net)
* 🔗 **Visitor Counter API (API Gateway):** [https://3fj6ti386b.execute-api.ap-southeast-1.amazonaws.com/count](https://3fj6ti386b.execute-api.ap-southeast-1.amazonaws.com/count)

---

## 📐 System Architecture

```mermaid
flowchart TD
    classDef client fill:#E5F6FF,stroke:#0078D4,stroke-width:2px,color:#000;
    classDef cdn fill:#FFF0F5,stroke:#FF1493,stroke-width:2px,color:#000;
    classDef storage fill:#FFF8DC,stroke:#DAA520,stroke-width:2px,color:#000;
    classDef api fill:#E6F9E6,stroke:#2E8B57,stroke-width:2px,color:#000;
    classDef compute fill:#FFF5EE,stroke:#FF4500,stroke-width:2px,color:#000;
    classDef db fill:#F3E5F5,stroke:#8A2BE2,stroke-width:2px,color:#000;

    Client["👤 User Browser"]:::client
    CF["🌐 Amazon CloudFront<br/>(Global CDN)"]:::cdn
    S3["🪣 Amazon S3<br/>(Static Website Hosting)"]:::storage
    APIGW["⚡ API Gateway<br/>(HTTP API Routes)"]:::api
    Lambda["🚀 AWS Lambda<br/>(Python 3.9 Service)"]:::compute
    DDB["🗄️ Amazon DynamoDB<br/>(Visitor Counter Table)"]:::db

    Client -->|1. Request Resume Page| CF
    CF -->|2. Fetch Assets via OAC| S3
    Client -->|3. Fetch / Update Visitor Count| APIGW
    APIGW -->|4. Trigger Lambda Event| Lambda
    Lambda -->|5. Get & Increment Counter| DDB
