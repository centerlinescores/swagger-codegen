build='n'
push='n'

while [[ "$#" > 0 ]]; do case $1 in
    --build) build='y';;
    --push) push='y';;
    *) break;;
  esac; shift; shift
done

echo -e "\e[34m --> Pull current CLS-Core...\e[0m"
cd ~/cls-core/
git pull
echo -e "\e[34m --> Pull current codegen...\e[0m"
cd ~/swagger-codegen/
git pull

if [ $build == 'y' ]
then 
    echo -e "\e[34m --> Rebuilding Swagger-Codegen Packages...\e[0m"
    ./swaggerdocker.sh mvn clean package
fi

echo -e "\e[34m --> Copy Swagger spec...\e[0m"
export TEMPLATES=/gen/modules/swagger-codegen/src/main/resources/mcgnetcore
export SWAGGERFILE=../cls-core/cls-core-swagger.yaml
cp -f $SWAGGERFILE ./swagger.yaml

echo -e "\e[34m --> Generate API code...\e[0m"
./swaggerdocker.sh generate -i swagger.yaml -l aspnetcore -t $TEMPLATES -o /gen/mcgnetcore -c ./config.json

if [ $push == 'y' ]
then 
    echo -e "\e[34m --> Pushing API changes to git repo...\e[0m"
    cp ./mcgnetcore/src/CenterlineScores/Models/* ~/cls-core/cls-model/Models/api/
    cp ./mcgnetcore/src/CenterlineScores/Controllers/*Api.cs ~/cls-core/cls-core/Controllers/api/
    cp ./mcgnetcore/src/CenterlineScores/Controllers/*domain*.cs ~/cls-core/cls-model/Data/
    cp ./mcgnetcore/src/CenterlineScores/DomainRepository.cs ~/cls-core/cls-model/Data/
    cd ~/cls-core
    export DT=`date +%Y%m%d-%H%M%S`
    git add -A
    git commit -m "Add/Update API files from Swagger specification as of $DT"
    git push
fi
