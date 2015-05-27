.PHONY: all

MESHRDF_HOME=/usr/nlm/mesh

INSTALL_BIN=/usr/bin/install -m 0755
INSTALL_FILE=/usr/bin/install -m 0644

all:
	@echo "There is oo default target"

target/jena-rdfcat.jar: pom.xml
	mvn clean package

install:
	$(INSTALL_BIN) rdfcat $(MESHRDF_HOME)/bin
	$(INSTALL_FILE) target/jena-rdfcat.jar $(MESHRDF_HOME)/lib/java
	


	
