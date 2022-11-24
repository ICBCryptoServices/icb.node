# if [ "$MONGO_INITDB_ROOT_USERNAME" ] && [ "$MONGO_INITDB_ROOT_PASSWORD" ]; then
#   "${mongo[@]}" "$MONGO_INITDB_ROOT_PASSWORD" <<-EOJS
#   db.createUser({
#      user: $(_js_escape "$MONGO_INITDB_ROOT_USERNAME"),
#      pwd: $(_js_escape "$MONGO_INITDB_ROOT_PASSWORD"),
#      roles: [ "readWrite", 
#              "dbAdmin" ,  
#              { role: "userAdminAnyDatabase", db: "admin" }, 
#              { role: "dbAdminAnyDatabase", db: "admin" }, 
#              { role: "readWriteAnyDatabase", db: "admin" } ]
#      })
# EOJS
# fi

# echo ======================================================
# echo created $MONGO_INITDB_ROOT_USERNAME in database $MONGO_INITDB_ROOT_DATABASE
# echo ======================================================

