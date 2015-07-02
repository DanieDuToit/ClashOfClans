<?php
/**
 * Created by PhpStorm.
 * User: dutoitd1
 * Date: 2015/05/27
 * Time: 10:49 AM
 */

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $gamename = $_REQUEST['gamename'];
    $realname = $_REQUEST['realname'];
    $active = $_REQUEST['active'] = 'on' ? 1 : 0;

    $db = new BaseDB();

    $sql = "insert into player(gamename,realname, active) values('$gamename','$realname', '$active')";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
    } else {
        echo json_encode(array (
            'success' => 'success'
        ));
    }
