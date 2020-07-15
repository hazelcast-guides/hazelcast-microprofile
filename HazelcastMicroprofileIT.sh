set -e

mvn clean install

mvn -pl server1 liberty:run-server > /dev/null 2>&1 & 
mvn -pl server2 liberty:run-server > /dev/null 2>&1 &

until curl --silent localhost:9080 | grep -q "Error 404"; do sleep 5; echo "Waiting for server1 to be started..."; done
until curl --silent localhost:9081 | grep -q "Error 404"; do sleep 5; echo "Waiting for server2 to be started..."; done

echo "Triggering Hazelcast Instance on server1..."
curl -X GET "http://localhost:9080/application/map/get?key=1" | grep "1 : null" 

echo "Triggering Hazelcast Instance on server2..."
curl -X GET "http://localhost:9081/application/map/get?key=1" | grep "1 : null" 

# Put from server1
curl -X PUT "http://localhost:9080/application/map/put?key=1&value=greetings_from_server1"

# Read from server2
curl -X GET "http://localhost:9081/application/map/get?key=1" | grep "1 : greetings_from_server1" 

mvn -pl server1 liberty:stop-server
mvn -pl server2 liberty:stop-server