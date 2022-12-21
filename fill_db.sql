-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
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
    "issuer_id" INTEGER NOT NULL,

    CONSTRAINT "NFT_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Auction" (
    "id" SERIAL NOT NULL,
    "nft_id" INTEGER NOT NULL,
    "minimal_price" DOUBLE PRECISION NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Auction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Bid" (
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "auction_id" INTEGER NOT NULL,
    "bidder_id" INTEGER NOT NULL,
    "bid_price" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "Bid_pkey" PRIMARY KEY ("timestamp","bidder_id","auction_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "NFT" ADD CONSTRAINT "NFT_issuer_id_fkey" FOREIGN KEY ("issuer_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auction" ADD CONSTRAINT "Auction_nft_id_fkey" FOREIGN KEY ("nft_id") REFERENCES "NFT"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_auction_id_fkey" FOREIGN KEY ("auction_id") REFERENCES "Auction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Bid" ADD CONSTRAINT "Bid_bidder_id_fkey" FOREIGN KEY ("bidder_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

create table public._prisma_migrations (
  id character varying(36) primary key not null,
  checksum character varying(64) not null,
  finished_at timestamp with time zone,
  migration_name character varying(255) not null,
  logs text,
  rolled_back_at timestamp with time zone,
  started_at timestamp with time zone not null default now(),
  applied_steps_count integer not null default 0
);


INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('kate_aa@mail.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('john_b@mail.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test@mail.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('Adam@Studios.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('school@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');

INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('Robot playing chess',  'QmV3WbGZDT9ZYbQk7pZk65vNpcrjr22fAgPvoqhQ5DYrfe', 'Digital drawing of Robot playing chess made by Anna from 2022 class', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('Robot playing chess',  'QmckcqdX1knwyEnTfuEbkW7KbPRusZJD8ETrSuTbZW3TZp', 'Little Mary made a drawing presenting our school', 3);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('Abstract painting',  'QmQF333ic72cxLhsF5Qm9oqVDnEYdrNMbW4C3rZesF46Hi', 'Abstract oil painting made by Adam class 2021', 2);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('Robot playing chess',  'QmNMuf2H75xkDBWzREURqJNNqhB4gLRGMsNKMtddJe8ujk', 'Digital drawing of computer made by Tom from 2022 class', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('Robot art',  'QmWDvMxGXoreLSKzbN2gdNm5nF2ZP9n7rGtNquMGEgXdQ8', 'Robot digital art', 1);

INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (1, 100, '2022-05-01 00:00:00', '2022-05-31 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (2, 200, '2022-12-01 00:00:00', '2022-12-31 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (3, 1, '2022-12-14 00:00:00', '2022-12-15 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (4, 12, '2022-07-01 00:00:00', '2022-12-31 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (5, 77, '2022-09-01 00:00:00', '2022-12-31 00:00:00');

INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-05-02 12:54:11', 1, 3, 200);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-05-20 13:00:11', 1, 2, 254);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-05-23 14:00:21', 1, 3, 512);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-05-30 15:15:00', 1, 2, 598);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-05-30 23:59:11', 1, 1, 1000);

INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-02 12:54:11', 2, 2, 201);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-22 12:00:11', 2, 1, 212);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-23 11:00:21', 2, 3, 999);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-11 16:15:00', 2, 4, 1000);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-29 22:59:11', 2, 5, 2000);

INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-14 12:54:11', 3, 2, 2);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-14 12:58:11', 3, 1, 3);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-12-14 13:00:21', 3, 3, 4);

INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-07-02 12:54:11', 4, 2, 13);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-07-22 12:00:11', 4, 1, 14);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-07-22 22:59:11', 4, 5, 17);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-07-23 11:00:21', 4, 3, 18);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-07-25 21:15:00', 4, 4, 25);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2022-07-30 23:59:11', 4, 1, 133);
