document.getElementById("hide").addEventListener("click", hide);
document.getElementById("apigouv").addEventListener("click", apigouv);

function apigouv() {
    var inputValue = document.getElementById("inputVille").value
    fetch("https://geo.api.gouv.fr/communes?nom=" + inputValue + "&fields=nom,code,codesPostaux,siren,codeEpci,codeDepartement,codeRegion,population&format=json&geometry=centre")
        .then(function (res) {
            if (res.ok) {
                return res.json();
            }
        })
        .then(function (value) {
            let insee = value[0].code;
            let verif = value[0].nom;
            askMeteo(insee);
        })
        .catch(function (err) {
            showError();
            // Une erreur est survenue
        });
}
function askMeteo(insee) {
    fetch("https://api.meteo-concept.com/api/forecast/daily/0?token=860c7ca24b17c1b97153417b32ca20ce30e99f4ba10f3af2e332b9b85e94f060&insee=" + insee)
        .then(function (res) {
            if (res.ok) {
                return res.json();
            }
        })
        .then(function (value) {
            let where = document.getElementById("where")
            place = value.city.name
            where.innerText = "Aujourd'hui, à "+place+" :"

            let tmax = document.getElementById("temperaturemax")
            tempMax = value.forecast.tmax
            tmax.innerText = tempMax + " °C";
            color(tempMax,"temperaturemax");
            
            let tmin = document.getElementById("temperature-min")
            tempMin= value.forecast.tmin
            tmin.innerText = tempMin + " °C";
            color(tempMin,"temperature-min");

            let pp = document.getElementById("proba-pluie")
            pre= value.forecast.probarain
            pp.innerText = pre + " %";
            color(pre,"proba-pluie");
            
            hideError();
            show();
        })

        .catch(function (err) {
            // Une erreur est survenue
        });
}
function color(nb,id) {

    if (nb >= 25) {
        let color = document.getElementById(id)
        color.style.color = "red"
    } else if (nb >= 12 && nb < 25) {
        let color = document.getElementById(id)
        color.style.color = "yellow"
    } else {
        let color = document.getElementById(id)
        color.style.color = "blue"
    }
}
function show() {
    let response = document.getElementById("results");
    response.style.display = "block";
}
function hide() {
    let response = document.getElementById("results");
    response.style.display="none";
}
function showError() {
    let response = document.getElementById("errors");
    response.style.display = "block";
}
function hideError() {
    let response = document.getElementById("errors");
    response.style.display = "none";
}