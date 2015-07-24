USE [COC]
GO
/****** Object:  View [dbo].[View_AttacksStats]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_AttacksStats]
AS
  SELECT     dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank, dbo.TheirParticipant.RankByExperience, dbo.Attack.StarsTaken, dbo.Attack.OurAttack,
    dbo.Attack.FirstAttack, dbo.OurParticipant.Experience AS OurExperience, dbo.TheirParticipant.Experience AS TheirExperience
  FROM         dbo.Attack INNER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID INNER JOIN
    dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID

GO
/****** Object:  View [dbo].[View_AttacksStatsResults]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Our Attacks*/
CREATE VIEW [dbo].[View_AttacksStatsResults]
AS
  SELECT     A.[Number of losts where our experience was less than or equals to theirs and the ranks was the same],
    B.[Number of losts where our experience was greater than or equals to theirs and the ranks was the same],
    C.[Number of wins where our experience was less than or equal to theirs and the ranks was the same],
    D.[Number of wins where our experience was greater than or equal to theirs and the ranks was the same], E.[Number of losts where the ranks was the same],
    F.[Number of losts where their ranks was one lower than ours], G.[Number of wins where the ranks was the same],
    H.[Number of wins where their ranks was one lower than ours]
  FROM         (SELECT     COUNT(*) AS [Number of losts where our experience was less than or equals to theirs and the ranks was the same]
  FROM          dbo.View_AttacksStats
  WHERE      (OurAttack = 1) AND (StarsTaken < 2) AND (OurExperience <= TheirExperience) AND (OurRank = TheirRank) OR
      (OurAttack = 0) AND (StarsTaken < 2) AND (OurRank = TheirRank) AND (TheirExperience <= OurExperience)) AS A CROSS JOIN
    (SELECT     COUNT(*) AS [Number of losts where our experience was greater than or equals to theirs and the ranks was the same]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_7
    WHERE      (OurAttack = 1) AND (StarsTaken < 2) AND (OurExperience >= TheirExperience) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken < 2) AND (OurRank = TheirRank) AND (TheirExperience >= OurExperience)) AS B CROSS JOIN
    (SELECT     COUNT(*) AS [Number of wins where our experience was less than or equal to theirs and the ranks was the same]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_6
    WHERE      (OurAttack = 1) AND (StarsTaken > 1) AND (OurExperience <= TheirExperience) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (OurRank = TheirRank) AND (TheirExperience <= OurExperience)) AS C CROSS JOIN
    (SELECT     COUNT(*) AS [Number of wins where our experience was greater than or equal to theirs and the ranks was the same]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_5
    WHERE      (OurAttack = 1) AND (StarsTaken > 1) AND (OurExperience >= TheirExperience) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (OurRank = TheirRank) AND (TheirExperience >= OurExperience)) AS D CROSS JOIN
    (SELECT     COUNT(*) AS [Number of losts where the ranks was the same]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_4
    WHERE      (OurAttack = 1) AND (StarsTaken < 2) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken < 2) AND (OurRank = TheirRank)) AS E CROSS JOIN
    (SELECT     COUNT(*) AS [Number of losts where their ranks was one lower than ours]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_3
    WHERE      (OurAttack = 1) AND (StarsTaken < 2) AND (TheirRank = OurRank + 1) OR
        (OurAttack = 0) AND (StarsTaken < 2) AND (TheirRank + 1 = OurRank)) AS F CROSS JOIN
    (SELECT     COUNT(*) AS [Number of wins where the ranks was the same]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_2
    WHERE      (OurAttack = 1) AND (StarsTaken > 1) AND (OurRank = TheirRank) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (OurRank = TheirRank)) AS G CROSS JOIN
    (SELECT     COUNT(*) AS [Number of wins where their ranks was one lower than ours]
    FROM          dbo.View_AttacksStats AS View_AttacksStats_1
    WHERE      (OurAttack = 1) AND (StarsTaken > 1) AND (TheirRank = OurRank + 1) OR
        (OurAttack = 0) AND (StarsTaken > 1) AND (TheirRank + 1 = OurRank)) AS H

