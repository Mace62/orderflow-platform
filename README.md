# Orderflow Platform

Local app stack (Docker Compose) and Terraform bootstrap for remote state.

## Docker Compose

From `app/`:

```bash
cd app
docker compose up --build
```

Run in the background:

```bash
docker compose up --build -d
```

Stop:

```bash
docker compose down
```

Useful endpoints when the stack is up:

- API gateway: http://localhost:8080
- Dashboard UI: http://localhost:8086
- LocalStack (SQS): http://localhost:4566

Quick checks:

```bash
curl -s http://localhost:8080/healthz
docker compose ps
```

## Terraform bootstrap

Creates the S3 bucket used for Terraform remote state.

From `infra/terraform/bootstrap/`:

```bash
cd infra/terraform/bootstrap
terraform init
terraform plan
terraform apply
```

Bootstrap uses a **local** backend. After apply, other stacks (e.g. `environments/dev`) can use the `orderflow-tfstate` S3 bucket as their remote backend.
