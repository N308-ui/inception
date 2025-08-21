<?php
$max_attempts = 30;
$attempt = 0;

while ($attempt < $max_attempts) {
    try {
        $db = new mysqli($_ENV['MYSQL_HOST'], $_ENV['MYSQL_USER'], $_ENV['MYSQL_PASSWORD']);
        if ($db->connect_error) {
            throw new Exception($db->connect_error);
        }
        echo "MariaDB is ready!\n";
        exit(0);
    } catch (Exception $e) {
        $attempt++;
        if ($attempt >= $max_attempts) {
            echo "Failed to connect to MariaDB after $max_attempts attempts: " . $e->getMessage() . "\n";
            exit(1);
        }
        sleep(2);
    }
}
?>