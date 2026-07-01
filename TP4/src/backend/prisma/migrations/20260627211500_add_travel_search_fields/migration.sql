-- AlterTable
ALTER TABLE "vessels"
ADD COLUMN "rating" DECIMAL(2,1),
ADD COLUMN "amenities" TEXT[] NOT NULL DEFAULT ARRAY[]::TEXT[];

-- CreateIndex
CREATE UNIQUE INDEX "ports_city_state_key" ON "ports"("city", "state");

-- CreateIndex
CREATE UNIQUE INDEX "vessel_photos_vesselId_url_key" ON "vessel_photos"("vesselId", "url");

-- CreateIndex
CREATE UNIQUE INDEX "trips_vesselId_originPortId_destinyPortId_departureAt_key" ON "trips"("vesselId", "originPortId", "destinyPortId", "departureAt");
