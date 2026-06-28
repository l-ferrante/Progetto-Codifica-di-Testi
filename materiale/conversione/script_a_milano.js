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
            
            gestione_cambio_pagina(indice_sez_attuale);
            gestione_firma(indice_sez_attuale);
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

    // La firma viene mostrata soltanto sotto l'ultima sezione
    function gestione_firma(indice_sez_attuale){
        if (indice_sez_attuale == (lista_sezioni.length - 1)){
            $(".firma").show();
        } else {
            $(".firma").hide(); 
        }
    }


    $("#button_persone").on("click", function(){
        $("#lista_persone").slideToggle(400);
        $("#button_persone img").toggleClass("ruotata");
    })

    $("#button_luoghi").on("click", function(){
        $("#lista_luoghi").slideToggle(400);
        $("#button_luoghi img").toggleClass("ruotata");
    })

    $("#button_organizzazioni").on("click", function(){
        $("#lista_organizzazioni").slideToggle(400);
        $("#button_organizzazioni img").toggleClass("ruotata");
    })


    // Gestione dei button per la visualizzazione degli elemementi codificati
    $("button#tutti").on("click", function(){
        if ($(".notevole").not(".grassetto").length > 0) {
            $(".notevole, .term, .pers, .place, .org").addClass("grassetto");
        } else {
            $(".notevole, .term, .pers, .place, .org").removeClass("grassetto");
        }
    });

    $("button#term").on("click", function(){
        $(".term").toggleClass("grassetto");
    })

    $("button#persone").on("click", function(){
        $(".pers").toggleClass("grassetto");
    })

    $("button#luoghi").on("click", function(){
        $(".place").toggleClass("grassetto");
    })

    $("button#organizzazioni").on("click", function(){
        $(".org").toggleClass("grassetto");
    })


    $(".notevole").on("click", function(){
        var posizioneGlossario = $("#glossario").offset().top;
        $("html, body").animate({
            scrollTop: posizioneGlossario
        });
    });

    $(window).on("scroll", gestoreFreccia);
    function gestoreFreccia(){
        if ($(window).scrollTop() > 1500) {
            $("#torna_su").css("opacity", "1");
        } else {
            $("#torna_su").css("opacity", "0");
        }
    }


    $(".immagine").on("mousemove", function(event) {
        var $img = $(this).find("img");

        var posX = event.pageX - $(this).offset().left;
        var posY = event.pageY - $(this).offset().top;

        var percenX = (posX / $(this).width()) * 100;
        var percenY = (posY / $(this).height()) * 100;

        $img.css("transform-origin", percenX + "% " + percenY + "%");
    });

    $(".immagine").on("mouseleave", function() {
        var $img = $(this).find("img");
        $img.css("transform-origin", "center center");
    });



})
