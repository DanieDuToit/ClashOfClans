USE [COC]
GO
/****** Object:  StoredProcedure [dbo].[GetOurParticipants]    Script Date: 2015/07/24 03:49:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetOurParticipants]
    @warID int

AS
  BEGIN

    SET NOCOUNT ON;

    SELECT
      OurParticipantID, dbo.OurParticipant.PlayerID, dbo.Player.GameName
    FROM
      dbo.OurParticipant INNER JOIN
      dbo.Player ON dbo.OurParticipant.PlayerID = dbo.Player.PlayerID
    WHERE
      (dbo.OurParticipant.WarID = @warID)
  END

GO
/****** Object:  StoredProcedure [dbo].[GetPlayersBelowWithAllAttacksLeft]    Script Date: 2015/07/24 03:49:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPlayersBelowWithAllAttacksLeft]
    @WarID INT,
    @OurRank INT
AS
  BEGIN
    SELECT A.Active, A.GameName, A.WarID, A.OurRank
    FROM (SELECT GameName, Active, WarID, OurRank
    FROM dbo.View_WarProgress
    WHERE (OurAttack = 1) AND (StarsTaken IS NULL)
         ) AS A
    GROUP BY A.GameName, A.Active, A.WarID, A.OurRank
    HAVING (COUNT(*) = 2 AND A.WarID = @WarID AND A.OurRank < @OurRank)
  END

GO
