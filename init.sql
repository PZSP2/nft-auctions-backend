-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'NORMAL_USER', 'SCHOOL');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('ACTIVE', 'EXPIRED', 'WON', 'CALL_FOR_CONFIRM', 'CONFIRMED');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "accountType" "Role" NOT NULL,
    "password" TEXT NOT NULL,
    "wallet_address" TEXT,
    "account_address" TEXT,
    "wallet_seed" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NFT" (
    "id" SERIAL NOT NULL,
    "ledgerId" TEXT,
    "name" TEXT NOT NULL,
    "uri" TEXT NOT NULL,
    "description" TEXT,
    "is_image" BOOLEAN NOT NULL,
    "issuer_id" INTEGER NOT NULL,
    "owner_id" INTEGER NOT NULL,
    "transferred" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "NFT_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Auction" (
    "id" SERIAL NOT NULL,
    "nft_id" INTEGER NOT NULL,
    "school_id" INTEGER NOT NULL,
    "minimal_price" DOUBLE PRECISION NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,
    "status" "Status" NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT "Auction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bid" (
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "auction_id" INTEGER NOT NULL,
    "bidder_id" INTEGER NOT NULL,
    "bid_price" DOUBLE PRECISION NOT NULL,
    "is_won" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Bid_pkey" PRIMARY KEY ("timestamp","bidder_id","auction_id")
);

-- CreateTable
CREATE TABLE "School" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,

    CONSTRAINT "School_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "School_email_key" ON "School"("email");

-- AddForeignKey
ALTER TABLE "NFT" ADD CONSTRAINT "NFT_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NFT" ADD CONSTRAINT "NFT_issuer_id_fkey" FOREIGN KEY ("issuer_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auction" ADD CONSTRAINT "Auction_nft_id_fkey" FOREIGN KEY ("nft_id") REFERENCES "NFT"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auction" ADD CONSTRAINT "Auction_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "School"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_auction_id_fkey" FOREIGN KEY ("auction_id") REFERENCES "Auction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_bidder_id_fkey" FOREIGN KEY ("bidder_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user1@mail.com', 'Eileen_Wallace', 'NORMAL_USER', 'password', 'rpnHcdWgSw9tN3cjy9rN33oeasAQUmaquf', 'sEdSiB1PC7Z32ch4z47kSGtrvindjru');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user2@mail.com', 'James_Reed', 'NORMAL_USER', 'password', 'rNbtHbSPMbfLCTJWYiPwb63tsDY1K5yPcq', 'sEdVUZNmWKDdsWQz9WYLyp3PGMTLSGC');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user3@mail.com', 'Shannon_Thompson', 'NORMAL_USER', 'password', 'rsGMYgYmxRCQAWWXLijLPM6UHEqKjVSY4d', 'sEd7huodvwjJBwMoBK5tQnvqWbDMGPW');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user4@mail.com', 'Barbara_Otten', 'NORMAL_USER', 'password', 'rhLw1uHdjwWyKdYGDSYhCunYUs17LmMrtW', 'sEdTtTj4ZithtccPwRn3zsdrqq76cmF');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user5@mail.com', 'Joaquin_Leib', 'NORMAL_USER', 'password', 'rU9iTnNY8iAJ7h69htSSA4fj79YtCQa5a7', 'sEdVdHAmE384uMGYHrieTVu7Txvxh3w');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user6@mail.com', 'Jack_Haggerty', 'NORMAL_USER', 'password', 'rDnQHRTWaXjE5vZgFfG87GjK2YfE7qyUoK', 'sEdVpjcsy8QeEks3QnCL8yFPrfiYoXM');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user7@mail.com', 'Frances_Johnson', 'NORMAL_USER', 'password', 'rK5sJFT7UJJFCcqN7SYoVKUiNZx6Ce7STd', 'sEdTrwTDCUocxSPu26LT5p1xiWdPwx6');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user8@mail.com', 'Verla_Sexton', 'NORMAL_USER', 'password', 'rULBD2PQSLeu71M2rmoJMdu7gKvZCRJRY4', 'sEdV3SfmHBnDWLewmf9ybjW16pTM5tU');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user9@mail.com', 'Karen_Degeorge', 'NORMAL_USER', 'password', 'rh71hVodnunH8nFJmJWLx3XbHb7TALcGVL', 'sEdSQuqeWrewF9zFH8nkwAAxy1VwK7V');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school1@mail.com', 'St. John''s High School', 'Poland', 'Warsaw', '2122 w. el. segundo blvd', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school2@mail.com', 'St. Mary''s High School', 'Poland', 'Warsaw', 'California Ave 12', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school3@mail.com', 'Politechnika Warszawska', 'Poland', 'Warsaw', 'ul. Nowowiejska 15', '+48 123 456 789');
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXyH7W5DrqKuPjXFjC9MC69Bv4EwtawsrQoZPSLbw521d', 'The Witch', 'Digital drawing of a Witch made on School''s Haloween competition by Greg', 7, 7, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (1, 3, now() - interval '1 day 3 hour 11 minute', now() + interval '1 day 3 hour 11 minute', 490);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 1, 490);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 1, 501);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 1, 513);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmTtV26GTAwN9cukmDEKS3eNg7FFP9Z6R23mgGkAm8EU74', 'Doggy', 'Photo of Ann''s dog take during her second term as a part of the project Animals 2021', 9, 9, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (2, 3, now() - interval '1 day 0 hour 16 minute', now() + interval '1 day 0 hour 16 minute', 705);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 2, 710);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 2, 719);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 2, 731);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcGntFm23oyobzLvXT4bLET3QFQHUNXXqLc9gjoRFS5Yq', 'Giraffe', 'Image of a giraffe met by Carl during his second Africa''s trip', 3, 3, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (3, 3, now() - interval '1 day 4 hour 13 minute', now() + interval '1 day 4 hour 13 minute', 60);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 3, 67);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 3, 80);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 3, 90);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcsLiLHgi3bmFBWMg4DjyqGzLkbVZ5tqqnJvbEYCDAY9e', 'Fox & Astronaut', 'Beautiful drawing made for The Science Convetion happening at our school during November', 7, 7, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (4, 3, now() - interval '1 day 4 hour 56 minute', now() + interval '1 day 4 hour 56 minute', 401);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 4, 411);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 4, 416);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 4, 423);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('Qmeq8pFjkdVQPgWzUka6u3xam64CVYaYezFhi4FwcU8WWF', 'Fight', 'Poster made for School''s Halloween competition', 4, 4, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (5, 3, now() - interval '0 day 0 hour 19 minute', now() + interval '0 day 0 hour 19 minute', 523);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 5, 528);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 5, 542);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 5, 552);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSQ5ABRdLSrMi1V3re5FpFjkdXE6GJ66u6P35SQkQKZiN', 'Drawing of Giraffe', 'Drawing made as a part of the project Animals 2021', 7, 7, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (6, 3, now() - interval '0 day 3 hour 8 minute', now() + interval '0 day 3 hour 8 minute', 467);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 6, 470);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 6, 477);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 6, 488);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmUX1N8h73TieEu1yrTiJg3iLC72eXidqrw65ExVXf1vRJ', 'Rainy day', 'Photo shoot by Adam, won first prize in the Annual School Photography Contest ', 8, 8, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (7, 3, now() - interval '0 day 0 hour 6 minute', now() + interval '0 day 0 hour 6 minute', 397);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 7, 407);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 7, 408);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 7, 424);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmUg8XeHvh9zqzTkgVBowW5yX7Q5WPdjst9xXwi1afZ3n2', 'Future cities', 'How cities would like in the future, that''s the question we asked our students ', 6, 6, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (8, 3, now() - interval '0 day 4 hour 25 minute', now() + interval '0 day 4 hour 25 minute', 328);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 8, 328);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 8, 347);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 8, 349);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmYbZcjcidR6zZa1nicB9vzZKR7mbtXo2vLFGBGGPXURGY', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students ', 1, 1, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (9, 3, now() - interval '1 day 1 hour 2 minute', now() + interval '1 day 1 hour 2 minute', 678);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 9, 684);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 9, 693);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 9, 705);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmetZaJTvXBehrTembaSP3EMCWochSrB8HwJBFpvkPq7rc', 'Duck', 'Mickey mouse and Donald the Duck drawing made by our youngest student Amy', 5, 5, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (10, 3, now() - interval '0 day 5 hour 40 minute', now() + interval '0 day 5 hour 40 minute', 787);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 10, 788);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 10, 800);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 10, 809);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmURz6hE1FxA4WLttLzKYeK7Gdx1gwpSroZwrUgzVsncNs', 'Portrait de la jeune fille en feu', 'Poster for a movie Portret of a Lady on Fire made during our first cinema event', 5, 5, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (11, 3, now() - interval '1 day 1 hour 11 minute', now() + interval '1 day 1 hour 11 minute', 306);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 11, 316);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 11, 319);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 11, 332);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Mascots', 'Little mascots made by our talented student Kate', 4, 4, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (12, 3, now() - interval '0 day 5 hour 29 minute', now() + interval '0 day 5 hour 29 minute', 348);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 12, 349);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 12, 358);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 12, 370);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('Qma7Uz6hWxNyyb9vCRT3bChBXebXv6iPUNYw81yDpaczB7', 'Woodland Fire', 'This art won third place at World Art Convention', 7, 7, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (13, 3, now() - interval '1 day 0 hour 44 minute', now() + interval '1 day 0 hour 44 minute', 341);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 13, 348);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 13, 354);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 13, 366);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Clouds', 'Clouds painted by our Art Teacher Mr. Wang', 4, 4, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (14, 3, now() - interval '0 day 5 hour 47 minute', now() + interval '0 day 5 hour 47 minute', 177);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 14, 180);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 14, 191);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 14, 205);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXyd25mCjs7MgFR6AD5HPZRx7zWwtBgxWRZkVBt34bogp', 'Now esports', 'Design made for our school esport team competing in CSGO tournament last summer', 5, 5, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (15, 3, now() - interval '0 day 0 hour 29 minute', now() + interval '0 day 0 hour 29 minute', 621);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 15, 629);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 15, 638);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 15, 642);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmPwmDBoBXeDYb5ZZ1QYWQVc9BW5E5tB1DLbRcQ4qnyfdJ', 'Egypt''s inspiration', 'Drawing made by Carl during his second Africa''s trip', 1, 1, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (16, 3, now() - interval '0 day 3 hour 30 minute', now() + interval '0 day 3 hour 30 minute', 304);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 16, 309);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 16, 318);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 16, 332);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcnZwMAoqhft7ft5XivmdXXV1YCVL5c7FbZWxnoL4mk2h', 'FutureBot', 'Result of our project ''Humans Or Robots''', 9, 9, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (17, 3, now() - interval '1 day 4 hour 5 minute', now() + interval '1 day 4 hour 5 minute', 704);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 17, 712);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 17, 719);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 17, 731);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSWSya5debgSt2X7m4miRSpovKZ8joEsXNDd6pW1sPUuk', 'FuturoCrab', 'Result of our project ''Humans Or Robots''', 6, 6, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (18, 3, now() - interval '1 day 3 hour 21 minute', now() + interval '1 day 3 hour 21 minute', 642);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 18, 645);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 18, 662);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 18, 670);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmQk5anuorUKQUfjUwCzKKhgJVJRds26AN4wxt5MHGwMMv', 'FuturoApe', 'Result of our project ''Humans Or Robots''', 2, 2, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (19, 3, now() - interval '1 day 5 hour 41 minute', now() + interval '1 day 5 hour 41 minute', 164);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 19, 164);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 19, 174);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 19, 185);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmQQ8SPZNGt8ffa4MVPdtFuxLSYvGxrsTeASLGKp1KR85k', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 6, 6, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (20, 3, now() - interval '0 day 4 hour 35 minute', now() + interval '0 day 4 hour 35 minute', 279);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 20, 284);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 20, 298);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 20, 300);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students ', 8, 8, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (21, 3, now() - interval '1 day 0 hour 34 minute', now() + interval '1 day 0 hour 34 minute', 576);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 21, 581);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 21, 586);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 21, 603);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmTno2wZ66MVzxAQhniUTJYfiLMkGp9Fc2mq4P4orrrWHb', 'FuturoButterfly', 'Result of our project ''Humans Or Robots''', 3, 3, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (22, 3, now() - interval '1 day 5 hour 3 minute', now() + interval '1 day 5 hour 3 minute', 793);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 22, 801);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 22, 809);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 22, 816);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmchdXv5f5B7biEeLmPoHPLDvQiaVpcHxQP4EJXsqaJhC5', 'Owl', 'Owl (Owl) ''Owl''', 5, 5, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (23, 3, now() - interval '0 day 0 hour 36 minute', now() + interval '0 day 0 hour 36 minute', 158);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 23, 159);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 23, 170);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 23, 185);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXNvT25zKS26MF1XE38L9CERYAodza1T37RtLxUrpmK4p', '25 years of our school', '25 anniversary of our school is coming...', 5, 5, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (24, 3, now() - interval '1 day 2 hour 12 minute', now() + interval '1 day 2 hour 12 minute', 56);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 24, 56);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 24, 73);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 24, 83);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZ9TaHebXHhgv7UgQH6u2AQFQ1oWcV56F2cv6cpzFFP3x', 'Sparkles', 'What a great time of the year', 5, 5, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (25, 3, now() - interval '0 day 1 hour 24 minute', now() + interval '0 day 1 hour 24 minute', 115);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 25, 125);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 25, 125);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 25, 140);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXPn9xBxTFmwgGsePaVPTcjhtWqsHF3t2F7Unqx1xFPDm', 'Digital Teachers', 'Digital drawing of our music teacher Mr. Butterman', 8, 8, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (26, 3, now() - interval '0 day 0 hour 1 minute', now() + interval '0 day 0 hour 1 minute', 568);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 26, 570);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 26, 578);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 26, 597);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmbxXhUA5i8yriFRX5Jr19EBgWfkRTAXDZn4dUKuGvfpzu', 'London', 'Picture won second prize during our state''s photography contest last spring', 7, 7, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (27, 3, now() - interval '0 day 3 hour 17 minute', now() + interval '0 day 3 hour 17 minute', 429);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 27, 431);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 27, 446);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 27, 451);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSCn1MhB9LaXEhSfAvDsffxXV2P2zWFmMkzuKRRAX7uvy', 'Fox', 'Digital drawing of a fox, result of our project ''Humans Or Robots''', 7, 7, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (28, 3, now() - interval '0 day 1 hour 6 minute', now() + interval '0 day 1 hour 6 minute', 323);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 28, 331);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 28, 341);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 28, 349);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Digital teachers v2', 'Drawing of our English teachers', 8, 8, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (29, 3, now() - interval '0 day 5 hour 4 minute', now() + interval '0 day 5 hour 4 minute', 139);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 29, 142);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 29, 155);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 29, 168);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmWCzLBDReoZUK8k3Bpvz5A69f3x49tg1bDHVcr2U6KSTN', 'Cats on party', 'Who said only people can party...', 6, 6, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (30, 3, now() - interval '1 day 1 hour 49 minute', now() + interval '1 day 1 hour 49 minute', 130);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 30, 135);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 30, 140);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 30, 155);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXJvsrxMwnfc7Mk2AnDsC5ZDt48ERB1aXj4sMmcoPn5gQ', 'I''m on fire', 'It got super hot', 4, 4, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (31, 3, now() - interval '1 day 4 hour 40 minute', now() + interval '1 day 4 hour 40 minute', 788);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 31, 794);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 31, 806);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 31, 808);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmYhEtMeVwDoLmPHCHwZjfq9Ps3QGizdCHgTGQoZdVtf8n', 'Horse', 'Horse (Horse) ''Horse''', 8, 8, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (32, 3, now() - interval '1 day 1 hour 32 minute', now() + interval '1 day 1 hour 32 minute', 185);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 32, 190);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 32, 205);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 32, 205);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZnHAyq5maVWvTBGoiQoqLNawXsGCreS4Ki9EDeii9hdt', 'HumanoBot', 'Result of our project ''Humans Or Robots''', 1, 1, true);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (33, 3, now() - interval '1 day 4 hour 14 minute', now() + interval '1 day 4 hour 14 minute', 367);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 33, 370);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 33, 383);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 33, 389);
