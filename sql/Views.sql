USE [COC]
GO
/****** Object:  View [dbo].[View_AttacksStats]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_AttacksStats]
AS
  SELECT
    dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank, dbo.TheirParticipant.RankByExperience,
    dbo.Attack.StarsTaken, dbo.Attack.OurAttack,
    dbo.Attack.FirstAttack, dbo.OurParticipant.Experience AS OurExperience,
    dbo.TheirParticipant.Experience AS TheirExperience
  FROM dbo.Attack
    INNER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
    INNER JOIN
    dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID

GO
/****** Object:  View [dbo].[View_AttacksStatsResults]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Our Attacks*/
ALTER VIEW [dbo].[View_AttacksStatsResults]
AS
  SELECT
    A.[Number of losts where our experience was less than or equals to theirs and the ranks was the same],
    B.[Number of losts where our experience was greater than or equals to theirs and the ranks was the same],
    C.[Number of wins where our experience was less than or equal to theirs and the ranks was the same],
    D.[Number of wins where our experience was greater than or equal to theirs and the ranks was the same],
    E.[Number of losts where the ranks was the same],
    F.[Number of losts where their ranks was one lower than ours], G.[Number of wins where the ranks was the same],
    H.[Number of wins where their ranks was one lower than ours]
  FROM (SELECT
    COUNT(*) AS [Number of losts where our experience was less than or equals to theirs and the ranks was the same]
  FROM dbo.View_AttacksStats
  WHERE (OurAttack = 1) AND (StarsTaken < 2) AND (OurExperience <= TheirExperience) AND (OurRank = TheirRank) OR
      (OurAttack = 0) AND (StarsTaken < 2) AND (OurRank = TheirRank) AND
          (TheirExperience <= OurExperience)) AS A CROSS JOIN
    (SELECT
      COUNT(*) AS [Number of losts where our experience was greater than or equals to theirs and the ranks was the same]
    FROM dbo.View_AttacksStats AS View_AttacksStats_7
    WHERE (OurAttack = 1) AND (StarsTaken < 2) AND (OurExperience >= TheirExperience) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken < 2) AND (OurRank = TheirRank) AND (TheirExperience >= OurExperience)) AS B
    CROSS JOIN
    (SELECT
      COUNT(*) AS [Number of wins where our experience was less than or equal to theirs and the ranks was the same]
    FROM dbo.View_AttacksStats AS View_AttacksStats_6
    WHERE (OurAttack = 1) AND (StarsTaken > 1) AND (OurExperience <= TheirExperience) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (OurRank = TheirRank) AND (TheirExperience <= OurExperience)) AS C
    CROSS JOIN
    (SELECT
      COUNT(*) AS [Number of wins where our experience was greater than or equal to theirs and the ranks was the same]
    FROM dbo.View_AttacksStats AS View_AttacksStats_5
    WHERE (OurAttack = 1) AND (StarsTaken > 1) AND (OurExperience >= TheirExperience) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (OurRank = TheirRank) AND (TheirExperience >= OurExperience)) AS D
    CROSS JOIN
    (SELECT COUNT(*) AS [Number of losts where the ranks was the same]
    FROM dbo.View_AttacksStats AS View_AttacksStats_4
    WHERE (OurAttack = 1) AND (StarsTaken < 2) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken < 2) AND (OurRank = TheirRank)) AS E
    CROSS JOIN
    (SELECT COUNT(*) AS [Number of losts where their ranks was one lower than ours]
    FROM dbo.View_AttacksStats AS View_AttacksStats_3
    WHERE (OurAttack = 1) AND (StarsTaken < 2) AND (TheirRank = OurRank + 1) OR
        (OurAttack = 0) AND (StarsTaken < 2) AND (TheirRank + 1 = OurRank)) AS F
    CROSS JOIN
    (SELECT COUNT(*) AS [Number of wins where the ranks was the same]
    FROM dbo.View_AttacksStats AS View_AttacksStats_2
    WHERE (OurAttack = 1) AND (StarsTaken > 1) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (OurRank = TheirRank)) AS G
    CROSS JOIN
    (SELECT COUNT(*) AS [Number of wins where their ranks was one lower than ours]
    FROM dbo.View_AttacksStats AS View_AttacksStats_1
    WHERE (OurAttack = 1) AND (StarsTaken > 1) AND (TheirRank = OurRank + 1) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (TheirRank + 1 = OurRank)) AS H

