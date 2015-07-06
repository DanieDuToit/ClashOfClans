<?php
    session_start();
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    $contestant = isset($_REQUEST['contestant']) ? $_REQUEST['contestant'] : -1;
    $reset = isset($_REQUEST['reset']) ? 1 : 0;
?>

    <h2>Select a war for the participants to participate in
    </h2>
    <p>&nbsp;</p>
    <form id="form1" name="form1" method="post">
        <label for="select">Select:</label>
        <select name="selectedWarID" id="selectedWarID">
            <?php
                $dbBaseClass = new BaseDB();
                $sql = "SELECT WarID ,CONVERT(VARCHAR(30), [Date], 13) AS dateString FROM War";
                $records = $dbBaseClass->dbQuery($sql);
                while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
                    echo "<option value={$record['WarID']}>War ID:{$record['WarID']} => {$record['dateString']}</option>";
                }
            ?>
        </select>
        <br>
        <br>
        <input name="submit" type="submit" id="submit" formaction=
            <?php
                if ($contestant == 0) {
                    echo '"OurContestantsSetup.php"';
                } else if ($contestant == 1) {
                    echo '"TheirContestantsSetup.php"';
                } else if ($contestant == 2) {
                    echo '"ManageOurAttack.php"';
                } else if ($contestant == 3) {
                    echo '"ManageTheirAttack.php"';
                } else if ($reset = 1) {
                    echo '"InitializeWar.php"';
                }
            ?>
        value="Select">
        <br>
    </form>
<?php
/**
 * Created by PhpStorm.
 * User: Danie
 * Date: 2015/05/31
 * Time: 03:30 AM
 */