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
graph TD
    Client[📱 Client Browser] -->|1. Request Resume Page| CF[🌐 AWS CloudFront CDN]
    CF -->|2. Fetch Static Files| S3[🪣 AWS S3 Bucket]
    Client -->|3. Fetch Visitor Count via JS| APIGW[🌉 AWS API Gateway]
    APIGW -->|4. Invoke Function| Lambda[⚡ AWS Lambda Python]
    Lambda -->|5. Get & Increment Count| Dynamo[🗄️ AWS DynamoDB]
