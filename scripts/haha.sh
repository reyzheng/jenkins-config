if [ -z ${BUILD_BRANCH+x} ]; then 
    echo "none"
    var="PARAM_COV_PROJECT"
    echo "${!var}"
else
    echo "set"
    var=$BUILD_BRANCH"_PARAM_COV_PROJECT"
    echo "${!var}"
fi
