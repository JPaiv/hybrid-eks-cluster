# tf-tg-eks
Open Tofu, Terragrunt and EKS system

graph TD
    subgraph "AWS Cloud"
        subgraph "VPC: [per-ec1-prod-main]"
            subgraph "Public Subnets"
                A[NAT Gateway 1]
                B[NAT Gateway 2]
                B[NAT Gateway 3]
            end
            subgraph "Private Subnets"
                C[EKS Node Group 1]
                D[EKS Node Group 2]
                D[EKS Node Group 3]
            end
        end
        E[EKS Control Plane]
        F[S3 Bucket for Terraform State]
        G[DynamoDB Table for State Locking]
    end
