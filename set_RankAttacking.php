<?php

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID    = $_REQUEST['selectedWarID'];
    $ourParticipantID = $_REQUEST['ourParticipantID'];
    $rank             = $_REQUEST['rank'];

    $db = new BaseDB();
    $data = array();

    // Update the attack
    $sql    = "
        UPDATE Attack SET BusyAttackingRank = 0
        WHERE ISNULL(OurParticipantID, -1) <> -1
            AND BusyAttackingRank > 0
            AND WarID = $selectedWarID
            AND OurAttack = 1
        UPDATE Attack Set BusyAttackingRank = $rank
        WHERE OurParticipantID = $ourParticipantID
            AND WarID = $selectedWarID
            AND OurAttack = 1
    ";
    $result = $db->dbQuery($sql);
    if (!$result) {
        $data['result'][0] =
            array(
                'success' => 0,
                'error'   => dbGetErrorMsg()
            );
    } else {
        // Remove the "NextAttacker" flag (whether it is set or not)
        $sql    = "
            UPDATE OurParticipant SET NextAttacker = 0
            WHERE OurParticipantID = $ourParticipantID
      ";
        $result = $db->dbQuery($sql);
        if (!$result) {
            $data['result'][0] =
                array(
                    'success' => 0,
                    'error'   => dbGetErrorMsg()
                );
        } else {
            array(
                'success' => 1,
                'error'   => ''
            );
        }
    }
    $db->close();
    echo json_encode($data);
