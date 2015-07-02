<?php
    session_start();
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $selectedWarID = $_REQUEST['selectedWarID'];
    // Set session variables
    $_SESSION["selectedWarID"] = "$selectedWarID";

    $db = new BaseDB();
    // Delete existing attacks for this war
    $sql = "DELETE FROM ATTACK WHERE WarID = $selectedWarID";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
        goto endOfFunction;
    }

    $sql = "SELECT OurParticipantID FROM OurParticipant WHERE WarID = $selectedWarID";
    $records = $db->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        // Insert both attack records for each of our contestants
        $sql = "INSERT INTO Attack(WarID, OurAttack, FirstAttack, OurParticipantID, TheirParticipantID, StarsTaken)
          VALUES ($selectedWarID, 1, 1, {$record['OurParticipantID']}, 0, null)";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
        $sql = "INSERT INTO Attack(WarID, OurAttack, FirstAttack, OurParticipantID, TheirParticipantID, StarsTaken)
          VALUES ($selectedWarID, 1, 0, {$record['OurParticipantID']}, 0, null)";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
    }

    // Insert the records for their opponents
    $sql = "SELECT TheirParticipantID FROM TheirParticipant WHERE WarID = $selectedWarID";
    $records = $db->dbQuery($sql);
    while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
        // Insert both attack records for each of our contestants
        $sql = "INSERT INTO Attack(WarID, OurAttack, FirstAttack, OurParticipantID, TheirParticipantID, StarsTaken)
          VALUES ($selectedWarID, 0, 1, 0, {$record['TheirParticipantID']}, null)";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
        $sql = "INSERT INTO Attack(WarID, OurAttack, FirstAttack, OurParticipantID, TheirParticipantID, StarsTaken)
          VALUES ($selectedWarID, 0, 0, 0, {$record['TheirParticipantID']}, null)";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
    }
endOfFunction:

