<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:sioc="http://rdfs.org/sioc/ns#" xmlns:twitter="http://rdf.opiumfield.com/twitter/0.1/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
		<!--
			twitter-rdf.xsl
			Copyright (c) 2008 Tom Morris
			This code is released under the GNU Affero General Public License 3.0
			
			You have all the rights given to you under the GNU GPL 3.0, except that
			you must release your modifications that you use when providing services
			over the Internet. See:
			http://www.fsf.org/licensing/licenses/agpl-3.0.html
			
			Full source code is available here:
			http://github.com/tommorris/twitter-rdf/
			
			Patches accepted: tom@tommorris.org
			or via the pull request in GitHub.
		-->
    <xsl:output method="xml" indent="yes" encoding="UTF-8" />
    <xsl:template match="text()"/>
    <xsl:param name="username"/>
    <xsl:template match="users">
        <rdf:RDF>
						<xsl:comment>
							This is translated using Twitter-RDF, which is an Affero-GPL licensed
							piece of software (Copyright (c) 2008 Tom Morris). Source code available
							here: http://github.com/tommorris/twitter-rdf/
						</xsl:comment>
            <rdf:Description rdf:about="">
                <foaf:primaryTopic rdf:resource="http://twitter.com/{$username}"/>
            </rdf:Description>
            <foaf:Agent rdf:about="http://twitter.com/{$username}">
                <xsl:apply-templates select="user" mode="link"/>
								<rdfs:seeAlso rdf:resource="http://tools.opiumfield.com/twitter/{$username}/rdf/history" />
            </foaf:Agent>
            <xsl:apply-templates select="user" mode="details"/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="user" mode="link">
        <foaf:knows rdf:resource="http://twitter.com/{screen_name}"/>
    </xsl:template>
    <xsl:template match="user" mode="details">
        <foaf:Agent rdf:about="http://twitter.com/{screen_name}">
            <foaf:nick>
                <xsl:value-of select="screen_name"/>
            </foaf:nick>
            <foaf:name>
                <xsl:value-of select="name"/>
            </foaf:name>
            <xsl:if test="string-length(url) &gt; 0">
                <foaf:homepage rdf:resource="{url}"/>
            </xsl:if>
						<xsl:if test="status">
								<foaf:made rdf:resource="http://twitter.com/{screen_name}/{status/id}" />
						</xsl:if>
            <rdfs:seeAlso rdf:resource="http://tools.opiumfield.com/twitter/{screen_name}/rdf"/>
						<rdfs:seeAlso rdf:resource="http://tools.opiumfield.com/twitter/{screen_name}/rdf/history" />
        </foaf:Agent>
        <xsl:if test="status">
            <xsl:apply-templates select="status" />
        </xsl:if>
    </xsl:template>
    <xsl:template match="status">
        <xsl:variable name="screen_name">
            <xsl:choose>
                <xsl:when test="../screen_name">
                    <xsl:value-of select="../screen_name" />
                </xsl:when>
                <xsl:when test="user/screen_name">
                    <xsl:value-of select="user/screen_name" />
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <sioc:Post rdf:about="http://twitter.com/{$screen_name}/statuses/{id}">
            <sioc:content>
                <xsl:value-of select="text"/>
            </sioc:content>
            <dcterms:created>
                <xsl:value-of select="substring(created_at, 27, 4)"/>
                <xsl:text>-</xsl:text>
                <xsl:if test="substring(created_at, 5, 3) = 'Jan'">
                    <xsl:text>01</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Feb'">
                    <xsl:text>02</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Mar'">
                    <xsl:text>03</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Apr'">
                    <xsl:text>04</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'May'">
                    <xsl:text>05</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Jun'">
                    <xsl:text>06</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Jul'">
                    <xsl:text>07</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Aug'">
                    <xsl:text>08</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Sep'">
                    <xsl:text>09</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Oct'">
                    <xsl:text>10</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Nov'">
                    <xsl:text>11</xsl:text>
                </xsl:if>
                <xsl:if test="substring(created_at, 5, 3) = 'Dec'">
                    <xsl:text>12</xsl:text>
                </xsl:if>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(created_at, 9, 2)"/>
                <xsl:text>T</xsl:text>
                <xsl:value-of select="substring(created_at, 12, 8)"/>
                <xsl:text>Z</xsl:text>
            </dcterms:created>
            <foaf:maker rdf:resource="http://twitter.com/{$screen_name}"/>
        </sioc:Post>
    </xsl:template>
</xsl:stylesheet>