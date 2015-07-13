<?php
    /**
     * Created by PhpStorm.
     * User: dutoitd1
     * Date: 2015/05/27
     * Time: 12:24 PM
     */

    //    echo json_encode(array (
    //        'errorMsg' => 'kjlkj jkh jhkl '
    //    ));
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $playerid = $_REQUEST['playerid'];
    $gamename = $_REQUEST['gamename'];
    $realname = $_REQUEST['realname'];
    $active = ($_REQUEST['active'] == null || $_REQUEST['active'] == 0) ? 0 : 1;

    $db = new BaseDB();

    $sql = "UPDATE player SET gamename = '$gamename',realname = '$realname', active = '$active' WHERE PlayerID = $playerid";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
    } else {
        echo json_encode([
            'success' => 'success'
        ]);
    }

