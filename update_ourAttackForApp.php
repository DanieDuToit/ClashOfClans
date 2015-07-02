<?php
    session_start();

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $db = new BaseDB();

    $WarID = 0;
    if (isset($_REQUEST["selectedWarID"])) {
        $WarID = $_REQUEST["selectedWarID"];
    } else {
        $WarID = $_SESSION["selectedWarID"];
    }
    $OurAttack = 1;
    $OurParticipantID = $_REQUEST['ourparticipantid'];
    $TheirParticipantID = 0;
    if (isset($_REQUEST['theirparticipantid'])) {
        $TheirParticipantID = $_REQUEST['theirparticipantid'];
    }
    // If their rank has been passed then we must get theirParticipantID
    if (isset($_REQUEST['theirRank'])) {
        $sql = "
            SELECT TheirParticipantID
            FROM dbo.TheirParticipant
            WHERE (Rank = {$_REQUEST['theirRank']}) AND (WarID = $WarID)
        ";
        $result = $db->dbQuery($sql);
        $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
        $TheirParticipantID = $record['TheirParticipantID'];
    }
    $StarsTaken = $_REQUEST['starstaken'];
    $FirstAttack = 0; // By default the second attack

    // See if this is the first or second attack
    $sql = "SELECT COUNT(AttackID) AS counter FROM Attack WHERE (WarID = $WarID) AND (OurParticipantID = $OurParticipantID) AND (ISNULL(StarsTaken, - 1) <> - 1) GROUP BY StarsTaken";
    $result = $db->dbQuery($sql);
    $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
    if ($record['counter'] == 0) {
        $FirstAttack = 1;
    } else if ($record['counter'] > 1) { // There is already 2 attacks
        echo json_encode([
            'errorMsg' => 'There is already 2 attacks for this Rank'
        ]);
    }

    $sql = "
        UPDATE Attack
        SET TheirParticipantID = $TheirParticipantID, StarsTaken = $StarsTaken,
          TimeOfAttack = GETDATE()
        WHERE OurParticipantID = $OurParticipantID
        AND FirstAttack = $FirstAttack AND OurAttack = 1
    ";
    $result = $db->dbQuery($sql);
    if ($result == false) {
        echo json_encode([
            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
        ]);
    } else {
        $sqlIdentity = "select @@identity as EntityId";
        $resultID = sqlsrv_query(Database::getInstance()->getConnection(), $sqlIdentity);
        $rowIdentity = sqlsrv_fetch_array($resultID);
        $AttackID = $rowIdentity["EntityId"];
        echo json_encode([
            'success' => 'success'
        ]);
    }
