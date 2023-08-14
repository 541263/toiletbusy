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
	exit;
}

$sensor = 'light1';
$threshold = 1000; // light is on
$response = "";
$id = -1;
$lux = -1;

# get the last record
$stmt = $mysqli->prepare("SELECT MAX(`id`) as 'id' FROM `lights` WHERE `sensor` = ? LIMIT 1;");
$stmt->bind_param("s", $sensor);
$stmt->execute();
$res = $stmt->get_result();
if($res) {
	if($row = $res->fetch_array(MYSQLI_ASSOC)) {
		$id = $row['id'];
	}
	$res->close();
}
$stmt->close();

if($id>0) {
	# get the last state
	$stmt = $mysqli->prepare("SELECT `lux`, UNIX_TIMESTAMP(`ts`) AS 'ts' FROM `lights` WHERE `id` = ? LIMIT 1;");
	$stmt->bind_param("i", $id);
	$stmt->execute();
	$res = $stmt->get_result();
	if($res) {
		if($row = $res->fetch_array(MYSQLI_ASSOC)) {
			$lux = $row['lux'];
			$ts_last = $row['ts'];
		}
		$res->close();
	}
	$stmt->close();

	if($lux >= $threshold) {
		# light is on
		$stmt = $mysqli->prepare("SELECT UNIX_TIMESTAMP(`ts`) AS 'ts' FROM `lights` WHERE `lux` < ? AND `sensor` = ? ORDER BY `ts` DESC LIMIT 1;");
		$stmt->bind_param("is", $threshold, $sensor);
		$stmt->execute();
		$res = $stmt->get_result();
		if($res) {
			if($row = $res->fetch_array(MYSQLI_ASSOC)) {
				$ts_first = $row['ts'];
				$response = $ts_last - $ts_first;
			}
			$res->close();
		}
		$stmt->close();
	} else {
		$response = "off";
	}
}

$mysqli->close();

header('Content-Type: text/plain');
echo $response;
?>
