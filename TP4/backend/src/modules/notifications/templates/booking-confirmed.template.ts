export type BookingConfirmedTemplateInput = {
  passengerName: string;
  ticketCode: string;
  bookingId: string;
  route: string;
  vesselName: string;
  departureAt: Date;
  accommodationLabel: string;
  paymentMethodLabel: string;
  totalAmount: number;
};

export function renderBookingConfirmedEmail(
  input: BookingConfirmedTemplateInput,
) {
  const departure = formatDateTime(input.departureAt);
  const amount = formatMoney(input.totalAmount);
  const subject = `Passagem confirmada - ${input.ticketCode}`;

  const text = [
    `Ola, ${input.passengerName}.`,
    '',
    'Sua passagem no Porto Certo foi confirmada.',
    '',
    `Bilhete: ${input.ticketCode}`,
    `Reserva: ${input.bookingId}`,
    `Rota: ${input.route}`,
    `Embarcacao: ${input.vesselName}`,
    `Saida: ${departure}`,
    `Acomodacao: ${input.accommodationLabel}`,
    `Pagamento: ${input.paymentMethodLabel}`,
    `Valor: ${amount}`,
    '',
    'Apresente este bilhete no embarque junto com um documento com foto.',
    '',
    'Boa viagem pela Amazonia!',
    'Equipe Porto Certo',
  ].join('\n');

  const html = `
    <div style="font-family: Arial, sans-serif; color: #1f2933; line-height: 1.5;">
      <h1 style="color: #0f766e; font-size: 24px;">Passagem confirmada</h1>
      <p>Ola, <strong>${escapeHtml(input.passengerName)}</strong>.</p>
      <p>Sua passagem no Porto Certo foi confirmada.</p>

      <table style="border-collapse: collapse; width: 100%; max-width: 560px;">
        ${renderRow('Bilhete', input.ticketCode)}
        ${renderRow('Reserva', input.bookingId)}
        ${renderRow('Rota', input.route)}
        ${renderRow('Embarcacao', input.vesselName)}
        ${renderRow('Saida', departure)}
        ${renderRow('Acomodacao', input.accommodationLabel)}
        ${renderRow('Pagamento', input.paymentMethodLabel)}
        ${renderRow('Valor', amount)}
      </table>

      <p style="margin-top: 24px;">
        Apresente este bilhete no embarque junto com um documento com foto.
      </p>
      <p>Boa viagem pela Amazonia!</p>
      <p><strong>Equipe Porto Certo</strong></p>
    </div>
  `;

  return { subject, text, html };
}

function renderRow(label: string, value: string) {
  return `
    <tr>
      <td style="padding: 8px 12px; border: 1px solid #d5dde5; background: #f7fafc;">
        <strong>${escapeHtml(label)}</strong>
      </td>
      <td style="padding: 8px 12px; border: 1px solid #d5dde5;">
        ${escapeHtml(value)}
      </td>
    </tr>
  `;
}

function formatDateTime(value: Date) {
  return new Intl.DateTimeFormat('pt-BR', {
    dateStyle: 'full',
    timeStyle: 'short',
    timeZone: 'America/Manaus',
  }).format(value);
}

function formatMoney(value: number) {
  return new Intl.NumberFormat('pt-BR', {
    style: 'currency',
    currency: 'BRL',
  }).format(value);
}

function escapeHtml(value: string) {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}
