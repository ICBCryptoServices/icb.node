mongo -- "$MONGO_INITDB_ROOT_DATABASE" <<EOF
    var rootUser = '$MONGO_INITDB_ROOT_USERNAME';
    var rootPassword = '$MONGO_INITDB_ROOT_PASSWORD';
    var admin = db.getSiblingDB('$MONGO_INITDB_ROOT_DATABASE');
    admin.auth(rootUser, rootPassword);
    var user = '$MONGO_INITDB_USERNAME';
    var passwd = '$MONGO_INITDB_PASSWORD';
    var chaindb='$MONGO_INITDB_DATABASE';
    db.createUser({user: user, pwd: passwd, roles: [{role: 'readWrite', db: chaindb },
      {role: 'dbAdmin', db: chaindb},
      {role: 'dbOwner', db: chaindb}]});
    var chaindb=db.getSiblingDB(chaindb);
    chaindb.auth(user, passwd);
    chaindb.createCollection('tbl_blocks');
    chaindb.createCollection('tbl_txns');
    chaindb.createCollection('tbl_txns_pool');
    chaindb.createCollection('tbl_stakes');
    chaindb.createCollection('tbl_peers');
    chaindb.createCollection('tbl_accounts');
    chaindb.createCollection('tbl_sysLogs');
EOF