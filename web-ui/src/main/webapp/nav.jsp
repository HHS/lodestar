<%
  String rp = request.getParameter("resource_prefix");
  String resourcePrefix = rp == null ? "" : rp;
%>
<ul class="nav nav-pills pull-right">
  <li role="presentation"><a href="<%= resourcePrefix %>sparql" target="_blank">SPARQL endpoint</a></li>
  <li role="presentation"><a href="http://hhs.github.io/meshrdf/" target="_blank">Technical Docs</a></li>
  <li role="presentation"><a href="/mesh" role="button">MeSH RDF Home</a></li>
  <li role="presentation"><a href="http://www.nlm.nih.gov/mesh/" target="_blank">MeSH Home</a></li>
</ul>
