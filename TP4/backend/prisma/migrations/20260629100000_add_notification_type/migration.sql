ALTER TABLE "notifications" ADD COLUMN "type" TEXT NOT NULL DEFAULT 'system';

CREATE INDEX "notifications_sentAt_createdAt_idx" ON "notifications"("sentAt", "createdAt");
