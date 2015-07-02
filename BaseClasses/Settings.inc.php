<?php

    //collate SQL_Latin1_General_CP1_CI_AS
    class ApplicationSettings
    {
        static $versionNumber = "1.0.0.0 ";
        static $applicationPrefix = "COC";
        static $applicationTitle = "Clash Of Clans";
    }

    class DBSettings
    {
        static $extension = "sqlsrv";
        static $database = "COC";
        static $dbUser = "sa";
        static $dbPass = "M1ll3nn1um";
        static $conn = null;
        // At work
        static $Server = "DANIE-TOSH";

        // At home
        //			static $Server = "DANIE-HP";
    }
