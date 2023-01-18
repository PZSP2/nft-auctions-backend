-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'NORMAL_USER', 'SCHOOL');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('ACTIVE', 'EXPIRED', 'WON', 'CALL_FOR_CONFIRM', 'CONFIRMED', 'REJECTED');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "account_type" "Role" NOT NULL,
    "password" TEXT NOT NULL,
    "wallet_address" TEXT,
    "account_address" TEXT,
    "wallet_seed" TEXT,
    "balance" MONEY NOT NULL,

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
    "ledger_id" TEXT,
    "name" TEXT NOT NULL,
    "uri" TEXT NOT NULL,
    "description" TEXT,
    "minted_date" DATE,
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
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user1@mail.com', 'Willie_Noel', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rpnHcdWgSw9tN3cjy9rN33oeasAQUmaquf', 'sEdSiB1PC7Z32ch4z47kSGtrvindjru', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user2@mail.com', 'Mark_Ponce', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rNbtHbSPMbfLCTJWYiPwb63tsDY1K5yPcq', 'sEdVUZNmWKDdsWQz9WYLyp3PGMTLSGC', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user3@mail.com', 'Lashonda_Dodson', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rsGMYgYmxRCQAWWXLijLPM6UHEqKjVSY4d', 'sEd7huodvwjJBwMoBK5tQnvqWbDMGPW', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user4@mail.com', 'Mary_Overall', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rhLw1uHdjwWyKdYGDSYhCunYUs17LmMrtW', 'sEdTtTj4ZithtccPwRn3zsdrqq76cmF', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user5@mail.com', 'Cheryl_Frediani', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rU9iTnNY8iAJ7h69htSSA4fj79YtCQa5a7', 'sEdVdHAmE384uMGYHrieTVu7Txvxh3w', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user6@mail.com', 'William_Poehlman', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rDnQHRTWaXjE5vZgFfG87GjK2YfE7qyUoK', 'sEdVpjcsy8QeEks3QnCL8yFPrfiYoXM', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user7@mail.com', 'Melissa_Harris', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rK5sJFT7UJJFCcqN7SYoVKUiNZx6Ce7STd', 'sEdTrwTDCUocxSPu26LT5p1xiWdPwx6', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user8@mail.com', 'Frances_Austin', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rULBD2PQSLeu71M2rmoJMdu7gKvZCRJRY4', 'sEdV3SfmHBnDWLewmf9ybjW16pTM5tU', 1000);
INSERT INTO "User" (email, name, "account_type", password, wallet_address, wallet_seed, balance)  VALUES ('user9@mail.com', 'Daniel_Brown', 'NORMAL_USER', '$2a$10$PhxujKJ451/xHtpGKrMeMeDRV1r5TJCmAVVO5QAlcdlDmA/1cuQmK', 'rh71hVodnunH8nFJmJWLx3XbHb7TALcGVL', 'sEdSQuqeWrewF9zFH8nkwAAxy1VwK7V', 1000);
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school1@mail.com', 'St. John''s High School', 'Poland', 'Warsaw', '2122 w. el. segundo blvd', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school2@mail.com', 'St. Mary''s High School', 'Poland', 'Warsaw', 'California Ave 12', '+48 123 456 789');
INSERT INTO "School" (email, name, country, city, address, phone) VALUES ('school3@mail.com', 'Politechnika Warszawska', 'Poland', 'Warsaw', 'ul. Nowowiejska 15', '+48 123 456 789');
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmXyH7W5DrqKuPjXFjC9MC69Bv4EwtawsrQoZPSLbw521d', 'The Witch', 'Digital drawing of a Witch made on School''s Haloween competition by Greg', 1, 1, true, '000800007A55FD5D87618448283563AE38A3056190F5206144B17C9E00000003', now());
INSERT INTO "_NFTToTag" VALUES (1, 1);
INSERT INTO "_NFTToTag" VALUES (1, 2);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (1, 1, now() - interval '1 day 1 hour 2 minute', now() + interval '1 day 1 hour 2 minute', 73);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 1, 73);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 1, 89);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 1, 102);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmTtV26GTAwN9cukmDEKS3eNg7FFP9Z6R23mgGkAm8EU74', 'Doggy', 'Photo of Ann''s dog take during her second term as a part of the project Animals 2021', 8, 8, true, '00080000953296E0ECB78FE009F3CC0B00C89B13D22167592DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (2, 5);
INSERT INTO "_NFTToTag" VALUES (2, 7);
INSERT INTO "_NFTToTag" VALUES (2, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (2, 3, now() - interval '0 day 1 hour 25 minute', now() + interval '0 day 1 hour 25 minute', 235);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 2, 242);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 2, 254);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 2, 265);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmcGntFm23oyobzLvXT4bLET3QFQHUNXXqLc9gjoRFS5Yq', 'Giraffe', 'Image of a giraffe met by Carl during his second Africa''s trip', 4, 4, true, '00080000262D6583CD3B58771E0DC75A4ED7C9326A0A71112DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (3, 5);
INSERT INTO "_NFTToTag" VALUES (3, 7);
INSERT INTO "_NFTToTag" VALUES (3, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (3, 3, now() - interval '1 day 4 hour 4 minute', now() + interval '1 day 4 hour 4 minute', 607);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 3, 614);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 3, 623);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 3, 632);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmcsLiLHgi3bmFBWMg4DjyqGzLkbVZ5tqqnJvbEYCDAY9e', 'Fox & Astronaut', 'Beautiful drawing made for The Science Convetion happening at our school during November', 7, 7, true, '0008000018D7A462B1A28EFCE13A37A94BAAE828D21AC6872DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (4, 2);
INSERT INTO "_NFTToTag" VALUES (4, 9);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (4, 1, now() - interval '1 day 4 hour 34 minute', now() + interval '1 day 4 hour 34 minute', 193);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 4, 194);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 4, 212);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 4, 217);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('Qmeq8pFjkdVQPgWzUka6u3xam64CVYaYezFhi4FwcU8WWF', 'Fight', 'Poster made for School''s Halloween competition', 9, 9, true, '0008000018D7A462B1A28EFCE13A37A94BAAE828D21AC6870000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (5, 2);
INSERT INTO "_NFTToTag" VALUES (5, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (5, 3, now() - interval '0 day 5 hour 49 minute', now() + interval '0 day 5 hour 49 minute', 223);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 5, 227);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 5, 243);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 5, 248);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmSQ5ABRdLSrMi1V3re5FpFjkdXE6GJ66u6P35SQkQKZiN', 'Drawing of Giraffe', 'Drawing made as a part of the project Animals 2021', 7, 7, true, '00080000262D6583CD3B58771E0DC75A4ED7C9326A0A71115B974D9F00000004', now());
INSERT INTO "_NFTToTag" VALUES (6, 5);
INSERT INTO "_NFTToTag" VALUES (6, 2);
INSERT INTO "_NFTToTag" VALUES (6, 3);
INSERT INTO "_NFTToTag" VALUES (6, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (6, 3, now() - interval '1 day 0 hour 8 minute', now() + interval '1 day 0 hour 8 minute', 179);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 6, 187);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 6, 195);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 6, 200);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmUX1N8h73TieEu1yrTiJg3iLC72eXidqrw65ExVXf1vRJ', 'Rainy day', 'Photo shoot by Adam, won first prize in the Annual School Photography Contest', 6, 6, true, '000800007C49D0C2885A5515F17FE69544998AC36FC4FCB20000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (7, 7);
INSERT INTO "_NFTToTag" VALUES (7, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (7, 2, now() - interval '0 day 3 hour 4 minute', now() + interval '0 day 3 hour 4 minute', 749);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 7, 756);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 7, 763);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 7, 773);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmUg8XeHvh9zqzTkgVBowW5yX7Q5WPdjst9xXwi1afZ3n2', 'Future cities', 'How cities would like in the future, that''s the question we asked our students', 6, 6, true, '00080000953296E0ECB78FE009F3CC0B00C89B13D221675916E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (8, 2);
INSERT INTO "_NFTToTag" VALUES (8, 10);
INSERT INTO "_NFTToTag" VALUES (8, 6);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (8, 2, now() - interval '1 day 4 hour 32 minute', now() + interval '1 day 4 hour 32 minute', 631);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 8, 636);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 8, 642);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 8, 656);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmYbZcjcidR6zZa1nicB9vzZKR7mbtXo2vLFGBGGPXURGY', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 7, 7, true, '000800007A55FD5D87618448283563AE38A3056190F5206116E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (9, 2);
INSERT INTO "_NFTToTag" VALUES (9, 10);
INSERT INTO "_NFTToTag" VALUES (9, 6);
INSERT INTO "_NFTToTag" VALUES (9, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (9, 3, now() - interval '0 day 3 hour 53 minute', now() + interval '0 day 3 hour 53 minute', 501);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 9, 503);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 9, 512);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 9, 524);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmetZaJTvXBehrTembaSP3EMCWochSrB8HwJBFpvkPq7rc', 'Duck', 'Mickey mouse and Donald the Duck drawing made by our youngest student Amy', 1, 1, true, '00080000262D6583CD3B58771E0DC75A4ED7C9326A0A71118962EFA100000006', now());
INSERT INTO "_NFTToTag" VALUES (10, 11);
INSERT INTO "_NFTToTag" VALUES (10, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (10, 3, now() - interval '1 day 0 hour 3 minute', now() + interval '1 day 0 hour 3 minute', 58);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 10, 61);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 10, 73);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 10, 84);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmURz6hE1FxA4WLttLzKYeK7Gdx1gwpSroZwrUgzVsncNs', 'Portrait de la jeune fille en feu', 'Poster for a movie Portret of a Lady on Fire made during our first cinema event', 5, 5, true, '0008000018D7A462B1A28EFCE13A37A94BAAE828D21AC68744B17C9E00000003', now());
INSERT INTO "_NFTToTag" VALUES (11, 2);
INSERT INTO "_NFTToTag" VALUES (11, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (11, 3, now() - interval '0 day 4 hour 13 minute', now() + interval '0 day 4 hour 13 minute', 407);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 11, 407);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 11, 418);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 11, 432);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Mascots', 'Little mascots made by our talented student Kate', 8, 8, true, '000800007C49D0C2885A5515F17FE69544998AC36FC4FCB22DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (12, 2);
INSERT INTO "_NFTToTag" VALUES (12, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (12, 1, now() - interval '1 day 1 hour 33 minute', now() + interval '1 day 1 hour 33 minute', 624);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 12, 624);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 12, 639);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 12, 650);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('Qma7Uz6hWxNyyb9vCRT3bChBXebXv6iPUNYw81yDpaczB7', 'Woodland Fire', 'This art won third place at World Art Convention', 9, 9, true, '00080000953296E0ECB78FE009F3CC0B00C89B13D221675944B17C9E00000003', now());
INSERT INTO "_NFTToTag" VALUES (13, 2);
INSERT INTO "_NFTToTag" VALUES (13, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (13, 3, now() - interval '1 day 5 hour 11 minute', now() + interval '1 day 5 hour 11 minute', 647);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 13, 654);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 13, 660);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 13, 671);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Clouds', 'Clouds painted by our Art Teacher Mr. Wang', 6, 6, true, '00080000953296E0ECB78FE009F3CC0B00C89B13D22167590000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (14, 8);
INSERT INTO "_NFTToTag" VALUES (14, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (14, 2, now() - interval '0 day 5 hour 35 minute', now() + interval '0 day 5 hour 35 minute', 525);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 14, 526);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 14, 543);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 14, 553);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmXyd25mCjs7MgFR6AD5HPZRx7zWwtBgxWRZkVBt34bogp', 'Now esports', 'Design made for our school esport team competing in CSGO tournament last summer', 6, 6, true, '00080000248886AA98A882F21D7BBA2B9476076CC63BC5EE44B17C9E00000003', now());
INSERT INTO "_NFTToTag" VALUES (15, 2);
INSERT INTO "_NFTToTag" VALUES (15, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (15, 1, now() - interval '0 day 4 hour 30 minute', now() + interval '0 day 4 hour 30 minute', 796);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 15, 798);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 15, 811);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 15, 821);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmPwmDBoBXeDYb5ZZ1QYWQVc9BW5E5tB1DLbRcQ4qnyfdJ', 'Egypt''s inspiration', 'Drawing made by Carl during his second Africa''s trip', 8, 8, true, '0008000084769BE98E2696ABE5EEB40FD36AF74C7D95C25D44B17C9E00000003', now());
INSERT INTO "_NFTToTag" VALUES (16, 2);
INSERT INTO "_NFTToTag" VALUES (16, 3);
INSERT INTO "_NFTToTag" VALUES (16, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (16, 1, now() - interval '0 day 3 hour 53 minute', now() + interval '0 day 3 hour 53 minute', 318);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 16, 319);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 16, 333);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 16, 342);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmcnZwMAoqhft7ft5XivmdXXV1YCVL5c7FbZWxnoL4mk2h', 'FutureBot', 'Result of our project ''Humans Or Robots''', 3, 3, true, '00080000CD353E97CC3D9B33F2FE162CA332D8597F24BE7C16E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (17, 2);
INSERT INTO "_NFTToTag" VALUES (17, 10);
INSERT INTO "_NFTToTag" VALUES (17, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (17, 3, now() - interval '1 day 0 hour 38 minute', now() + interval '1 day 0 hour 38 minute', 782);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 17, 785);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 17, 799);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 17, 804);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmSWSya5debgSt2X7m4miRSpovKZ8joEsXNDd6pW1sPUuk', 'FuturoCrab', 'Result of our project ''Humans Or Robots''', 2, 2, true, '00080000248886AA98A882F21D7BBA2B9476076CC63BC5EE2DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (18, 2);
INSERT INTO "_NFTToTag" VALUES (18, 10);
INSERT INTO "_NFTToTag" VALUES (18, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (18, 2, now() - interval '0 day 4 hour 34 minute', now() + interval '0 day 4 hour 34 minute', 694);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 18, 699);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 18, 705);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 18, 714);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmQk5anuorUKQUfjUwCzKKhgJVJRds26AN4wxt5MHGwMMv', 'FuturoApe', 'Result of our project ''Humans Or Robots''', 2, 2, true, '00080000262D6583CD3B58771E0DC75A4ED7C9326A0A711116E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (19, 2);
INSERT INTO "_NFTToTag" VALUES (19, 10);
INSERT INTO "_NFTToTag" VALUES (19, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (19, 3, now() - interval '1 day 1 hour 26 minute', now() + interval '1 day 1 hour 26 minute', 451);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 19, 456);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 19, 465);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 19, 476);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmQQ8SPZNGt8ffa4MVPdtFuxLSYvGxrsTeASLGKp1KR85k', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 2, 2, true, '000800007A55FD5D87618448283563AE38A3056190F520610000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (20, 2);
INSERT INTO "_NFTToTag" VALUES (20, 10);
INSERT INTO "_NFTToTag" VALUES (20, 6);
INSERT INTO "_NFTToTag" VALUES (20, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (20, 3, now() - interval '1 day 0 hour 35 minute', now() + interval '1 day 0 hour 35 minute', 667);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 20, 667);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 20, 685);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 20, 694);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmNyPsTs2Hijehp3nC15hNrsyMVYWShrpxar35rdTnFH4s', 'Future cities green', 'How cities would like in the future, that''s the question we asked our students', 6, 6, true, '00080000CD353E97CC3D9B33F2FE162CA332D8597F24BE7C0000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (21, 2);
INSERT INTO "_NFTToTag" VALUES (21, 10);
INSERT INTO "_NFTToTag" VALUES (21, 6);
INSERT INTO "_NFTToTag" VALUES (21, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (21, 2, now() - interval '0 day 2 hour 20 minute', now() + interval '0 day 2 hour 20 minute', 463);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 21, 465);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 21, 483);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 21, 483);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmTno2wZ66MVzxAQhniUTJYfiLMkGp9Fc2mq4P4orrrWHb', 'FuturoButterfly', 'Result of our project ''Humans Or Robots''', 6, 6, true, '00080000248886AA98A882F21D7BBA2B9476076CC63BC5EE0000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (22, 2);
INSERT INTO "_NFTToTag" VALUES (22, 10);
INSERT INTO "_NFTToTag" VALUES (22, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (22, 1, now() - interval '1 day 4 hour 26 minute', now() + interval '1 day 4 hour 26 minute', 754);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 22, 756);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 22, 769);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 22, 781);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmchdXv5f5B7biEeLmPoHPLDvQiaVpcHxQP4EJXsqaJhC5', 'Owl', 'Owl (Owl) ''Owl''', 3, 3, true, '00080000262D6583CD3B58771E0DC75A4ED7C9326A0A7111727D1EA000000005', now());
INSERT INTO "_NFTToTag" VALUES (23, 2);
INSERT INTO "_NFTToTag" VALUES (23, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (23, 3, now() - interval '0 day 2 hour 31 minute', now() + interval '0 day 2 hour 31 minute', 177);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 23, 185);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 23, 187);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 23, 204);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmXNvT25zKS26MF1XE38L9CERYAodza1T37RtLxUrpmK4p', '25 years of our school', '25 anniversary of our school is coming...', 7, 7, true, '0008000084769BE98E2696ABE5EEB40FD36AF74C7D95C25D5B974D9F00000004', now());
INSERT INTO "_NFTToTag" VALUES (24, 2);
INSERT INTO "_NFTToTag" VALUES (24, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (24, 2, now() - interval '0 day 0 hour 15 minute', now() + interval '0 day 0 hour 15 minute', 758);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 24, 759);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 24, 778);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 24, 787);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmZ9TaHebXHhgv7UgQH6u2AQFQ1oWcV56F2cv6cpzFFP3x', 'Sparkles', 'What a great time of the year', 9, 9, true, '000800007A55FD5D87618448283563AE38A3056190F520615B974D9F00000004', now());
INSERT INTO "_NFTToTag" VALUES (25, 2);
INSERT INTO "_NFTToTag" VALUES (25, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (25, 2, now() - interval '1 day 0 hour 23 minute', now() + interval '1 day 0 hour 23 minute', 757);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 25, 763);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 25, 774);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 25, 781);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmXPn9xBxTFmwgGsePaVPTcjhtWqsHF3t2F7Unqx1xFPDm', 'Digital Teachers', 'Digital drawing of our music teacher Mr. Butterman', 3, 3, true, '0008000084769BE98E2696ABE5EEB40FD36AF74C7D95C25D16E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (26, 2);
INSERT INTO "_NFTToTag" VALUES (26, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (26, 1, now() - interval '1 day 3 hour 51 minute', now() + interval '1 day 3 hour 51 minute', 573);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 26, 575);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 26, 589);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 26, 603);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmbxXhUA5i8yriFRX5Jr19EBgWfkRTAXDZn4dUKuGvfpzu', 'London', 'Picture won second prize during our state''s photography contest last spring', 4, 4, true, '0008000018D7A462B1A28EFCE13A37A94BAAE828D21AC68716E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (27, 7);
INSERT INTO "_NFTToTag" VALUES (27, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (27, 3, now() - interval '1 day 1 hour 45 minute', now() + interval '1 day 1 hour 45 minute', 156);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 27, 159);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 27, 175);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 27, 178);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmSCn1MhB9LaXEhSfAvDsffxXV2P2zWFmMkzuKRRAX7uvy', 'Fox', 'Digital drawing of a fox, result of our project ''Humans Or Robots''', 1, 1, true, '0008000084769BE98E2696ABE5EEB40FD36AF74C7D95C25D2DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (28, 2);
INSERT INTO "_NFTToTag" VALUES (28, 5);
INSERT INTO "_NFTToTag" VALUES (28, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (28, 1, now() - interval '1 day 4 hour 37 minute', now() + interval '1 day 4 hour 37 minute', 517);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 28, 522);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (5, 28, 529);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 28, 542);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmZF1uWgXgufzgCCwTCQhgnKhTHGTChQLxZcmV6ujZXvVB', 'Digital teachers v2', 'Drawing of our English teachers', 7, 7, true, '00080000248886AA98A882F21D7BBA2B9476076CC63BC5EE16E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (29, 3);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (29, 1, now() - interval '0 day 1 hour 55 minute', now() + interval '0 day 1 hour 55 minute', 62);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 29, 62);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (8, 29, 82);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (3, 29, 86);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmWCzLBDReoZUK8k3Bpvz5A69f3x49tg1bDHVcr2U6KSTN', 'Cats on party', 'Who said only people can party...', 7, 7, true, '000800007C49D0C2885A5515F17FE69544998AC36FC4FCB216E5DA9C00000001', now());
INSERT INTO "_NFTToTag" VALUES (30, 2);
INSERT INTO "_NFTToTag" VALUES (30, 5);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (30, 2, now() - interval '0 day 4 hour 24 minute', now() + interval '0 day 4 hour 24 minute', 775);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 30, 782);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 30, 792);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 30, 799);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmXJvsrxMwnfc7Mk2AnDsC5ZDt48ERB1aXj4sMmcoPn5gQ', 'I''m on fire', 'It got super hot', 6, 6, true, '0008000084769BE98E2696ABE5EEB40FD36AF74C7D95C25D0000099B00000000', now());
INSERT INTO "_NFTToTag" VALUES (31, 2);
INSERT INTO "_NFTToTag" VALUES (31, 4);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (31, 2, now() - interval '0 day 3 hour 16 minute', now() + interval '0 day 3 hour 16 minute', 287);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (7, 31, 290);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 31, 300);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (6, 31, 309);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmYhEtMeVwDoLmPHCHwZjfq9Ps3QGizdCHgTGQoZdVtf8n', 'Horse', 'Horse (Horse) ''Horse''', 3, 3, true, '000800007A55FD5D87618448283563AE38A3056190F520612DCBAB9D00000002', now());
INSERT INTO "_NFTToTag" VALUES (32, 5);
INSERT INTO "_NFTToTag" VALUES (32, 8);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (32, 2, now() - interval '0 day 5 hour 3 minute', now() + interval '0 day 5 hour 3 minute', 511);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (4, 32, 521);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (2, 32, 526);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 32, 541);
INSERT INTO "NFT" (uri, name, description, issuer_id, owner_id, is_image, ledger_id, minted_date) VALUES ('QmZnHAyq5maVWvTBGoiQoqLNawXsGCreS4Ki9EDeii9hdt', 'HumanoBot', 'Result of our project ''Humans Or Robots''', 6, 6, true, '00080000262D6583CD3B58771E0DC75A4ED7C9326A0A711144B17C9E00000003', now());
INSERT INTO "_NFTToTag" VALUES (33, 2);
INSERT INTO "_NFTToTag" VALUES (33, 10);
INSERT INTO "_NFTToTag" VALUES (33, 1);
INSERT INTO "Auction" (nft_id, school_id, start_time, end_time, minimal_price) VALUES (33, 2, now() - interval '0 day 4 hour 39 minute', now() + interval '0 day 4 hour 39 minute', 477);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 33, 482);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (9, 33, 497);
INSERT INTO "Bid" (bidder_id, auction_id, bid_price) VALUES (1, 33, 506);
