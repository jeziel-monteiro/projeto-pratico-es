CREATE TABLE "trip_stops" (
  "id" TEXT NOT NULL,
  "tripId" TEXT NOT NULL,
  "portId" TEXT NOT NULL,
  "stopOrder" INTEGER NOT NULL,
  "arrivalEstimateAt" TIMESTAMP(3),
  "departureEstimateAt" TIMESTAMP(3),
  "priceMultiplier" DECIMAL(5, 4) NOT NULL DEFAULT 0,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,

  CONSTRAINT "trip_stops_pkey" PRIMARY KEY ("id")
);

ALTER TABLE "bookings"
  ADD COLUMN "originStopId" TEXT,
  ADD COLUMN "destinationStopId" TEXT;

CREATE UNIQUE INDEX "trip_stops_tripId_stopOrder_key" ON "trip_stops"("tripId", "stopOrder");
CREATE UNIQUE INDEX "trip_stops_tripId_portId_key" ON "trip_stops"("tripId", "portId");
CREATE INDEX "trip_stops_portId_idx" ON "trip_stops"("portId");
CREATE INDEX "bookings_originStopId_destinationStopId_idx" ON "bookings"("originStopId", "destinationStopId");

ALTER TABLE "trip_stops"
  ADD CONSTRAINT "trip_stops_tripId_fkey"
  FOREIGN KEY ("tripId") REFERENCES "trips"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "trip_stops"
  ADD CONSTRAINT "trip_stops_portId_fkey"
  FOREIGN KEY ("portId") REFERENCES "ports"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "bookings"
  ADD CONSTRAINT "bookings_originStopId_fkey"
  FOREIGN KEY ("originStopId") REFERENCES "trip_stops"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "bookings"
  ADD CONSTRAINT "bookings_destinationStopId_fkey"
  FOREIGN KEY ("destinationStopId") REFERENCES "trip_stops"("id") ON DELETE SET NULL ON UPDATE CASCADE;
