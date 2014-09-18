# MeSH� RDF

This repository contains a set of XSLT files that transform MeSH XML into RDF.

Please read the [MeSH Memorandum of Understanding](http://www.nlm.nih.gov/mesh/2014/download/termscon.html)
before use.

For documention, see the [GitHub wiki](https://github.com/HHS/mesh-rdf/wiki).

## Quick start

First, clone this repository:

    git clone https://github.com/HHS/mesh-rdf.git
    cd mesh-rdf

Next, you can either explore this repository using the included sample XML files (which are
relatively small), or, if you need complete and up-to-date data, you can download the latest
MeSH XML files from the NLM server.  The latter option is described first.

### Getting the MeSH XML files

Since the complete MeSH data files are quite large, we assume that they are kept in a separate
location on the filesystem than this GitHub repository.  Set the environment variable
$MESHRDF_HOME to point to that location.  For example,

    export MESHRDF_HOME=/var/data/mesh-rdf

When you download the MeSH XML files, save them to the *data* subdirectory of $MESHRDF_HOME.
You can get them from [the download page](http://www.nlm.nih.gov/mesh/filelist.html);
you will have to agree to the terms of use, and fill out a short form.
Download the following:

* desc2014.dtd
* desc2014.xml
* pa2014.dtd
* pa2014.xml
* qual2014.dtd
* qual2014.xml
* supp2014.dtd
* supp2014.xml


### Getting Saxon

There are a number of different ways to run the XSLT stylesheets to convert the XML data
into RDF.  The XSLTs are written in XSLT 2.0, though, so the `xsltproc` command, which
comes on most Unix systems, will not work.

One easy way is to download and extract the open-source Saxon Home Edition, which
is written in Java, and will work on most platforms. You can download
it from [here](http://sourceforge.net/projects/saxon/files/Saxon-HE/).  Navigate to the latest version,
and follow the instructions (which appear after the list of files). As a shortcut, you can
download from the command line directly:

    wget http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip

Unzip that into the *saxon9he* subdirectory.  For example:

    unzip -d saxon9he SaxonHE9-5-1-5J.zip

Set an environment variable SAXON_JAR to point to the executable Jar file.

If you are on a Unix system:

    export SAXON_JAR=*repository-dir*/saxon9he/saxon9he.jar

Where "repository-dir" is the base directory of this repository.
If your version of Saxon is in a different location, then, of course, set this environment variable
appropriately.

On Windows:

    set SAXON_JAR=*repository-dir*\saxon\saxon9he.jar



### Converting the complete MeSH data set

There are a few conversion scripts in the repository which you can use to run the
XSLT conversions.


The conversion scripts are:

* convert-all.sh - For unix, this shell script will brute-force convert each of the three
  main MeSH XML files into RDF N-Triples format, and put the results into the *out* directory
* convert-all.bat - This does the same thing, but can be run from Windows.
* convert-all.pl - [To do: fix this to work with the MESHRDF_HOME env. var.]
  This Perl script takes a completely different approach, that is useful
  for doing the conversions on less-powerful machines.  It first chops up each of the
  input XML files into manageable sized chunks, and then runs each chunk through the
  XSLTs separately.  It should run on any machine that has Perl installed.


### Generating and converting the sample files

In the *samples* subdirectory are a number of sample files that can be used for testing.
The XML files here are generated from the full MeSH XML files, but are included in the
repository so that anyone can get up and running, and try things out, very easily.

The *sample-list.txt* file has the list of items from each of the three main XML
files that provide a fairly good coverage of the variation of data found within MeSH.

These three sample files, corresponding to that list and the three main XML files,
are included in the repository:

* desc-samples.xml
* qual-samples.xml
* supp-samples.xml

The Perl script *make-samples.pl* can be used to regenerate these sample files from the
the master XML files, extracting just those items that are listed in the *sample-list.txt*
file, if any of those changes.  So, keep in mind that these samples in the repository are
used for testing/demo purposes, and are not necessarily up to date with the latest MeSH
release.

Finally, either of the scripts *convert-samples.sh* (for Unix) or *convert-samples.bat*
(for Windows) can be used to convert the sample XML files into RDF, the final output
being *samples.nt*.



## Project directory structure

These are the subdirectories of this project -- either part of the repository, or created:

* *data* - Source MeSH XML, DTD, and other ancillary files. This directory and its files are not part of the
  repository, but should be downloaded separately, as described above.
* *doc* - Schema for the RDF, and other documentation
* *rnc* - Relax NG Compact version of the MeSH XML file schema (experimental)
* *samples* - XML data files for testing and demo purposes, which each contain a small subset of the items
  from the real XML data files
* *saxon* - Not part of the repository, this is where the Saxon XSLT processor should be extracted.
* *xslt* - The main XSLT processor files that convert the XML into RDF.

## Virtuoso setup

Dependencies:
	gcc, gmake, autoconf, automake, libtool, flex, bison, gperf, gawk, m4, make, openssl-devel, readline-devel, wget

Checkout source from github:
	sudo su - rxnorm
	cd /usr/nlm/rxnorm/opt
	git clone git://github.com/openlink/virtuoso-opensource.git
	cd virtuoso-opensource   
	git fetch
	git checkout develop/7   (should say already at develop/7)
	./autogen.sh
	CFLAGS="-O2 -m64"
	export CFLAGS
	./configure --prefix=/usr/nlm/rxnorm/opt/virtuoso
	make
	make install
	
Start up of server:
	cd /usr/nlm/rxnorm/opt/virtuoso/var/lib/virtuoso/db
	/usr/nlm/rxnorm/opt/virtuoso/bin/virtuoso-t
	
Shutdown of server:
Reference:  http://data-gov.tw.rpi.edu/wiki/How_to_install_virtuoso_sparql_endpoint#Manual_Shutdown
	
	/usr/nlm/rxnorm/opt/virtuoso/bin/isql 1111 dba <password>
	SQL> shutdown();