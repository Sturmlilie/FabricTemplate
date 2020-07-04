#!/bin/bash

# NOTE: Do not edit anything in this file!
#       Everything to edit is in template_strings.src

source template_strings.src

HP_ESC=$(echo $HP | sed -e 's/[\/&]/\\&/g')
SOURCES_ESC=$(echo $SOURCES | sed -e 's/[\/&]/\\&/g')
MAIN_PATH="src/main/java/"$(echo $PACKAGE | sed -e 's/\./\//g')

PROPS='gradle.properties'
MODJSON='src/main/resources/fabric.mod.json'

# Process gradle properties
sed -i "s/1\.0\.0/${VERSION}/g" $PROPS
sed -i "s/fabric-example-mod/${TOPDIR}/g" $PROPS

# Remove sample mixin (might make this optional)
rm -r 'src/main/java/net/fabricmc/example/mixin'
rm 'src/main/resources/modid.mixins.json'
sed -i '/.*modid\.mixins\.json.*/d' $MODJSON

# Process fabric.mod.json
sed -i "s/modid/${MODID}/g" $MODJSON
sed -i "s/Example Mod/${FULL_NAME}/g" $MODJSON
sed -i "s/.*\"description\"\:.*/  \"description\": \"${DESC}\",/g" $MODJSON
sed -i "s/Me\!/${AUTHOR}/g" $MODJSON
sed -i "s/.*homepage.*/    \"homepage\": \"${HP_ESC}\",/g" $MODJSON
sed -i "s/.*sources.*/    \"sources\": \"${SOURCES_ESC}\"/g" $MODJSON
sed -i "s/net\.fabricmc\.example\.ExampleMod/${PACKAGE}.Main/g" $MODJSON

MAIN_JAVA='src/main/java/net/fabricmc/example/ExampleMod.java'

# Process Main.java
sed -i "s/net\.fabricmc\.example/${PACKAGE}/g" $MAIN_JAVA
sed -i 's/ExampleMod/Main/g' $MAIN_JAVA

# Create and move to package path
mkdir -p $MAIN_PATH
mv $MAIN_JAVA "$MAIN_PATH/Main.java"
rm -r 'src/main/java/net'

# Rename assets folder
mv 'src/main/resources/assets/modid' "src/main/resources/assets/${MODID}"
