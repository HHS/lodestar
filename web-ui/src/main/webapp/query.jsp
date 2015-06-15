<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH SPARQL Explorer (beta)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="" />
    <meta name="author" content="" />

    <!--[if lt IE 9]>
      <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <script data-require="jquery" data-semver="2.1.1" 
      src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

    <!--
      Bootstrap CSS.  Question [from klortho]: do we need both of these, or is one a
      minified version of the other?
      Note these have to be loaded before codemirror, otherwise codemirror gets 
      confused when placing the cursor.
    -->

    <link data-require="bootstrap-css" data-semver="3.2.0" rel="stylesheet" 
        href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link data-require="bootstrap@*" data-semver="3.2.0" rel="stylesheet" 
        href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.css" />
    <script data-require="bootstrap" data-semver="3.2.0" src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.js"></script>


    <link rel="stylesheet" type="text/css" href="css/lode-style.css" />
    <link rel="stylesheet" type="text/css" href="codemirror/codemirror.css" />
    <script type="text/javascript" src="codemirror/codemirror.js"></script>
    <script type="text/javascript" src="codemirror/sparql.js"></script>
    <script type="text/javascript" src="scripts/namespaces.js"></script>
    <script type="text/javascript" src="scripts/queries.js"></script>
    <script type="text/javascript" src="scripts/lode.js"></script>
    <link rel='stylesheet' href='css/style.css' />
    <lodestar:dapscript></lodestar:dapscript>
  </head>

  <body onload="$('#sparql-content').sparql({namespaces : lodeNamespacePrefixes, inference: true});">
    <div class="skipnav"><a href="#skip" class="skipnav">Skip Navigation</a></div>
    <div class="header">
      <%@ include file="/internal/header.html" %>
    </div>
    <div class="container-fluid">
      <div id="meshTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
          <div class="navi">
            <%@ include file="/internal/nav.jspf" %>
          </div>

          <a name="skip"> </a>
          <h1>Medical Subject Headings (MeSH) RDF Linked Data (beta)</h1>

	      <div class="grid_24" id="sparql-content">
	      </div>

          <div class="footer">
            <%@ include file="/internal/footer.html" %>
          </div>
        </div>
      </div>
    </div>
  </body>

</html>
