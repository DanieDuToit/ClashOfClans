<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $db = new BaseDB();

    $stmt    = odbc_prepare($db, 'CALL PlayersNextBestAttack(?,?)');
    $success = odbc_execute($stmt, array(11, 15));
    $temp = 10;