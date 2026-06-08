<?php
include 'koneksi.php';

header('Content-Type: application/json');

// Ambil parameter dari request (GET)
$search = isset($_GET['search']) ? $_GET['search'] : '';
$min_rating = isset($_GET['min_rating']) ? $_GET['min_rating'] : 0;

// Anti SQL Injection: validasi tipe data
$min_rating = floatval($min_rating); // pastikan angka, bukan string berbahaya

// Parameterized Query menggunakan pg_query_params
// $1, $2 adalah placeholder parameter yang aman dari SQL Injection
if ($search !== '') {
    $query = "SELECT id, nama, alamat, latitude, longitude, rating, jam_operasional, no_tlp, harga, status 
              FROM klinik 
              WHERE (nama ILIKE $1 OR alamat ILIKE $1) 
              AND rating >= $2
              ORDER BY rating DESC";

    // Parameter dipisah dari query = AMAN dari SQL Injection
    $result = pg_query_params($conn, $query, ['%' . $search . '%', $min_rating]);
} else {
    $query = "SELECT id, nama, alamat, latitude, longitude, rating, jam_operasional, no_tlp, harga, status 
              FROM klinik 
              WHERE rating >= $1
              ORDER BY id";

    $result = pg_query_params($conn, $query, [$min_rating]);
}

// Cek error
if (!$result) {
    http_response_code(500);
    echo json_encode(['error' => 'Query gagal: ' . pg_last_error($conn)]);
    exit;
}

$data = [];
while ($row = pg_fetch_assoc($result)) {
    $data[] = $row;
}

echo json_encode($data);
?>