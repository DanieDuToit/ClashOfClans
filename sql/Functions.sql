USE [COC]
GO
/****** Object:  UserDefinedFunction [dbo].[CompletedFirstAttack]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CompletedFirstAttack]
  (
    @warID INT
    ,@ourRank INT
    ,@rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    DECLARE @result BIT;
    DECLARE @i int = -1;
    SET @result = (SELECT     COUNT(*) AS counter
    FROM dbo.Attack INNER JOIN
      dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
    WHERE (dbo.Attack.OurAttack = 1) AND (NOT (dbo.Attack.StarsTaken IS NULL)) AND dbo.Attack.WarID = @warID
    GROUP BY dbo.OurParticipant.Rank
    HAVING (dbo.OurParticipant.Rank = @ourRank));
    SET @i = @result;
    IF (@result IS NULL)
      BEGIN
        SET @result = 0
      END
    ELSE
      BEGIN
        SET @result = 1
      END
    RETURN @result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[CompletedSecondAttack]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CompletedSecondAttack]
  (
    @warID INT
    ,@opponent INT
  )
  RETURNS BIT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @result BIT
    SET @result = (SELECT
      COUNT(*) AS counter
    FROM
      dbo.Attack INNER JOIN
      dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
    WHERE
      (dbo.Attack.OurAttack = 1) AND (dbo.Attack.FirstAttack = 0) AND (NOT (dbo.Attack.StarsTaken IS NULL)) AND dbo.Attack.WarID = @warID
    GROUP BY dbo.OurParticipant.Rank
    HAVING
      (dbo.OurParticipant.Rank = @opponent))
    IF (@result IS NULL)
      BEGIN
        SET @result = 0
      END
    ELSE
      BEGIN
        SET @result = 1
      END
    RETURN @Result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetAvailableNeighbour]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetAvailableNeighbour]
  (
    @WarID INT
    ,@OwnRank INT
    ,@rankByExperience BIT
  )
  RETURNS INT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Result INT
    DECLARE @counter INT
    ,@lowerNeighbour INT = 0
    ,@higherNeighbour INT = 0
    ,@numberOfStars INT

    -- Is the higher neighbour available?
    IF (@OwnRank > 1) -- This is the highest rank
      BEGIN
        SET @numberOfStars = (SELECT [dbo].[GetMaxStars](@WarID, @OwnRank - 1, @rankByExperience))
        IF (@numberOfStars < 2) --Is the next higher opponent available
          SET @higherNeighbour = @OwnRank - 1
      END

    -- Is the lower neighbour available?
    IF (@OwnRank < [dbo].[GetNumberOfParticipants](@WarID)) -- This is the lowest rank
      BEGIN
        SET @numberOfStars = (SELECT [dbo].[GetMaxStars](@WarID, @OwnRank + 1, @rankByExperience))
        IF (@numberOfStars < 2)
          SET @lowerNeighbour = @OwnRank + 1
      END

    -- Check the lower rank first
    IF (@lowerNeighbour > 0)
      BEGIN
        -- Check if this opponent has already been attacked by our rank
        SELECT @numberOfStars = (SELECT COUNT(*) FROM dbo.View_OurAttackedOpponents WHERE (WarID = @WarID) AND (OurRank = @OwnRank) AND (TheirRank = @lowerNeighbour))
        IF (@numberOfStars > 0)
          SET @Result = 0
        ELSE
          SET @Result = @lowerNeighbour
      END
    ELSE
      BEGIN
        SELECT @numberOfStars = (SELECT COUNT(*) FROM dbo.View_OurAttackedOpponents WHERE (WarID = @WarID) AND (OurRank = @OwnRank) AND (TheirRank = @higherNeighbour))
        IF (@numberOfStars > 0)
          SET @Result = 0
        ELSE
          SET @Result = @higherNeighbour
      END
    END_OF_FUNCTION:
    RETURN @Result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetClosestAvailabledAttackOpponent]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetClosestAvailabledAttackOpponent]
  (
    @warID int,
    @ownRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @rankToAttack int
    DECLARE @alreadyAttacked bit = 0
    ,@defeated bit = 0
    ,@foundMatch bit = 0
    ,@maxStars int = 0
    ,@attacked BIT = 0
    ,@result BIT = 0

    -- Did the player already attacked twice
    SET @attacked = [dbo].[GetNumberOfAttacks](@warID, @ownRank, @rankByExperience)
    IF (@attacked = 2)
      BEGIN
        SET @rankToAttack = 0
        GOTO END_OF_PROCEDURE
      END

    -- Lets see if their is a next lower rank opponent available for him to attack
    SET @rankToAttack =  (SELECT [dbo].GetAvailableNeighbour(@warID, @ownRank, @rankByExperience))
    IF (@rankToAttack > 0 AND @rankToAttack >  @ownRank) --There is neighbours available that has not been attacked yet so we go for the next Lowest opponent
      BEGIN
        GOTO END_OF_PROCEDURE --We are done
      END

    SET @alreadyAttacked = (SELECT dbo.OwnDirectOpponentAttacked(@warID, @ownRank, @rankByExperience));
    IF (@alreadyAttacked = 0) --This player did not yet attack his direct opponent
      BEGIN
        SET @maxStars = (SELECT dbo.GetMaxStars(@warID, @ownRank, @rankByExperience)) --Check if anybody else already defeated his direct opponent
        IF (@maxStars >= 2)
          SET @defeated = 1;
      END

    IF (@alreadyAttacked = 0 AND @defeated = 0) --This player's direct opponent is available for him to attack
      BEGIN
        SET @rankToAttack = @ownRank
      END

    IF ((@alreadyAttacked = 0 AND @defeated = 1) OR -- He did not attacked his own opponent but the opponent was already defeated
        (@alreadyAttacked = 1 AND @defeated = 0))  -- OR he already attacked his own direct opponent
      BEGIN
        -- Get the next lowest available opponent where the possability is slim for a first attacker to defeat him
        -- See if there is any of this player's opponent's neighbours available for a first attack
        SET @rankToAttack = (SELECT dbo.GetNextLowest(@warID, @ownRank, @rankByExperience)) -- Get the next highest available opponent
        IF (@rankToAttack = 0) -- There is no lower rank available to attack
          BEGIN
            SET @rankToAttack = (SELECT dbo.GetNextHighest(@warID, @ownRank, @rankByExperience))  --So we go for the next highest opponent
            GOTO END_OF_PROCEDURE --We are done
          END
        SET @rankToAttack = (SELECT dbo.GetNextLowest(@warID, @ownRank, @rankByExperience))  --So we go for the next lowest opponent
        IF (@rankToAttack = 0) -- There is no lower rank available to attack
          BEGIN
            SET @rankToAttack = (SELECT dbo.GetNexthighest(@warID, @ownRank, @rankByExperience)) -- Get the next highest available opponent
          END
      END
    END_OF_PROCEDURE:
    RETURN @rankToAttack
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetClosestFirstAttackOpponent]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GetClosestFirstAttackOpponent]
  (
    @warID int,
    @ownRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @alreadyAttacked bit = 0
    ,@defeated bit = 0
    ,@foundMatch bit = 0
    ,@maxStars int = 0
    ,@attack BIT = 0
    ,@rankToAttack int

    SET @attack = (SELECT [dbo].[CompletedFirstAttack](@warid,@ownRank, @rankByExperience))
    IF (@attack = 1) -- This player already did his first attack
      BEGIN
        SET @rankToAttack = 0
        GOTO END_OF_PROCEDURE
      END
    SET @alreadyAttacked = (SELECT [dbo].[OwnDirectOpponentAttacked](@warID, @ownRank, @rankByExperience));
    IF (@alreadyAttacked = 0) --This player did not yet attack his direct opponent
      BEGIN
        SET @maxStars = (SELECT [dbo].[GetMaxStars](@warID, @ownRank, @rankByExperience)); --Check if anybody else already defeated his direct opponent
        IF (@maxStars >= 2)
          SET @defeated = 1;
      END

    IF (@alreadyAttacked = 0 AND @defeated = 0) --This player's direct opponent is available for him to attack
      BEGIN
        SET @rankToAttack = @ownRank
      END

    IF ((@alreadyAttacked = 0 AND @defeated = 1) OR -- He did not attacked his own opponent but the opponent was already defeated
        (@alreadyAttacked = 1 AND @defeated = 0))  -- Already attacked own direct opponent
      BEGIN
        SET @rankToAttack = (SELECT dbo.GetNextLowest(@warID, @ownRank, @rankByExperience)) -- Get the next lowest available opponent
        IF (@rankToAttack = 0) -- There is no lower rank available to attack
          SET @rankToAttack = (SELECT dbo.GetNexthighest(@warID, @ownRank, @rankByExperience)) -- Get the next highest available opponent
      END
    END_OF_PROCEDURE:
    -- Return the result of the function
    RETURN @rankToAttack
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetClosestSecondAttackOpponent]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetClosestSecondAttackOpponent]
  (
    @warID int,
    @ownRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @rankToAttack int
    DECLARE @alreadyAttacked bit = 0
    ,@defeated bit = 0
    ,@foundMatch bit = 0
    ,@maxStars int = 0
    ,@attacked BIT = 0
    ,@result BIT = 0
    ,@secondAttacksLeft int = 0
    ,@numberOfParticipants INT = 0
    ,@count INT = 0

    SET @attacked = (SELECT dbo.CompletedSecondAttack(@warID, @ownRank))
    IF (@attacked = 1) -- This player already did his second attack
      BEGIN
        SET @rankToAttack = 0
        GOTO END_OF_PROCEDURE
      END

    -- We Favour a lower rank neighbour first
    -- See if there is any of this player's opponent's neighbours available for a first attack
    SET @rankToAttack =  (SELECT [dbo].GetAvailableNeighbour(@warID, @ownRank, @rankByExperience))
    IF (@rankToAttack > @ownRank) --Is the neighbour a lower rank
      BEGIN
        GOTO END_OF_PROCEDURE --We are done
      END

    -- Next we see if there is any lower ranks available
    SET @rankToAttack = (SELECT dbo.GetNextLowest(@warID, @ownRank, @rankByExperience)) -- Get the next lowest available opponent
    IF (@rankToAttack <> 0) -- There is a lower rank available to attack
      BEGIN
        GOTO END_OF_PROCEDURE --We are done
      END

    -- Next we see if he can attack his direct opponent
    SET @alreadyAttacked = (SELECT dbo.OwnDirectOpponentAttacked(@warID, @ownRank, @rankByExperience));
    IF (@alreadyAttacked = 0) --This player did not yet attack his direct opponent
      BEGIN
        SET @maxStars = (SELECT dbo.GetMaxStars(@warID, @ownRank, @rankByExperience)) --Check if anybody else already defeated his direct opponent
        IF (@maxStars >= 2)
          SET @defeated = 1;
      END

    -- Is his direct opponent available
    IF (@alreadyAttacked = 0 AND @defeated = 0) --This player's direct opponent is available for him to attack
      BEGIN
        SET @rankToAttack = @ownRank
        GOTO END_OF_PROCEDURE --We are done
      END

    -- No lower or equal rank available
    SET @rankToAttack = (SELECT dbo.GetNextHighest(@warID, @ownRank, @rankByExperience))  --So we go for the next highest opponent
    END_OF_PROCEDURE:
    RETURN @rankToAttack
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetDirectOppositeOpponentByExperience]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetDirectOppositeOpponentByExperience]
  (
    @WarID INT
    ,@OwnRank INT
    ,@rankByExperience BIT
  )
  RETURNS INT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Rank INT
    DECLARE @rowNum INT

    SET @rowNum = (
      SELECT RowNum
      FROM (
             select
               ROW_NUMBER() OVER (ORDER BY WarID, Experience, Rank DESC) AS RowNum,
               WarID, [Experience],[Rank],[TownHallLevel]
             from [dbo].[OurParticipant]
             WHERE WarID = @WarID
           ) AS MyDerivedTable
      WHERE MyDerivedTable.RANK BETWEEN @OwnRank AND @OwnRank
    );

    SET @Rank = (
      SELECT Rank
      FROM (
             select
               ROW_NUMBER() OVER (ORDER BY WarID, Experience, Rank DESC) AS RowNum,
               WarID, [Experience],[Rank],[TownHallLevel]
             from [dbo].[TheirParticipant]
             WHERE WarID = @WarID
           ) AS MyDerivedTable
      WHERE MyDerivedTable.RowNum BETWEEN @rowNum AND @rowNum
    );
    RETURN @Rank
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetEqualOrNextHighest]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetEqualOrNextHighest]
  (
    @warID int,
    @opponent int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Rank int
    DECLARE @starsTaken int
    SET @starsTaken = (Select A.StarsTaken FROM (
                                                  Select WarID, OurAttack, OurRank, MAX(ISNULL(StarsTaken,0)) AS StarsTaken
                                                  FROM View_StarsTaken GROUP BY OurAttack, WarID, OurRank) as A WHERE A.OurRank = @opponent AND A.WarID = @warID AND A.OurAttack = 1)
    IF (ISNULL(@starsTaken,0) <= 1)
      BEGIN
        SET @Rank = @opponent
      END
    ELSE
      BEGIN
        SET @Rank = (SELECT dbo.GetNextHighest(@warID, @opponent, @rankByExperience))
      END

    -- Return the result of the function
    RETURN @Rank

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetEqualOrNextLowest]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetEqualOrNextLowest]
  (
    @warID int,
    @opponent int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Rank INT
    DECLARE @starsTaken int

    SET @starsTaken = (Select A.StarsTaken FROM (
                                                  Select WarID, OurAttack, OurRank, MAX(StarsTaken) AS StarsTaken
                                                  FROM View_StarsTaken GROUP BY OurAttack, WarID, OurRank) as A
    WHERE A.OurRank = @opponent AND A.WarID = @warID AND OurAttack = 1)
    IF (ISNULL(@starsTaken,0) <= 1)
      BEGIN
        SET @Rank = @opponent
      END
    ELSE
      BEGIN
        SET @Rank = (SELECT dbo.GetNextLowest(@warID, @opponent, @rankByExperience))
      END
    -- Return the result of the function
    RETURN @Rank

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetMaxStars]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetMaxStars]
  (
    @WarID int,
    @opponent int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @NumberOfStars INT
    SET @NumberOfStars = (
      Select A.StarsTaken FROM (
                                 Select WarID, OurAttack, TheirRank, MAX(StarsTaken) AS StarsTaken
                                 FROM View_StarsTaken GROUP BY OurAttack, WarID, TheirRank) as A
      WHERE A.WarID = @warID AND A.TheirRank = @opponent AND A.OurAttack = 1)
    IF (ISNULL(@NumberOfStars, -1) = -1)
      BEGIN
        SET @NumberOfStars = 0
      END

    RETURN @NumberOfStars

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNextHighest]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNextHighest]
  (
    @WarID int,
    @ourRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @counter INT = 0
    ,@temp int = 0
    ,@Rank int
    ,@numberOfParticipants INT
    ,@rankToCheck INT = 0
    ,@starsToBeTaken INT = 0

    SET @numberOfParticipants = (SELECT [dbo].[GetNumberOfParticipants](@WarID))

    -- Check if there is any opponents left with 1 star to take
    IF @ourRank = 1
      RETURN 0
    SET @rankToCheck = @ourRank - 1
    WHILE @rankToCheck <= @numberOfParticipants
      BEGIN
        BEGIN
          SET @temp = (select StarsToBeWin from [View_StarsToBeWin] WHERE warid = @WarID and RANK = @rankToCheck)
          --SET @temp = (SELECT TOP(1) [Rank] FROM [COC].[dbo].[View_StarsToBeWin] WHERE WarID = @WarID AND Rank < @rankToCheck AND StarsToBeWin >= 1 ORDER BY [Rank] DESC)
          SET @starsToBeTaken = (SELECT ISNULL(@temp,0))
          IF @starsToBeTaken <> 0 -- There is 1 or more stars left from this opponent to take
            BEGIN
              -- check if this opponent has already been attacked by our rank
              IF (select [dbo].[HasTheirRankAlreadyBeenAttackedByOurRank](@WarID, @rankToCheck, @ourRank, @rankByExperience)) = 0
                BEGIN
                  SET @Rank = @rankToCheck
                  BREAK
                END
            END
        END
        SET @rankToCheck = @rankToCheck - 1
      END
    IF (@ourRank -1 > @Rank) -- The recommened target is more than 1 rank stronger than our opponent
      BEGIN
        SET @Rank = -1
      END
    RETURN @Rank
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNextHighestOrEqual]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNextHighestOrEqual]
  (
    @warID int,
    @opponent int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Rank INT
    DECLARE @starsTaken int

    SET @Rank = (SELECT dbo.GetNextHighest(@warID, @opponent, @rankByExperience))
    IF (@Rank = 0)
      BEGIN
        SET @starsTaken = (
          Select A.StarsTaken FROM (
                                     Select WarID, OurAttack, OurRank, MAX(StarsTaken) AS StarsTaken
                                     FROM View_StarsTaken GROUP BY OurAttack, WarID, OurRank) as A
          WHERE A.OurRank = @opponent AND A.WarID = @warID AND A.OurAttack = 1)
        IF (@starsTaken <= 1)
          BEGIN
            SET @Rank = @opponent
          END
      END
    IF (ISNULL(@Rank, -1) = -1)
      BEGIN
        SET @Rank = 0
      END

    -- Return the result of the function
    RETURN @Rank

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNextLowest]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNextLowest]
  (
    @WarID int,
    @ourRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @counter INT = 0
    ,@temp int = 0
    ,@Rank int
    ,@numberOfParticipants INT
    ,@rankToCheck INT = 0
    ,@starsToBeTaken INT = 0

    SET @numberOfParticipants = (SELECT [dbo].[GetNumberOfParticipants](@WarID))

    SET @rankToCheck = @ourRank + 1
    WHILE @rankToCheck <= @numberOfParticipants
      BEGIN
        BEGIN
          SET @temp = (select StarsToBeWin from [View_StarsToBeWin] WHERE warid = @WarID and RANK = @rankToCheck)
          SET @starsToBeTaken = (SELECT ISNULL(@temp,0))
          IF @starsToBeTaken <> 0 -- There is 1 or more stars left from this opponent to take
            BEGIN
              IF (select [dbo].[HasTheirRankAlreadyBeenAttackedByOurRank](@WarID, @rankToCheck, @ourRank, @rankByExperience)) = 0
                BEGIN
                  SET @Rank = @rankToCheck
                  BREAK
                END
            END
        END
        SET @rankToCheck = @rankToCheck + 1
      END
    IF @rankToCheck > @numberOfParticipants
      SET @rankToCheck = 0
    RETURN @Rank
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNextLowestOrEqual]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNextLowestOrEqual]
  (
    @warID int,
    @opponent int,
    @rankByExperience BIT
  )
  RETURNS INT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Rank INT
    DECLARE @starsTaken int

    SET @Rank = (SELECT dbo.GetNextLowest(@warID, @opponent, @rankByExperience))
    IF (@Rank = 0)
      BEGIN
        SET @starsTaken = (
          Select A.StarsTaken FROM (
                                     Select WarID, OurAttack, OurRank, MAX(StarsTaken) AS StarsTaken
                                     FROM View_StarsTaken GROUP BY OurAttack, WarID, OurRank) as A
          WHERE A.OurRank = @opponent AND A.WarID = @warID AND OurAttack = 1)
        IF (@starsTaken <= 1)
          BEGIN
            SET @Rank = @opponent
          END
      END
    IF (ISNULL(@Rank, -1) = -1)
      BEGIN
        SET @Rank = 0
      END

    -- Return the result of the function
    RETURN @Rank

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfAttacks]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNumberOfAttacks]
  (
    @warID INT
    ,@ownRank INT
    ,@rankByExperience BIT
  )
  RETURNS INT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @numberOfAttacks INT
    SET @numberOfAttacks = (
      SELECT COUNT(dbo.OurParticipant.OurParticipantID) AS NumberOfAttacks
      FROM dbo.Attack INNER JOIN
        dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
      WHERE (dbo.Attack.StarsTaken IS NOT NULL) AND (dbo.OurParticipant.WarID = @warID) AND (dbo.OurParticipant.Rank = @ownRank) AND dbo.Attack.OurAttack = 1)

    -- Return the result of the function
    RETURN @numberOfAttacks

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfParticipants]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNumberOfParticipants]
  (
    @WarID INT
  )
  RETURNS INT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Result INT

    -- Add the T-SQL statements to compute the return value here
    SET @Result = (SELECT COUNT(*) FROM OurParticipant WHERE WarID = @WarID)

    -- Return the result of the function
    RETURN @Result

  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetSecondAttacksLeftBelowRank]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSecondAttacksLeftBelowRank]
  (
    @warID int,
    @ownRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @result INT = 0

    SET @result = (
      SELECT COUNT(*) AS Result
      FROM [COC].[dbo].[View_WarProgress]
      WHERE WarID = @warID AND FirstAttack = 0 AND OurRank > @ownRank AND StarsTaken IS NULL
    )
    -- Return the result of the function
    RETURN @result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[GetStarsTakenFromOpponent]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetStarsTakenFromOpponent]
  (
    @warID int,
    @theirRank int,
    @rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @result INT = 0

    SET @result = (
      SELECT ISNULL(MAX([StarsTaken]),0)
      FROM [COC].[dbo].[View_StarsTaken] WHERE WarID = @warID AND TheirRank = @theirRank
      GROUP BY WarID, TheirRank	)

    -- Return the result of the function
    RETURN @result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[HasTheirRankAlreadyBeenAttackedByOurRank]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[HasTheirRankAlreadyBeenAttackedByOurRank]
  (
    @warID INT,
    @rankToCheck INT,
    @ourRank INT,
    @rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @result BIT = 0
    ,@count INT = 0


    SET @count = (SELECT count(*) FROM [COC].[dbo].[View_StarsTaken] where ourrank = @ourRank and TheirRank = @rankToCheck and warid = @warID)
    IF @count > 0
      SET @result = 1
    ELSE
      SET @result = 0
    RETURN @result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[IsNeighbourAvailable]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsNeighbourAvailable]
  (
    @WarID INT
    ,@OwnRank INT
    ,@rankByExperience BIT
  )
  RETURNS INT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Result INT
    DECLARE @counter INT
    ,@lowerNeighbour INT = 0
    ,@higherNeighbour INT = 0
    ,@numberOfStars INT

    -- Is the higher neighbour available?
    IF (@OwnRank > 1) -- This is the highest rank
      BEGIN
        SET @numberOfStars = (SELECT [dbo].[GetMaxStars](@WarID, @OwnRank - 1, @rankByExperience))
        IF (@numberOfStars < 2) --Is the next higher opponent available
          SET @higherNeighbour = @OwnRank - 1
      END

    -- Is the lower neighbour available?
    IF (@OwnRank < [dbo].[GetNumberOfParticipants](@WarID)) -- This is the lowest rank
      BEGIN
        SET @numberOfStars = (SELECT [dbo].[GetMaxStars](@WarID, @OwnRank + 1, @rankByExperience))
        IF (@numberOfStars < 2)
          SET @lowerNeighbour = @OwnRank + 1
      END

    -- Check the lower rank first
    IF (@lowerNeighbour > 0)
      BEGIN
        -- Check if this opponent has already been attacked by our rank
        SELECT @numberOfStars = (SELECT COUNT(*) FROM dbo.View_OurAttackedOpponents WHERE (WarID = @WarID) AND (OurRank = @OwnRank) AND (TheirRank = @lowerNeighbour))
        IF (@numberOfStars > 0)
          SET @Result = 0
        ELSE
          SET @Result = @lowerNeighbour
      END
    ELSE
      BEGIN
        SELECT @numberOfStars = (SELECT COUNT(*) FROM dbo.View_OurAttackedOpponents WHERE (WarID = @WarID) AND (OurRank = @OwnRank) AND (TheirRank = @higherNeighbour))
        IF (@numberOfStars > 0)
          SET @Result = 0
        ELSE
          SET @Result = @higherNeighbour
      END
    END_OF_FUNCTION:
    RETURN @Result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[IsNexLowerNeighbourAvailable]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsNexLowerNeighbourAvailable]
  (
    @WarID INT
    ,@OwnRank INT
    ,@rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Result BIT
    DECLARE @counter INT
    ,@numberOfParticipants INT = 0
    ,@starsTaken INT = 0

    SET @numberOfParticipants = (SELECT [dbo].[GetNumberOfParticipants](@warID))
    IF (@OwnRank = @numberOfParticipants)
      BEGIN
        SET @Result = 0
        GOTO END_OF_PROCEDURE
      END

    SET @starsTaken = (
      SELECT MAX(StarsTaken) AS StarsTaken
      FROM dbo.View_StarsTaken
      WHERE (WarID = @warID)
      GROUP BY TheirRank
      HAVING	(TheirRank = @OwnRank + 1))
    IF (@starsTaken IS NULL OR @starsTaken < 2) --The next lower neighbour is available
      BEGIN
        SET @Result = 1
      END
    ELSE
      BEGIN
        SET @Result = 0
      END
    END_OF_PROCEDURE:
    RETURN @Result
  END
GO
/****** Object:  UserDefinedFunction [dbo].[IsNextHigherNeighbourAvailable]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsNextHigherNeighbourAvailable]
  (
    @WarID INT
    ,@OwnRank INT
    ,@rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Result BIT
    DECLARE @counter INT,
    @numberOfParticipants INT = 0,
    @starsTaken INT = 0

    IF (@OwnRank = 1)
      BEGIN
        SET @Result = 0
        GOTO END_OF_PROCEDURE
      END

    SET @starsTaken = (SELECT [dbo].[GetMaxStars](@WarID, @OwnRank - 1, @rankByExperience))
    IF (@starsTaken < 2) --The next higher neighbour is available
      BEGIN
        SET @Result = 1
      END
    ELSE
      BEGIN
        SET @Result = 0
      END
    END_OF_PROCEDURE:
    RETURN @Result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[OwnDirectOpponentAttacked]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[OwnDirectOpponentAttacked]
  (
    @warID int,
    @ownRank int,
    @rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    -- Declare the return variable here
    DECLARE @Result BIT
    DECLARE @counter int

    SET @counter = (
      --SELECT dbo.Attack.WarID, dbo.Attack.StarsTaken, dbo.OurParticipant.Rank AS OurRank, dbo.TheirParticipant.Rank AS TheirRank
      SELECT COUNT(*)
      FROM dbo.Attack INNER JOIN
        dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID INNER JOIN
        dbo.TheirParticipant ON dbo.Attack.TheirParticipantID = dbo.TheirParticipant.TheirParticipantID
      WHERE (dbo.Attack.OurAttack = 1)
          AND (dbo.OurParticipant.Rank = @ownRank)
          AND (dbo.Attack.WarID = @warID)
          AND dbo.OurParticipant.Rank = dbo.TheirParticipant.Rank
          AND (dbo.Attack.StarsTaken IS NOT NULL)
    )
    IF (@counter = 0)
      BEGIN
        SET @Result = 0
      END
    ELSE
      BEGIN
        SET @Result = 1
      END
    RETURN @Result
  END

GO
/****** Object:  UserDefinedFunction [dbo].[PlayersNextBestAttack]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[PlayersNextBestAttack]
  (
    @warID INT
    ,@ownRank INT
    ,@rankByExperience BIT
  )
  RETURNS int
AS
  BEGIN
    DECLARE @attacksDone INT
    ,@RankToAttack INT
    ,@NeighbourattacksDone INT
    ,@numberOfPlayers INT

    --Must player still do his first attack?

    SET @attacksDone = (SELECT [dbo].[GetNumberOfAttacks](@warID, @ownRank, @rankByExperience))

    IF (@attacksDone = 2) -- Check if both attacks were done
      BEGIN
        SET @RankToAttack = 0
        GOTO END_OF_PROCEDURE
      END
    IF (@attacksDone = 1) -- First attack done
      BEGIN
        --Check if a Preferred Attack Has been set for him for his second attack
        SET @RankToAttack = (
          SELECT ISNULL(dbo.Attack.NextRecommendedAttack, 0) AS RecommendedAttack
          FROM dbo.Attack INNER JOIN
            dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
          WHERE (dbo.Attack.WarID = @warID) AND (dbo.OurParticipant.Rank = @ownRank) AND (dbo.Attack.FirstAttack = 0)
        )
        IF @RankToAttack > 0
          BEGIN
            GOTO END_OF_PROCEDURE
          END
        GOTO SECOND_ATTACK
      END
    ELSE
      BEGIN
        --Check if a Preferred Attack Has been set for him for his first attack
        SET @RankToAttack = (
          SELECT ISNULL(dbo.Attack.NextRecommendedAttack, 0) AS RecommendedAttack
          FROM dbo.Attack INNER JOIN
            dbo.OurParticipant ON dbo.Attack.OurParticipantID = dbo.OurParticipant.OurParticipantID
          WHERE (dbo.Attack.WarID = @warID) AND (dbo.OurParticipant.Rank = @ownRank) AND (dbo.Attack.FirstAttack = 1)
        )
        IF @RankToAttack > 0
          BEGIN
            GOTO END_OF_PROCEDURE
          END
        -- ELSE continue
      END



    -- Check to see if this player got a lower neighbour available that was already attacked but less than 2 stars were taken
    --First lets see if this is the lowest rank player
    SET @numberOfPlayers = (SELECT [dbo].[GetNumberOfParticipants](@warID))
    IF (@ownRank <> @numberOfPlayers)
      BEGIN
        --Get the neighbours
        SET @RankToAttack = (SELECT [dbo].[GetAvailableNeighbour](@warID, @ownRank, @rankByExperience))
        IF (@ownRank < @RankToAttack) --Is this a lower rank opponent

          BEGIN
            -- This is a lower rank available neighbour that was already attacked but less than 2 stars were taken
            GOTO END_OF_PROCEDURE
          END
      END

    IF (@attacksDone = 0) -- Not done first attack
      BEGIN
        SET @RankToAttack = (SELECT dbo.GetClosestFirstAttackOpponent(@warID, @ownRank, @rankByExperience))
        GOTO END_OF_PROCEDURE
      END

    SECOND_ATTACK:
    -- Must be second attack
    SET @RankToAttack = (SELECT dbo.GetClosestSecondAttackOpponent(@warID, @ownRank, @rankByExperience))
    IF (@RankToAttack = 0) --This player must still do one attack and
		-- no one seems left.. Lets try and see if their is a higher neighbour available
      BEGIN
        SET @RankToAttack = (SELECT [dbo].[GetAvailableNeighbour](@warID, @ownRank, @rankByExperience))
      END

    END_OF_PROCEDURE:
    RETURN @RankToAttack
  END
GO
/****** Object:  UserDefinedFunction [dbo].[WasTheirRankAttacked]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[WasTheirRankAttacked]
  (
    @WarID INT
    ,@TheirRank INT
    ,@rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    DECLARE @Result BIT, @count INT
    SET @count = (
      SELECT COUNT(*) FROM (SELECT [OurRank], [TheirRank]
      FROM [COC].[dbo].[View_WarProgress]
      WHERE warid = 1024) A WHERE A.TheirRank = @TheirRank
    )
    IF (@count > 0)
      BEGIN
        SET @Result = 1
      END
    ELSE
      BEGIN
        SET @Result = 0
      END
    RETURN @Result
  END


GO
/****** Object:  UserDefinedFunction [dbo].[WasTheirRankAttackedByOurRank]    Script Date: 2015/07/24 03:50:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[WasTheirRankAttackedByOurRank]
  (
    @WarID INT
    ,@OwnRank INT
    ,@TheirRank INT
    ,@rankByExperience BIT
  )
  RETURNS BIT
AS
  BEGIN
    DECLARE @Result BIT, @count INT
    SET @count = (
      SELECT COUNT(*) FROM (SELECT [OurRank], [TheirRank]
      FROM [COC].[dbo].[View_WarProgress]
      WHERE warid = @WarID) A WHERE A.OurRank = @OwnRank AND A.TheirRank = @TheirRank
    )
    IF (@count > 0)
      BEGIN
        SET @Result = 1
      END
    ELSE
      BEGIN
        SET @Result = 0
      END
    RETURN @Result
  END


GO
