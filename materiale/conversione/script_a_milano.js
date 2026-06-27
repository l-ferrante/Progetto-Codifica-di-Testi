$(document).ready(function(){
    $("#pag_90").hide();

    var indice_sez_attuale=0;


    // Seleziona i div con class="sezioni"
    var lista_sezioni = $(".sezioni"); 

    lista_sezioni.hide();

    // Mostra la sezione corrente
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

            gestione_cambio_pagina(indice_sez_attuale);
            console.log(indice_sez_attuale);
            console.log(lista_sezioni.length-1);

            gestione_firma(indice_sez_attuale);
        }
    })

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
            
            gestione_cambio_pagina(indice_sez_attuale)

        }
    })


    
    function gestione_cambio_pagina(indice_sez_attuale){
        if (indice_sez_attuale == 2){
            $("#avanti").text("Cambia pagina").addClass("cambia_pagina_avanti");
        } else{
            $("#avanti").text("Avanti").removeClass("cambia_pagina_avanti");
        }

        if (indice_sez_attuale == 3){
            $("#indietro").text("Cambia pagina").addClass("cambia_pagina_indietro");
        } else{
            $("#indietro").text("Indietro").removeClass("cambia_pagina_indietro");
        }

        if (indice_sez_attuale > 2) {
            $("#pag_89").fadeOut(300, function() {
                $("#pag_90").fadeIn(300);
            });          
        } else { 
            $("#pag_90").fadeOut(300, function() {
                $("#pag_89").fadeIn(300);
            });          
        }
    }

    function gestione_firma(indice_sez_attuale){
    if (indice_sez_attuale == (lista_sezioni.length - 1)){
        $(".firma").show();
    } else {
        $(".firma").hide(); 
    }
}


})