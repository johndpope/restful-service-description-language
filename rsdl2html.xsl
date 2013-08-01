<?xml version="1.0"?>
<!-- 
##   rsdl2html.xsl
##
##   Converts a RSDL description to HTML.
##
##   Copyright 2012, EMC Corporation
##
##   Licensed under the Apache License, Version 2.0 (the "License");
##   you may not use this file except in compliance with the License.
##   You may obtain a copy of the License at
##
##       http://www.apache.org/licenses/LICENSE-2.0
##
##   Unless required by applicable law or agreed to in writing, software
##   distributed under the License is distributed on an "AS IS" BASIS,
##   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##   See the License for the specific language governing permissions and
##   limitations under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:html="http://www.w3.org/1999/xhtml/"
    xmlns:rsdl="http://identifiers.emc.com/rsdl">
  <xsl:output method="html" encoding ="utf-8" indent="no"/>
  <xsl:strip-space elements="*"/>

  <xsl:key name="status" match="//rsdl:status-codes/rsdl:status" use="@code" />
    
  <xsl:template match="/rsdl:service">
    <html>
      <head>
        <title><xsl:call-template name="title"/></title>
        <xsl:call-template name="style"/>
      </head>
      <body>
        <div class="outline index">
          <xsl:call-template name="index"/>
        </div>
        <div class="outline reference">
          <xsl:call-template name="reference"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="title">
    <xsl:value-of select="@name"/> REST Service
  </xsl:template>

  <xsl:template name="style">
    <style type="text/css">
      body { margin: 0; padding: 0 0 0 16em; }
      h1, h2 { color: Navy; }
      h3 { color: Blue; }
      table { border-collapse: collapse; margin-bottom: 1em; }
      th, td { border: 1px solid; padding: 0.35em; vertical-align: top; }
      th { color: White; background-color: CornflowerBlue; text-align: left; border-color: Black; }
      td { border-color: DarkBlue; }
      .outline { vertical-align: top; padding: 1em; }
      .index { position: fixed; top: 0; left: 0; width: 16em; height: 96%; overflow: auto; font-size: smaller; }
      .reference { height: 100%; overflow: auto; }
      div { overflow: scroll; }
      .homeResource { 
        font-weight: bold; 
        font-size: smaller; 
        background-color: Green; 
        color: Yellow; 
        padding: 0.3em;
        margin-left: 1em;
        border-radius: 1em; 
      }
      #hint { 
        display: none; 
        font-size: small; 
        font-weight: normal;
        white-space: nowrap; 
        background-color: LightYellow; 
        color: DimGrey;
        border: 1px solid DimGrey;
        border-radius: 0.5em;
        padding: 0.5em; 
        margin-right: 0.5em;
      }
      #full { color: Green; margin-right: 0.2em; }
      #full:hover ~ #hint { display: inline; }
      #no { color: Red; margin-right: 0.2em; }
      #no:hover ~ #hint { display: inline; }
      #partial { color: Coral; margin-right: 0.3em; }
      #partial:hover ~ #hint { display: inline; }
      .one-piece { white-space: nowrap; text-wrap: none; }
      .center { text-align: center; }
      .button { 
        background-color: LightGrey; 
        color: Black; 
        font-size: smaller;
        border: 1px solid DarkGrey; 
        border-radius: 0.35em; 
        padding: 0.35em;
        text-decoration: none;
      }
      .header-suffix { font-size: small; }
    </style>
  </xsl:template>
  
  <xsl:template name="index">
    <xsl:call-template name="index-resources"/>
    <xsl:call-template name="index-media-types"/>
    <xsl:call-template name="index-link-relations"/>
    <xsl:call-template name="index-uri-parameters"/>
    <xsl:call-template name="index-custom-headers"/>
    <xsl:call-template name="index-status-codes"/>
    <xsl:call-template name="index-authentication-mechanisms"/>
  </xsl:template>
  
  <xsl:template name="index-resources">
    <h3>Resources</h3>
    <xsl:for-each select="//rsdl:resources/rsdl:resource">
      <xsl:sort select="@name"/>
      <a class="item">
        <xsl:attribute name="style">
          top: <xsl:value-of select="4 + position()"/>em;
        </xsl:attribute>
        <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
         <code><xsl:value-of select="@name"/></code>
      </a>
      <xsl:call-template name="home-resource"/>
      <br/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="home-resource">
    <xsl:if test="@id = /rsdl:service/@home-resource">
	    <span class="homeResource">Home resource</span>
	  </xsl:if>
  </xsl:template>
  
  <xsl:template name="index-media-types">
    <h3>Media Types</h3>
    <xsl:for-each select="//rsdl:media-types/rsdl:media-type">
      <xsl:sort select="@name"/>
      <a class="item">
        <xsl:attribute name="style">
          top: <xsl:value-of select="4 + position()"/>em;
        </xsl:attribute>
        <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
         <code><xsl:value-of select="@name"/></code>
      </a>
      <br/>
    </xsl:for-each>
  </xsl:template>
    
  <xsl:template name="index-link-relations">
    <h3>Link Relations</h3>
    <xsl:for-each select="//rsdl:link-relations/rsdl:link-relation">
      <xsl:sort select="@name"/>
      <a class="item">
        <xsl:attribute name="style">
          top: <xsl:value-of select="4 + position()"/>em;
        </xsl:attribute>
        <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
         <code><xsl:value-of select="@name"/></code>
      </a>
      <br/>
    </xsl:for-each>
  </xsl:template>
    
  <xsl:template name="index-authentication-mechanisms">
    <xsl:if test="//rsdl:authentication/rsdl:uri-mechanism">
      <h3>Authentication Mechanisms</h3>
      <xsl:for-each select="//rsdl:authentication/rsdl:mechanism">
        <xsl:sort select="@name"/>
        <a class="item">
          <xsl:attribute name="style">
            top: <xsl:value-of select="4 + position()"/>em;
          </xsl:attribute>
          <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
           <code><xsl:value-of select="@name"/></code>
        </a>
        <br/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
    
  <xsl:template name="index-status-codes">
    <xsl:if test="//rsdl:status-codes/rsdl:status">
      <h3>Status Codes</h3>
      <xsl:for-each select="//rsdl:status-codes/rsdl:status">
        <xsl:sort select="@code"/>
        <a class="item">
          <xsl:attribute name="style">
            top: <xsl:value-of select="4 + position()"/>em;
          </xsl:attribute>
          <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
           <code><xsl:value-of select="@code"/></code>
        </a>
        <br/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
    
  <xsl:template name="index-custom-headers">
    <xsl:if test="//rsdl:custom-headers/rsdl:custom-header">
      <h3>Headers</h3>
      <xsl:for-each select="//rsdl:custom-headers/rsdl:custom-header">
        <xsl:sort select="@name"/>
        <a class="item">
          <xsl:attribute name="style">
            top: <xsl:value-of select="4 + position()"/>em;
          </xsl:attribute>
          <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
           <code><xsl:value-of select="@name"/></code>
        </a>
        <br/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
    
  <xsl:template name="index-uri-parameters">
    <xsl:if test="//rsdl:uri-parameters/rsdl:uri-parameter">
      <h3>URI Parameters</h3>
      <xsl:for-each select="//rsdl:uri-parameters/rsdl:uri-parameter">
        <xsl:sort select="@name"/>
        <a class="item">
          <xsl:attribute name="style">
            top: <xsl:value-of select="4 + position()"/>em;
          </xsl:attribute>
          <xsl:attribute name="href">#<xsl:value-of select="@id"/></xsl:attribute>
           <code><xsl:value-of select="@name"/></code>
        </a>
        <br/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="reference">
    <h1><xsl:call-template name="title"/></h1>
    <xsl:call-template name="resources"/>
    <xsl:call-template name="media-types"/>
    <xsl:call-template name="link-relations"/>
    <xsl:call-template name="uri-parameters"/>
    <xsl:call-template name="custom-headers"/>
    <xsl:call-template name="status-codes"/>
    <xsl:call-template name="authentication-mechanisms"/>
  </xsl:template>
  
  <xsl:template name="resources">
    <h2>Resources</h2>
    <xsl:for-each select="//rsdl:resource">
      <xsl:sort select="@name"/>
      <hr/>
      <h3>
        <a>
          <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
        </a>
        <xsl:call-template name="implemented"/>
        <code><xsl:value-of select="@name"/></code>
        <xsl:call-template name="home-resource"/>
      </h3>
      <xsl:apply-templates select="rsdl:documentation"/>
      <xsl:call-template name="authentication"/>
      <xsl:apply-templates select="*[local-name() != 'methods' and local-name() != 'documentation']"/>
      <xsl:call-template name="methods"/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="authentication">
    <xsl:choose>
      <xsl:when test="/service/@identity-provider-ref and @public = 'true'">
        <xsl:call-template name="no-authentication"/>
      </xsl:when>
      <xsl:when test="@identity-provider-ref">
        <xsl:call-template name="identity-provider">
          <xsl:with-param name="id" select="@identity-provider-ref"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="/service/@identity-provider-ref">
        <xsl:variable name="id" select="/service/@identity-provider-ref"/>
        <h4>Authentication</h4>
        <p>
          <xsl:apply-templates select="//authentication/identity-provider[@id = $id]"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="no-authentication"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="no-authentication">
    <xsl:if test="//rsdl:authentication/rsdl:mechanism">
      <h4>Authentication</h4>
      <p>This resource requires no authentication.</p>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="identity-provider">
    <xsl:param name="id"/>
    <xsl:variable name="idp" select="//rsdl:authentication/rsdl:identity-provider[@id = $id]"/>
    <xsl:variable name="mechanismId" select="$idp/@mechanism-ref"/>
    <xsl:variable name="mechanism" select="//rsdl:authentication/rsdl:mechanism[@id = $mechanismId]"/>
    <h4>Authentication</h4>
    <table>
      <tr>
        <th>Mechanism</th>
        <th>Identity Provider</th>
      </tr>
      <tr>
        <td>
          <a>
            <xsl:attribute name="href">#<xsl:value-of select="$mechanismId"/></xsl:attribute>
            <xsl:apply-templates select="$mechanism/@name"/>
          </a>
        </td>
        <td>
          <xsl:apply-templates select="$idp/rsdl:documentation"/>
        </td>
      </tr>
    </table>
  </xsl:template>
   
  <xsl:template name="implemented">
    <xsl:choose>
      <xsl:when test="@status = 'full'">
        <span id="full">&#x2714;</span><span id="hint">Fully implemented</span>
      </xsl:when>
      <xsl:when test="@status = 'partial'">
        <span id="partial">?</span><span id="hint">Partially implemented</span>
      </xsl:when>
      <xsl:otherwise>
        <span id="no">&#x2718;</span><span id="hint">Not implemented</span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  <xsl:template match="rsdl:documentation">
    <xsl:apply-templates select="text()|*"/>
  </xsl:template>

  <xsl:template match="rsdl:authentication">
    <xsl:variable name="mechanism" select="@mechanism-ref"/>
    <h4>Authentication</h4>
    <p>
      <a>
        <xsl:attribute name="href">#<xsl:value-of select="$mechanism"/></xsl:attribute>
        <xsl:value-of select="//rsdl:authentication/rsdl:mechanism[@id = $mechanism]/@name"/>
      </a>.&#160; <xsl:apply-templates select="*"/>
    </p>
  </xsl:template>
  
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="*|@*|text()"/>
    </xsl:element>
  </xsl:template>
      
  <xsl:template match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="rsdl:ref">
    <xsl:choose>
      <xsl:when test="@resource and ancestor::rsdl:resource/@id = @resource">
        <code>
          <xsl:value-of select="@resource"/>
        </code>
      </xsl:when>
      <xsl:otherwise>
		    <xsl:choose>
		      <xsl:when test="@resource">
            <xsl:variable name="id" select="@resource"/>
            <xsl:call-template name="ref-by-id">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="name" select="//rsdl:resources/rsdl:resource[@id = $id]/@name"/>
            </xsl:call-template>
		      </xsl:when>
          <xsl:when test="@status-code">
            <xsl:variable name="id" select="@status-code"/>
            <xsl:call-template name="ref-by-id">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="name" select="//rsdl:status-codes/rsdl:status[@id = $id]/@code"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@uri-parameter">
            <xsl:variable name="id" select="@uri-parameter"/>
            <xsl:call-template name="ref-by-id">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="name" select="//rsdl:uri-parameters/rsdl:uri-parameter[@id = $id]/@name"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@custom-header">
            <xsl:variable name="id" select="@custom-header"/>
            <xsl:call-template name="ref-by-id">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="name" select="//rsdl:custom-headers/rsdl:custom-header[@id = $id]/@name"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@mechanism">
            <xsl:variable name="id" select="@mechanism"/>
            <xsl:call-template name="ref-by-id">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="name" select="//rsdl:authentication/rsdl:mechanism[@id = $id]/@name"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@media-type">
            <xsl:variable name="id" select="@media-type"/>
            <xsl:call-template name="ref-by-id">
              <xsl:with-param name="id" select="$id"/>
              <xsl:with-param name="name" select="//rsdl:media-types/rsdl:media-type[@id = $id]/@name"/>
            </xsl:call-template>
          </xsl:when>
		      <xsl:otherwise>
            <a>
  		        <xsl:attribute name="href">
  		          <xsl:value-of select="@uri"/>
  		        </xsl:attribute>
  		        <xsl:apply-templates select="*|text()"/>
            </a>
		      </xsl:otherwise>
		    </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ref-by-id">
    <xsl:param name="id"/>
    <xsl:param name="name"/>
    <a>
      <xsl:attribute name="href">#<xsl:value-of select="$id"/></xsl:attribute>
      <xsl:choose>
        <xsl:when test="text()">
          <xsl:apply-templates select="*|text()"/>
        </xsl:when>
        <xsl:otherwise>
          <code>
            <xsl:value-of select="$name"/>
          </code>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </xsl:template>
  
  <xsl:template name="methods">
    <xsl:if test="rsdl:methods/rsdl:method">
      <xsl:variable name="showStatus" select="rsdl:methods/rsdl:method/@status"/>
      <h4>Supported Methods</h4>
      <table>
        <tr>
          <xsl:if test="$showStatus">
            <th>Status</th>
          </xsl:if>
          <th>Name</th>
          <xsl:if test="rsdl:methods/rsdl:method/rsdl:request">
            <th>Request</th>
          </xsl:if>
          <xsl:if test="rsdl:methods/rsdl:method/rsdl:response">
            <th>Response</th>
          </xsl:if>
        </tr>
        <xsl:for-each select="rsdl:methods//rsdl:method">
          <tr>
            <xsl:if test="$showStatus">
              <td class="center">
                <xsl:call-template name="implemented"/>
              </td>
            </xsl:if>
            <td>
              <code><xsl:value-of select="@name"/></code>
            </td>
            <xsl:if test="../rsdl:method/rsdl:request">
              <td>
                <xsl:apply-templates select="rsdl:request/*"/>
              </td>
            </xsl:if>
            <xsl:if test="../rsdl:method/rsdl:response">
              <td>
                <xsl:apply-templates select="rsdl:response/*"/>
              </td>
            </xsl:if>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="rsdl:status-codes">
    <em>Status code<xsl:if test="count(rsdl:status-code) &gt; 0">s</xsl:if>:</em>&#160;
    <xsl:for-each select="rsdl:status-code">
      <xsl:variable name="statusId" select="@status-code-ref"/>
      <a>
        <xsl:attribute name="href">#<xsl:value-of select="$statusId"/></xsl:attribute>
        <code><xsl:value-of select="//rsdl:status-codes/rsdl:status[@id = $statusId]/@code"/></code>
      </a>
      <xsl:if test="position() &lt; count(../rsdl:status-code)">, &#160;</xsl:if>
    </xsl:for-each>
    <br/>
  </xsl:template>
    
  <xsl:template match="rsdl:header">
    <xsl:variable name="id" select="@header-ref"/>
    <em>Header:</em>&#160;
    <a>
      <xsl:attribute name="href">#<xsl:value-of select="$id"/></xsl:attribute>
      <code>
        <xsl:apply-templates select="//rsdl:custom-headers/rsdl:custom-header[@id = $id]/@name"/>
      </code> 
    </a>
    <br/>
  </xsl:template>
    
  <xsl:template match="rsdl:representation">
    <xsl:variable name="id" select="@media-type-ref"/>
    <xsl:if test="../rsdl:documentation">
      <br/>
    </xsl:if>
    <em>Media type:</em>&#160;<code>
    <a>
      <xsl:attribute name="href">#<xsl:value-of select="$id"/></xsl:attribute>
      <xsl:value-of select="//rsdl:media-types/rsdl:media-type[@id = $id]/@name"/>
    </a>
    </code>
    <xsl:if test="@entity">, entity: <code><xsl:value-of select="@entity"/></code></xsl:if>
    <xsl:if test="@entry">
      <xsl:variable name="resId" select="@entry"/>
      <xsl:text>, entry:</xsl:text>&#160; 
      <code>
        <a>
          <xsl:attribute name="href">#<xsl:value-of select="$resId"></xsl:value-of></xsl:attribute>
          <xsl:value-of select="//rsdl:resources/rsdl:resource[@id = $resId]/@name"/>
        </a>
      </code>
    </xsl:if>
    <xsl:if test="rsdl:documentation">
      <br/>&#160;&#160;&#160;&#160;<xsl:apply-templates select="rsdl:documentation"/>
    </xsl:if>
    <br/>
  </xsl:template>
  
  <xsl:template match="rsdl:links">
    <xsl:if test="rsdl:link">
      <h4>Links to other resources</h4>
      <xsl:variable name="showStatus" select="rsdl:link/@status"/>
	    <table>
	      <tr>
	        <xsl:if test="$showStatus"> 
            <th>Status</th>
	        </xsl:if>
	        <th>Relation</th>
	        <th>Resource</th>
          <xsl:if test="rsdl:link/rsdl:documentation">
	          <th>Description</th>
          </xsl:if>
	      </tr>
	      <xsl:for-each select="rsdl:link">
	        <xsl:sort select="@resource-ref"/>
          <xsl:variable name="resId" select="@resource-ref"/>
          <xsl:variable name="relId" select="@link-relation-ref"/>
	        <tr>
            <xsl:if test="$showStatus">
              <td class="center">
                <xsl:call-template name="implemented"/>
              </td>
            </xsl:if>
	          <td>
	            <code>
                <a>
                  <xsl:attribute name="href">#<xsl:value-of select="$relId"></xsl:value-of></xsl:attribute>
                  <xsl:value-of select="//rsdl:link-relations/rsdl:link-relation[@id = $relId]/@name"/>
                </a>
	            </code>
	          </td>
	          <td>
	            <code>
	              <a>
	                <xsl:attribute name="href">#<xsl:value-of select="$resId"></xsl:value-of></xsl:attribute>
	                <xsl:value-of select="//rsdl:resources/rsdl:resource[@id = $resId]/@name"/>
	              </a>
              </code>
	          </td>
            <xsl:if test="../rsdl:link/rsdl:documentation">
  	          <td>
  	            <xsl:apply-templates select="rsdl:documentation/*|rsdl:documentation/text()"/>
  	          </td>
            </xsl:if>
	        </tr>
	      </xsl:for-each>
	    </table>
    </xsl:if>
  </xsl:template>
    
  <xsl:template match="rsdl:location">
    <xsl:choose>
      <xsl:when test="../@id = /rsdl:service/@home-resource">
        <h4>Location</h4>
        <p>
          Reach this resource at <code><xsl:value-of select="@href"/></code>.
        </p>
      </xsl:when>
      <xsl:when test="@template and rsdl:var[@uri-parameter-ref]">
        <h4>URI Parameters</h4>
        <table>
          <tr>
            <th>Name</th>
            <th>Description</th>
          </tr>
          <xsl:for-each select="rsdl:var">
            <xsl:sort select="@name"/>
            <xsl:variable name="id" select="@uri-parameter-ref"/>
            <tr>
              <td><code><xsl:value-of select="@name"/></code></td>
              <td><xsl:apply-templates select="//rsdl:uri-parameters/rsdl:uri-parameter[@id = $id]/rsdl:documentation"/></td>
            </tr>
          </xsl:for-each>
        </table>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="authentication-mechanisms">
    <xsl:if test="//rsdl:authentication/rsdl:mechanism">
      <hr/>
      <h2>Authentication Mechanisms</h2>
      <xsl:for-each select="//rsdl:authentication/rsdl:mechanism">
        <xsl:sort select="@name"/>
        <h3>
          <a>
            <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
          </a>
          <code><xsl:value-of select="@name"/></code>
        </h3>
        <xsl:apply-templates select="rsdl:documentation"/>
        <xsl:for-each select="rsdl:scheme">
          <xsl:sort select="@name"/>
          <xsl:apply-templates select="." />
        </xsl:for-each>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rsdl:scheme">
    <h4>Scheme: <em><xsl:value-of select="@name"/></em></h4>
    <xsl:if test="rsdl:documentation">
      <p><xsl:apply-templates select="rsdl:documentation"/></p>
    </xsl:if>
    <xsl:if test="rsdl:parameter">
      <table>
        <tr>
          <th>Parameter</th>
          <th>Description</th>
        </tr>
        <xsl:for-each select="rsdl:parameter">
          <xsl:sort select="@name"/>
          <tr>
            <td><code><xsl:value-of select="@name"/></code></td>
            <td><xsl:apply-templates select="rsdl:documentation"/></td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>
         
  <xsl:template name="status-codes">
    <xsl:if test="//rsdl:status-codes/rsdl:status">
      <hr/>
      <h2>Status Codes</h2>
      <xsl:for-each select="//rsdl:status-codes/rsdl:status">
        <xsl:sort select="@code"/>
        <h3>
          <a>
            <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
          </a>
          <code><xsl:value-of select="@code"/></code>
        </h3>
        <xsl:apply-templates/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="custom-headers">
    <xsl:if test="//rsdl:custom-headers/rsdl:custom-header">
      <hr/>
      <h2>Headers</h2>
      <xsl:for-each select="//rsdl:custom-headers/rsdl:custom-header">
        <xsl:sort select="@name"/>
        <h3>
          <a>
            <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
          </a>
          <code><xsl:value-of select="@name"/></code>&#160;&#160;<span class="header-suffix">(<xsl:value-of select="@type"/>)</span>
        </h3>
        <xsl:apply-templates/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="media-types">
    <hr/>
    <h2>Media-types</h2>
    <xsl:for-each select="//rsdl:media-types/rsdl:media-type">
      <xsl:sort select="@name"/>
      <h3>
        <a>
          <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
        </a>
        <code><xsl:value-of select="@name"/></code>
      </h3>
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="rsdl:description">
    <br/>
    <xsl:choose>
      <xsl:when test="@type = 'html'">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          More information
        </a>
      </xsl:when>
      <xsl:when test="@type = 'sedola'">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          Service registration
        </a>
      </xsl:when>
      <xsl:when test="@type = 'xsd'">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          XML Schema
        </a>
      </xsl:when>
      <xsl:when test="@type = 'rnc'">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          Relax NG Schema
        </a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="link-relations">
    <hr/>
    <h2>Link Relations</h2>
    <xsl:for-each select="//rsdl:link-relations/rsdl:link-relation">
      <xsl:sort select="@name"/>
      <h3>
        <a>
          <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
        </a>
        <code><xsl:value-of select="@name"/></code>
      </h3>
      <xsl:apply-templates/>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="uri-parameters">
    <xsl:if test="//rsdl:uri-parameters/rsdl:uri-parameter">
      <hr/>
      <h2>URI Parameters</h2>
      <xsl:for-each select="//rsdl:uri-parameters/rsdl:uri-parameter">
        <xsl:sort select="@name"/>
        <h3>
          <a>
            <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
          </a>
          <code><xsl:value-of select="@name"/></code>
        </h3>
        <xsl:apply-templates/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rsdl:properties">
    <xsl:if test="rsdl:property">
      <h4>Properties</h4>
      <table>
        <tr>
          <th>Name</th>
          <th>Description</th>
        </tr>
        <xsl:for-each select="rsdl:property">
          <xsl:sort select="@name"/>
          <tr>
            <td><code><xsl:value-of select="@name"/></code></td>
            <td><xsl:apply-templates select="rsdl:documentation"/></td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:if>
  </xsl:template>
    
</xsl:stylesheet>
