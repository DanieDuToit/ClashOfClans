<?php
		session_start();

	//	if (!isset($_SESSION["selectedClanID"])) {
	//		header("Location: Index.php?err=You must sign in first.");
	//		die();
	//	}
	if (isset($_SESSION["ClanName"])) {
		$clanName = $_SESSION["ClanName"];
	} else {
		$clanName = "";
	}
?>
<!DOCTYPE html>
<html dir="ltr">
<title>Clan Menu</title>
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0">
	<title>css3menu.com</title>
	<!-- Start css3menu.com HEAD section -->
	<link rel="stylesheet" href="Index_files/css3menu1/style.css" type="text/css" /><style type="text/css">._css3m{display:none}</style>
	<!-- End css3menu.com HEAD section -->


</head>
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
<h2>Clan: <?php echo $clanName ?></h2>

<body ontouchstart="" style="background-color:#EBEBEB">
<!-- Start css3menu.com BODY section -->
<input type="checkbox" id="css3menu-switcher" class="c3m-switch-input">
<ul id="css3menu1" class="topmenu">
	<li class="switch"><label onclick="" for="css3menu-switcher"></label></li>
	<li class="topmenu"><a href="#" title="Create / Read / Update / Delete Assets" style="height:32px;line-height:32px;"><span><img src="Index_files/css3menu1/samples2.png" alt=""/>War</span></a>
		<ul>
			<li class="subfirst"><a href="ManageWars.php">Manage Wars</a></li>
			<li><a href="selectWar.php?contestant=0">Set up our contestats</a></li>
			<li><a href="selectWar.php?contestant=1">Set up their contestats</a></li>
			<li><a href="selectWar.php?reset=1"><img src="Index_files/css3menu1/icon18.png" alt=""/>Initialize or Reset War</a></li>
			<li><a href="selectWar.php?contestant=2">Our Attacks</a></li>
			<li class="sublast"><a href="selectWar.php?contestant=3">Their Attacks</a></li>
		</ul></li>
	<li class="topmenu"><a href="ManagePlayers.php" title="Assign an asset to the asset owner" style="height:32px;line-height:32px;"><img src="Index_files/css3menu1/service.png" alt=""/>Manage Players</a></li>
</ul><p class="_css3m"><a href="http://css3menu.com/">dhtml menu</a> by Css3Menu.com</p>
<!-- End css3menu.com BODY section -->

</body>
</html>
