<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID = $_REQUEST['selectedWarID'];

    $db = new BaseDB();

    $sql = "
      UPDATE Attack SET BusyAttackingRank = 0
        WHERE ISNULL(OurParticipantID, -1) <> -1
        AND BusyAttackingRank > 0
        AND WarID = $selectedWarID
        AND OurAttack = 1
    ";
    $result = $db->dbQuery($sql);
    if (!$result) {
        $data['result'][0] =
            array(
                'success' => 0,
                'error' => dbGetErrorMsg()
            );
    } else {
        array(
            'success' => 1,
            'error' => ''
        );
    }
    $db->close();
