import { Job, scheduleJob } from "node-schedule";
import { PrismaClient } from "@prisma/client";

export class ScheduleUtils {
  private jobs = new Map<number, Job>();
  public static getInstance(): ScheduleUtils {
    if (!ScheduleUtils.instance) {
      ScheduleUtils.instance = new ScheduleUtils();
    }
    return ScheduleUtils.instance;
  }

  private static instance: ScheduleUtils;

  // create a method to schedule a job
  public scheduleJob = (
    auctionId: number,
    date: Date,
    callback: () => void
  ): void => {
    const existingJob = this.jobs.get(auctionId);
    if (existingJob) {
      existingJob.reschedule(date.getTime());
    }
    const job = scheduleJob(date, () => {
      callback();
      this.jobs.delete(auctionId);
    });
    this.jobs.set(auctionId, job);
  };

  updateStatuses = async (): Promise<void> => {
    const prisma = new PrismaClient();
    await Promise.all(
      (
        await prisma.auction.findMany({
          include: {
            bids: true,
          },
        })
      ).map(async (auction) => {
        if (
          auction.status === "ACTIVE" &&
          auction.end_time.getTime() < Date.now()
        ) {
          await prisma.auction.update({
            where: { id: auction.id },
            data: { status: auction.bids.length > 0 ? "WON" : "EXPIRED" },
          });
        } else {
          this.scheduleJob(auction.id, auction.end_time, async () => {
            await prisma.auction.update({
              where: { id: auction.id },
              data: { status: auction.bids.length > 0 ? "WON" : "EXPIRED" },
            });
          });
        }
      })
    );
  };
}
