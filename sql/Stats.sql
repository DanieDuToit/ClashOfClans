(SELECT COUNT(*) AS [Number of wins where our experience was equal to theirs and our rank was equal to theirs]
 FROM [dbo].[View_AttacksStats]
 WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience = TheirExperience AND OurRank = TheirRank) OR
       (OurAttack = 0 AND StarsTaken > 1 AND TheirExperience = OurExperience AND TheirRank = OurRank))
(SELECT COUNT(*) AS [Number of wins where our experience was greater than theirs and the ranks was the same]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience > TheirExperience AND OurRank = TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience > OurExperience AND OurRank = TheirRank))
(SELECT COUNT(*) AS [Number of wins where our experience was less than theirs and the ranks was the same]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience < TheirExperience AND OurRank = TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience < OurExperience AND OurRank = TheirRank))
(SELECT COUNT(*) AS [Number of wins where our experience equals theirs and our rank is greater than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience = TheirExperience AND OurRank > TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience  = OurExperience AND TheirRank > OurRank))
(SELECT COUNT(*) AS [Number of wins where our experience equals theirs and our rank is less than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience = TheirExperience AND OurRank < TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND OurExperience = TheirExperience AND TheirRank < OurRank))
(SELECT COUNT(*) AS [Number of wins where our experience is greater than theirs and our rank is greater than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience > TheirExperience AND OurRank > TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience > OurExperience AND TheirRank > OurRank ))
(SELECT COUNT(*) AS [Number of wins where our experience is less than theirs and our rank is less than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience < TheirExperience AND OurRank < TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience < OurExperience AND TheirRank < OurRank ))
(SELECT COUNT(*) AS [Number of wins where our experience is less than theirs and our rank is greater than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience < TheirExperience AND OurRank > TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience < OurExperience AND TheirRank > OurRank ))
(SELECT COUNT(*) AS [Number of wins where our experience is less than theirs and our rank is less than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken > 1 AND OurExperience < TheirExperience AND OurRank < TheirRank) OR
(OurAttack = 0 AND StarsTaken > 1 AND TheirExperience < OurExperience AND TheirRank < OurRank ))

----- LOSTS ------------
SELECT '----------------- LOSTS ------------------'
( SELECT COUNT(*) AS [Number of lost where our experience was equal to theirs and our rank was equal to theirs]
  FROM [dbo].[View_AttacksStats]
  WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience = TheirExperience AND OurRank = TheirRank) OR
        (OurAttack = 0 AND StarsTaken < 1 AND TheirExperience = OurExperience AND TheirRank = OurRank))
(SELECT COUNT(*) AS [Number of losts where our experience was greater than theirs and the ranks was the same]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience > TheirExperience AND OurRank = TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience > OurExperience AND OurRank = TheirRank))
(SELECT COUNT(*) AS [Number of losts where our experience was less than theirs and the ranks was the same]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 0 AND StarsTaken < 2 AND OurExperience < TheirExperience AND OurRank = TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience < OurExperience AND OurRank = TheirRank))
(SELECT COUNT(*) AS [Number of losts where our experience equals theirs and our rank is greater than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience = TheirExperience AND OurRank > TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience  = OurExperience AND TheirRank > OurRank))
(SELECT COUNT(*) AS [Number of lost where our experience equals theirs and our rank is less than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience = TheirExperience AND OurRank < TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND OurExperience = TheirExperience AND TheirRank < OurRank))
(SELECT COUNT(*) AS [Number of losts where our experience is greater than theirs and our rank is greater than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience > TheirExperience AND OurRank > TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience > OurExperience AND TheirRank > OurRank ))
(SELECT COUNT(*) AS [Number of losts where our experience is less than theirs and our rank is less than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience < TheirExperience AND OurRank < TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience < OurExperience AND TheirRank < OurRank ))
(SELECT COUNT(*) AS [Number of losts where our experience is less than theirs and our rank is greater than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience < TheirExperience AND OurRank > TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience < OurExperience AND TheirRank > OurRank ))
(SELECT COUNT(*) AS [Number of losts where our experience is less than theirs and our rank is less than theirs]
FROM [dbo].[View_AttacksStats]
WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience < TheirExperience AND OurRank < TheirRank) OR
(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience < OurExperience AND TheirRank < OurRank ))
