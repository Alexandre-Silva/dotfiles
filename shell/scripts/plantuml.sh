#! /bin/sh

# this differ from the script in /usr/bin/plantuml
# by disabling splash window

exec java -splash:no -jar /opt/plantuml/plantuml.jar "$@"
