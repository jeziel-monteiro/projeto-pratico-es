const VALID_PLACE_PATTERN = /^[\p{L}\s'./-]+$/u;

export function isValidTripSearchPlace(value: string) {
  return VALID_PLACE_PATTERN.test(value.trim());
}

export function parseTripSearchDate(value: string) {
  const normalizedValue = value.trim();
  const parts = normalizedValue.includes('-')
    ? normalizedValue.split('-').map(Number)
    : normalizedValue.split('/').reverse().map(Number);

  if (parts.length !== 3) return null;

  const [year, month, day] = parts;
  if (!year || !month || !day) return null;

  const date = new Date(Date.UTC(year, month - 1, day, 0, 0, 0));
  if (
    date.getUTCFullYear() !== year ||
    date.getUTCMonth() !== month - 1 ||
    date.getUTCDate() !== day
  ) {
    return null;
  }

  return date;
}
