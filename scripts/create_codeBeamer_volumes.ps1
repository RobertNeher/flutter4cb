# creating codeBeamer volumes:
docker volume create --name=codebeamer-app-logo
docker volume create --name=codebeamer-app-logs
docker volume create --name=codebeamer-app-tmp
docker volume create --name=codebeamer-app-repository-search
docker volume create --name=codebeamer-app-repository-logs
docker volume create --name=codebeamer-app-repository-update
docker volume create --name=codebeamer-app-repository-access
docker volume create --name=codebeamer-app-repository-svn
docker volume create --name=codebeamer-app-repository-git
docker volume create --name=codebeamer-app-repository-hg
docker volume create --name=codebeamer-app-repository-docs
docker volume create --name=codebeamer-app-repository-wiki
docker volume create --name=codebeamer-db-data