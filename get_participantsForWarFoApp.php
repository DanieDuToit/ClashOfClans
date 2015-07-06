<?php
    $noWarID = false;
    $selectedWarID = 0;
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    if ($_REQUEST['selectedWarID'] = 0) {
        $noWarID = true;
    } else {
        $noWarID = false;
    }

    $db = new BaseDB();
    // If no warid was send (WarID = 0) then use the first War that is active
    if ($noWarID == false) {
        $sql = "
            SELECT TOP(1) WarID FROM War WHERE Active = 1
        ";
        $records = $db->dbQuery($sql);
        $record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH);
        $selectedWarID = $record['WarID'];
    } else {
        $selectedWarID = $_SESSION["selectedWarID"];
    }

    // increment visits counter
    $sql = "UPDATE Visits SET visits = visits + 1 WHERE id = 1";
    $result = $db->dbQuery($sql);

    $i = 0;
    $sql = "SELECT dbo.Player.PlayerID, dbo.Player.GameName, dbo.Player.RealName, dbo.OurParticipant.Rank,
        dbo.OurParticipant.Experience, dbo.OurParticipant.TownHallLevel, dbo.OurParticipant.OurParticipantID, dbo.OurParticipant.WarID
      FROM
        dbo.Player LEFT OUTER JOIN
        dbo.OurParticipant ON dbo.Player.PlayerID = dbo.OurParticipant.PlayerID
      WHERE
        (dbo.Player.Active = 1 AND WarID = $selectedWarID) AND ((SELECT [dbo].[GetNumberOfAttacks]($selectedWarID, Rank)) < 2) ORDER BY Rank
    ";
    $result = $db->dbQuery($sql);
    $data = array();
    while ($record = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH)) {
        $data['warParticipants'][$i++] = array(
            'playerid' => $record['PlayerID'],
            'gamename' => $record['GameName'],
            'realname' => $record['RealName'],
            'rank' => $record['Rank'],
            'experience' => $record['Experience'],
            'townhalllevel' => $record['TownHallLevel'],
            'ourparticipantid' => $record['OurParticipantID'],
            'warid' => $record['WarID']
        );
    }
    $db->Free($result);
    $db->close();
    echo json_encode($data);