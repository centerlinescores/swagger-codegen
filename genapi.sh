cd ~/cls-core/
git pull
cd ~/swagger-codegen/
git pull
#./swaggerdocker.sh mvn clean package
export TEMPLATES=/gen/modules/swagger-codegen/src/main/resources/mcgnetcore
export SWAGGERFILE=../cls-core/cls-core-swagger.yaml
cp -f $SWAGGERFILE ./swagger.yaml
./swaggerdocker.sh generate -i swagger.yaml -l aspnetcore -t $TEMPLATES -o /gen/mcgnetcore -c ./config.json
#cp ./mcgnetcore/src/IO.Swagger/Models/* ~/cls-core/cls-model/Models/api/
#cp ./mcgnetcore/src/IO.Swagger/Controllers/* ~/cls-core/cls-core/Controllers/api/
#cd ~/cls-core
#export DT=`date +%Y%m%d-%H%M%S`
#git add -A
#git commit -m "Add/Update API files from Swagger specification as of $DT"
#git push
