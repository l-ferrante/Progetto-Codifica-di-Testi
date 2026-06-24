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
                <link rel="stylesheet" href="style.css"/>
                <script src="https://code.jquery.com/jquery-4.0.0.min.js" integrity="sha256-OaVG6prZf4v69dPg6PhVattBXkcOWQB62pdZ3ORyrao=" crossorigin="anonymous"></script>
                <script src="script.js"></script>

            </head>
            <body>
                <div class="immagine">

                    <xsl:for-each select = "//tei:surface">
                        <img>
                            <xsl:attribute name="src">
                                <xsl:value-of select="tei:graphic/@url"/>
                            </xsl:attribute>
                            <xsl:attribute name="usemap">
                                <xsl:value-of select="concat('area-', @xml:id)"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="tei:graphic/@xml:id"/>
                            </xsl:attribute>
                            <xsl:attribute name="id">
                                <xsl:value-of select="tei:graphic/@xml:id"/>
                            </xsl:attribute>
                        
                        </img>

                        <map>
                            <xsl:attribute name="name">
                                <xsl:value-of select="tei:graphic/@xml:id"/>
                            </xsl:attribute>

                            <xsl:for-each select = "tei:zone">

                                <area shape="rect">
                                    <xsl:attribute name="coords"><xsl:value-of select="@ulx"/>,<xsl:value-of select="@uly"/>,<xsl:value-of select="@lrx"/>,<xsl:value-of select="@lry"/></xsl:attribute>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                </area>
                            
                            </xsl:for-each>

                        </map>
                    </xsl:for-each>

<!--                     
                    <img>
                        <xsl:attribute name="src">
                            <xsl:value-of select = "//tei:body/tei:pb/@facs"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select = "//tei:body/tei:pb/@n"/>
                        </xsl:attribute>   
                    </img>
 -->

                </div>

                <div class="testo">
                    <h1>
                        <xsl:value-of select = "//tei:body/tei:div[@type='intestazione']/tei:head"/>
                    </h1>

                    <!-- 
                    Il ciclo estrae il testo da ogni paragrafo, lo inserisce in un <p> di html,
                    gli assegna un id del tipo "p_n", lo inserisce dentro un <div> di html con id
                    del tipo "sezione_n".
                    -->
                    <xsl:for-each select = "//tei:body//tei:div[@type='section']">

                        <div class="sezioni">
                            <xsl:attribute name="id">
                                <xsl:value-of select="substring(@facs, 2)"/> <!--Imposta come id il valore dell'attributo @facs in xml a partire dal secondo carattere (cioè esclude "#": importante per la gestione dell'html via jquery)-->
                            </xsl:attribute>

                            <xsl:for-each select="./tei:p">

                                <xsl:if test="@rend = 'first-line-indented'">
                                    <p class="rientro">
                                        <xsl:attribute name="id">
                                            <xsl:value-of select="@xml:id"/>
                                        </xsl:attribute>
                                        <xsl:apply-templates select="."/> <!--Rimando a un template per la gestione dei paragrafi-->
                                    </p>
                                </xsl:if>

                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                    

                    <!-- Spazio per i pulsanti di navigazione delle sezioni -->
                    <div id="nav">
                        <button id="indietro">Indietro</button>
                        <button id="avanti">Avanti</button>
                    </div>
                </div>

<!-- 
                <xsl:for-each select = "//tei:surface">
                        <map>
                            <xsl:attribute name="name">
                                <xsl:value-of select="tei:graphic/@xml:id"/>
                            </xsl:attribute>

                            <xsl:for-each select = "tei:zone">

                                <area shape="rect">
                                    <xsl:attribute name="coords"><xsl:value-of select="@ulx"/>,<xsl:value-of select="@uly"/>,<xsl:value-of select="@lrx"/>,<xsl:value-of select="@lry"/></xsl:attribute>
                                    <xsl:attribute name="id">
                                        <xsl:value-of select="@xml:id"/>
                                    </xsl:attribute>
                                </area>
                            
                            </xsl:for-each>

                        </map>
                </xsl:for-each>

     -->

            </body>
        </html>
    </xsl:template>

    <!-- Template per la gestione delle parole a capo spezzate (marcate con il tag <lb> in xml e con l'attributo @break="no")
     Il template fa match sul nodo il cui fratello PREDECESSORE è <lb break="no">, quindi
      sfrutta un'espressione regolare per sostituire \s (spazio) con niente, unendo quindi le parti della parola-->
    <xsl:template match="text()[preceding-sibling::node()[1][self::tei:lb[@break='no']]]">
        <xsl:value-of select="replace(., '^\s+', '')"/>
    </xsl:template>

    
    <!-- Template per la gestione dei discorsi diretti e dei segni grafici marcatori di discorso diretto:
     il template quando trova <q> va a capo, stampa un trattino (-) e poi il contenuto stesso di <q>.
     Il template che segue "ripulisce" il trattino "naturalmente" presente da xml che, però, si trova al di fuori del tag <q>
     Questa è la logica: se il following-sibling è un tag tei:q, in questa stringa (.), sostituisci il trattino seguito da spazi (-\s*) con niente-->
    <xsl:template match="tei:q">
        <br/>
        <xsl:text>- </xsl:text>
        <xsl:value-of select="."/>
    </xsl:template>
    <xsl:template match="text()[following-sibling::*[1][self::tei:q]]">
        <xsl:value-of select="replace(., '-\s*', '')"/>
    </xsl:template>
    

</xsl:stylesheet>