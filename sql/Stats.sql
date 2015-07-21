-- Our Attacks
SELECT A.*, B.*, C.*, D.*, E.*, F.*, G.*, H.* FROM 
	(SELECT COUNT(*) [Number of losts where our experience was less than or equals to theirs and the ranks was the same] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND StarsTaken < 2 AND OurExperience <= TheirExperience AND OurRank = TheirRank) OR 
		(OurAttack = 0 AND StarsTaken < 2 AND TheirExperience <= OurExperience AND OurRank = TheirRank)) A,
	(SELECT COUNT(*) [Number of losts where our experience was greater than or equals to theirs and the ranks was the same] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken < 2 AND OurExperience >= TheirExperience AND OurRank = TheirRank) OR
		(OurAttack = 0 AND  StarsTaken < 2 AND TheirExperience >= OurExperience AND OurRank = TheirRank)) B,
	(SELECT COUNT(*) [Number of wins where our experience was less than or equal to theirs and the ranks was the same] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken > 1 AND OurExperience <= TheirExperience AND OurRank = TheirRank) OR
		(OurAttack = 0 AND  StarsTaken > 1 AND TheirExperience <= OurExperience AND OurRank = TheirRank)) C,
	(SELECT COUNT(*) [Number of wins where our experience was greater than or equal to theirs and the ranks was the same] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken > 1 AND OurExperience >= TheirExperience AND OurRank = TheirRank) OR
		(OurAttack = 0 AND  StarsTaken > 1 AND TheirExperience >= OurExperience AND OurRank = TheirRank)) D,
	(SELECT COUNT(*) [Number of losts where the ranks was the same] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken < 2 AND OurRank = TheirRank) OR
		(OurAttack = 0 AND  StarsTaken < 2 AND OurRank = TheirRank)) E,
	(SELECT COUNT(*) [Number of losts where their ranks was one lower than ours] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken < 2 AND TheirRank = OurRank+1) OR 
		(OurAttack = 0 AND  StarsTaken < 2 AND TheirRank+1 = OurRank)) F,
	(SELECT COUNT(*) [Number of wins where the ranks was the same] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken > 1 AND OurRank = TheirRank) OR
		(OurAttack = 0 AND  StarsTaken > 1 AND OurRank = TheirRank)) G,
	(SELECT COUNT(*) [Number of wins where their ranks was one lower than ours] 
		FROM [dbo].[View_AttacksStats] 
		WHERE (OurAttack = 1 AND  StarsTaken > 1 AND TheirRank = OurRank+1) OR
		(OurAttack = 0 AND  StarsTaken > 1 AND TheirRank+1 = OurRank)) H