GO
/****** Object:  View [dbo].[View_OurAttackedOpponents]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_OurAttackedOpponents]
AS
  SELECT
    dbo.Attack.WarID, dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank,
    dbo.OurParticipant.OurParticipantID, dbo.Attack.StarsTaken,
    dbo.TheirParticipant.RankByExperience
  FROM dbo.Attack
    LEFT OUTER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
    LEFT OUTER JOIN
    dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
  WHERE (dbo.Attack.OurAttack = 1)

GO
/****** Object:  View [dbo].[View_OurStatsVSTheirStats]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_OurStatsVSTheirStats]
AS
  SELECT DISTINCT
    TOP (100) PERCENT
    dbo.TheirParticipant.WarID, dbo.Player.GameName, dbo.OurParticipant.Rank AS OurRank,
    dbo.OurParticipant.Experience AS OurExperience,
    dbo.OurParticipant.TownHallLevel AS OurTownhall, dbo.TheirParticipant.Rank AS TheirRank,
    dbo.TheirParticipant.Experience AS TheirExperience,
    dbo.TheirParticipant.TownHallLevel AS TheirTownhall, dbo.TheirParticipant.RankByExperience
  FROM dbo.OurParticipant
    INNER JOIN
    dbo.TheirParticipant
      ON dbo.OurParticipant.WarID = dbo.TheirParticipant.WarID AND dbo.OurParticipant.Rank = dbo.TheirParticipant.Rank
    INNER JOIN
    dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID

GO
/****** Object:  View [dbo].[View_StarsTaken]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_StarsTaken]
AS
  SELECT
    dbo.TheirParticipant.WarID, dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank,
    dbo.Attack.StarsTaken, dbo.Attack.OurAttack,
    dbo.Attack.FirstAttack, dbo.TheirParticipant.RankByExperience
  FROM dbo.Attack
    INNER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
    INNER JOIN
    dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID

GO
/****** Object:  View [dbo].[View_StarsToBeWin]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_StarsToBeWin]
AS
  SELECT TOP (100) PERCENT
    dbo.Attack.WarID, 3 - MAX(ISNULL(dbo.Attack.StarsTaken, 0)) AS StarsToBeWin, dbo.TheirParticipant.Rank,
    dbo.TheirParticipant.RankByExperience
  FROM dbo.TheirParticipant
    LEFT OUTER JOIN
    dbo.Attack ON dbo.TheirParticipant.TheirParticipantID = dbo.Attack.TheirParticipantID
  GROUP BY dbo.Attack.WarID, dbo.TheirParticipant.Rank, dbo.TheirParticipant.RankByExperience

GO
/****** Object:  View [dbo].[View_WarProgress]    Script Date: 2015/07/24 03:48:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[View_WarProgress]
AS
  SELECT TOP (100) PERCENT
    dbo.Player.GameName, dbo.Attack.FirstAttack, dbo.Attack.StarsTaken, dbo.OurParticipant.Rank AS OurRank,
    dbo.TheirParticipant.Rank AS TheirRank, dbo.War.WarID, dbo.Attack.OurAttack, dbo.Attack.TimeOfAttack,
    dbo.OurParticipant.Active, dbo.OurParticipant.OurParticipantID,
    dbo.TheirParticipant.RankByExperience
  FROM dbo.Attack
    INNER JOIN
    dbo.War
    INNER JOIN
    dbo.OurParticipant ON dbo.War.WarID = dbo.OurParticipant.WarID
    INNER JOIN
    dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID
      ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
    LEFT OUTER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
  WHERE (dbo.Attack.OurAttack = 1)

GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[41] 4[20] 2[17] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 4 [25] 3))"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 2 [25] 3))"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4 [30] 2 [40] 3))"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1 [56] 3))"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2 [66] 3))"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1 [75] 4))"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 0
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "Attack"
  BEGIN Extent =
  Top = 18
  LEFT = 249
  Bottom = 229
  RIGHT = 453
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "TheirParticipant"
BEGIN Extent =
Top = 156
LEFT = 26
Bottom = 309
RIGHT = 192
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "OurParticipant"
BEGIN Extent =
Top = 141
LEFT = 522
Bottom = 322
RIGHT = 682
END
  DisplayFlags = 280
  TopColumn = 0
END
END
END
BEGIN SQLPane =
End
  BEGIN DataPane =
  Begin ParameterDefaults = ""
  END
  BEGIN ColumnWidths = 9
  Width = 284
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
    Width = 1500
    Width = 1500
    Width = 1500
END
END
BEGIN CriteriaPane =
Begin ColumnWidths = 11
COLUMN = 1440
Alias = 1755
TABLE = 1170
OUTPUT = 720
APPEND = 1400
NewValue = 1170
SortType = 1350
SortOrder = 1410
GroupBy = 1350
Filter = 1350
OR = 1350
OR = 1350
OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_AttacksStats''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=1, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_AttacksStats''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[40] 4[20] 2[20] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 4 [25] 3))"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 2 [25] 3))"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4 [30] 2 [40] 3))"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1 [56] 3))"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2 [66] 3))"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1 [75] 4))"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 0
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "A"
  BEGIN Extent =
  Top = 6
  LEFT = 38
  Bottom = 69
  RIGHT = 597
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "B"
BEGIN Extent =
Top = 6
LEFT = 635
Bottom = 69
RIGHT = 1212
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "C"
BEGIN Extent =
Top = 72
LEFT = 38
Bottom = 135
RIGHT = 599
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "D"
BEGIN Extent =
Top = 73
LEFT = 624
Bottom = 136
RIGHT = 1195
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "E"
BEGIN Extent =
Top = 138
LEFT = 38
Bottom = 201
RIGHT = 343
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "F"
BEGIN Extent =
Top = 138
LEFT = 381
Bottom = 201
RIGHT = 744
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "G"
BEGIN Extent =
Top = 138
LEFT = 782
Bottom = 201
RIGHT = 1086
END
  DisplayFlags = 280
  TopColumn = 0
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_AttacksStatsResults''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane2'', @value = N'' BEGIN TABLE = "H"
BEGIN Extent =
Top = 204
LEFT = 38
Bottom = 267
RIGHT = 400
END
  DisplayFlags = 280
  TopColumn = 0
END
END
END
BEGIN SQLPane =
End
  BEGIN DataPane =
  Begin ParameterDefaults = ""
  END
  BEGIN ColumnWidths = 9
  Width = 284
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
    Width = 1500
    Width = 1500
    Width = 1500
END
END
BEGIN CriteriaPane =
Begin ColumnWidths = 11
COLUMN = 1440
Alias = 900
TABLE = 1170
OUTPUT = 720
APPEND = 1400
NewValue = 1170
SortType = 1350
SortOrder = 1410
GroupBy = 1350
Filter = 1350
OR = 1350
OR = 1350
OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_AttacksStatsResults''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=2, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_AttacksStatsResults''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[42] 4[21] 2[15] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 4 [25] 3))"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 2 [25] 3))"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4 [30] 2 [40] 3))"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1 [56] 3))"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2 [66] 3))"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1 [75] 4))"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 0
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "Attack"
  BEGIN Extent =
  Top = 0
  LEFT = 35
  Bottom = 191
  RIGHT = 201
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "TheirParticipant"
BEGIN Extent =
Top = 110
LEFT = 488
Bottom = 282
RIGHT = 654
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "OurParticipant"
BEGIN Extent =
Top = 6
LEFT = 277
Bottom = 114
RIGHT = 437
END
  DisplayFlags = 280
  TopColumn = 0
END
END
END
BEGIN SQLPane =
End
  BEGIN DataPane =
  Begin ParameterDefaults = ""
  END
  BEGIN ColumnWidths = 9
  Width = 284
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
    Width = 1500
    Width = 1500
    Width = 1500
END
END
BEGIN CriteriaPane =
Begin ColumnWidths = 11
COLUMN = 1440
Alias = 900
TABLE = 1170
OUTPUT = 720
APPEND = 1400
NewValue = 1170
SortType = 1350
SortOrder = 1410
GroupBy = 1350
Filter = 1350
OR = 1350
OR = 1350
OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_OurAttackedOpponents''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=1, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_OurAttackedOpponents''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[40] 4[20] 2[20] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1[40] 4[35] 3) )"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1[38] 2[21] 3) )"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4 [30] 2 [40] 3))"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1[56] 3) )"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2 [66] 3))"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1[47] 4) )"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 1
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "OurParticipant"
  BEGIN Extent =
  Top = 7
  LEFT = 391
  Bottom = 166
  RIGHT = 551
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "TheirParticipant"
BEGIN Extent =
Top = 11
LEFT = 90
Bottom = 169
RIGHT = 256
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "Player"
BEGIN Extent =
Top = 0
LEFT = 629
Bottom = 108
RIGHT = 780
END
  DisplayFlags = 280
  TopColumn = 0
END
END
END
BEGIN SQLPane =
PaneHidden =
END
BEGIN DataPane =
Begin ParameterDefaults = ""
END
BEGIN ColumnWidths = 9
Width = 284
Width = 1500
Width = 1500
Width = 1500
Width = 1500
Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
END
END
BEGIN CriteriaPane =
Begin ColumnWidths = 11
COLUMN = 1440
Alias = 2190
TABLE = 2700
OUTPUT = 720
APPEND = 1400
NewValue = 1170
SortType = 1350
SortOrder = 1410
GroupBy = 1350
Filter = 1350
OR = 1350
OR = 1350
OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_OurStatsVSTheirStats''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=1, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_OurStatsVSTheirStats''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[43] 4[21] 2[14] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 4 [25] 3))"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 2 [25] 3))"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4 [30] 2 [40] 3))"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1 [56] 3))"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2 [66] 3))"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1 [75] 4))"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 0
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "Attack"
  BEGIN Extent =
  Top = 4
  LEFT = 321
  Bottom = 214
  RIGHT = 487
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "TheirParticipant"
BEGIN Extent =
Top = 0
LEFT = 574
Bottom = 156
RIGHT = 740
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "OurParticipant"
BEGIN Extent =
Top = 6
LEFT = 38
Bottom = 206
RIGHT = 198
END
  DisplayFlags = 280
  TopColumn = 0
END
END
END
BEGIN SQLPane =
End
  BEGIN DataPane =
  Begin ParameterDefaults = ""
  END
  BEGIN ColumnWidths = 9
  Width = 284
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
    Width = 1500
    Width = 1500
    Width = 1500
END
END
BEGIN CriteriaPane =
Begin ColumnWidths = 11
COLUMN = 2265
Alias = 900
TABLE = 1170
OUTPUT = 720
APPEND = 1400
NewValue = 1170
SortType = 1350
SortOrder = 1410
GroupBy = 1350
Filter = 1350
OR = 1350
OR = 1350
OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_StarsTaken''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=1, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_StarsTaken''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[40] 4[20] 2[20] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 4 [25] 3))"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1 [50] 2 [25] 3))"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4[30] 2[40] 3) )"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1 [56] 3))"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2[57] 3) )"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1 [75] 4))"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 0
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "TheirParticipant"
  BEGIN Extent =
  Top = 6
  LEFT = 38
  Bottom = 171
  RIGHT = 220
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "Attack"
BEGIN Extent =
Top = 6
LEFT = 258
Bottom = 175
RIGHT = 478
END
  DisplayFlags = 280
  TopColumn = 0
END
END
END
BEGIN SQLPane =
End
  BEGIN DataPane =
  Begin ParameterDefaults = ""
  END
  BEGIN ColumnWidths = 9
  Width = 284
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
    Width = 1500
    Width = 1500
    Width = 1500
END
END
BEGIN CriteriaPane =
Begin ColumnWidths = 12
COLUMN = 1440
Alias = 1860
TABLE = 1170
OUTPUT = 720
APPEND = 1400
NewValue = 1170
SortType = 1350
SortOrder = 1410
GroupBy = 1350
Filter = 1350
OR = 1350
OR = 1350
OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_StarsToBeWin''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=1, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_StarsToBeWin''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane1'', @value = N''[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
BEGIN DesignProperties =
Begin PaneConfigurations =
  BEGIN PaneConfiguration = 0
    NumPanes = 4
    CONFIGURATION = "(H (1[40] 4[20] 2[20] 3) )"
END
BEGIN PaneConfiguration = 1
  NumPanes = 3
  CONFIGURATION = "(H (1[50] 4[25] 3) )"
END
BEGIN PaneConfiguration = 2
  NumPanes = 3
  CONFIGURATION = "(H (1[50] 2[25] 3) )"
END
BEGIN PaneConfiguration = 3
  NumPanes = 3
  CONFIGURATION = "(H (4 [30] 2 [40] 3))"
END
BEGIN PaneConfiguration = 4
  NumPanes = 2
  CONFIGURATION = "(H (1[69] 3) )"
END
BEGIN PaneConfiguration = 5
  NumPanes = 2
  CONFIGURATION = "(H (2 [66] 3))"
END
BEGIN PaneConfiguration = 6
  NumPanes = 2
  CONFIGURATION = "(H (4 [50] 3))"
END
BEGIN PaneConfiguration = 7
  NumPanes = 1
  CONFIGURATION = "(V (3))"
END
BEGIN PaneConfiguration = 8
  NumPanes = 3
  CONFIGURATION = "(H (1[56] 4[18] 2) )"
END
BEGIN PaneConfiguration = 9
  NumPanes = 2
  CONFIGURATION = "(H (1[62] 4) )"
END
BEGIN PaneConfiguration = 10
  NumPanes = 2
  CONFIGURATION = "(H (1[66] 2) )"
END
BEGIN PaneConfiguration = 11
  NumPanes = 2
  CONFIGURATION = "(H (4 [60] 2))"
END
BEGIN PaneConfiguration = 12
  NumPanes = 1
  CONFIGURATION = "(H (1) )"
END
BEGIN PaneConfiguration = 13
  NumPanes = 1
  CONFIGURATION = "(V (4))"
END
BEGIN PaneConfiguration = 14
  NumPanes = 1
  CONFIGURATION = "(V (2))"
END
ActivePaneConfig = 0
END
BEGIN DiagramPane =
Begin Origin =
TOP = 0
LEFT = 0
END
BEGIN Tables =
Begin TABLE = "Attack"
  BEGIN Extent =
  Top = 176
  LEFT = 632
  Bottom = 409
  RIGHT = 798
  END
    DisplayFlags = 280
    TopColumn = 0
END
BEGIN TABLE = "War"
BEGIN Extent =
Top = 6
LEFT = 38
Bottom = 163
RIGHT = 223
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "OurParticipant"
BEGIN Extent =
Top = 211
LEFT = 344
Bottom = 396
RIGHT = 504
END
  DisplayFlags = 280
  TopColumn = 1
END
BEGIN TABLE = "Player"
BEGIN Extent =
Top = 291
LEFT = 67
Bottom = 413
RIGHT = 218
END
  DisplayFlags = 280
  TopColumn = 0
END
BEGIN TABLE = "TheirParticipant"
BEGIN Extent =
Top = 0
LEFT = 971
Bottom = 211
RIGHT = 1137
END
  DisplayFlags = 280
  TopColumn = 1
END
END
END
BEGIN SQLPane =
End
  BEGIN DataPane =
  Begin ParameterDefaults = ""
  END
  BEGIN ColumnWidths = 12
  Width = 284
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
  Width = 1500
    Width = 1500
    Width = 1500
    Width = 1980
    Width = 1500
    Width = 1500
    Width = 1500
END
END
BEGIN CriteriaPane =
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_WarProgress''
GO
EXEC sys.sp_addextendedproperty @name = N''MS_DiagramPane2'', @value = N'' BEGIN ColumnWidths = 11
COLUMN = 1440
Alias = 900
TABLE = 1170
OUTPUT = 720
APPEND = 1400
NewValue = 1170
  SortType = 1350
  SortOrder = 1410
  GroupBy = 1350
  Filter = 1350
  OR = 1350
  OR = 1350
  OR = 1350
END
END
END
'' , @level0type=N'' SCHEMA '', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name=N''View_WarProgress''
GO
EXEC sys.sp_addextendedproperty@name =
                                   N''MS_DiagramPaneCount'', @value=2, @level0type=N'' SCHEMA'', @level0name=N''dbo'', @level1type=N'' VIEW '', @level1name = N''View_WarProgress''
GO
