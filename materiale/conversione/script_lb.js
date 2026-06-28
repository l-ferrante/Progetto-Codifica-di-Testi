$(document).ready(function(){

    var indice_sez_attuale=0;


    // Seleziona i div con class="sezioni"
    var lista_sezioni = $(".sezioni"); 

    lista_sezioni.hide();

    // Mostra la prima sezione
    $(lista_sezioni[indice_sez_attuale]).show();
    
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

            gestione_firma(indice_sez_attuale);
        }
    });

    function gestione_firma(indice_sez_attuale) {
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

});

document.addEventListener("DOMContentLoaded", function() {
    
    const contenitoreImmagine = document.querySelector('.immagine');
    contenitoreImmagine.style.position = 'relative';
    contenitoreImmagine.style.display = 'inline-block';

    const originalImgWidth = 3500.33;
    const originalImgHeight = 4988.33;

    const areas = document.querySelectorAll('area');
    areas.forEach(area => {
        const coords = area.getAttribute('coords').split(',');
        const ulx = parseInt(coords[0]);
        const uly = parseInt(coords[1]);
        const lrx = parseInt(coords[2]);
        const lry = parseInt(coords[3]);

        const leftPerc = (ulx / originalImgWidth) * 100;
        const topPerc = (uly / originalImgHeight) * 100;
        const widthPerc = ((lrx - ulx) / originalImgWidth) * 100;
        const heightPerc = ((lry - uly) / originalImgHeight) * 100;

        const box = document.createElement('div');
        box.id = 'box_' + area.id; // Es: diventerà "box_prima_sezione"
        box.className = 'zona-immagine';
        
        box.style.left = leftPerc + '%';
        box.style.top = topPerc + '%';
        box.style.width = widthPerc + '%';
        box.style.height = heightPerc + '%';
        
        box.style.position = 'absolute';
        box.style.backgroundColor = 'rgba(255, 235, 59, 0)';
        box.style.border = '2px solid transparent';
        box.style.transition = 'all 0.3s ease';
        box.style.pointerEvents = 'none';

        contenitoreImmagine.appendChild(box);
    });

    const sezioniTesto = document.querySelectorAll('.sezioni');

    sezioniTesto.forEach(sezione => {
        sezione.addEventListener('click', function() {
            
            document.querySelectorAll('.zona-immagine').forEach(box => {
                box.style.backgroundColor = 'rgba(255, 235, 59, 0)';
                box.style.border = '2px solid transparent';
                box.style.boxShadow = 'none';
            });

            const idZona = this.getAttribute('data-facs');
            
            if (idZona) {
                const boxDaIlluminare = document.getElementById('box_' + idZona);
                if (boxDaIlluminare) {
                    boxDaIlluminare.style.backgroundColor = 'rgba(255, 235, 59, 0.4)';
                    boxDaIlluminare.style.border = '2px solid #ff9800';
                    boxDaIlluminare.style.boxShadow = '0 0 15px rgba(255, 152, 0, 0.5)';
                }
            }
        });
    });
});