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
CREATE TABLE "Tag" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
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

-- CreateTable
CREATE TABLE "_NFTToTag" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "School_email_key" ON "School"("email");

-- CreateIndex
CREATE UNIQUE INDEX "_NFTToTag_AB_unique" ON "_NFTToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_NFTToTag_B_index" ON "_NFTToTag"("B");

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

-- AddForeignKey
ALTER TABLE "_NFTToTag" ADD CONSTRAINT "_NFTToTag_A_fkey" FOREIGN KEY ("A") REFERENCES "NFT"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_NFTToTag" ADD CONSTRAINT "_NFTToTag_B_fkey" FOREIGN KEY ("B") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO "Tag" (name) VALUES ('Scary');
INSERT INTO "Tag" (name) VALUES ('Digital');
INSERT INTO "Tag" (name) VALUES ('Realistic');
INSERT INTO "Tag" (name) VALUES ('Abstract');
INSERT INTO "Tag" (name) VALUES ('Animal');
INSERT INTO "Tag" (name) VALUES ('Architecture');
INSERT INTO "Tag" (name) VALUES ('Photography');
INSERT INTO "Tag" (name) VALUES ('Nature');
INSERT INTO "Tag" (name) VALUES ('Science');
INSERT INTO "Tag" (name) VALUES ('Future');
INSERT INTO "Tag" (name) VALUES ('Fantasy');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user1@mail.com', 'Lori_Banick', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rpnHcdWgSw9tN3cjy9rN33oeasAQUmaquf', 'sEdSiB1PC7Z32ch4z47kSGtrvindjru');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user2@mail.com', 'Stephanie_Ogburn', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rNbtHbSPMbfLCTJWYiPwb63tsDY1K5yPcq', 'sEdVUZNmWKDdsWQz9WYLyp3PGMTLSGC');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user3@mail.com', 'Sonya_Girouard', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rsGMYgYmxRCQAWWXLijLPM6UHEqKjVSY4d', 'sEd7huodvwjJBwMoBK5tQnvqWbDMGPW');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user4@mail.com', 'Gary_Andersen', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rhLw1uHdjwWyKdYGDSYhCunYUs17LmMrtW', 'sEdTtTj4ZithtccPwRn3zsdrqq76cmF');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user5@mail.com', 'Robert_Southerly', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rU9iTnNY8iAJ7h69htSSA4fj79YtCQa5a7', 'sEdVdHAmE384uMGYHrieTVu7Txvxh3w');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user6@mail.com', 'Elizabeth_Padilla', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rDnQHRTWaXjE5vZgFfG87GjK2YfE7qyUoK', 'sEdVpjcsy8QeEks3QnCL8yFPrfiYoXM');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user7@mail.com', 'Sam_Lowery', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rK5sJFT7UJJFCcqN7SYoVKUiNZx6Ce7STd', 'sEdTrwTDCUocxSPu26LT5p1xiWdPwx6');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user8@mail.com', 'Julie_Winslow', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rULBD2PQSLeu71M2rmoJMdu7gKvZCRJRY4', 'sEdV3SfmHBnDWLewmf9ybjW16pTM5tU');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user9@mail.com', 'Missy_Buzzard', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rh71hVodnunH8nFJmJWLx3XbHb7TALcGVL', 'sEdSQuqeWrewF9zFH8nkwAAxy1VwK7V');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school1@mail.com', 'St. John''s High School', 'Poland', 'Warsaw', '2122 w. el. segundo blvd', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school2@mail.com', 'St. Mary''s High School', 'Poland', 'Warsaw', 'California Ave 12', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school3@mail.com', 'Politechnika Warszawska', 'Poland', 'Warsaw', 'ul. Nowowiejska 15', '+48 123 456 789');
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXyH7W5DrqKuPjXFjC9MC69Bv4EwtawsrQoZPSLbw521d', 'The Witch', 'Digital drawing of a Witch made on School''s Haloween competition by Greg', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (1, 1);
INSERT INTO "_NFTToTag" VALUES (1, 2);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (1, 3, now() - interval '1 day 0 hour 47 minute', now() + interval '1 day 0 hour 47 minute', 549);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 1, 556);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 1, 559);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 1, 571);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmTtV26GTAwN9cukmDEKS3eNg7FFP9Z6R23mgGkAm8EU74', 'Doggy', 'Photo of Ann''s dog take during her second term as a part of the project Animals 2021', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (2, 5);
INSERT INTO "_NFTToTag" VALUES (2, 7);
INSERT INTO "_NFTToTag" VALUES (2, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (2, 1, now() - interval '0 day 3 hour 56 minute', now() + interval '0 day 3 hour 56 minute', 214);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 2, 221);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 2, 234);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 2, 238);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcGntFm23oyobzLvXT4bLET3QFQHUNXXqLc9gjoRFS5Yq', 'Giraffe', 'Image of a giraffe met by Carl during his second Africa''s trip', 6, 6, true);
INSERT INTO "_NFTToTag" VALUES (3, 5);
INSERT INTO "_NFTToTag" VALUES (3, 7);
INSERT INTO "_NFTToTag" VALUES (3, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (3, 1, now() - interval '1 day 0 hour 34 minute', now() + interval '1 day 0 hour 34 minute', 544);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 3, 553);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 3, 563);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 3, 566);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcsLiLHgi3bmFBWMg4DjyqGzLkbVZ5tqqnJvbEYCDAY9e', 'Fox & Astronaut', 'Beautiful drawing made for The Science Convetion happening at our school during November', 6, 6, true);
INSERT INTO "_NFTToTag" VALUES (4, 2);
INSERT INTO "_NFTToTag" VALUES (4, 9);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (4, 3, now() - interval '1 day 5 hour 59 minute', now() + interval '1 day 5 hour 59 minute', 788);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 4, 793);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 4, 801);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 4, 817);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('Qmeq8pFjkdVQPgWzUka6u3xam64CVYaYezFhi4FwcU8WWF', 'Fight', 'Poster made for School''s Halloween competition', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (5, 2);
INSERT INTO "_NFTToTag" VALUES (5, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (5, 2, now() - interval '1 day 5 hour 58 minute', now() + interval '1 day 5 hour 58 minute', 482);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 5, 492);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 5, 502);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 5, 512);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSQ5ABRdLSrMi1V3re5FpFjkdXE6GJ66u6P35SQkQKZiN', 'Drawing of Giraffe', 'Drawing made as a part of the project Animals 2021', 8, 8, true);
INSERT INTO "_NFTToTag" VALUES (6, 5);
INSERT INTO "_NFTToTag" VALUES (6, 2);
INSERT INTO "_NFTToTag" VALUES (6, 3);
INSERT INTO "_NFTToTag" VALUES (6, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (6, 1, now() - interval '0 day 4 hour 7 minute', now() + interval '0 day 4 hour 7 minute', 632);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 6, 640);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 6, 652);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 6, 656);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmUX1N8h73TieEu1yrTiJg3iLC72eXidqrw65ExVXf1vRJ', 'Rainy day', 'Photo shoot by Adam, won first prize in the Annual School Photography Contest', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (7, 7);
INSERT INTO "_NFTToTag" VALUES (7, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (7, 1, now() - interval '1 day 0 hour 0 minute', now() + interval '1 day 0 hour 0 minute', 374);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 7, 375);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 7, 387);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 7, 403);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmUg8XeHvh9zqzTkgVBowW5yX7Q5WPdjst9xXwi1afZ3n2', 'Future cities', 'How cities would like in the future, that''s the question we asked our students', 9, 9, true);
INSERT INTO "_NFTToTag" VALUES (8, 2);
INSERT INTO "_NFTToTag" VALUES (8, 10);
INSERT INTO "_NFTToTag" VALUES (8, 6);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (8, 1, now() - interval '0 day 3 hour 41 minute', now() + interval '0 day 3 hour 41 minute', 301);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 8, 309);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 8, 314);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 8, 330);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmYbZcjcidR6zZa1nicB9vzZKR7mbtXo2vLFGBGGPXURGY', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (9, 2);
INSERT INTO "_NFTToTag" VALUES (9, 10);
INSERT INTO "_NFTToTag" VALUES (9, 6);
INSERT INTO "_NFTToTag" VALUES (9, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (9, 1, now() - interval '1 day 1 hour 39 minute', now() + interval '1 day 1 hour 39 minute', 441);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 9, 446);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 9, 459);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 9, 463);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmetZaJTvXBehrTembaSP3EMCWochSrB8HwJBFpvkPq7rc', 'Duck', 'Mickey mouse and Donald the Duck drawing made by our youngest student Amy', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (10, 11);
INSERT INTO "_NFTToTag" VALUES (10, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (10, 1, now() - interval '0 day 5 hour 57 minute', now() + interval '0 day 5 hour 57 minute', 98);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 10, 99);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 10, 113);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 10, 121);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmURz6hE1FxA4WLttLzKYeK7Gdx1gwpSroZwrUgzVsncNs', 'Portrait de la jeune fille en feu', 'Poster for a movie Portret of a Lady on Fire made during our first cinema event', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (11, 2);
INSERT INTO "_NFTToTag" VALUES (11, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (11, 2, now() - interval '0 day 0 hour 15 minute', now() + interval '0 day 0 hour 15 minute', 435);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 11, 436);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 11, 451);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 11, 464);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Mascots', 'Little mascots made by our talented student Kate', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (12, 2);
INSERT INTO "_NFTToTag" VALUES (12, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (12, 1, now() - interval '1 day 5 hour 19 minute', now() + interval '1 day 5 hour 19 minute', 384);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 12, 384);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 12, 399);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 12, 408);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('Qma7Uz6hWxNyyb9vCRT3bChBXebXv6iPUNYw81yDpaczB7', 'Woodland Fire', 'This art won third place at World Art Convention', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (13, 2);
INSERT INTO "_NFTToTag" VALUES (13, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (13, 3, now() - interval '1 day 5 hour 26 minute', now() + interval '1 day 5 hour 26 minute', 712);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 13, 720);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 13, 730);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 13, 737);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Clouds', 'Clouds painted by our Art Teacher Mr. Wang', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (14, 8);
INSERT INTO "_NFTToTag" VALUES (14, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (14, 2, now() - interval '0 day 4 hour 2 minute', now() + interval '0 day 4 hour 2 minute', 515);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 14, 523);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 14, 535);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 14, 539);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXyd25mCjs7MgFR6AD5HPZRx7zWwtBgxWRZkVBt34bogp', 'Now esports', 'Design made for our school esport team competing in CSGO tournament last summer', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (15, 2);
INSERT INTO "_NFTToTag" VALUES (15, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (15, 3, now() - interval '0 day 0 hour 23 minute', now() + interval '0 day 0 hour 23 minute', 595);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 15, 603);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 15, 613);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 15, 616);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmPwmDBoBXeDYb5ZZ1QYWQVc9BW5E5tB1DLbRcQ4qnyfdJ', 'Egypt''s inspiration', 'Drawing made by Carl during his second Africa''s trip', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (16, 2);
INSERT INTO "_NFTToTag" VALUES (16, 3);
INSERT INTO "_NFTToTag" VALUES (16, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (16, 2, now() - interval '1 day 1 hour 1 minute', now() + interval '1 day 1 hour 1 minute', 301);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 16, 311);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 16, 317);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 16, 328);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcnZwMAoqhft7ft5XivmdXXV1YCVL5c7FbZWxnoL4mk2h', 'FutureBot', 'Result of our project ''Humans Or Robots''', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (17, 2);
INSERT INTO "_NFTToTag" VALUES (17, 10);
INSERT INTO "_NFTToTag" VALUES (17, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (17, 2, now() - interval '1 day 2 hour 1 minute', now() + interval '1 day 2 hour 1 minute', 161);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 17, 161);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 17, 173);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 17, 185);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSWSya5debgSt2X7m4miRSpovKZ8joEsXNDd6pW1sPUuk', 'FuturoCrab', 'Result of our project ''Humans Or Robots''', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (18, 2);
INSERT INTO "_NFTToTag" VALUES (18, 10);
INSERT INTO "_NFTToTag" VALUES (18, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (18, 2, now() - interval '0 day 4 hour 32 minute', now() + interval '0 day 4 hour 32 minute', 106);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 18, 116);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 18, 123);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 18, 135);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmQk5anuorUKQUfjUwCzKKhgJVJRds26AN4wxt5MHGwMMv', 'FuturoApe', 'Result of our project ''Humans Or Robots''', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (19, 2);
INSERT INTO "_NFTToTag" VALUES (19, 10);
INSERT INTO "_NFTToTag" VALUES (19, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (19, 2, now() - interval '0 day 0 hour 19 minute', now() + interval '0 day 0 hour 19 minute', 117);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 19, 125);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 19, 134);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 19, 140);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmQQ8SPZNGt8ffa4MVPdtFuxLSYvGxrsTeASLGKp1KR85k', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (20, 2);
INSERT INTO "_NFTToTag" VALUES (20, 10);
INSERT INTO "_NFTToTag" VALUES (20, 6);
INSERT INTO "_NFTToTag" VALUES (20, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (20, 1, now() - interval '0 day 5 hour 45 minute', now() + interval '0 day 5 hour 45 minute', 123);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 20, 125);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 20, 140);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 20, 150);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (21, 2);
INSERT INTO "_NFTToTag" VALUES (21, 10);
INSERT INTO "_NFTToTag" VALUES (21, 6);
INSERT INTO "_NFTToTag" VALUES (21, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (21, 2, now() - interval '0 day 5 hour 10 minute', now() + interval '0 day 5 hour 10 minute', 558);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 21, 566);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 21, 569);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 21, 588);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmTno2wZ66MVzxAQhniUTJYfiLMkGp9Fc2mq4P4orrrWHb', 'FuturoButterfly', 'Result of our project ''Humans Or Robots''', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (22, 2);
INSERT INTO "_NFTToTag" VALUES (22, 10);
INSERT INTO "_NFTToTag" VALUES (22, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (22, 2, now() - interval '1 day 1 hour 5 minute', now() + interval '1 day 1 hour 5 minute', 334);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 22, 340);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 22, 347);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 22, 363);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmchdXv5f5B7biEeLmPoHPLDvQiaVpcHxQP4EJXsqaJhC5', 'Owl', 'Owl (Owl) ''Owl''', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (23, 2);
INSERT INTO "_NFTToTag" VALUES (23, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (23, 3, now() - interval '0 day 5 hour 36 minute', now() + interval '0 day 5 hour 36 minute', 322);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 23, 326);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 23, 334);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 23, 351);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXNvT25zKS26MF1XE38L9CERYAodza1T37RtLxUrpmK4p', '25 years of our school', '25 anniversary of our school is coming...', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (24, 2);
INSERT INTO "_NFTToTag" VALUES (24, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (24, 3, now() - interval '1 day 1 hour 14 minute', now() + interval '1 day 1 hour 14 minute', 413);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 24, 413);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 24, 429);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 24, 442);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZ9TaHebXHhgv7UgQH6u2AQFQ1oWcV56F2cv6cpzFFP3x', 'Sparkles', 'What a great time of the year', 6, 6, true);
INSERT INTO "_NFTToTag" VALUES (25, 2);
INSERT INTO "_NFTToTag" VALUES (25, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (25, 1, now() - interval '1 day 5 hour 55 minute', now() + interval '1 day 5 hour 55 minute', 590);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 25, 600);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 25, 605);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 25, 611);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXPn9xBxTFmwgGsePaVPTcjhtWqsHF3t2F7Unqx1xFPDm', 'Digital Teachers', 'Digital drawing of our music teacher Mr. Butterman', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (26, 2);
INSERT INTO "_NFTToTag" VALUES (26, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (26, 1, now() - interval '0 day 5 hour 13 minute', now() + interval '0 day 5 hour 13 minute', 411);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 26, 421);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 26, 425);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 26, 436);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmbxXhUA5i8yriFRX5Jr19EBgWfkRTAXDZn4dUKuGvfpzu', 'London', 'Picture won second prize during our state''s photography contest last spring', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (27, 7);
INSERT INTO "_NFTToTag" VALUES (27, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (27, 1, now() - interval '1 day 4 hour 34 minute', now() + interval '1 day 4 hour 34 minute', 672);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 27, 674);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 27, 683);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 27, 696);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSCn1MhB9LaXEhSfAvDsffxXV2P2zWFmMkzuKRRAX7uvy', 'Fox', 'Digital drawing of a fox, result of our project ''Humans Or Robots''', 9, 9, true);
INSERT INTO "_NFTToTag" VALUES (28, 2);
INSERT INTO "_NFTToTag" VALUES (28, 5);
INSERT INTO "_NFTToTag" VALUES (28, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (28, 3, now() - interval '0 day 3 hour 30 minute', now() + interval '0 day 3 hour 30 minute', 695);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 28, 699);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 28, 712);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 28, 715);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Digital teachers v2', 'Drawing of our English teachers', 8, 8, true);
INSERT INTO "_NFTToTag" VALUES (29, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (29, 2, now() - interval '1 day 1 hour 48 minute', now() + interval '1 day 1 hour 48 minute', 524);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 29, 530);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 29, 535);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 29, 552);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmWCzLBDReoZUK8k3Bpvz5A69f3x49tg1bDHVcr2U6KSTN', 'Cats on party', 'Who said only people can party...', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (30, 2);
INSERT INTO "_NFTToTag" VALUES (30, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (30, 3, now() - interval '0 day 3 hour 42 minute', now() + interval '0 day 3 hour 42 minute', 576);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 30, 579);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 30, 594);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 30, 606);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXJvsrxMwnfc7Mk2AnDsC5ZDt48ERB1aXj4sMmcoPn5gQ', 'I''m on fire', 'It got super hot', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (31, 2);
INSERT INTO "_NFTToTag" VALUES (31, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (31, 3, now() - interval '0 day 3 hour 40 minute', now() + interval '0 day 3 hour 40 minute', 327);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 31, 327);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 31, 337);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 31, 349);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmYhEtMeVwDoLmPHCHwZjfq9Ps3QGizdCHgTGQoZdVtf8n', 'Horse', 'Horse (Horse) ''Horse''', 9, 9, true);
INSERT INTO "_NFTToTag" VALUES (32, 5);
INSERT INTO "_NFTToTag" VALUES (32, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (32, 1, now() - interval '0 day 4 hour 52 minute', now() + interval '0 day 4 hour 52 minute', 578);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 32, 587);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 32, 590);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 32, 604);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZnHAyq5maVWvTBGoiQoqLNawXsGCreS4Ki9EDeii9hdt', 'HumanoBot', 'Result of our project ''Humans Or Robots''', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (33, 2);
INSERT INTO "_NFTToTag" VALUES (33, 10);
INSERT INTO "_NFTToTag" VALUES (33, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (33, 2, now() - interval '0 day 5 hour 47 minute', now() + interval '0 day 5 hour 47 minute', 455);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 33, 460);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 33, 466);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 33, 478);
INSERT INTO "Tag" (name) VALUES ('Scary');
INSERT INTO "Tag" (name) VALUES ('Digital');
INSERT INTO "Tag" (name) VALUES ('Realistic');
INSERT INTO "Tag" (name) VALUES ('Abstract');
INSERT INTO "Tag" (name) VALUES ('Animal');
INSERT INTO "Tag" (name) VALUES ('Architecture');
INSERT INTO "Tag" (name) VALUES ('Photography');
INSERT INTO "Tag" (name) VALUES ('Nature');
INSERT INTO "Tag" (name) VALUES ('Science');
INSERT INTO "Tag" (name) VALUES ('Future');
INSERT INTO "Tag" (name) VALUES ('Fantasy');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user1@mail.com', 'Lori_Banick', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rpnHcdWgSw9tN3cjy9rN33oeasAQUmaquf', 'sEdSiB1PC7Z32ch4z47kSGtrvindjru');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user2@mail.com', 'Stephanie_Ogburn', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rNbtHbSPMbfLCTJWYiPwb63tsDY1K5yPcq', 'sEdVUZNmWKDdsWQz9WYLyp3PGMTLSGC');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user3@mail.com', 'Sonya_Girouard', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rsGMYgYmxRCQAWWXLijLPM6UHEqKjVSY4d', 'sEd7huodvwjJBwMoBK5tQnvqWbDMGPW');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user4@mail.com', 'Gary_Andersen', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rhLw1uHdjwWyKdYGDSYhCunYUs17LmMrtW', 'sEdTtTj4ZithtccPwRn3zsdrqq76cmF');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user5@mail.com', 'Robert_Southerly', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rU9iTnNY8iAJ7h69htSSA4fj79YtCQa5a7', 'sEdVdHAmE384uMGYHrieTVu7Txvxh3w');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user6@mail.com', 'Elizabeth_Padilla', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rDnQHRTWaXjE5vZgFfG87GjK2YfE7qyUoK', 'sEdVpjcsy8QeEks3QnCL8yFPrfiYoXM');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user7@mail.com', 'Sam_Lowery', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rK5sJFT7UJJFCcqN7SYoVKUiNZx6Ce7STd', 'sEdTrwTDCUocxSPu26LT5p1xiWdPwx6');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user8@mail.com', 'Julie_Winslow', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rULBD2PQSLeu71M2rmoJMdu7gKvZCRJRY4', 'sEdV3SfmHBnDWLewmf9ybjW16pTM5tU');
INSERT INTO "User" (email, name, "accountType", password, wallet_address, wallet_seed)  VALUES ('user9@mail.com', 'Missy_Buzzard', 'NORMAL_USER', '$2a$10$TcrdvBfXmrD7m8H.UM4K0.nIOcq3IhSdwNMjJFOPsjzkD.a2xJOzS', 'rh71hVodnunH8nFJmJWLx3XbHb7TALcGVL', 'sEdSQuqeWrewF9zFH8nkwAAxy1VwK7V');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school1@mail.com', 'St. John''s High School', 'Poland', 'Warsaw', '2122 w. el. segundo blvd', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school2@mail.com', 'St. Mary''s High School', 'Poland', 'Warsaw', 'California Ave 12', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school3@mail.com', 'Politechnika Warszawska', 'Poland', 'Warsaw', 'ul. Nowowiejska 15', '+48 123 456 789');
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXyH7W5DrqKuPjXFjC9MC69Bv4EwtawsrQoZPSLbw521d', 'The Witch', 'Digital drawing of a Witch made on School''s Haloween competition by Greg', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (1, 1);
INSERT INTO "_NFTToTag" VALUES (1, 2);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (1, 3, now() - interval '1 day 0 hour 47 minute', now() + interval '1 day 0 hour 47 minute', 549);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 1, 556);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 1, 559);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 1, 571);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmTtV26GTAwN9cukmDEKS3eNg7FFP9Z6R23mgGkAm8EU74', 'Doggy', 'Photo of Ann''s dog take during her second term as a part of the project Animals 2021', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (2, 5);
INSERT INTO "_NFTToTag" VALUES (2, 7);
INSERT INTO "_NFTToTag" VALUES (2, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (2, 1, now() - interval '0 day 3 hour 56 minute', now() + interval '0 day 3 hour 56 minute', 214);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 2, 221);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 2, 234);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 2, 238);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcGntFm23oyobzLvXT4bLET3QFQHUNXXqLc9gjoRFS5Yq', 'Giraffe', 'Image of a giraffe met by Carl during his second Africa''s trip', 6, 6, true);
INSERT INTO "_NFTToTag" VALUES (3, 5);
INSERT INTO "_NFTToTag" VALUES (3, 7);
INSERT INTO "_NFTToTag" VALUES (3, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (3, 1, now() - interval '1 day 0 hour 34 minute', now() + interval '1 day 0 hour 34 minute', 544);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 3, 553);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 3, 563);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 3, 566);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcsLiLHgi3bmFBWMg4DjyqGzLkbVZ5tqqnJvbEYCDAY9e', 'Fox & Astronaut', 'Beautiful drawing made for The Science Convetion happening at our school during November', 6, 6, true);
INSERT INTO "_NFTToTag" VALUES (4, 2);
INSERT INTO "_NFTToTag" VALUES (4, 9);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (4, 3, now() - interval '1 day 5 hour 59 minute', now() + interval '1 day 5 hour 59 minute', 788);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 4, 793);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 4, 801);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 4, 817);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('Qmeq8pFjkdVQPgWzUka6u3xam64CVYaYezFhi4FwcU8WWF', 'Fight', 'Poster made for School''s Halloween competition', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (5, 2);
INSERT INTO "_NFTToTag" VALUES (5, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (5, 2, now() - interval '1 day 5 hour 58 minute', now() + interval '1 day 5 hour 58 minute', 482);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 5, 492);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 5, 502);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 5, 512);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSQ5ABRdLSrMi1V3re5FpFjkdXE6GJ66u6P35SQkQKZiN', 'Drawing of Giraffe', 'Drawing made as a part of the project Animals 2021', 8, 8, true);
INSERT INTO "_NFTToTag" VALUES (6, 5);
INSERT INTO "_NFTToTag" VALUES (6, 2);
INSERT INTO "_NFTToTag" VALUES (6, 3);
INSERT INTO "_NFTToTag" VALUES (6, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (6, 1, now() - interval '0 day 4 hour 7 minute', now() + interval '0 day 4 hour 7 minute', 632);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 6, 640);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 6, 652);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 6, 656);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmUX1N8h73TieEu1yrTiJg3iLC72eXidqrw65ExVXf1vRJ', 'Rainy day', 'Photo shoot by Adam, won first prize in the Annual School Photography Contest', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (7, 7);
INSERT INTO "_NFTToTag" VALUES (7, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (7, 1, now() - interval '1 day 0 hour 0 minute', now() + interval '1 day 0 hour 0 minute', 374);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 7, 375);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 7, 387);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 7, 403);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmUg8XeHvh9zqzTkgVBowW5yX7Q5WPdjst9xXwi1afZ3n2', 'Future cities', 'How cities would like in the future, that''s the question we asked our students', 9, 9, true);
INSERT INTO "_NFTToTag" VALUES (8, 2);
INSERT INTO "_NFTToTag" VALUES (8, 10);
INSERT INTO "_NFTToTag" VALUES (8, 6);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (8, 1, now() - interval '0 day 3 hour 41 minute', now() + interval '0 day 3 hour 41 minute', 301);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 8, 309);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 8, 314);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 8, 330);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmYbZcjcidR6zZa1nicB9vzZKR7mbtXo2vLFGBGGPXURGY', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (9, 2);
INSERT INTO "_NFTToTag" VALUES (9, 10);
INSERT INTO "_NFTToTag" VALUES (9, 6);
INSERT INTO "_NFTToTag" VALUES (9, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (9, 1, now() - interval '1 day 1 hour 39 minute', now() + interval '1 day 1 hour 39 minute', 441);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 9, 446);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 9, 459);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 9, 463);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmetZaJTvXBehrTembaSP3EMCWochSrB8HwJBFpvkPq7rc', 'Duck', 'Mickey mouse and Donald the Duck drawing made by our youngest student Amy', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (10, 11);
INSERT INTO "_NFTToTag" VALUES (10, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (10, 1, now() - interval '0 day 5 hour 57 minute', now() + interval '0 day 5 hour 57 minute', 98);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 10, 99);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 10, 113);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 10, 121);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmURz6hE1FxA4WLttLzKYeK7Gdx1gwpSroZwrUgzVsncNs', 'Portrait de la jeune fille en feu', 'Poster for a movie Portret of a Lady on Fire made during our first cinema event', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (11, 2);
INSERT INTO "_NFTToTag" VALUES (11, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (11, 2, now() - interval '0 day 0 hour 15 minute', now() + interval '0 day 0 hour 15 minute', 435);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 11, 436);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 11, 451);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 11, 464);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Mascots', 'Little mascots made by our talented student Kate', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (12, 2);
INSERT INTO "_NFTToTag" VALUES (12, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (12, 1, now() - interval '1 day 5 hour 19 minute', now() + interval '1 day 5 hour 19 minute', 384);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 12, 384);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 12, 399);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 12, 408);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('Qma7Uz6hWxNyyb9vCRT3bChBXebXv6iPUNYw81yDpaczB7', 'Woodland Fire', 'This art won third place at World Art Convention', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (13, 2);
INSERT INTO "_NFTToTag" VALUES (13, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (13, 3, now() - interval '1 day 5 hour 26 minute', now() + interval '1 day 5 hour 26 minute', 712);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 13, 720);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 13, 730);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 13, 737);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Clouds', 'Clouds painted by our Art Teacher Mr. Wang', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (14, 8);
INSERT INTO "_NFTToTag" VALUES (14, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (14, 2, now() - interval '0 day 4 hour 2 minute', now() + interval '0 day 4 hour 2 minute', 515);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 14, 523);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 14, 535);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 14, 539);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXyd25mCjs7MgFR6AD5HPZRx7zWwtBgxWRZkVBt34bogp', 'Now esports', 'Design made for our school esport team competing in CSGO tournament last summer', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (15, 2);
INSERT INTO "_NFTToTag" VALUES (15, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (15, 3, now() - interval '0 day 0 hour 23 minute', now() + interval '0 day 0 hour 23 minute', 595);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 15, 603);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 15, 613);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 15, 616);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmPwmDBoBXeDYb5ZZ1QYWQVc9BW5E5tB1DLbRcQ4qnyfdJ', 'Egypt''s inspiration', 'Drawing made by Carl during his second Africa''s trip', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (16, 2);
INSERT INTO "_NFTToTag" VALUES (16, 3);
INSERT INTO "_NFTToTag" VALUES (16, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (16, 2, now() - interval '1 day 1 hour 1 minute', now() + interval '1 day 1 hour 1 minute', 301);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 16, 311);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 16, 317);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 16, 328);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmcnZwMAoqhft7ft5XivmdXXV1YCVL5c7FbZWxnoL4mk2h', 'FutureBot', 'Result of our project ''Humans Or Robots''', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (17, 2);
INSERT INTO "_NFTToTag" VALUES (17, 10);
INSERT INTO "_NFTToTag" VALUES (17, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (17, 2, now() - interval '1 day 2 hour 1 minute', now() + interval '1 day 2 hour 1 minute', 161);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 17, 161);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 17, 173);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 17, 185);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSWSya5debgSt2X7m4miRSpovKZ8joEsXNDd6pW1sPUuk', 'FuturoCrab', 'Result of our project ''Humans Or Robots''', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (18, 2);
INSERT INTO "_NFTToTag" VALUES (18, 10);
INSERT INTO "_NFTToTag" VALUES (18, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (18, 2, now() - interval '0 day 4 hour 32 minute', now() + interval '0 day 4 hour 32 minute', 106);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 18, 116);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 18, 123);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 18, 135);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmQk5anuorUKQUfjUwCzKKhgJVJRds26AN4wxt5MHGwMMv', 'FuturoApe', 'Result of our project ''Humans Or Robots''', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (19, 2);
INSERT INTO "_NFTToTag" VALUES (19, 10);
INSERT INTO "_NFTToTag" VALUES (19, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (19, 2, now() - interval '0 day 0 hour 19 minute', now() + interval '0 day 0 hour 19 minute', 117);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 19, 125);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 19, 134);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 19, 140);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmQQ8SPZNGt8ffa4MVPdtFuxLSYvGxrsTeASLGKp1KR85k', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (20, 2);
INSERT INTO "_NFTToTag" VALUES (20, 10);
INSERT INTO "_NFTToTag" VALUES (20, 6);
INSERT INTO "_NFTToTag" VALUES (20, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (20, 1, now() - interval '0 day 5 hour 45 minute', now() + interval '0 day 5 hour 45 minute', 123);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 20, 125);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 20, 140);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 20, 150);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (21, 2);
INSERT INTO "_NFTToTag" VALUES (21, 10);
INSERT INTO "_NFTToTag" VALUES (21, 6);
INSERT INTO "_NFTToTag" VALUES (21, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (21, 2, now() - interval '0 day 5 hour 10 minute', now() + interval '0 day 5 hour 10 minute', 558);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 21, 566);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 21, 569);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 21, 588);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmTno2wZ66MVzxAQhniUTJYfiLMkGp9Fc2mq4P4orrrWHb', 'FuturoButterfly', 'Result of our project ''Humans Or Robots''', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (22, 2);
INSERT INTO "_NFTToTag" VALUES (22, 10);
INSERT INTO "_NFTToTag" VALUES (22, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (22, 2, now() - interval '1 day 1 hour 5 minute', now() + interval '1 day 1 hour 5 minute', 334);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 22, 340);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 22, 347);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 22, 363);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmchdXv5f5B7biEeLmPoHPLDvQiaVpcHxQP4EJXsqaJhC5', 'Owl', 'Owl (Owl) ''Owl''', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (23, 2);
INSERT INTO "_NFTToTag" VALUES (23, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (23, 3, now() - interval '0 day 5 hour 36 minute', now() + interval '0 day 5 hour 36 minute', 322);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 23, 326);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 23, 334);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 23, 351);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXNvT25zKS26MF1XE38L9CERYAodza1T37RtLxUrpmK4p', '25 years of our school', '25 anniversary of our school is coming...', 3, 3, true);
INSERT INTO "_NFTToTag" VALUES (24, 2);
INSERT INTO "_NFTToTag" VALUES (24, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (24, 3, now() - interval '1 day 1 hour 14 minute', now() + interval '1 day 1 hour 14 minute', 413);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 24, 413);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 24, 429);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 24, 442);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZ9TaHebXHhgv7UgQH6u2AQFQ1oWcV56F2cv6cpzFFP3x', 'Sparkles', 'What a great time of the year', 6, 6, true);
INSERT INTO "_NFTToTag" VALUES (25, 2);
INSERT INTO "_NFTToTag" VALUES (25, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (25, 1, now() - interval '1 day 5 hour 55 minute', now() + interval '1 day 5 hour 55 minute', 590);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 25, 600);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 25, 605);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 25, 611);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXPn9xBxTFmwgGsePaVPTcjhtWqsHF3t2F7Unqx1xFPDm', 'Digital Teachers', 'Digital drawing of our music teacher Mr. Butterman', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (26, 2);
INSERT INTO "_NFTToTag" VALUES (26, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (26, 1, now() - interval '0 day 5 hour 13 minute', now() + interval '0 day 5 hour 13 minute', 411);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 26, 421);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 26, 425);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 26, 436);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmbxXhUA5i8yriFRX5Jr19EBgWfkRTAXDZn4dUKuGvfpzu', 'London', 'Picture won second prize during our state''s photography contest last spring', 5, 5, true);
INSERT INTO "_NFTToTag" VALUES (27, 7);
INSERT INTO "_NFTToTag" VALUES (27, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (27, 1, now() - interval '1 day 4 hour 34 minute', now() + interval '1 day 4 hour 34 minute', 672);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 27, 674);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 27, 683);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 27, 696);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmSCn1MhB9LaXEhSfAvDsffxXV2P2zWFmMkzuKRRAX7uvy', 'Fox', 'Digital drawing of a fox, result of our project ''Humans Or Robots''', 9, 9, true);
INSERT INTO "_NFTToTag" VALUES (28, 2);
INSERT INTO "_NFTToTag" VALUES (28, 5);
INSERT INTO "_NFTToTag" VALUES (28, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (28, 3, now() - interval '0 day 3 hour 30 minute', now() + interval '0 day 3 hour 30 minute', 695);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 28, 699);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 28, 712);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 28, 715);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Digital teachers v2', 'Drawing of our English teachers', 8, 8, true);
INSERT INTO "_NFTToTag" VALUES (29, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (29, 2, now() - interval '1 day 1 hour 48 minute', now() + interval '1 day 1 hour 48 minute', 524);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 29, 530);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 29, 535);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 29, 552);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmWCzLBDReoZUK8k3Bpvz5A69f3x49tg1bDHVcr2U6KSTN', 'Cats on party', 'Who said only people can party...', 2, 2, true);
INSERT INTO "_NFTToTag" VALUES (30, 2);
INSERT INTO "_NFTToTag" VALUES (30, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (30, 3, now() - interval '0 day 3 hour 42 minute', now() + interval '0 day 3 hour 42 minute', 576);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 30, 579);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 30, 594);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 30, 606);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmXJvsrxMwnfc7Mk2AnDsC5ZDt48ERB1aXj4sMmcoPn5gQ', 'I''m on fire', 'It got super hot', 1, 1, true);
INSERT INTO "_NFTToTag" VALUES (31, 2);
INSERT INTO "_NFTToTag" VALUES (31, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (31, 3, now() - interval '0 day 3 hour 40 minute', now() + interval '0 day 3 hour 40 minute', 327);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 31, 327);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 31, 337);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 31, 349);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmYhEtMeVwDoLmPHCHwZjfq9Ps3QGizdCHgTGQoZdVtf8n', 'Horse', 'Horse (Horse) ''Horse''', 9, 9, true);
INSERT INTO "_NFTToTag" VALUES (32, 5);
INSERT INTO "_NFTToTag" VALUES (32, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (32, 1, now() - interval '0 day 4 hour 52 minute', now() + interval '0 day 4 hour 52 minute', 578);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 32, 587);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 32, 590);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 32, 604);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image) VALUES ('QmZnHAyq5maVWvTBGoiQoqLNawXsGCreS4Ki9EDeii9hdt', 'HumanoBot', 'Result of our project ''Humans Or Robots''', 4, 4, true);
INSERT INTO "_NFTToTag" VALUES (33, 2);
INSERT INTO "_NFTToTag" VALUES (33, 10);
INSERT INTO "_NFTToTag" VALUES (33, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (33, 2, now() - interval '0 day 5 hour 47 minute', now() + interval '0 day 5 hour 47 minute', 455);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 33, 460);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 33, 466);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 33, 478);
