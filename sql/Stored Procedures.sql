USE [COC]
GO
/****** Object:  StoredProcedure [dbo].[GetOurParticipants]    Script Date: 2015/07/24 10:51:42 AM ******/
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
