$(document).ready(function(){
    $("#pag_90").hide()

    var indice_sez_attuale=0;
    var lista_sezioni = $("div[id^='sezione_']"); //Seleziona tutti i div il cui id COMINCIA con "sezione_"

    $(lista_sezioni[indice_sez_attuale]).show()


    $("#avanti").on("click", function(){
        var sezione_attuale = lista_sezioni[indice_sez_attuale]
        var sezione_successiva = lista_sezioni[indice_sez_attuale+1]

        if (indice_sez_attuale >= (lista_sezioni.length)-1){
            console.log("Sei già all'ultima pagina del testo!");
        } else {
            $(sezione_attuale).hide();
            $(sezione_successiva).show();
        
            indice_sez_attuale ++;
        }
    })

    $("#indietro").on("click", function(){
        var sezione_attuale = lista_sezioni[indice_sez_attuale]
        var sezione_precedente = lista_sezioni[indice_sez_attuale-1]

        if(indice_sez_attuale == 0){
            console.log("Sei già alla prima pagina del testo!");
        } else{

            $(sezione_attuale).hide();
            $(sezione_precedente).show();

            indice_sez_attuale --;
        }
    })

})

