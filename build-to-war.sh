#/bin/bash
if [[ -z "$MESHRDF_HOME" ]]; then 
    echo "You must first define $MESHRDF_HOME\n" 1>&2
    exit 1
fi
. $MESHRDF_HOME/set_env_mesh
(cd lode-core-api; mvn install)
(cd lode-core-servlet; mvn install)
(cd lode-virtuoso-impl; mvn install)
(cd web-ui; mvn package)
