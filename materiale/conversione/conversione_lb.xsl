<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei">
    
    <xsl:output method="html" encoding="utf-8"/>
    
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select = "//tei:titleStmt/tei:title"/>
                </title>
                <link rel="stylesheet" href="conversione/style.css"/>
                <script src="https://code.jquery.com/jquery-4.0.0.min.js" integrity="sha256-OaVG6prZf4v69dPg6PhVattBXkcOWQB62pdZ3ORyrao=" crossorigin="anonymous"></script>
                <script src="conversione/script_lb.js"></script>
                
            </head>
            <body>
                
                <div class="immagine">
                    
                    <xsl:for-each select = "//tei:surface">
                        <xsl:variable name="imgId" select="tei:graphic/@xml:id"/>
                        <img>
                            <xsl:attribute name="src">
                                <xsl:value-of select="tei:graphic/@url"/>
                            </xsl:attribute>
                            <xsl:attribute name="usemap">
                                <xsl:value-of select="concat('#', $imgId)"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="$imgId"/>
                            </xsl:attribute>
                            <xsl:attribute name="id">
                                <xsl:value-of select="$imgId"/>
                            </xsl:attribute>
                            
                        </img>
                        
                        <map>
                            <xsl:attribute name="name">
                                <xsl:value-of select="$imgId"/>
                            </xsl:attribute>
                            
                            <xsl:for-each select = "tei:zone">
                                <area shape="rect">
                                    <xsl:attribute name="coords">
                                        <xsl:value-of select="@ulx"/>,<xsl:value-of select="@uly"/>,<xsl:value-of select="@lrx"/>,<xsl:value-of select="@lry"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="alt">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                </area>
                            </xsl:for-each> 
                        </map>
                    </xsl:for-each>  
                </div>
                
                <div class="testo">
                    <xsl:if test="//tei:body/tei:div[@type='intestazione']/tei:head">
                        <h1>
                            <xsl:apply-templates select="//tei:body/tei:div[@type='intestazione']/tei:head"/>
                        </h1>
                    </xsl:if>
                    
                    <!-- 
                         Il ciclo estrae il testo da ogni paragrafo, lo inserisce in un <p> di html,
                         gli assegna un id del tipo "p_n", lo inserisce dentro un <div> di html con id
                         del tipo "sezionen".
                    -->
                    <xsl:for-each select = "//tei:body//tei:div[@type='section']">
                        <div class="sezioni">
                            <xsl:attribute name="id">
                                <xsl:value-of select="concat('sezione', @n)"/>
                            </xsl:attribute>
                            
                            <xsl:for-each select=".//tei:p">
                                <p>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                    <xsl:if test="@rend = 'first-line-indented'">
                                        <xsl:attribute name="class">rientro</xsl:attribute>
                                    </xsl:if>
                                    <xsl:apply-templates select="."/>
                                </p>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                    
                    <!-- Spazio per i pulsanti di navigazione delle sezioni -->
                    <div id="nav">
                        <button id="indietro">Indietro</button>
                        <button id="avanti">Avanti</button>
                    </div>

                </div>
                
            </body>
        </html>
    </xsl:template>
    
</xsl:stylesheet>