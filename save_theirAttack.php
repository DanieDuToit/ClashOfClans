<?php
    session_start();

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $WarID            = $_SESSION["selectedWarID"];
    $OurAttack        = 0;
    $FirstAttack      = $_REQUEST['firstattack'];
    $OurParticipantID = $_REQUEST['ourparticipantid'];
    $TheirParticipantID = $_REQUEST['theirparticipantid'];
    $StarsTaken       = $_REQUEST['starstaken'];

    $db = new BaseDB();

    $sql          = "insert into Attack(WarID, OurAttack, FirstAttack, OurParticipantID, TheirParticipantID, StarsTaken) values(
      $WarID, $OurAttack, $FirstAttack, $OurParticipantID, $TheirParticipantID, $StarsTaken)";
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
