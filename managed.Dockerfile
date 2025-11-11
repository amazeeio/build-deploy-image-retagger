FROM amazeeio/compose-fixer:main AS --fixer
FROM uselagoon/build-deploy-image:pr-463

RUN mkdir -p /kubectl-build-deploy/hooks/pre-docker-compose-validation
COPY --from=fixer /compose-fixer /kubectl-build-deploy/hooks/pre-docker-compose-validation/01-compose-fixer