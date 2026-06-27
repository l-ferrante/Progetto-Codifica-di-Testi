# Progetto-Codifica-di-Testi


Per quanto possibile, il progetto di codifica intende **seguire le norme del progetto COVerLess**.
Per questo motivo alcuni elementi dell’intestazione (teiHeader) sono ripresi dal modello di codifica indicato dal progetto, come suggerito dalle indicazioni nelle linee guida.
Inoltre, la **gestione delle entità nominate** è stata tratta da quella messa in atto dal progetto COVerLess, vale a dire la marcatura delle stesse nel documento xml corredata dall’aggiunta dell’attributo ref che rimanda all’elemento codificato in una lista di entità nominate esterna, in cui dell’entità stessa viene data una definizione e una breve descrizione, o ulteriori dati, dove possibile. Tuttavia, rispetto all’approccio di COVerLess (una lista per ogni tipo di dato; es: la lista per i luoghi, quella per le persone, ecc…) è stato deciso di **unificare le liste delle entità nominali** in un unico file .xml, entita_nominate.xml. E tuttavia il modo di codificare e di definire le entità nominale (luoghi, persone, organizzazioni) è tratto da quello di COVerLess.

Un esempio:
`<place ref="entita_nominate.xml#CA">Cagliari</place>
con, nella documento entita_nominate.xml l’elemento #CA:
<place xml:id="CA" type="real">
	<placeName ref="https://www.geonames.org/2525473/cagliari.html">Cagliari</placeName>
	<country key="IT">Italia</country>
	<note resp="#LF" source="https://www.treccani.it/enciclopedia/cagliari/"><p>Comune della Sardegna meridionale (133,5 km2 con 149.883 ab. al censimento del 2011, divenuti 			151.005 secondo rilevamenti ISTAT del 2020, detti cagliaritani), città metropolitana 		e capoluogo di regione; sede del governo regionale sardo.</p>
	</note>
</place>`
