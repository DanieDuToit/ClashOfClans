<?php
    session_start();

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $clanID = $_SESSION['selectedClanID'];
    $gamename = $_REQUEST['gamename'];
    $realname = $_REQUEST['realname'];
    $active = $_REQUEST['active'] = 'on' ? 1 : 0;

    $db = new BaseDB();

    $sql = "insert into player(ClanID, gamename,realname, active) values($clanID, '$gamename','$realname', '$active')";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
    } else {
        echo json_encode(array(
            'success' => 'success'
        ));
    }
