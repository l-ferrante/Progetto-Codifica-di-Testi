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
                <link rel="stylesheet" href="conversione/stile_a_milano.css"/>
                <script src="https://code.jquery.com/jquery-4.0.0.min.js" integrity="sha256-OaVG6prZf4v69dPg6PhVattBXkcOWQB62pdZ3ORyrao=" crossorigin="anonymous"></script>
                <script src="conversione/script_a_milano.js"></script>

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

                                    <xsl:apply-templates select="."/> <!--Rimando agli altri template per la gestione degli elementi interni ai paragrafi-->
                                </p>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>

                    <div class="firma">
                        <xsl:apply-templates select="//tei:body//tei:div[@type='closer']"/>
                    </div>

                    
                    <!-- Spazio per i pulsanti di navigazione delle sezioni -->
                    <div id="nav">
                        <button id="indietro">Indietro</button>
                        <button id="avanti">Avanti</button>
                    </div>

                </div>




                
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
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="text()[following-sibling::*[1][self::tei:q]]">
        <xsl:value-of select="replace(., '-\s*', '')"/>
    </xsl:template>

    <!-- Template per la gestione della firma -->
     <!-- <xsl:template match="tei:div[@type='closer']">
        <xsl:apply-templates/>
    </xsl:template> -->

    <!-- Per ogni term viene visualizzata la sua gloss tramite attributo "data-*"
     (visualizza la gloss quando il mouse è sopra il term in questione) -->

    <xsl:template match="tei:term[@ref]">
        <xsl:variable name="file_glossario" select="'../glossario.xml'"/>
        <xsl:variable name="id_term" select="substring-after(@ref, '#')"/>
        <xsl:variable name="gloss" select="document($file_glossario)//*[@xml:id=$id_term]/following-sibling::tei:gloss"/>
    
        <span class="term notevole" data-box="{$gloss}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Serve per chiamare il file entita_nominate.xml nei template successivi -->
    <xsl:variable name="file_entita_nominate" select="'../entita_nominate.xml'"/>

    <!-- Visualizza nome, cognome e un breve testo sulle persone/personaggi menzionati. 
     Sfrutta un if-else per persone/personaggi dove non sono specificati parti del nome,
     mostrando solo i dati presenti.
     Uso normalize-space per trasformare i tag non trovati in stringhe vuote. -->

    <xsl:template match="tei:persName[@ref] | tei:rs[@type='person']">
        <xsl:variable name="id_pers" select="substring-after(@ref, '#')"/>
        <xsl:variable name="persona" select="document($file_entita_nominate)//*[@xml:id=$id_pers]"/>
        <xsl:variable name="nome" select="normalize-space($persona//tei:forename)"/>
        <xsl:variable name="cognome" select="normalize-space($persona//tei:surname)"/>
        <xsl:variable name="nota" select="normalize-space($persona//tei:note)"/>
    
        <span class="pers notevole">
            <xsl:attribute name="data-box">
                <xsl:value-of select="
                    if ($nome = '' and $cognome = '') then $nota
                    else if ($nome != '' and $cognome = '') then concat($nome, ': ', $nota)
                    else if ($nome = '' and $cognome != '') then concat($cognome, ': ', $nota)
                    else concat($nome, ' ', $cognome, ': ', $nota)
                "/>
            </xsl:attribute>
            
            <xsl:apply-templates/>

        </span>
    </xsl:template>
    
    <!-- Mostra info sui luoghi menzionati -->

    <xsl:template match="tei:placeName[@ref] | tei:rs[@type='place']">
        <xsl:variable name="id_place" select="substring-after(@ref, '#')"/>
        <xsl:variable name="luogo" select="document($file_entita_nominate)//*[@xml:id=$id_place]"/>
        <xsl:variable name="toponimo" select="normalize-space($luogo/tei:placeName)"/>
        <xsl:variable name="nota" select="$luogo/tei:note"/>
    
        <span class="place notevole" data-box="{$toponimo}: {$nota}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <!-- Mostra info sulle opere menzionate, sia indirettamente (rs), sia direttamente (ref) -->

    <xsl:template match="tei:rs[@type='work' and @ref]">
        <xsl:variable name="id_work" select="substring-after(@ref, '#')"/>
        <xsl:variable name="opera" select="document($file_entita_nominate)//*[@xml:id=$id_work]"/>
        <xsl:variable name="autore" select="$opera//tei:author"/>
        <xsl:variable name="titolo" select="$opera//tei:title"/>
        <xsl:variable name="luogo_pubbl" select="$opera//tei:pubPlace"/>
        <xsl:variable name="editore" select="$opera//tei:publisher"/>
        <xsl:variable name="data_pubbl" select="$opera//tei:date"/>
    
        <span class="work notevole">
            <xsl:attribute name="data-box">
                <xsl:value-of select="concat($autore, ', ', $titolo, ', ', $luogo_pubbl, ', ', $editore, ', ', $data_pubbl)"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <xsl:template match="tei:ref[@target]">
        <xsl:variable name="id_work" select="substring-after(@target, '#')"/>
        <xsl:variable name="opera" select="document($file_entita_nominate)//*[@xml:id=$id_work]"/>
        <xsl:variable name="autore" select="$opera//tei:author"/>
        <xsl:variable name="titolo" select="$opera//tei:title"/>
        <xsl:variable name="luogo_pubbl" select="$opera//tei:pubPlace"/>
        <xsl:variable name="editore" select="$opera//tei:publisher"/>
        <xsl:variable name="data_pubbl" select="$opera//tei:date"/>
    
        <span class="work notevole">
            <xsl:attribute name="data-box">
                <xsl:value-of select="concat($autore, ', ', $titolo, ', ', $luogo_pubbl, ', ', $editore, ', ', $data_pubbl)"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Mostra info sulle org menzionate -->

    <xsl:template match="tei:orgName[@ref] | tei:rs[@type='org']">
        <xsl:variable name="id_org" select="substring-after(@ref, '#')"/>
        <xsl:variable name="organizzazione" select="document($file_entita_nominate)//*[@xml:id=$id_org]"/>
        <xsl:variable name="nome_org" select="$organizzazione/tei:orgName"/>
        <xsl:variable name="desc_org" select="$organizzazione/tei:desc"/>
    
        <span class="org notevole">
            <xsl:attribute name="data-box">
                <xsl:value-of select="concat($nome_org, ': ', $desc_org)"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>