<?php

$servername = "localhost";

$username = "lowtancq_269957myshopadmin";

$password = "";

$dbname = "lowtancq_269957myshopdb";



$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {

die("Connection failed: " . $conn->connect_error);

}

?>