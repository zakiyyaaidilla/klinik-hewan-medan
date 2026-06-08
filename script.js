let map;
let dataGlobal = [];

function initMap() {
    map = new google.maps.Map(document.getElementById("map"), {
        zoom: 12,
        center: { lat: 3.5952, lng: 98.6722 }
    });

    fetch('data.php')
    .then(res => res.json())
    .then(data => {
        dataGlobal = data;
        tampilkanMarker(data);
    });
}

function tampilkanMarker(data) {
    data.forEach(d => {
        let marker = new google.maps.Marker({
            position: { lat: parseFloat(d.latitude), lng: parseFloat(d.longitude) },
            map: map
        });

        let info = new google.maps.InfoWindow({
            content: `<b>${d.nama}</b><br>Rating: ${d.rating}`
        });

        marker.addListener("click", () => info.open(map, marker));
    });
}

function hitungJarak(lat1, lon1, lat2, lon2) {
    let R = 6371;
    let dLat = (lat2 - lat1) * Math.PI / 180;
    let dLon = (lon2 - lon1) * Math.PI / 180;

    let a =
        Math.sin(dLat/2)**2 +
        Math.cos(lat1 * Math.PI/180) *
        Math.cos(lat2 * Math.PI/180) *
        Math.sin(dLon/2)**2;

    return R * (2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)));
}

function cariTerdekat() {
    let userLat = parseFloat(document.getElementById("lat").value);
    let userLng = parseFloat(document.getElementById("lng").value);

    let min = 9999;
    let hasil = null;

    dataGlobal.forEach(d => {
        let jarak = hitungJarak(userLat, userLng, d.latitude, d.longitude);

        if (jarak < min) {
            min = jarak;
            hasil = d;
        }
    });

    alert("Terdekat: " + hasil.nama + " (" + min.toFixed(2) + " km)");
}