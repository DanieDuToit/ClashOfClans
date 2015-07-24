USE [COC]
GO
/****** Object:  Table [dbo].[Attack]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attack](
  [AttackID] [int] IDENTITY(1,1) NOT NULL,
  [WarID] [int] NOT NULL,
  [OurAttack] [bit] NOT NULL,
  [FirstAttack] [bit] NOT NULL,
  [OurParticipantID] [int] NOT NULL,
  [TheirParticipantID] [int] NULL,
  [StarsTaken] [int] NULL,
  [TimeOfAttack] [datetime] NULL,
  [NextRecommendedAttack] [int] NULL,
  [BusyAttackingRank] [int] NULL,
  CONSTRAINT [PK_Attack] PRIMARY KEY CLUSTERED
    (
      [AttackID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Clan]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Clan](
  [ClanID] [int] IDENTITY(1,1) NOT NULL,
  [ClanName] [varchar](50) NOT NULL,
  [Password] [varchar](50) NULL,
  CONSTRAINT [PK_Clan] PRIMARY KEY CLUSTERED
    (
      [ClanID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[gcm_users]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[gcm_users](
  [id] [int] IDENTITY(1,1) NOT NULL,
  [gcm_regid] [text] NOT NULL,
  [PlayerID] [int] NOT NULL,
  [clanID] [int] NOT NULL,
  [game_name] [varchar](50) NOT NULL,
  [email] [varchar](255) NULL,
  [created_at] [datetime] NOT NULL,
  [Active] [bit] NULL,
  CONSTRAINT [PK_gcm_users] PRIMARY KEY CLUSTERED
    (
      [id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OurParticipant]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OurParticipant](
  [OurParticipantID] [int] IDENTITY(1,1) NOT NULL,
  [WarID] [int] NOT NULL,
  [PlayerID] [int] NOT NULL,
  [Experience] [int] NULL,
  [Rank] [int] NOT NULL,
  [TownHallLevel] [int] NOT NULL,
  [Active] [bit] NULL,
  [NextAttacker] [bit] NULL,
  CONSTRAINT [PK_OurParticipant] PRIMARY KEY CLUSTERED
    (
      [OurParticipantID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Player]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Player](
  [PlayerID] [int] IDENTITY(1,1) NOT NULL,
  [ClanID] [int] NOT NULL,
  [DeviceID] [varchar](50) NULL,
  [GameName] [varchar](50) NOT NULL,
  [RealName] [varchar](50) NOT NULL,
  [Active] [bit] NULL,
  CONSTRAINT [PK_Player] PRIMARY KEY CLUSTERED
    (
      [PlayerID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TheirParticipant]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TheirParticipant](
  [TheirParticipantID] [int] IDENTITY(1,1) NOT NULL,
  [WarID] [int] NOT NULL,
  [Experience] [int] NULL,
  [Rank] [int] NOT NULL,
  [TownHallLevel] [int] NOT NULL,
  [RankByExperience] [int] NULL,
  CONSTRAINT [PK_TheirParticipant] PRIMARY KEY CLUSTERED
    (
      [TheirParticipantID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Visits]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Visits](
  [id] [tinyint] NULL,
  [visits] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[War]    Script Date: 2015/07/24 10:50:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[War](
  [WarID] [int] IDENTITY(1,1) NOT NULL,
  [ClanId] [int] NOT NULL,
  [Date] [date] NOT NULL,
  [NumberOfParticipants] [int] NOT NULL,
  [WarsWeWon] [int] NULL,
  [WarsTheyWon] [int] NULL,
  [OurClanRank] [int] NULL,
  [TheirClanRank] [int] NULL,
  [OurTotalPoints] [int] NULL,
  [TheirTotalPoints] [int] NULL,
  [Active] [bit] NULL,
  CONSTRAINT [PK_War] PRIMARY KEY CLUSTERED
    (
      [WarID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Attack] ADD  CONSTRAINT [DF_Attack_BusyAttackingRank]  DEFAULT ((0)) FOR [BusyAttackingRank]
GO
ALTER TABLE [dbo].[gcm_users] ADD  CONSTRAINT [DF_gcm_users_created_at]  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[gcm_users] ADD  CONSTRAINT [DF_gcm_users_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[OurParticipant] ADD  CONSTRAINT [DF_OurParticipant_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[OurParticipant] ADD  CONSTRAINT [DF_OurParticipant_NextAttacker]  DEFAULT ((0)) FOR [NextAttacker]
GO
ALTER TABLE [dbo].[Attack]  WITH NOCHECK ADD  CONSTRAINT [FK_Attack_OurParticipant] FOREIGN KEY([OurParticipantID])
REFERENCES [dbo].[OurParticipant] ([OurParticipantID])
GO
ALTER TABLE [dbo].[Attack] NOCHECK CONSTRAINT [FK_Attack_OurParticipant]
GO
ALTER TABLE [dbo].[Attack]  WITH NOCHECK ADD  CONSTRAINT [FK_Attack_TheirParticipant] FOREIGN KEY([TheirParticipantID])
REFERENCES [dbo].[TheirParticipant] ([TheirParticipantID])
GO
ALTER TABLE [dbo].[Attack] NOCHECK CONSTRAINT [FK_Attack_TheirParticipant]
GO
ALTER TABLE [dbo].[gcm_users]  WITH CHECK ADD  CONSTRAINT [FK_gcm_users_Clan] FOREIGN KEY([clanID])
REFERENCES [dbo].[Clan] ([ClanID])
GO
ALTER TABLE [dbo].[gcm_users] CHECK CONSTRAINT [FK_gcm_users_Clan]
GO
ALTER TABLE [dbo].[gcm_users]  WITH CHECK ADD  CONSTRAINT [FK_gcm_users_Player] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[Player] ([PlayerID])
GO
ALTER TABLE [dbo].[gcm_users] CHECK CONSTRAINT [FK_gcm_users_Player]
GO
ALTER TABLE [dbo].[OurParticipant]  WITH CHECK ADD  CONSTRAINT [FK_OurParticipant_Player] FOREIGN KEY([PlayerID])
REFERENCES [dbo].[Player] ([PlayerID])
GO
ALTER TABLE [dbo].[OurParticipant] CHECK CONSTRAINT [FK_OurParticipant_Player]
GO
ALTER TABLE [dbo].[OurParticipant]  WITH CHECK ADD  CONSTRAINT [FK_OurParticipant_War] FOREIGN KEY([WarID])
REFERENCES [dbo].[War] ([WarID])
GO
ALTER TABLE [dbo].[OurParticipant] CHECK CONSTRAINT [FK_OurParticipant_War]
GO
ALTER TABLE [dbo].[Player]  WITH CHECK ADD  CONSTRAINT [FK_Player_Clan] FOREIGN KEY([ClanID])
REFERENCES [dbo].[Clan] ([ClanID])
GO
ALTER TABLE [dbo].[Player] CHECK CONSTRAINT [FK_Player_Clan]
GO
ALTER TABLE [dbo].[TheirParticipant]  WITH CHECK ADD  CONSTRAINT [FK_TheirParticipant_War] FOREIGN KEY([WarID])
REFERENCES [dbo].[War] ([WarID])
GO
ALTER TABLE [dbo].[TheirParticipant] CHECK CONSTRAINT [FK_TheirParticipant_War]
GO
ALTER TABLE [dbo].[War]  WITH CHECK ADD  CONSTRAINT [FK_War_Clan] FOREIGN KEY([ClanId])
REFERENCES [dbo].[Clan] ([ClanID])
GO
ALTER TABLE [dbo].[War] CHECK CONSTRAINT [FK_War_Clan]
GO
