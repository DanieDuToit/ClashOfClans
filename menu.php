<?php
    //    session_start();
    //
    //    if (!isset($_SESSION["selectedClanID"]))
    //    {
    //        header("Location: Index.php?err=You must sign in first.");
    //        die();
    //    }
    //?>
<!DOCTYPE html>
<html>
<!--<head>-->
<link rel="stylesheet" type="text/css" href="css/coc.css">
<link rel="stylesheet" type="text/css" href="themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="themes/icon.css">
<link rel="stylesheet" type="text/css" href="themes/color.css">
<script type="text/javascript" src="src/jquery.min.js"></script>
<script type="text/javascript" src="src/jquery.easyui.min.js"></script>
<meta charset="utf-8">
<!-- Start css3menu.com HEAD section -->

<link rel="stylesheet" href="Index_files/css3menu0/style.css" type="text/css"/>
<style type="text/css">._css3m {
        display: none
    }</style>

<!-- End css3menu.com HEAD section -->

<!-- Start css3menu.com HEAD section -->

<link rel="stylesheet" href="Index_files/css3menu1/style.css" type="text/css"/>
<style type="text/css">._css3m {
        display: none
    }</style>

<!-- End css3menu.com HEAD section -->

<!--</head>-->
<body>
<div data-role="header">
    <h1>Clash Of Clans Admin</h1>
</div>

<div data-role="page" id="page">
    <!-- Start css3menu.com BODY section -->

    <input type="checkbox" id="css3menu-switcher" class="c3m-switch-input">
    <ul id="css3menu1" class="topmenu">

        <li class="switch"><label onclick="" for="css3menu-switcher"></label></li>
        <li class="topfirst"><a href="#" style="height:15px;line-height:15px;"><span>Wars</span></a>
            <ul>
                <li class="subfirst">
                    <a href="ManageWars.php">Manage Wars</a>
                </li>

                <li>
                    <a href="selectWar.php?contestant=0">Set up our contestants</a>
                </li>

                <li>
                    <a href="selectWar.php?contestant=1">Set up their contestants</a>
                </li>

                <li>
                    <a href="selectWar.php?reset=1">Initialize Or RESET War</a>
                </li>

                <li>
                    <a href="selectWar.php?contestant=2">Our Attacks</a>
                </li>

                <li class="sublast">
                    <a href="selectWar.php?contestant=3">Their Attacks</a>
                </li>
            </ul>
        </li>

        <li class="toplast"><a href="ManagePlayers.php" style="height:15px;line-height:15px;">Manage Players</a></li>

    </ul>
    <p class="_css3m"><a href="http://css3menu.com/">css3 dropdown menu</a> by Css3Menu.com</p>

</div>
</body>
</html>