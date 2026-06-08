<?php
$conn = pg_connect("host=localhost dbname=sig_klinik_medan user=postgres password=Zakiyya123");

if (!$conn) {
    die("Koneksi gagal");
}
?>