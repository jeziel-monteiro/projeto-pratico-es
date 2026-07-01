ALTER TABLE "bookings"
  ADD COLUMN "passengerName" TEXT NOT NULL DEFAULT '',
  ADD COLUMN "passengerCpf" TEXT NOT NULL DEFAULT '',
  ADD COLUMN "accommodationType" "AccommodationType" NOT NULL DEFAULT 'HAMMOCK';