GO
/****** Object:  View [dbo].[View_WarProgress]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_WarProgress]
AS
  SELECT     TOP (100) PERCENT dbo.Player.GameName, dbo.Attack.FirstAttack, dbo.Attack.StarsTaken, dbo.OurParticipant.Rank AS OurRank,
    dbo.TheirParticipant.Rank AS TheirRank, dbo.War.WarID, dbo.Attack.OurAttack, dbo.Attack.TimeOfAttack, dbo.OurParticipant.Active, dbo.OurParticipant.OurParticipantID,
    dbo.TheirParticipant.RankByExperience
  FROM         dbo.Attack INNER JOIN
    dbo.War INNER JOIN
    dbo.OurParticipant ON dbo.War.WarID = dbo.OurParticipant.WarID INNER JOIN
    dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID LEFT OUTER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
  WHERE     (dbo.Attack.OurAttack = 1)

GO
/****** Object:  View [dbo].[View_GetPlayersBelowWithTwoAttacksLeft]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[View_GetPlayersBelowWithTwoAttacksLeft]
AS
  SELECT     Active, GameName, WarID, OurRank
  FROM         (SELECT     GameName, Active, WarID, OurRank
  FROM          dbo.View_WarProgress
  WHERE      (OurAttack = 1) AND (StarsTaken IS NULL)) AS A
  GROUP BY GameName, Active, WarID, OurRank
  HAVING      (COUNT(*) = 2)


GO
/****** Object:  View [dbo].[View_OurAttackedOpponents]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_OurAttackedOpponents]
AS
  SELECT     dbo.Attack.WarID, dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank, dbo.OurParticipant.OurParticipantID, dbo.Attack.StarsTaken,
    dbo.TheirParticipant.RankByExperience
  FROM         dbo.Attack LEFT OUTER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID LEFT OUTER JOIN
    dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
  WHERE     (dbo.Attack.OurAttack = 1)

GO
/****** Object:  View [dbo].[View_OurStatsVSTheirStats]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_OurStatsVSTheirStats]
AS
  SELECT DISTINCT
    TOP (100) PERCENT dbo.TheirParticipant.WarID, dbo.Player.GameName, dbo.OurParticipant.Rank AS OurRank, dbo.OurParticipant.Experience AS OurExperience,
    dbo.OurParticipant.TownHallLevel AS OurTownhall, dbo.TheirParticipant.Rank AS TheirRank, dbo.TheirParticipant.Experience AS TheirExperience,
    dbo.TheirParticipant.TownHallLevel AS TheirTownhall, dbo.TheirParticipant.RankByExperience
  FROM         dbo.OurParticipant INNER JOIN
    dbo.TheirParticipant ON dbo.OurParticipant.WarID = dbo.TheirParticipant.WarID AND dbo.OurParticipant.Rank = dbo.TheirParticipant.Rank INNER JOIN
    dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID

GO
/****** Object:  View [dbo].[View_StarsTaken]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_StarsTaken]
AS
  SELECT     dbo.TheirParticipant.WarID, dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank, dbo.Attack.StarsTaken, dbo.Attack.OurAttack,
    dbo.Attack.FirstAttack, dbo.TheirParticipant.RankByExperience
  FROM         dbo.Attack INNER JOIN
    dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID INNER JOIN
    dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID

GO
/****** Object:  View [dbo].[View_StarsToBeWin]    Script Date: 2015/07/24 10:50:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_StarsToBeWin]
AS
  SELECT     TOP (100) PERCENT dbo.Attack.WarID, 3 - MAX(ISNULL(dbo.Attack.StarsTaken, 0)) AS StarsToBeWin, dbo.TheirParticipant.Rank,
    dbo.TheirParticipant.RankByExperience
  FROM         dbo.TheirParticipant LEFT OUTER JOIN
    dbo.Attack ON dbo.TheirParticipant.TheirParticipantID = dbo.Attack.TheirParticipantID
  GROUP BY dbo.Attack.WarID, dbo.TheirParticipant.Rank, dbo.TheirParticipant.RankByExperience

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "Attack"
            Begin Extent =
               Top = 18
               Left = 249
               Bottom = 229
               Right = 453
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TheirParticipant"
            Begin Extent =
               Top = 156
               Left = 26
               Bottom = 309
               Right = 192
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OurParticipant"
            Begin Extent =
               Top = 141
               Left = 522
               Bottom = 322
               Right = 682
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 1755
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AttacksStats'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AttacksStats'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "A"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 69
               Right = 597
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent =
               Top = 6
               Left = 635
               Bottom = 69
               Right = 1212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent =
               Top = 72
               Left = 38
               Bottom = 135
               Right = 599
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "D"
            Begin Extent =
               Top = 73
               Left = 624
               Bottom = 136
               Right = 1195
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "E"
            Begin Extent =
               Top = 138
               Left = 38
               Bottom = 201
               Right = 343
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "F"
            Begin Extent =
               Top = 138
               Left = 381
               Bottom = 201
               Right = 744
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "G"
            Begin Extent =
               Top = 138
               Left = 782
               Bottom = 201
               Right = 1086
            End
            DisplayFlags = 280
            TopColumn = 0
         End
 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AttacksStatsResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'        Begin Table = "H"
            Begin Extent =
               Top = 204
               Left = 38
               Bottom = 267
               Right = 400
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AttacksStatsResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_AttacksStatsResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "A"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 114
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GetPlayersBelowWithTwoAttacksLeft'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_GetPlayersBelowWithTwoAttacksLeft'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[21] 2[15] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "Attack"
            Begin Extent =
               Top = 0
               Left = 35
               Bottom = 191
               Right = 201
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TheirParticipant"
            Begin Extent =
               Top = 110
               Left = 488
               Bottom = 282
               Right = 654
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OurParticipant"
            Begin Extent =
               Top = 6
               Left = 277
               Bottom = 114
               Right = 437
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_OurAttackedOpponents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_OurAttackedOpponents'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[40] 4[35] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[38] 2[21] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[56] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[47] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 1
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "OurParticipant"
            Begin Extent =
               Top = 7
               Left = 391
               Bottom = 166
               Right = 551
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TheirParticipant"
            Begin Extent =
               Top = 11
               Left = 90
               Bottom = 169
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Player"
            Begin Extent =
               Top = 0
               Left = 629
               Bottom = 108
               Right = 780
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
      PaneHidden =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 2190
         Table = 2700
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_OurStatsVSTheirStats'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_OurStatsVSTheirStats'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[43] 4[21] 2[14] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "Attack"
            Begin Extent =
               Top = 4
               Left = 321
               Bottom = 214
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TheirParticipant"
            Begin Extent =
               Top = 0
               Left = 574
               Bottom = 156
               Right = 740
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OurParticipant"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 206
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 2265
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_StarsTaken'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_StarsTaken'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4[30] 2[40] 3) )"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2[57] 3) )"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "TheirParticipant"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 171
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Attack"
            Begin Extent =
               Top = 6
               Left = 258
               Bottom = 175
               Right = 478
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 1860
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_StarsToBeWin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_StarsToBeWin'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1[69] 3) )"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[62] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "Attack"
            Begin Extent =
               Top = 176
               Left = 632
               Bottom = 409
               Right = 798
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "War"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 163
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OurParticipant"
            Begin Extent =
               Top = 211
               Left = 344
               Bottom = 396
               Right = 504
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Player"
            Begin Extent =
               Top = 291
               Left = 67
               Bottom = 413
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TheirParticipant"
            Begin Extent =
               Top = 0
               Left = 971
               Bottom = 211
               Right = 1137
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 12
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
      End
   End
   Begin CriteriaPane =
      ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_WarProgress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_WarProgress'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_WarProgress'
GO
