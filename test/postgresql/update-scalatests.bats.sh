#!/usr/bin/env bash
# A script for regnerating scalatests/*.bats
set -eu

cd "$(dirname "$0")"

# generate a corresponding bats file for every test in Scala
mkdir -p scalatests
for t in $(cd ../.. && sbt coverage "export printTests" | grep ^org.deepdive.test); do
    bats=scalatests/${t}.bats
    cat >$bats <<EOF
#!/usr/bin/env bats
# DeepDive Scala Tests for $t
# DO NOT EDIT -- GENERATED BY test/postgresql/update-scalatests.bats.sh

. "\${BATS_TEST_DIRNAME%/scalatests}"/env.sh >&2

setup() {
    db-init
}

@test "\$DBVARIANT ScalaTest $t" {
    java org.scalatest.tools.Runner -oDF -s $t
}
EOF
    chmod +x "$bats"
    echo >&2 "# generated $bats"
done