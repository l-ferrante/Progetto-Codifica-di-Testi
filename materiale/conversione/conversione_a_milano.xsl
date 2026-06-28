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
                <link rel="stylesheet" href="conversione/stile.css"/>
                <script src="https://code.jquery.com/jquery-4.0.0.min.js" integrity="sha256-OaVG6prZf4v69dPg6PhVattBXkcOWQB62pdZ3ORyrao=" crossorigin="anonymous"></script>
                <script src="conversione/script_a_milano.js"></script>
                <link rel="icon" type="image/x-icon" href="immagini/icone/favicon.ico"/>

            </head>
            <body>
                <!-- Header -->
                <div id="header">
                    <p id="titolo" class="evidenza">Tre testi da <span class="grassetto corsivo">La Farfalla</span><img src="immagini/icone/farfalla.png" alt="farfalla"/></p>
                    <a id="a_milano" href="output_AMilano.html">A Milano!</a>
                    <a id="la_mafia" href="output_LaMafia.html">La Mafia</a>
                    <a id="giacinta" href="output_RecensioneGiacinta.html">Recensione di <span class="corsivo">Giacinta</span></a>
                </div>

                <!-- Introduzione -->
                <div id="introduzione">
                    <h1>
                        Testo 1:
                        <span class="evidenza">
                            <xsl:value-of select = "//tei:titleStmt/tei:title"/>
                        </span>
                    </h1>

                    <div class="blocco">
                        <div id="bibliografia">
                            <h2>Informazioni bibliografiche</h2>
                            <ul>
                                <li>
                                    <h3>Titolo:</h3>
                                    <xsl:value-of select="//tei:teiHeader//tei:sourceDesc//tei:analytic/tei:title"/>
                                </li>
                                <li>
                                    <h3>Autore:</h3>
                                    <xsl:apply-templates select="//tei:teiHeader//tei:sourceDesc//tei:analytic/tei:author" mode="informazioni_bibliografiche"/>
                                </li>
                                <li>
                                    <h3>Tratto da:</h3>
                                    <span class="corsivo">
                                        <xsl:value-of select="//tei:teiHeader//tei:sourceDesc//tei:monogr/tei:title"/>
                                    </span>
                                    del
                                    <xsl:value-of select="//tei:teiHeader//tei:profileDesc//tei:date"/>,
                                    <xsl:value-of select="//tei:teiHeader//tei:sourceDesc//tei:monogr//tei:pubPlace" separator=" - "/>,
                                    <br/>
                                    volume
                                    <xsl:value-of select="//tei:teiHeader//tei:sourceDesc//tei:biblScope[@unit='volume']"/>,
                                    pubblicazione
                                    <xsl:value-of select="//tei:teiHeader//tei:sourceDesc//tei:biblScope[@unit='issue']"/>,
                                    pagine
                                    <xsl:value-of select="//tei:teiHeader//tei:sourceDesc//tei:biblScope[@unit='page']"/>
                                </li>

                            </ul>
                        </div>

                        <div id="altre_informazioni">
                            <h2>Altre informazioni</h2>
                            <ul>
                                <li>
                                    <h3>Lingue:</h3>
                                    <ul>
                                        <xsl:for-each select="//tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language">
                                            <li>
                                                <xsl:value-of select="."/>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </li>
                            </ul>
                        </div>

                    </div>                  

                    <div id="abstract">
                        <h2>Riassunto:</h2>
                        <p>
                            <xsl:value-of select="//tei:teiHeader/tei:profileDesc/tei:abstract"/>
                        </p>

                        <!-- Recupera dal file delle entità nominate la descrizione dell'autore -->
                        <h2>Sull'autore:</h2>
                        <xsl:apply-templates select="//tei:teiHeader//tei:sourceDesc//tei:analytic/tei:author[@ref]" mode="informazioni_bibliografiche_2"/>
                    </div>

                

                </div>

                
                <div id="corpo">
                        <div id="pulsanti">
                            <h3>Evidenziazione degli elementi codificati</h3>
                            <span>Clicca sui pulsanti sottostanti per modificare l'evidenziazione dei termini notevoli e delle entità nominate codificate nel testo.</span>

                            <button id="tutti">Tutti gli elementi</button>
                            <button id="term">Termini notevoli</button>
                            <button id="persone">Persone</button>
                            <button id="luoghi">Luoghi</button>
                            <button id="organizzazioni">Organizzazioni</button>
                        </div>

                    <!-- Immagine -->
                    <div class="immagine">
                        <xsl:for-each select = "//tei:surface">
                            <img>
                                <xsl:attribute name="src">
                                    <xsl:value-of select="tei:graphic/@url"/>
                                </xsl:attribute>
                                <xsl:attribute name="alt">
                                    <xsl:value-of select="tei:graphic/@xml:id"/>
                                </xsl:attribute>
                                <xsl:attribute name="id">
                                    <xsl:value-of select="tei:graphic/@xml:id"/>
                                </xsl:attribute>
                            </img>
                        </xsl:for-each>
                    </div>
                    
                    <!-- Testo -->
                    <div class="testo">
                        <h1>
                            <xsl:apply-templates select="//tei:body/tei:div[@type='intestazione']/tei:head"/>
                        </h1>

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
                </div>

                <!-- Glossario dei termini notevoli e delle entità nominate -->
                <div class="blocco">
                    <xsl:if test="//tei:body//tei:div[@type='section']/tei:p/tei:term">
                        <div id="glossario">
                            <ul>
                                <h2>Glossario dei termini notevoli</h2>
                                <xsl:for-each-group select="//tei:body//tei:div[@type='section']/tei:p/tei:term" group-by="@ref">
                                    <xsl:apply-templates select="." mode="glossario"/>
                                </xsl:for-each-group>
                            </ul>
                        </div>
                    </xsl:if>


                    <div id="entita_nominate">
                        <h2>Glossario delle entità nominate</h2>
                            
                            <xsl:if test="//tei:body//tei:div[@type='section']/tei:p/tei:persName">
                                <h3 id="button_persone">Persone <img src="immagini/icone/freccia_giu.png" alt="freccia_giù" class="freccia_giu"/></h3>
                                <ul id="lista_persone">
                                    <xsl:for-each-group select="//tei:body//tei:div[@type='section']/tei:p/tei:persName" group-by="@ref">
                                            <xsl:apply-templates select="." mode="glossario"/>
                                    </xsl:for-each-group>
                                </ul>
                            </xsl:if>


                            <xsl:if test="//tei:body//tei:div[@type='section']/tei:p/tei:placeName">
                                <h3 id="button_luoghi">Luoghi <img src="immagini/icone/freccia_giu.png" alt="freccia_giù" class="freccia_giu"/></h3>
                                <ul id="lista_luoghi">
                                    <xsl:for-each-group select="//tei:body//tei:div[@type='section']/tei:p/tei:placeName" group-by="@ref">
                                        <xsl:apply-templates select="." mode="glossario"/>
                                    </xsl:for-each-group>
                                </ul>
                            </xsl:if>

                            <xsl:if test="//tei:body//tei:div[@type='section']/tei:p/tei:orgName">
                                <h3 id="button_organizzazioni">Organizzazioni <img src="immagini/icone/freccia_giu.png" alt="freccia_giù" class="freccia_giu"/></h3>
                                <ul id="lista_organizzazioni">
                                    <xsl:for-each-group select="//tei:body//tei:div[@type='section']/tei:p/tei:orgName" group-by="@ref">
                                        <xsl:apply-templates select="." mode="glossario"/>
                                    </xsl:for-each-group>
                                </ul>
                            </xsl:if>

                    </div>
                </div>

                <!-- Note di codifica -->
                <div id="note_codifica">
                    <h3>Note di codifica</h3>
                    <xsl:value-of select="//tei:teiHeader/tei:encodingDesc"/>
                </div>



                <!-- Footer -->
                <div id="footer">
                    <div>
                        <span class="grassetto">Università di Pisa</span>
                        <br/>
                        <span>Corso di laurea triennale in Informatica Umanistica</span>
                        <br/>
                        <span>Anno accademico 2025-2026</span>
                    </div>

                    <div>
                        <span class="grassetto">Corso di codifica di testi</span>
                        <br/>
                        <span>Professor Angelo Mario del Grosso</span>
                    </div>


                    <div>
                        <span class="grassetto">Autori</span>
                        <br/>
                        <span><a href="mailto:l.bianchi59@studenti.unipi.it" target="_blank">Lorenzo Bianchi</a></span>
                        <br/>
                        <span><a href="mailto:l.ferrante9@studenti.unipi.it" target="_blank">Lorenzo Ferrante</a></span>
                    </div>
                </div>

                <a href="#corpo"><img id="torna_su" src="immagini/icone/freccia_giu.png" alt="torna su"/></a>


            </body>
        </html>
    </xsl:template>

    <!-- Template per la gestione delle parole a capo spezzate (marcate con il tag <lb> in xml e con l'attributo @break="no")
     Il template fa match sul nodo il cui fratello PREDECESSORE è <lb break="no">, quindi
      sfrutta un'espressione regolare per sostituire \s (spazio) con niente, unendo quindi le parti della parola-->
    <xsl:template match="text()[preceding-sibling::node()[1][self::tei:lb[@break='no']]]">
        <xsl:value-of select="replace(., '^\s+', '')"/>
    </xsl:template>

    <xsl:template match="tei:w">
        <xsl:value-of select="@lemma"/>
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


    <!-- Per ogni term viene visualizzata la sua gloss tramite attributo "data-*"
     (visualizza la gloss quando il mouse è sopra il term in questione) -->
    <xsl:template match="tei:term[@ref]">
        <xsl:variable name="file_glossario" select="'../glossario.xml'"/>
        <xsl:variable name="id_term" select="substring-after(@ref, '#')"/>
        <xsl:variable name="gloss" select="document($file_glossario)//*[@xml:id=$id_term]/following-sibling::tei:gloss"/>
    
        <span>
            <xsl:attribute name="class">
                term notevole
                <xsl:if test="@rend='italic'">
                corsivo
                </xsl:if>
            </xsl:attribute>

            <xsl:attribute name="data-box">
                <xsl:value-of select="$gloss"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <!-- Template per la costruzione del glossario dei termini notevoli-->
    <xsl:template match="tei:term[@ref]" mode="glossario">
        <xsl:variable name="file_glossario" select="'../glossario.xml'"/>
        <xsl:variable name="id_term" select="substring-after(@ref, '#')"/>
        <xsl:variable name="gloss" select="document($file_glossario)//*[@xml:id=$id_term]/following-sibling::tei:gloss"/>
    
        <li>
            <span class="grassetto">
                <xsl:value-of select="."/>
            </span>
            <p class="gloss">
                <xsl:value-of select="$gloss"/>
            </p>
        </li>
        
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


    <!-- Template per la costruzione del glossario delle entità nominate (PERSONE)-->
    <xsl:template match="tei:persName[@ref]" mode="glossario">
        <xsl:variable name="id_pers" select="substring-after(@ref, '#')"/>
        <xsl:variable name="persona" select="document($file_entita_nominate)//*[@xml:id=$id_pers]"/>
        <xsl:variable name="nome" select="normalize-space($persona//tei:forename)"/>
        <xsl:variable name="cognome" select="normalize-space($persona//tei:surname)"/>
        <xsl:variable name="nota" select="normalize-space($persona//tei:note)"/>

        <xsl:variable name="genere" select="$persona//tei:sex"/>

        <xsl:variable name="luogo_nascita" select="$persona/tei:birth/tei:placeName"/>
        <xsl:variable name="anno_nascita" select="$persona/tei:birth/tei:date"/>

        <xsl:variable name="luogo_morte" select="$persona/tei:death/tei:placeName"/>
        <xsl:variable name="anno_morte" select="$persona/tei:death/tei:date"/>

        <li>
            <span class="grassetto">
                <xsl:value-of select="."/>
            </span>
            <p>
                <xsl:if test="$luogo_nascita!=''">
                    <!-- Nascita -->
                    Nat<xsl:choose><xsl:when test="$genere='M'">o</xsl:when><xsl:otherwise>a</xsl:otherwise></xsl:choose> a 
                    <xsl:value-of select="$luogo_nascita"/> nel <xsl:value-of select="$anno_nascita"/>

                    <br/>

                    <!-- Morte -->
                    Mort<xsl:choose><xsl:when test="$genere='M'">o</xsl:when><xsl:otherwise>a</xsl:otherwise></xsl:choose> a 
                    <xsl:value-of select="$luogo_morte"/> nel <xsl:value-of select="$anno_morte"/>
                    
                    <br/>
                    <br/>
                </xsl:if>

                <!-- Nota -->
                <xsl:value-of select="$nota"/>

            </p>
        </li>
    
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

    <!-- Template per la costruzione del glossario delle entità nominate (LUOGHI) -->
    <xsl:template match="tei:placeName[@ref]" mode="glossario">
        <xsl:variable name="id_place" select="substring-after(@ref, '#')"/>
        <xsl:variable name="luogo" select="document($file_entita_nominate)//*[@xml:id=$id_place]"/>
        <xsl:variable name="toponimo" select="normalize-space($luogo/tei:placeName)"/>
        <xsl:variable name="nota" select="$luogo/tei:note"/>
        
        <xsl:variable name="paese" select="$luogo/tei:country"/>
        
        <li>
            <span class="grassetto">
                <xsl:value-of select="."/>
            </span>
            <p>
                <xsl:value-of select="$paese"/>
                <br/>
                <br/>
                <xsl:value-of select="$nota"/>
            </p>
        </li>
    
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
    
        <span>
            <xsl:attribute name="class">
                org notevole
                <xsl:if test="@rend='italic'">
                corsivo
                </xsl:if>
            </xsl:attribute>

            <xsl:attribute name="data-box">
                <xsl:value-of select="concat($nome_org, ': ', $desc_org)"/>
            </xsl:attribute>

            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- Template per la costruzione del glossario delle entità nominate (ORGANIZZAZIONI) -->
     
    <xsl:template match="tei:orgName[@ref]" mode="glossario">
        <xsl:variable name="id_org" select="substring-after(@ref, '#')"/>
        <xsl:variable name="organizzazione" select="document($file_entita_nominate)//*[@xml:id=$id_org]"/>
        <xsl:variable name="nome_org" select="$organizzazione/tei:orgName"/>
        <xsl:variable name="desc_org" select="$organizzazione/tei:desc"/>
        
        
        <li>
            <span class="grassetto">
                <xsl:value-of select="."/>
            </span>
            <p>
                <xsl:value-of select="$desc_org"/>
            </p>
        </li>
    
    </xsl:template>


    <!-- Template per la gestione dei forestierismi -->
    <xsl:template match="tei:foreign">
        <span class="corsivo">
            <xsl:apply-templates/>
        </span>
    </xsl:template>


    <!-- Template per la gestione dello pseudonimo dell'autore nelle informazioni bibliografiche -->
    <xsl:template match="tei:addName[@type='pseudonym']" mode="informazioni_bibliografiche">
        <span>
            detto
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:author[@ref]" mode="informazioni_bibliografiche_2">
        <xsl:variable name="id_pers" select="substring-after(@ref, '#')"/>
        <xsl:variable name="persona" select="document($file_entita_nominate)//*[@xml:id=$id_pers]"/>
        <xsl:variable name="nota" select="normalize-space($persona//tei:note)"/>
        <p>
            <xsl:value-of select="$nota"/>
        </p>
    </xsl:template>



</xsl:stylesheet>
