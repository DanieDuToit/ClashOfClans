<?php
    session_start();
    $clanID = $_SESSION['selectedClanID'];

    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $warDate     = $_REQUEST['wardate'];
    $NumberOfParticipants = $_REQUEST['numberofparticipants'];
    $WarsWeWon   = $_REQUEST['warswewon'];
    $WarsTheyWon = $_REQUEST['warstheywon'];
    $active      = $_REQUEST['active'];

    $db = new BaseDB();

    $sql = "insert into War(ClanId, date, NumberOfParticipants, WarsWeWon, WarsTheyWon, active) values(
      $clanID, '$warDate','$NumberOfParticipants', '$WarsWeWon', '$WarsTheyWon', '$active')";
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
    //    if ($result == false) {
    //        echo json_encode([
    //            'errorMsg' => 'An error occured: ' . dbGetErrorMsg()
    //        ]);
    //    } else {
    //        $sqlIdentity = "select @@identity as EntityId";
    //        $resultWarID = sqlsrv_query(Database::getInstance()->getConnection(), $sqlIdentity);
    //        $rowIdentity = sqlsrv_fetch_array($resultWarID);
    //        $WarID = $rowIdentity["EntityId"];
    //    }
