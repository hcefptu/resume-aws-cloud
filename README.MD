# ☁️ Cloud Resume Challenge - Backend & Infrastructure as Code (IaC)

![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Serverless-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=FF9900)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-CI/CD-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.9-3776AB?style=for-the-badge&logo=python&logoColor=white)

An automated, serverless backend infrastructure built for the **Cloud Resume Challenge**, fully provisioned via **Infrastructure as Code (Terraform)** and deployed using an automated **CI/CD Pipeline (GitHub Actions)**.

---

## 📐 Architecture Overview

```text
[ Client Request ]
       │
       ▼
[ CloudFront CDN ]
       │
       ▼
[ S3 Website Bucket ]
       │
 (Fetch Visitor Count)
       ▼
[ API Gateway (HTTP) ]
       │
       ▼
[ AWS Lambda (Python 3.9) ]
       │
       ▼
[ DynamoDB Table ] (Increments & stores visitor count)