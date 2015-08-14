<?php
//    session_start();
    include_once("menu.php");

    if (!isset($_SESSION["selectedClanID"])) {
        header("Location: Index.php?err=You must sign in first.");
        die();
    }

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $clanID = $_SESSION["selectedClanID"];
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
        // First Attack
        $sql = "INSERT INTO Attack(WarID, OurAttack, FirstAttack, OurParticipantID, TheirParticipantID, StarsTaken)
          VALUES ($selectedWarID, 1, 1, {$record['OurParticipantID']}, 0, null)";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
        // Second Attack
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
    $sql = "SELECT TheirParticipantID, Rank FROM TheirParticipant WHERE WarID = $selectedWarID ORDER BY WarID, Rank";
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
        // Update TheirParticipant to set the Rank by Experience
        // Get the Opponents Rank by experience
        $sql_callFunc = "SELECT (SELECT dbo.[GetDirectOppositeOpponentByExperience]($selectedWarID, {$record['Rank']}) AS RankToAttack) AS RankToAttack";
        $result = $db->dbQuery($sql_callFunc);
        $rankToAttack = 0;
        $err = "";
        $record2 = sqlsrv_fetch_array($result, SQLSRV_FETCH_BOTH);
        if ($record2 == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
        $rankToAttack = $record2['RankToAttack'];
        // Update the record
        $sql = "UPDATE TheirParticipant SET RankByExperience = $rankToAttack WHERE TheirParticipantID = {$record['TheirParticipantID']}";
        $result = $db->dbQuery($sql);
        if ($result == false) {
            echo json_encode([
                'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
            ]);
            goto endOfFunction;
        }
    }
    endOfFunction:
    if ($result == false) {
        echo "<h1>An Error occured and War has not been reset</h1> <br>
            The error was : dbGetErrorMsg()";
    } else {
        echo "<h1>War has been reset</h1>";
    }
?>

