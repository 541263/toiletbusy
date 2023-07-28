<?php

/***


CREATE TABLE `lights` (
  `id` int(11) UNSIGNED NOT NULL,
  `sensor` enum('light1','light2') NOT NULL,
  `lux` smallint(5) UNSIGNED NOT NULL,
  `ts` timestamp NOT NULL DEFAULT current_timestamp()
);

ALTER TABLE `lights` ADD PRIMARY KEY (`id`);
ALTER TABLE `lights` MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;


*/

$mysqli = new mysqli('localhost', 'user', 'pass', 'database');
if ($mysqli->connect_errno) {
  header('Content-Type: text/plain');
  echo "db error";
  exit;
}

$sensor = 'light1';
$lux = intval($_GET['lux']);

if($lux>0) {
	$stmt = $mysqli->prepare("INSERT INTO `lights` (`id`, `sensor`, `lux`, `ts`) VALUES (NULL, ?, ?, current_timestamp());");
	$stmt->bind_param("si", $sensor, $lux);
	$stmt->execute();
	$stmt->close();
}

$mysqli->close();

header('Content-Type: text/plain');
echo $lux;
?>