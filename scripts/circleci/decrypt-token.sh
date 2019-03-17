#
# Decript token with the key and initial virtualization
# stored as circleci hidden eviroment variable.
#
#

if [[ -n ${CIRCLECI} ]]; then
    # follow the guide to store credential file on repo (https://github.com/circleci/encrypted-files)
    export GITHUB_TOKEN=$(openssl aes-256-cbc -d -in .circleci/github_token -k ${KEY} -iv ${IV_NONCE})
fi