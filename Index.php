<html>
<title>Clash Of Clans Admin</title>
</html>
<?php
    session_start();
    include_once("menu.php");
    include_once("BaseClasses/BaseDB.class.php");
    include_once("BaseClasses/Database.class.php");

    if (isset($_REQUEST['err'])) {
        echo "<h2 class='error'>" . $_REQUEST['err'] . "</h2>";
    }

    $pwdMatch = false;
    if (isset($_REQUEST['submit'])) {
        $pwd = $_REQUEST['password'];
        $clanID = $_REQUEST['selectedClanID'];
        // Check the given password
        $dbBaseClass = new BaseDB();
        $sql = "SELECT Password FROM Clan WHERE ClanID = $clanID";
        $records = $dbBaseClass->dbQuery($sql);
        $record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH);
        if ($record['Password'] === $pwd) {
            $pwdMatch = true;
            $_SESSION["selectedClanID"] = $clanID;
            header("Location: menu.php");
            die();
        } else {
            echo "
                <div class=\"error\">The password you entered is not correct. Please try again.</div>
            ";
        }
    }
?>

<h2>Select your Clan and enter the password</h2>

<form id="form1" name="form1" method="post">
    <label for="select">Select Your Clan:</label>
    <select name="selectedClanID" id="selectedClanID">
        <?php
            $dbBaseClass = new BaseDB();
            $sql = "SELECT ClanID ,ClanName FROM Clan ORDER BY ClanName";
            $records = $dbBaseClass->dbQuery($sql);
            while ($record = sqlsrv_fetch_array($records, SQLSRV_FETCH_BOTH)) {
                echo "<option value={$record['ClanID']}>Clan:{$record['ClanName']}</option>";
            }
        ?>
    </select>
    <br>
    <br>
    <label for="password">Password:</label>
    <input type="password" name="password" id="password">
    <br>
    <br>
    <input name="submit" type="submit" id="submit" value="Continue">
    <br>
    <br>
</form>
<?php
    /**
     * Created by PhpStorm.
     * User: Danie
     * Date: 2015/05/31
     * Time: 03:30 AM
     */