# Product Copy Service

FastAPI service for checking Korean product copy. The `main` branch runs six tests with an 85% coverage floor, builds a Docker image, and publishes `latest` to AWS ECR in Seoul.

The EC2 lab server checks ECR about once per minute using its read-only instance role. When `latest` changes, it restarts the container and checks `/health`. GitHub Actions needs only the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` repository secrets for the ECR-only publisher user. The EC2 security group keeps SSH restricted to the administrator's IP.

Run tests locally with `pytest -q --cov=app --cov-fail-under=85` after installing `requirements.txt`. A successful deployment responds at `/health`, `/docs`, and `/check`. The `독보적` wording must be rejected by `/check`.

This is a temporary educational deployment. The EC2 instance is terminated after the demonstration; the ECR image and repository remain for later lessons.
