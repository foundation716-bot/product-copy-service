![CI](https://github.com/foundation716-bot/product-copy-service/actions/workflows/ci.yml/badge.svg)

# Product Copy Service

상품 소개문 규칙 검사 서비스. `main`에 push하면 테스트, 이미지 빌드, ECR 푸시, SSH로 EC2 컨테이너 교체가 이어진다.

| job | 하는 일 | 조건 |
| --- | --- | --- |
| `test` | `pytest`와 커버리지 85% | push, pull request |
| `build` | `docker build`로 이미지가 만들어지는지 확인 | `test` 성공 후 |
| `deploy` | ECR에 `latest`를 푸시한 뒤 EC2 컨테이너를 교체 | `build` 성공, 그리고 `main` push일 때만 |

`deploy`가 쓰는 GitHub Actions Secrets는 `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `ECR_REGISTRY`, `EC2_HOST`, `EC2_SSH_KEY`다.

로컬 확인:

```powershell
uv run pytest -q --cov=app --cov-fail-under=85
```

기대 결과는 `6 passed`, 커버리지 85% 이상이다. 배포된 서비스는 `/health`, `/docs`, `/check`에 응답하고, `독보적`이 들어간 소개문은 `R4`로 거절한다.
