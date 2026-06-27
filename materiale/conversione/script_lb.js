$(document).ready(function(){

    var indice_sez_attuale=0;


    // Seleziona i div con class="sezioni"
    var lista_sezioni = $(".sezioni"); 

    lista_sezioni.hide();

    // Mostra la prima sezione
    $(lista_sezioni[indice_sez_attuale]).show()
    
    // Pulsante avanti
    $("#avanti").on("click", function(){
        var sezione_attuale = lista_sezioni[indice_sez_attuale];
        var sezione_successiva = lista_sezioni[indice_sez_attuale+1];

        if (indice_sez_attuale >= (lista_sezioni.length)-1){
            console.log("Sei già all'ultima pagina del testo!");
        } else {
            $(sezione_attuale).hide();
            $(sezione_successiva).show();
        
            indice_sez_attuale ++;

            gestione_firma(indice_sez_attuale);
        }
    });

    // Pulsante indietro
    $("#indietro").on("click", function(){
        var sezione_attuale = lista_sezioni[indice_sez_attuale];
        var sezione_precedente = lista_sezioni[indice_sez_attuale-1];

        if(indice_sez_attuale == 0){
            console.log("Sei già alla prima pagina del testo!");
        } else {
            $(sezione_attuale).hide();
            $(sezione_precedente).show();
            indice_sez_attuale --;
        }
    });

    function gestione_firma(indice_sez_attuale) {
        if (indice_sez_attuale == (lista_sezioni.length - 1)){
            $(".firma").show();
        } else {
            $(".firma").hide(); 
        }
    }

})