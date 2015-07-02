<?php
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warID = $_REQUEST['selectedWarID'];
    $db = new BaseDB();

    $sql = "
        SELECT TOP (1) dbo.Attack.BusyAttackingRank, dbo.Player.GameName
        FROM dbo.Attack INNER JOIN
          dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID INNER JOIN
          dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID
        WHERE (ISNULL(dbo.Attack.BusyAttackingRank, - 1) <> - 1) AND (dbo.Attack.OurAttack = 1) AND (dbo.Attack.WarID = $warID) AND (dbo.Attack.BusyAttackingRank > 0)
        GROUP BY dbo.Attack.BusyAttackingRank, dbo.Attack.AttackID, dbo.Attack.OurAttack, dbo.Attack.WarID, dbo.Player.GameName
    ";

    $result = $db->dbQuery($sql);

    $record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);

    $data = array();
    if(!$record) {
        $data['busyAttackingRank'][0] = array('rank' => 0);
    } else {
        $data['busyAttackingRank'][0] =
            array(
                'rank' => $record['BusyAttackingRank'],
                'gameName' => $record['GameName']
            );
    }

    $db->Free($result);
    $db->close();

    echo json_encode($data);
?>