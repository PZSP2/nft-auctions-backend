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



INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email1@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email2@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email3@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email4@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email5@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');
INSERT INTO "User" (email, password, wallet_address, wallet_seed) VALUES ('test_email6@test.com', 'test_password', 'rLp1vjjiHVVRLgLPCcktrGHXLq8RJWWAmk', 'sEd7dpWW9APCTD62t6rrW7oE6KVfeqv');

INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft', 'ipfs://uri', 'test_description', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft1', 'ipfs://uri', 'test_description', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft2', 'ipfs://uri', 'test_description', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft3', 'ipfs://uri', 'test_description', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft4', 'ipfs://uri', 'test_description', 1);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft5', 'ipfs://uri', 'test_description', 4);
INSERT INTO "NFT" (name, uri, description, issuer_id) VALUES ('test_nft6', 'ipfs://uri', 'test_description', 5);


INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (1, 100, '2021-12-01 00:00:00', '2021-12-15 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (2, 100, '2021-11-01 00:00:00', '2021-11-30 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (3, 200, '2021-10-01 00:00:00', '2021-10-02 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (1, 1, '2021-12-16 00:00:00', '2021-12-31 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (4, 200, '2021-12-20 00:00:00', '2021-12-29 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (5, 300, '2021-12-21 00:00:00', '2021-12-22 00:00:00');
INSERT INTO "Auction" (nft_id, minimal_price, start_time, end_time) VALUES (6, 500, '2021-12-22 00:00:00', '2021-12-29 00:00:00');


INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-01 00:00:00', 1, 2, 100);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-02 00:00:00', 1, 3, 120);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-03 00:00:00', 1, 4, 150);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-01 12:48:00', 1, 5, 160);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-03 00:00:00', 3, 2, 400);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-06 00:00:00', 3, 2, 400);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-02 00:00:00', 3, 2, 400);
INSERT INTO "Bid" (timestamp, auction_id, bidder_id, bid_price) VALUES ('2021-12-03 00:00:00', 3, 2, 400);