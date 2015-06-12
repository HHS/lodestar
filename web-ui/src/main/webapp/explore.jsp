<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH RDF Explorer (beta)</title>
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

    <%
      String rp = request.getParameter("resource_prefix");
      String resourcePrefix = rp == null ? "" : rp;
    %>
    <!-- 
      resourcePrefix = <%= resourcePrefix %>
    -->

    <link rel="stylesheet" href="<%= resourcePrefix %>css/lode-style.css" type="text/css" media="screen">

    <script type="text/javascript" src="<%= resourcePrefix %>codemirror/codemirror.js"></script>
    <script type="text/javascript" src="<%= resourcePrefix %>codemirror/sparql.js"></script>
    <script type="text/javascript" src="<%= resourcePrefix %>scripts/namespaces.js"></script>
    <script type="text/javascript" src="<%= resourcePrefix %>scripts/queries.js"></script>
    <script type="text/javascript" src="<%= resourcePrefix %>scripts/lode.js"></script>

    <link data-require="font-awesome@*" data-semver="4.2.0" rel="stylesheet" 
        href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.2.0/css/font-awesome.css" />
    <link href="<%= resourcePrefix %>css/style.css" rel="stylesheet" />

    <!--[if lt IE 9]>
      <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <lodestar:dapscript></lodestar:dapscript>
  </head>

  <body onload="$('#data-explorer-content').explore({
      resource_prefix : '<%= resourcePrefix %>',
      namespaces : lodeNamespacePrefixes
    });">
    <div class="header"></div>
    <div class="container-fluid">
      <div id="meshTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
          <div class="navi"></div>
          <h1>Medical Subject Headings (MeSH) RDF Linked Data (beta)</h1>

          <div class="grid_24" id="data-explorer-content">
          </div>

          <div class="footer">
          </div>
        </div>
      </div>
    </div>

    <script>
      $(function() {
        $(".header").load("<%= resourcePrefix %>header.html");
        $(".navi").load('<%= resourcePrefix %>nav.jsp?resource_prefix=<%= 
          java.net.URLEncoder.encode(resourcePrefix, "UTF-8")
        %>');
        $(".footer").load("<%= resourcePrefix %>footer.html");
      });
    </script>
  </body>
</html>
