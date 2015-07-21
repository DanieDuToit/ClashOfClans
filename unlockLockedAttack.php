<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

//    $warID = $_REQUEST['selectedWarID'];
    $db = new BaseDB();
//
//    $sql = "
//      UPDATE Attack SET [BusyAttackingRank] = 0
//      WHERE WarID = $warID
//        AND OurAttack = 1 AND [BusyAttackingRank] > 0
//    ";
//
//    $result = $db->dbQuery($sql);
//    $db->Free($records);
//    $db->close();
//    echo json_encode(array());

    //Query SQL

    $params = array(1023);
    $tsql = "Exec [dbo].[GetOurParticipants] @warID=?";
    $records = $db->dbCallSP($tsql, $params);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        echo $record['GameName'];
    }
