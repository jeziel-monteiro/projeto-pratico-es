const MINIMUM_TRAVELER_AGE = 18;

export function parseTravelerBirthDate(value: string) {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(value.trim());
  if (!match) return null;

  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
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

export function isAtLeastMinimumTravelerAge(
  birthDate: Date,
  now = new Date(),
) {
  let age = now.getUTCFullYear() - birthDate.getUTCFullYear();
  const currentMonth = now.getUTCMonth();
  const birthMonth = birthDate.getUTCMonth();

  if (
    currentMonth < birthMonth ||
    (currentMonth === birthMonth && now.getUTCDate() < birthDate.getUTCDate())
  ) {
    age -= 1;
  }

  return age >= MINIMUM_TRAVELER_AGE;
}
