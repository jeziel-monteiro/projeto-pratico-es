CREATE TABLE "reviews" (
  "id" TEXT NOT NULL,
  "vesselId" TEXT NOT NULL,
  "travelerId" TEXT NOT NULL,
  "rating" INTEGER NOT NULL,
  "comment" TEXT NOT NULL,
  "helpfulCount" INTEGER NOT NULL DEFAULT 0,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,

  CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "reviews_vesselId_travelerId_key" ON "reviews"("vesselId", "travelerId");
CREATE INDEX "reviews_vesselId_createdAt_idx" ON "reviews"("vesselId", "createdAt");

ALTER TABLE "reviews" ADD CONSTRAINT "reviews_vesselId_fkey"
  FOREIGN KEY ("vesselId") REFERENCES "vessels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "reviews" ADD CONSTRAINT "reviews_travelerId_fkey"
  FOREIGN KEY ("travelerId") REFERENCES "traveler_profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
