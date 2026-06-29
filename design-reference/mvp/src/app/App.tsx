import { useState, useEffect, useRef } from "react";
import { ImageWithFallback } from "@/app/components/figma/ImageWithFallback";
import portoCertoLogo from "@/imports/imagem_2026-06-24_162010309.png";
import {
  Home, Search, Heart, User, ChevronLeft, X, MapPin, Clock, Star,
  CreditCard, QrCode, Download, Share2, Bell, HelpCircle, FileText,
  Shield, BarChart3, Ship, Calendar, DollarSign, CheckCircle,
  XCircle, AlertCircle, Loader2, ArrowRight, Mail, Lock, Eye, EyeOff,
  Navigation, Wifi, Copy, RefreshCw, TrendingUp, Users, LogOut, Plus,
  LayoutDashboard, Filter, Accessibility, ChevronDown, ChevronRight,
  Type, WifiOff, Edit, Check, Info, MessageSquare, Settings, Phone,
  Package, Menu, Anchor, MoreVertical, Trash2, Globe, Waves, Ticket,
} from "lucide-react";
import {
  AreaChart, Area, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, ResponsiveContainer, PieChart, Pie, Cell, Legend,
} from "recharts";

// ─────────────────────────────────────────────────────────────
// TYPES
// ─────────────────────────────────────────────────────────────
type Screen =
  | "splash" | "onboarding" | "assistant" | "login" | "register"
  | "forgot" | "home" | "search" | "results" | "vessel" | "vessel-trips" | "vessel-reviews"
  | "purchase" | "seats" | "accommodation" | "summary" | "payment" | "pix" | "boleto"
  | "credit-card" | "rejected" | "approved" | "ticket" | "favorites" | "tracking"
  | "notifications" | "profile" | "settings-screen" | "accessibility" | "high-contrast"
  | "help" | "terms" | "privacy" | "change-password"
  | "my-trips" | "guide-purchase" | "guide-payment" | "guide-accommodation";
type OwnerTab = "dashboard" | "trips" | "vessels" | "revenue" | "customers" | "settings";

// ─────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────
const mockTrips = [
  { id: 1, vessel: "Comandante Freitas", origin: "Manaus", destination: "Santarém", date: "25/06/2026", time: "06:00", duration: "14h", price: 180, seats: 12, rating: 4.8, img: "https://images.unsplash.com/photo-1774453262743-451850856acf?w=600&h=300&fit=crop", amenities: ["Refeição", "WiFi", "AC", "Camarote"], capacity: 60, speed: "20 km/h", reg: "AMZ-2891-M" },
  { id: 2, vessel: "Ana Beatriz", origin: "Manaus", destination: "Parintins", date: "26/06/2026", time: "08:30", duration: "8h", price: 95, seats: 3, rating: 4.6, img: "https://images.unsplash.com/photo-1558484779-3092f73da26e?w=600&h=300&fit=crop", amenities: ["Lanche", "Banheiro"], capacity: 40, speed: "25 km/h", reg: "RNE-1023-M" },
  { id: 3, vessel: "Expresso Amazonas", origin: "Manaus", destination: "Tefé", date: "27/06/2026", time: "05:00", duration: "20h", price: 220, seats: 0, rating: 4.9, img: "https://images.unsplash.com/photo-1632022083836-e0f2abb5a212?w=600&h=300&fit=crop", amenities: ["Refeição", "WiFi", "AC", "Camarote", "Restaurante"], capacity: 80, speed: "18 km/h", reg: "SOL-3340-M" },
  { id: 4, vessel: "Rei Davi", origin: "Santarém", destination: "Belém", date: "28/06/2026", time: "07:00", duration: "18h", price: 155, seats: 8, rating: 4.7, img: "https://images.unsplash.com/photo-1668431396497-d5528cf612a5?w=600&h=300&fit=crop", amenities: ["Refeição", "WiFi", "Camarote"], capacity: 55, speed: "22 km/h", reg: "TAP-4412-B" },
];
const revenueData = [
  { mes: "Jan", receita: 42000, passageiros: 320 }, { mes: "Fev", receita: 38500, passageiros: 290 },
  { mes: "Mar", receita: 51000, passageiros: 410 }, { mes: "Abr", receita: 47000, passageiros: 375 },
  { mes: "Mai", receita: 63000, passageiros: 490 }, { mes: "Jun", receita: 58000, passageiros: 445 },
];
const pieData = [{ name: "PIX", value: 55 }, { name: "Cartão", value: 30 }, { name: "Boleto", value: 15 }];
const PIE_COLORS = ["#005BC5", "#0084FC", "#008B8B"];
const ownerTrips = [
  { id: "VG-001", route: "Manaus → Santarém", vessel: "Amazonas I", date: "25/06", passengers: 48, capacity: 60, status: "confirmada", revenue: 8640 },
  { id: "VG-002", route: "Manaus → Parintins", vessel: "Rio Negro Express", date: "26/06", passengers: 37, capacity: 40, status: "embarcando", revenue: 3515 },
  { id: "VG-003", route: "Manaus → Tefé", vessel: "Solimões Star", date: "27/06", passengers: 72, capacity: 80, status: "confirmada", revenue: 15840 },
  { id: "VG-004", route: "Santarém → Belém", vessel: "Tapajós Veloz", date: "28/06", passengers: 29, capacity: 55, status: "pendente", revenue: 4495 },
  { id: "VG-005", route: "Manaus → Parintins", vessel: "Rio Negro Express", date: "29/06", passengers: 15, capacity: 40, status: "aberta", revenue: 1425 },
];

const mockReviews = [
  { id:1, user:"Pedro Henrique L.", avatar:"P", rating:5, date:"15/06/2026", comment:"Viagem excelente! Embarcação limpa, tripulação atenciosa e chegamos no horário. Recomendo muito!", helpful:12 },
  { id:2, user:"Juliana Ferreira", avatar:"J", rating:4, date:"10/06/2026", comment:"Boa viagem no geral. O camarote era confortável, mas o Wi-Fi ficou intermitente na metade do trajeto.", helpful:7 },
  { id:3, user:"Roberto Costa", avatar:"R", rating:5, date:"02/06/2026", comment:"Melhor embarcação que já viajei no Amazonas. Comida boa, espaço bem organizado e vista incrível.", helpful:19 },
  { id:4, user:"Mariana Alves", avatar:"M", rating:3, date:"28/05/2026", comment:"Viagem razoável. Houve atraso de 40 minutos na saída e a área de redes estava bem cheia.", helpful:4 },
  { id:5, user:"Carlos Mendes", avatar:"C", rating:5, date:"20/05/2026", comment:"Incrível! A vista do rio ao amanhecer é algo que não tem preço. Voltarei com certeza.", helpful:22 },
  { id:6, user:"Ana Beatriz S.", avatar:"A", rating:4, date:"12/05/2026", comment:"Muito boa experiência. Só sentei falta de mais tomadas no convés para carregar o celular.", helpful:8 },
];

const routeStops = [
  { name:"Manaus",      priceMult:0,    etaFrom:"Partida" },
  { name:"Itacoatiara", priceMult:0.45, etaFrom:"3h 30min" },
  { name:"Silves",      priceMult:0.60, etaFrom:"5h 20min" },
  { name:"Itapiranga",  priceMult:0.72, etaFrom:"7h 10min" },
  { name:"Urucurituba", priceMult:0.85, etaFrom:"10h 00min" },
  { name:"Parintins",   priceMult:1.0,  etaFrom:"12h 30min" },
];

// ─────────────────────────────────────────────────────────────
// UTILITIES & DESIGN SYSTEM
// ─────────────────────────────────────────────────────────────
const cn = (...c: (string | boolean | undefined | null)[]) => c.filter(Boolean).join(" ");

const M = ({ children, className = "", as: Tag = "span" }: { children: React.ReactNode; className?: string; as?: keyof JSX.IntrinsicElements }) =>
  <Tag className={cn("font-[Montserrat,sans-serif]", className)}>{children}</Tag>;

interface BtnProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "outline" | "ghost" | "danger" | "teal";
  size?: "xs" | "sm" | "md" | "lg";
  loading?: boolean;
  full?: boolean;
}
const Btn = ({ variant = "primary", size = "md", loading, full, className, children, disabled, ...p }: BtnProps) => {
  const base = "inline-flex items-center justify-center font-semibold rounded-2xl transition-all duration-200 active:scale-[0.97] disabled:opacity-50 disabled:pointer-events-none focus:outline-none focus-visible:ring-2 focus-visible:ring-[#005BC5]/50 select-none";
  const v = { primary: "bg-[#005BC5] text-white hover:bg-[#004fa8] shadow-md shadow-[#005BC5]/25", secondary: "bg-[#0084FC] text-white hover:bg-[#006de0] shadow-md", outline: "border-2 border-[#005BC5] text-[#005BC5] bg-white hover:bg-[#005BC5]/5", ghost: "text-[#005BC5] bg-transparent hover:bg-[#005BC5]/8", danger: "bg-[#d4183d] text-white hover:bg-[#b0152f]", teal: "bg-[#008B8B] text-white hover:bg-[#007070]" };
  const s = { xs: "text-[11px] px-2.5 py-1 gap-1", sm: "text-xs px-3.5 py-2 gap-1.5", md: "text-sm px-5 py-2.5 gap-2", lg: "text-base px-6 py-3.5 gap-2" };
  return <button className={cn(base, v[variant], s[size], full && "w-full", className)} disabled={disabled || loading} {...p}>{loading && <Loader2 className="animate-spin" size={14} />}{children}</button>;
};

interface FldProps extends React.InputHTMLAttributes<HTMLInputElement> { label?: string; error?: string; icon?: React.ReactNode; right?: React.ReactNode; }
const Fld = ({ label, error, icon, right, className, ...p }: FldProps) => (
  <div className="flex flex-col gap-1.5">
    {label && <label className="text-[11px] font-bold text-gray-500 uppercase tracking-wider">{label}</label>}
    <div className="relative flex items-center">
      {icon && <span className="absolute left-3.5 text-gray-400 pointer-events-none">{icon}</span>}
      <input className={cn("w-full bg-white border border-gray-200 rounded-2xl py-3 text-sm text-gray-800 placeholder-gray-400 outline-none transition-all focus:border-[#005BC5] focus:ring-2 focus:ring-[#005BC5]/15", error && "border-red-400 focus:border-red-400 focus:ring-red-400/15", icon ? "pl-10 pr-4" : "px-4", right && "pr-11", className)} {...p} />
      {right && <span className="absolute right-3.5">{right}</span>}
    </div>
    {error && <p className="text-[11px] text-red-500 flex items-center gap-1"><AlertCircle size={11} />{error}</p>}
  </div>
);

const Badge = ({ c, children }: { c?: "blue" | "orange" | "teal" | "red" | "gray" | "green"; children: React.ReactNode }) => {
  const cols = { blue: "bg-[#005BC5]/10 text-[#005BC5]", orange: "bg-[#FFA500]/15 text-[#cc8400]", teal: "bg-[#008B8B]/12 text-[#008B8B]", red: "bg-red-100 text-red-600", gray: "bg-gray-100 text-gray-500", green: "bg-emerald-100 text-emerald-700" };
  return <span className={cn("text-[10px] font-bold px-2.5 py-1 rounded-full uppercase tracking-wide", cols[c ?? "blue"])}>{children}</span>;
};

const Chip = ({ children, active, onClick }: { children: React.ReactNode; active?: boolean; onClick?: () => void }) => (
  <button onClick={onClick} className={cn("text-xs font-semibold px-3 py-1.5 rounded-full border transition-all", active ? "bg-[#005BC5] text-white border-[#005BC5]" : "bg-white text-gray-600 border-gray-200 hover:border-[#005BC5] hover:text-[#005BC5]")}>{children}</button>
);

const StarRating = ({ value, onChange, size = 14 }: { value: number; onChange?: (v: number) => void; size?: number }) => (
  <div className="flex gap-0.5">
    {[1,2,3,4,5].map(i => (
      <button key={i} type="button" onClick={() => onChange?.(i)} className={onChange ? "cursor-pointer" : "cursor-default pointer-events-none"}>
        <Star size={size} className={i <= value ? "fill-[#FFA500] text-[#FFA500]" : "text-gray-300"} />
      </button>
    ))}
  </div>
);

const ReviewCard = ({ review }: { review: typeof mockReviews[0] }) => (
  <div className="py-3 border-b border-gray-50 last:border-0">
    <div className="flex items-start gap-3">
      <div className="w-8 h-8 rounded-full bg-[#005BC5]/10 flex items-center justify-center flex-shrink-0">
        <span className="text-xs font-bold text-[#005BC5]">{review.avatar}</span>
      </div>
      <div className="flex-1 min-w-0">
        <div className="flex items-center justify-between gap-2 mb-0.5">
          <M className="text-xs font-bold text-gray-800">{review.user}</M>
          <span className="text-[10px] text-gray-400 flex-shrink-0">{review.date}</span>
        </div>
        <StarRating value={review.rating} size={11} />
        <p className="text-xs text-gray-500 leading-relaxed mt-1.5">{review.comment}</p>
        <button className="text-[10px] text-gray-400 mt-1.5 flex items-center gap-1 hover:text-[#005BC5]">
          👍 Útil ({review.helpful})
        </button>
      </div>
    </div>
  </div>
);

const StatusBar = ({ light = false }: { light?: boolean }) => (
  <div className={cn("flex justify-between items-center px-5 pt-3 pb-1 flex-shrink-0", light ? "text-white" : "text-gray-800")}>
    <span className="text-[11px] font-bold">9:41</span>
    <div className="flex items-center gap-1.5">
      <div className="flex gap-0.5 items-end h-3">{[1,2,3,4].map(i => <div key={i} className={cn("w-0.5 rounded-sm", light?"bg-white":"bg-gray-800")} style={{ height: `${i*3}px` }} />)}</div>
      <Wifi size={11} />
      <div className="flex items-center gap-0.5"><div className="w-5 h-2.5 border-[1.5px] rounded-sm relative"><div className="absolute inset-[1px] bg-current rounded-sm" style={{ width: "65%" }} /></div><div className="w-0.5 h-1.5 bg-current rounded-sm" /></div>
    </div>
  </div>
);

const BottomNav = ({ active, nav }: { active: string; nav: (s: Screen) => void }) => (
  <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-100 flex items-center justify-around px-1 pt-2 pb-4 z-20">
    {([["home","Início",Home],["search","Buscar",Search],["favorites","Favoritos",Heart],["profile","Perfil",User]] as const).map(([scr, lbl, Icon]) => (
      <button key={scr} onClick={() => nav(scr as Screen)} className={cn("flex flex-col items-center gap-0.5 px-3 py-1 rounded-xl transition-all", active===scr ? "text-[#005BC5]" : "text-gray-400")}>
        <Icon size={20} strokeWidth={active===scr ? 2.5 : 1.8} />
        <span className="text-[9px] font-semibold">{lbl}</span>
      </button>
    ))}
  </div>
);

const TripCard = ({ trip, onDetails, onBuy, onFav, fav }: { trip: typeof mockTrips[0]; onDetails?:()=>void; onBuy?:()=>void; onFav?:()=>void; fav?: boolean }) => (
  <div className="bg-white rounded-3xl overflow-hidden shadow-sm border border-gray-100 mb-3">
    <div className="relative h-32">
      <img src={trip.img} alt={trip.vessel} className="w-full h-full object-cover" />
      <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-transparent" />
      <button onClick={onFav} className="absolute top-2.5 right-2.5 w-7 h-7 rounded-full bg-white/90 flex items-center justify-center shadow" aria-label="Favoritar">
        <Heart size={13} className={fav ? "fill-red-500 text-red-500" : "text-gray-400"} />
      </button>
      {trip.seats === 0 && <div className="absolute inset-0 bg-black/50 flex items-center justify-center"><Badge c="red">Esgotado</Badge></div>}
      {trip.seats > 0 && trip.seats <= 4 && <div className="absolute top-2.5 left-2.5"><Badge c="orange">Últimas {trip.seats} vagas!</Badge></div>}
      <div className="absolute bottom-2.5 left-3"><M className="text-white font-bold text-sm">{trip.vessel}</M></div>
    </div>
    <div className="p-3">
      <div className="flex items-center justify-between mb-1.5">
        <div className="flex items-center gap-1 text-gray-500"><MapPin size={11} /><span className="text-xs">{trip.origin} → {trip.destination}</span></div>
        <div className="flex items-center gap-1 text-[#FFA500]"><Star size={11} fill="#FFA500" /><span className="text-xs font-bold">{trip.rating}</span></div>
      </div>
      <div className="flex items-center gap-2 text-gray-500 text-xs mb-3">
        <span className="flex items-center gap-1"><Calendar size={10} />{trip.date}</span>
        <span className="flex items-center gap-1"><Clock size={10} />{trip.time} · {trip.duration}</span>
      </div>
      <div className="flex items-center justify-between">
        <div><span className="text-[#005BC5] font-bold text-base">R$ {trip.price}</span><span className="text-gray-400 text-xs">/pessoa</span></div>
        <div className="flex gap-2">
          <Btn variant="outline" size="sm" onClick={onDetails}>Detalhes</Btn>
          {trip.seats > 0 && <Btn size="sm" onClick={onBuy}>Comprar</Btn>}
        </div>
      </div>
    </div>
  </div>
);

const Divider = ({ label }: { label?: string }) => (
  <div className="flex items-center gap-3 my-4">
    <div className="flex-1 h-px bg-gray-200" />
    {label && <span className="text-xs text-gray-400 font-medium">{label}</span>}
    <div className="flex-1 h-px bg-gray-200" />
  </div>
);

const SectionTitle = ({ children, action, onAction }: { children: React.ReactNode; action?: string; onAction?: () => void }) => (
  <div className="flex items-center justify-between mb-3">
    <M className="font-bold text-sm text-gray-800">{children}</M>
    {action && <button onClick={onAction} className="text-xs text-[#005BC5] font-semibold flex items-center gap-0.5">{action}<ChevronRight size={12} /></button>}
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 1 – SPLASH
// ─────────────────────────────────────────────────────────────
const SplashScreen = ({ nav }: { nav: (s: Screen) => void }) => {
  useEffect(() => { const t = setTimeout(() => nav("onboarding"), 2800); return () => clearTimeout(t); }, [nav]);
  return (
    <div className="relative flex flex-col h-full bg-gradient-to-b from-[#003a8c] via-[#005BC5] to-[#0084FC] overflow-hidden">
      <div className="absolute inset-0">
        {[...Array(6)].map((_, i) => (
          <div key={i} className="absolute rounded-full opacity-10 bg-white animate-pulse" style={{ width: `${60+i*40}px`, height: `${60+i*40}px`, top: `${20+i*12}%`, left: `${10+i*13}%`, animationDelay: `${i*0.4}s` }} />
        ))}
        <div className="absolute bottom-0 left-0 right-0 h-64 opacity-20">
          <svg viewBox="0 0 390 120" className="w-full" preserveAspectRatio="none">
            <path d="M0 60 Q97.5 20 195 60 T390 60 L390 120 L0 120Z" fill="white" />
            <path d="M0 80 Q97.5 40 195 80 T390 80 L390 120 L0 120Z" fill="white" opacity="0.5" />
          </svg>
        </div>
      </div>
      <div className="flex-1 flex flex-col items-center justify-center gap-6 relative z-10">
        <ImageWithFallback src={portoCertoLogo} alt="Porto Certo Viagens" className="w-52 h-52 object-contain" style={{ mixBlendMode: "screen", filter: "invert(1) hue-rotate(180deg) brightness(1.2) drop-shadow(0 4px 24px rgba(0,180,255,0.6))" }} />
        <p className="text-white/70 text-sm font-normal text-center px-8" style={{ fontFamily: "Roboto, sans-serif" }}>Sua jornada pela Amazônia começa aqui</p>
        <div className="flex gap-1.5 mt-2">{[0,1,2].map(i => <div key={i} className="h-1 rounded-full bg-white/40 animate-pulse" style={{ width: i===1?"24px":"8px", animationDelay:`${i*0.3}s` }} />)}</div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 2 – ONBOARDING
// ─────────────────────────────────────────────────────────────
const slides = [
  { img: "https://images.unsplash.com/photo-1774453262743-451850856acf?w=600&h=400&fit=crop", title: "Navegue com Segurança", sub: "Viaje pelos rios da Amazônia com conforto, pontualidade e total segurança." },
  { img: "https://images.unsplash.com/photo-1558484779-3092f73da26e?w=600&h=400&fit=crop", title: "Encontre as Melhores Viagens", sub: "Compare preços, horários e embarcações com poucos toques na tela." },
  { img: "https://images.unsplash.com/photo-1632022083836-e0f2abb5a212?w=600&h=400&fit=crop", title: "Viaje com Praticidade", sub: "Compre sua passagem, acompanhe em tempo real e leve o bilhete no celular." },
];
const OnboardingScreen = ({ nav }: { nav: (s: Screen) => void }) => {
  const [i, setI] = useState(0);
  const last = i === slides.length - 1;
  return (
    <div className="flex flex-col h-full bg-white">
      <div className="relative h-[45%] flex-shrink-0">
        <img src={slides[i].img} alt={slides[i].title} className="w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-b from-transparent to-white/90" />
        <button onClick={() => nav("login")} className="absolute top-4 right-4 text-xs font-bold text-gray-500 bg-white/80 rounded-full px-3 py-1.5">Pular</button>
      </div>
      <div className="flex-1 flex flex-col items-center justify-between px-6 py-6">
        <div className="text-center">
          <M as="h2" className="text-2xl font-black text-gray-900 leading-tight mb-3">{slides[i].title}</M>
          <p className="text-gray-500 text-sm leading-relaxed" style={{ fontFamily: "Roboto, sans-serif" }}>{slides[i].sub}</p>
        </div>
        <div className="w-full flex flex-col gap-4">
          <div className="flex justify-center gap-2">{slides.map((_,j) => <div key={j} className={cn("h-1.5 rounded-full transition-all duration-300", j===i ? "w-8 bg-[#005BC5]" : "w-1.5 bg-gray-200")} />)}</div>
          {last
            ? <Btn full size="lg" onClick={() => nav("login")}>Começar Agora <ArrowRight size={18} /></Btn>
            : <Btn full size="lg" onClick={() => setI(i+1)}>Próximo <ArrowRight size={18} /></Btn>}
          {!last && <button onClick={() => nav("login")} className="text-sm text-gray-400 font-medium text-center">Já tenho conta</button>}
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 3 – ASSISTANT
// ─────────────────────────────────────────────────────────────
const AssistantScreen = ({ nav }: { nav: (s: Screen) => void }) => {
  const [step, setStep] = useState(0);
  const [origin, setOrigin] = useState("");
  const cities = ["Manaus", "Santarém", "Belém", "Parintins", "Tefé", "Itacoatiara"];
  const steps = [
    { q: "Olá! 👋 Para onde você quer viajar hoje?", opts: cities },
    { q: `Ótimo! E de onde você vai sair?`, opts: cities.filter(c => c !== origin) },
    { q: "Perfeito! Quando você vai viajar?", opts: ["Hoje", "Amanhã", "Esta semana", "Escolher data"] },
  ];
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-gradient-to-b from-[#005BC5] to-[#0084FC] px-5 pt-3 pb-6">
        <StatusBar light />
        <div className="flex items-center gap-3 mt-2">
          <div className="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center"><Waves size={20} className="text-white" /></div>
          <div><M className="text-white font-bold text-sm">Assistente Porto Certo</M><p className="text-white/70 text-xs">Online agora</p></div>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 flex flex-col gap-3">
        {steps.slice(0, step+1).map((s, idx) => (
          <div key={idx}>
            <div className="flex gap-2 mb-2">
              <div className="w-7 h-7 rounded-full bg-[#005BC5] flex items-center justify-center flex-shrink-0"><Waves size={14} className="text-white" /></div>
              <div className="bg-white rounded-2xl rounded-tl-sm px-4 py-3 shadow-sm max-w-[80%]"><p className="text-sm text-gray-700">{s.q}</p></div>
            </div>
            {idx === step && (
              <div className="flex flex-wrap gap-2 ml-9">
                {s.opts.map(opt => (
                  <button key={opt} onClick={() => { if (idx===0) setOrigin(opt); if (idx < steps.length-1) setStep(idx+1); else nav("results"); }} className="bg-white border border-[#005BC5] text-[#005BC5] text-xs font-semibold px-3 py-1.5 rounded-full hover:bg-[#005BC5] hover:text-white transition-all">{opt}</button>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
      <div className="px-4 pb-6 pt-2 bg-white border-t border-gray-100">
        <Btn full variant="ghost" onClick={() => nav("search")} size="sm">Buscar manualmente <ChevronRight size={14} /></Btn>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 4 – LOGIN
// ─────────────────────────────────────────────────────────────
const LoginScreen = ({ nav }: { nav: (s: Screen) => void }) => {
  const [email, setEmail] = useState(""); const [pass, setPass] = useState(""); const [show, setShow] = useState(false);
  const [err, setErr] = useState(""); const [loading, setLoading] = useState(false);
  const submit = () => {
    if (!email) { setErr("Email obrigatório"); return; }
    if (!pass) { setErr("Senha obrigatória"); return; }
    if (!email.includes("@")) { setErr("Email inválido. Verifique e tente novamente."); return; }
    setErr(""); setLoading(true);
    setTimeout(() => { setLoading(false); nav("home"); }, 1500);
  };
  return (
    <div className="flex flex-col h-full bg-white overflow-y-auto">
      <div className="bg-gradient-to-b from-[#005BC5] to-[#0084FC] px-5 pb-10 pt-3">
        <StatusBar light />
        <div className="flex flex-col items-center mt-2 gap-2">
          <ImageWithFallback src={portoCertoLogo} alt="Porto Certo Viagens" className="w-36 h-36 object-contain" style={{ mixBlendMode: "screen", filter: "invert(1) hue-rotate(180deg) brightness(1.2) drop-shadow(0 2px 14px rgba(0,180,255,0.5))" }} />
          <M className="text-white text-xl font-black -mt-2">Bem-vindo de volta</M>
          <p className="text-white/75 text-xs text-center">Entre na sua conta para continuar</p>
        </div>
      </div>
      <div className="flex-1 px-5 pt-6 pb-6 flex flex-col gap-4" style={{ marginTop: -16 }}>
        <div className="bg-white rounded-3xl shadow-lg p-5 flex flex-col gap-4">
          {err && <div className="bg-red-50 border border-red-200 rounded-2xl px-4 py-3 flex items-start gap-2"><AlertCircle size={14} className="text-red-500 mt-0.5 flex-shrink-0" /><p className="text-xs text-red-700">{err}</p></div>}
          <Fld label="Email" type="email" placeholder="seu@email.com" value={email} onChange={e=>setEmail(e.target.value)} icon={<Mail size={16} />} />
          <Fld label="Senha" type={show?"text":"password"} placeholder="••••••••" value={pass} onChange={e=>setPass(e.target.value)} icon={<Lock size={16} />} right={<button type="button" onClick={()=>setShow(!show)} className="text-gray-400">{show?<EyeOff size={16}/>:<Eye size={16}/>}</button>} />
          <button onClick={() => nav("forgot")} className="text-xs text-[#005BC5] font-semibold text-right -mt-1">Esqueci minha senha</button>
          <Btn full size="lg" loading={loading} onClick={submit}>Entrar</Btn>
        </div>
        <Divider label="ou" />
        <Btn full variant="outline" size="lg" onClick={() => nav("register")}>Criar nova conta</Btn>
        <p className="text-center text-[9px] text-gray-300 px-6 leading-relaxed">Ao entrar você concorda com os{" "}<button onClick={() => nav("terms")} className="text-[9px] text-gray-400 underline underline-offset-1">Termos de Uso</button>{" "}e a{" "}<button onClick={() => nav("privacy")} className="text-[9px] text-gray-400 underline underline-offset-1">Política de Privacidade</button></p>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 5 – REGISTER
// ─────────────────────────────────────────────────────────────
const RegisterScreen = ({ nav }: { nav: (s: Screen) => void }) => {
  const [f, setF] = useState({ name:"", cpf:"", phone:"", email:"", pass:"", confirm:"" });
  const [errs, setErrs] = useState<Record<string,string>>({});
  const [loading, setLoading] = useState(false);
  const validate = () => {
    const e: Record<string,string> = {};
    if (!f.name) e.name = "Nome obrigatório";
    if (!f.cpf || f.cpf.replace(/\D/g,"").length < 11) e.cpf = "CPF inválido";
    if (!f.email.includes("@")) e.email = "Email inválido";
    if (f.pass.length < 8) e.pass = "Senha deve ter no mínimo 8 caracteres";
    if (f.pass !== f.confirm) e.confirm = "As senhas não coincidem";
    return e;
  };
  const submit = () => { const e = validate(); if (Object.keys(e).length) { setErrs(e); return; } setLoading(true); setTimeout(() => { setLoading(false); nav("home"); }, 1500); };
  const upd = (k: string) => (e: React.ChangeEvent<HTMLInputElement>) => setF(p => ({...p, [k]: e.target.value}));
  const fmtCPF = (v: string) => v.replace(/\D/g,"").replace(/(\d{3})(\d)/,"$1.$2").replace(/(\d{3})\.(\d{3})(\d)/,"$1.$2.$3").replace(/(\d{3})\.(\d{3})\.(\d{3})(\d)/,"$1.$2.$3-$4").slice(0,14);
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("login")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Criar Conta</M>
        </div>
      </div>
      <div className="px-5 py-5 flex flex-col gap-3">
        <div className="bg-white rounded-3xl p-5 flex flex-col gap-4 shadow-sm">
          <Fld label="Nome Completo" placeholder="João da Silva" value={f.name} onChange={upd("name")} error={errs.name} icon={<User size={16} />} />
          <Fld label="CPF" placeholder="000.000.000-00" value={f.cpf} onChange={e => setF(p=>({...p,cpf:fmtCPF(e.target.value)}))} error={errs.cpf} icon={<FileText size={16} />} maxLength={14} />
          <Fld label="Telefone" type="tel" placeholder="(92) 99999-9999" value={f.phone} onChange={upd("phone")} icon={<Phone size={16} />} />
          <Fld label="Email" type="email" placeholder="seu@email.com" value={f.email} onChange={upd("email")} error={errs.email} icon={<Mail size={16} />} />
          <Fld label="Senha" type="password" placeholder="Mín. 8 caracteres" value={f.pass} onChange={upd("pass")} error={errs.pass} icon={<Lock size={16} />} />
          <Fld label="Confirmar Senha" type="password" placeholder="Repita a senha" value={f.confirm} onChange={upd("confirm")} error={errs.confirm} icon={<Lock size={16} />} />
        </div>
        <Btn full size="lg" loading={loading} onClick={submit}>Criar Minha Conta</Btn>
        <p className="text-center text-[9px] text-gray-400 px-2 leading-relaxed">Ao criar uma conta, você concorda com os <button onClick={() => nav("terms")} className="text-[9px] text-[#005BC5] underline">Termos de Uso</button> e a <button onClick={() => nav("privacy")} className="text-[9px] text-[#005BC5] underline">Política de Privacidade</button></p>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 6 – FORGOT PASSWORD
// ─────────────────────────────────────────────────────────────
const ForgotScreen = ({ nav }: { nav: (s: Screen) => void }) => {
  const [email, setEmail] = useState(""); const [sent, setSent] = useState(false); const [loading, setLoading] = useState(false);
  return (
    <div className="flex flex-col h-full bg-white">
      <div className="px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("login")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Recuperar Senha</M>
        </div>
      </div>
      <div className="flex-1 px-5 pt-8 flex flex-col gap-6">
        {!sent ? (
          <>
            <div className="flex flex-col items-center gap-4">
              <div className="w-20 h-20 rounded-full bg-[#005BC5]/10 flex items-center justify-center"><Lock size={32} className="text-[#005BC5]" /></div>
              <div className="text-center"><M className="font-bold text-lg text-gray-800">Esqueceu a senha?</M><p className="text-gray-500 text-sm mt-1 leading-relaxed">Informe seu email e enviaremos um link para redefinir sua senha.</p></div>
            </div>
            <Fld label="Email cadastrado" type="email" placeholder="seu@email.com" value={email} onChange={e=>setEmail(e.target.value)} icon={<Mail size={16} />} />
            <Btn full size="lg" loading={loading} onClick={() => { setLoading(true); setTimeout(() => { setLoading(false); setSent(true); }, 1500); }}>Enviar Instruções</Btn>
          </>
        ) : (
          <div className="flex flex-col items-center gap-5 pt-4">
            <div className="w-20 h-20 rounded-full bg-emerald-100 flex items-center justify-center"><CheckCircle size={40} className="text-emerald-600" /></div>
            <div className="text-center"><M className="font-bold text-lg text-gray-800">Email enviado!</M><p className="text-gray-500 text-sm mt-2 leading-relaxed">Verifique sua caixa de entrada em <strong>{email}</strong> e siga as instruções para redefinir sua senha.</p></div>
            <Btn full onClick={() => nav("login")}>Voltar para Login</Btn>
            <button className="text-sm text-[#005BC5] font-medium">Não recebi o email</button>
          </div>
        )}
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 7 – HOME
// ─────────────────────────────────────────────────────────────
const HomeScreen = ({ nav, favs, toggleFav }: { nav:(s:Screen)=>void; favs:number[]; toggleFav:(id:number)=>void }) => (
  <div className="flex flex-col h-full bg-[#F1F1F1]">
    <div className="bg-gradient-to-b from-[#003a8c] to-[#005BC5] px-5 pt-3 pb-8">
      <StatusBar light />
      <div className="flex items-center justify-between mt-2">
        <div><p className="text-white/70 text-xs">Bom dia,</p><M className="text-white font-bold text-base">Ana Carolina 👋</M></div>
        <div className="flex gap-2">
          <button onClick={() => nav("notifications")} className="w-9 h-9 rounded-full bg-white/15 flex items-center justify-center relative"><Bell size={18} className="text-white" /><span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-[#FFA500]" /></button>
          <button onClick={() => nav("profile")} className="w-9 h-9 rounded-full bg-white/25 flex items-center justify-center overflow-hidden"><img src="https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100&h=100&fit=crop" alt="Perfil" className="w-full h-full object-cover" /></button>
        </div>
      </div>
      <div className="mt-4 bg-white rounded-2xl flex items-center px-4 py-3 gap-3 shadow-md" onClick={() => nav("search")}>
        <Search size={18} className="text-gray-400" />
        <span className="text-sm text-gray-400">Para onde você vai?</span>
      </div>
    </div>
    <div className="flex-1 overflow-y-auto -mt-4 px-4 pb-24">
      <div className="bg-white rounded-3xl p-4 shadow-sm mb-4">
        <SectionTitle action="Ver todas" onAction={() => nav("search")}>Viagens em Destaque</SectionTitle>
        {mockTrips.slice(0,2).map(t => <TripCard key={t.id} trip={t} onDetails={() => nav("vessel")} onBuy={() => nav("purchase")} onFav={() => toggleFav(t.id)} fav={favs.includes(t.id)} />)}
      </div>
      <div className="bg-white rounded-3xl p-4 shadow-sm mb-4">
        <SectionTitle>Rotas Populares</SectionTitle>
        <div className="grid grid-cols-2 gap-2">
          {[["Manaus","Santarém"],["Manaus","Parintins"],["Santarém","Belém"],["Manaus","Tefé"]].map(([o,d]) => (
            <button key={o+d} onClick={() => nav("results")} className="bg-gradient-to-br from-[#005BC5]/8 to-[#0084FC]/5 border border-[#005BC5]/15 rounded-2xl p-3 text-left hover:border-[#005BC5]/40 transition-all">
              <MapPin size={14} className="text-[#005BC5] mb-1" />
              <M className="text-xs font-bold text-gray-800 block">{o}</M>
              <div className="flex items-center gap-1"><ArrowRight size={10} className="text-gray-400" /><M className="text-xs text-gray-500">{d}</M></div>
            </button>
          ))}
        </div>
      </div>
      <div className="bg-white rounded-3xl p-4 shadow-sm mb-4">
        <SectionTitle>Acesso Rápido</SectionTitle>
        <div className="grid grid-cols-4 gap-2">
          {[["Buscar",Search,"search"],["Favoritos",Heart,"favorites"],["Rastrear",Navigation,"tracking"],["Ajuda",HelpCircle,"help"]].map(([lbl,Icon,scr]) => (
            <button key={scr} onClick={() => nav(scr as Screen)} className="flex flex-col items-center gap-1.5 p-2">
              <div className="w-12 h-12 rounded-2xl bg-[#005BC5]/8 flex items-center justify-center"><Icon size={20} className="text-[#005BC5]" /></div>
              <span className="text-[10px] text-gray-600 font-medium">{lbl}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
    <BottomNav active="home" nav={nav} />
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 8 – SEARCH
// ─────────────────────────────────────────────────────────────
const SearchScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [origin, setOrigin] = useState(""); const [dest, setDest] = useState(""); const [date, setDate] = useState(""); const [err, setErr] = useState("");
  const cities = ["Manaus","Santarém","Belém","Parintins","Tefé","Itacoatiara","Óbidos","Juruti"];
  const today = new Date().toISOString().split("T")[0];
  const submit = () => {
    if (!origin||!dest||!date) { setErr("Preencha todos os campos para buscar viagens."); return; }
    if (date < today) { setErr("Não é possível pesquisar viagens em datas anteriores ao dia atual."); return; }
    setErr(""); nav("results");
  };
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("home")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Buscar Viagem</M>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 pb-28">
        <div className="bg-white rounded-3xl p-4 shadow-sm mb-4 flex flex-col gap-3">
          {err && <div className="bg-amber-50 border border-amber-200 rounded-2xl px-4 py-3 flex gap-2"><AlertCircle size={14} className="text-amber-500 mt-0.5 flex-shrink-0" /><p className="text-xs text-amber-700">{err}</p></div>}
          <div className="relative">
            <Fld label="Origem" placeholder="De onde você sai?" value={origin} onChange={e=>setOrigin(e.target.value)} icon={<MapPin size={16} className="text-[#005BC5]" />} />
            <button onClick={() => { const t=origin; setOrigin(dest); setDest(t); }} className="absolute right-3 top-1/2 -translate-y-px mt-3 w-8 h-8 rounded-full bg-[#005BC5]/10 flex items-center justify-center z-10">
              <svg viewBox="0 0 16 16" className="w-4 h-4 text-[#005BC5]" fill="none" stroke="currentColor" strokeWidth="2"><path d="M4 6l4-4 4 4M12 10l-4 4-4-4" strokeLinecap="round" strokeLinejoin="round"/></svg>
            </button>
          </div>
          <Fld label="Destino" placeholder="Para onde vai?" value={dest} onChange={e=>setDest(e.target.value)} icon={<MapPin size={16} className="text-red-400" />} />
          <Fld label="Data" type="date" value={date} onChange={e=>setDate(e.target.value)} icon={<Calendar size={16} />} min={today} />
          <Btn full size="lg" onClick={submit}>Buscar Viagens <Search size={16} /></Btn>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm mb-4">
          <SectionTitle>Cidades Populares</SectionTitle>
          <div className="flex flex-wrap gap-2">{cities.map(c => <Chip key={c} active={c===origin||c===dest} onClick={() => { if (!origin) setOrigin(c); else setDest(c); }}>{c}</Chip>)}</div>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Buscas Recentes</SectionTitle>
          {[["Manaus","Santarém","24/06"],["Manaus","Parintins","20/06"]].map(([o,d,dt]) => (
            <button key={o+d} onClick={() => nav("results")} className="flex items-center gap-3 w-full py-2.5 border-b border-gray-50 last:border-0">
              <div className="w-8 h-8 rounded-xl bg-gray-100 flex items-center justify-center"><Search size={14} className="text-gray-500" /></div>
              <div className="flex-1 text-left"><p className="text-sm font-semibold text-gray-700">{o} → {d}</p><p className="text-xs text-gray-400">{dt}</p></div>
              <ChevronRight size={14} className="text-gray-400" />
            </button>
          ))}
        </div>
      </div>
      <BottomNav active="search" nav={nav} />
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 9 – RESULTS
// ─────────────────────────────────────────────────────────────
const ResultsScreen = ({ nav, favs, toggleFav }: { nav:(s:Screen)=>void; favs:number[]; toggleFav:(id:number)=>void }) => {
  const [sort, setSort] = useState("price"); const [filter, setFilter] = useState("");
  const filtered = mockTrips.filter(t => !filter || (filter==="available" ? t.seats>0 : filter==="ac" ? t.amenities.includes("AC") : true));
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-3 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("search")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <div className="flex-1"><M className="font-bold text-sm text-gray-800">Manaus → Santarém</M><p className="text-xs text-gray-500">25/06/2026 · {filtered.length} viagens</p></div>
        </div>
        <div className="flex gap-2 mt-3 overflow-x-auto pb-1">
          <Chip active={!filter} onClick={() => setFilter("")}>Todas</Chip>
          <Chip active={filter==="available"} onClick={() => setFilter("available")}>Com vagas</Chip>
          <Chip active={filter==="ac"} onClick={() => setFilter("ac")}>Com AC</Chip>
          <Chip active={sort==="price"} onClick={() => setSort("price")}>Menor preço</Chip>
          <Chip active={sort==="rating"} onClick={() => setSort("rating")}>Mais avaliados</Chip>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 pb-6">
        {filtered.length === 0
          ? <div className="flex flex-col items-center justify-center h-48 gap-3"><div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center"><Search size={28} className="text-gray-400" /></div><M className="font-bold text-gray-600">Nenhuma viagem encontrada</M><p className="text-xs text-gray-400 text-center">Tente alterar os filtros ou a data de busca.</p></div>
          : filtered.map(t => <TripCard key={t.id} trip={t} onDetails={() => nav("vessel")} onBuy={() => nav("purchase")} onFav={() => toggleFav(t.id)} fav={favs.includes(t.id)} />)}
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 10 – VESSEL PROFILE
// ─────────────────────────────────────────────────────────────
const VesselScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const trip = mockTrips[0]; const [imgIdx, setImgIdx] = useState(0);
  const imgs = [trip.img, "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&h=300&fit=crop", "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&h=300&fit=crop"];
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="relative h-52 flex-shrink-0">
        <img src={imgs[imgIdx]} alt={trip.vessel} className="w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent" />
        <button onClick={() => nav("results")} className="absolute top-12 left-4 w-9 h-9 rounded-full bg-black/30 flex items-center justify-center backdrop-blur-sm"><ChevronLeft size={20} className="text-white" /></button>
        <div className="absolute bottom-0 left-0 right-0 flex gap-2 p-3 justify-center">{imgs.map((_,i) => <button key={i} onClick={() => setImgIdx(i)} className={cn("h-1.5 rounded-full transition-all", i===imgIdx ? "w-6 bg-white" : "w-1.5 bg-white/50")} />)}</div>
      </div>
      <div className="px-4 py-4 flex flex-col gap-4 pb-6">
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <div className="flex items-start justify-between mb-2">
            <M className="font-black text-lg text-gray-900 flex-1">{trip.vessel}</M>
            <div className="flex items-center gap-1 bg-[#FFA500]/10 px-2 py-1 rounded-full"><Star size={13} fill="#FFA500" className="text-[#FFA500]" /><span className="text-sm font-bold text-[#cc8400]">{trip.rating}</span></div>
          </div>
          <p className="text-xs text-gray-500 flex items-center gap-1 mb-4"><FileText size={12} />Reg. {trip.reg}</p>
          <div className="grid grid-cols-3 gap-3">
            {[["Capacidade",`${trip.capacity} pass.`,Users],["Velocidade",trip.speed,Navigation],["Registro",trip.reg,Anchor]].map(([l,v,Icon]) => (
              <div key={l} className="bg-[#F1F1F1] rounded-2xl p-3 text-center">
                <Icon size={18} className="text-[#005BC5] mx-auto mb-1" />
                <p className="text-[9px] text-gray-500 font-medium uppercase tracking-wide">{l}</p>
                <M className="text-xs font-bold text-gray-800">{v}</M>
              </div>
            ))}
          </div>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Comodidades</SectionTitle>
          <div className="flex flex-wrap gap-2">{trip.amenities.map(a => <Chip key={a} active>{a}</Chip>)}</div>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle action="Ver todas" onAction={() => nav("vessel-trips")}>Próximas Viagens</SectionTitle>
          {mockTrips.slice(0,2).map(t => (
            <div key={t.id} className="flex items-center gap-3 py-2.5 border-b border-gray-50 last:border-0">
              <div className="w-10 h-10 rounded-2xl bg-[#005BC5]/10 flex items-center justify-center"><Ship size={18} className="text-[#005BC5]" /></div>
              <div className="flex-1"><p className="text-sm font-semibold text-gray-800">{t.origin} → {t.destination}</p><p className="text-xs text-gray-500">{t.date} · {t.time}</p></div>
              <div className="text-right"><M className="text-sm font-bold text-[#005BC5]">R$ {t.price}</M><p className="text-[10px] text-gray-400">{t.seats} vagas</p></div>
            </div>
          ))}
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle action="Ver todas" onAction={() => nav("vessel-reviews")}>Avaliações dos Passageiros</SectionTitle>
          <div className="flex items-center gap-4 mb-3 pb-3 border-b border-gray-100">
            <div className="text-center flex-shrink-0">
              <M className="text-3xl font-black text-gray-900">4.8</M>
              <StarRating value={5} size={12} />
              <p className="text-[10px] text-gray-400 mt-0.5">127 avaliações</p>
            </div>
            <div className="flex-1 flex flex-col gap-1.5">
              {[5,4,3,2,1].map(s => {
                const pct = s===5?70:s===4?20:s===3?6:s===2?2:2;
                return (
                  <div key={s} className="flex items-center gap-2">
                    <span className="text-[10px] text-gray-500 w-2.5 text-right">{s}</span>
                    <Star size={9} className="fill-[#FFA500] text-[#FFA500] flex-shrink-0" />
                    <div className="flex-1 h-1.5 bg-gray-100 rounded-full overflow-hidden">
                      <div className="h-full bg-[#FFA500] rounded-full" style={{ width:`${pct}%` }} />
                    </div>
                    <span className="text-[10px] text-gray-400 w-6">{pct}%</span>
                  </div>
                );
              })}
            </div>
          </div>
          {mockReviews.slice(0,2).map(r => <ReviewCard key={r.id} review={r} />)}
          <button onClick={() => nav("vessel-reviews")} className="w-full mt-3 text-xs text-[#005BC5] font-semibold flex items-center justify-center gap-1 py-2 rounded-xl hover:bg-[#005BC5]/5 transition-all">
            Ver todas as 127 avaliações <ChevronRight size={13} />
          </button>
        </div>
        <Btn full size="lg" onClick={() => nav("purchase")}>Comprar Passagem <ArrowRight size={18} /></Btn>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 11 – VESSEL TRIPS
// ─────────────────────────────────────────────────────────────
const VesselTripsScreen = ({ nav }: { nav:(s:Screen)=>void }) => (
  <div className="flex flex-col h-full bg-[#F1F1F1]">
    <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
      <StatusBar />
      <div className="flex items-center gap-3 mt-1">
        <button onClick={() => nav("vessel")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
        <div><M className="font-bold text-sm text-gray-800">Barco Amazonas I</M><p className="text-xs text-gray-500">Próximas viagens</p></div>
      </div>
    </div>
    <div className="flex-1 overflow-y-auto px-4 py-4">
      {mockTrips.map(t => (
        <div key={t.id} className="bg-white rounded-3xl p-4 shadow-sm mb-3 flex gap-3">
          <div className="w-12 h-12 rounded-2xl bg-[#005BC5]/10 flex items-center justify-center flex-shrink-0"><Ship size={22} className="text-[#005BC5]" /></div>
          <div className="flex-1">
            <p className="text-sm font-bold text-gray-800">{t.origin} → {t.destination}</p>
            <p className="text-xs text-gray-500 mt-0.5">{t.date} · Saída: {t.time} · {t.duration}</p>
            <div className="flex items-center gap-2 mt-2">
              <Badge c={t.seats===0?"red":t.seats<=4?"orange":"teal"}>{t.seats===0?"Esgotado":`${t.seats} vagas`}</Badge>
              <span className="text-[#005BC5] font-bold text-sm">R$ {t.price}</span>
            </div>
          </div>
          {t.seats > 0 && <Btn size="sm" onClick={() => nav("purchase")}>Comprar</Btn>}
        </div>
      ))}
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 11b – VESSEL REVIEWS
// ─────────────────────────────────────────────────────────────
const VesselReviewsScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [showForm, setShowForm] = useState(false);
  const [myRating, setMyRating] = useState(0);
  const [myComment, setMyComment] = useState("");
  const [submitted, setSubmitted] = useState(false);
  const [reviews, setReviews] = useState(mockReviews);
  const [sort, setSort] = useState<"recentes"|"uteis"|"nota">("recentes");
  const avg = (reviews.reduce((a,r) => a+r.rating, 0) / reviews.length).toFixed(1);

  const submit = () => {
    if (!myRating || !myComment.trim()) return;
    setReviews(prev => [{
      id: prev.length+1, user:"Você", avatar:"V", rating:myRating,
      date: new Date().toLocaleDateString("pt-BR"), comment:myComment, helpful:0,
    }, ...prev]);
    setSubmitted(true); setShowForm(false); setMyRating(0); setMyComment("");
  };

  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("vessel")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <div>
            <M className="font-bold text-base text-gray-800">Avaliações</M>
            <p className="text-xs text-gray-500">Barco Amazonas I</p>
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 flex flex-col gap-4 pb-6">
        {/* Summary */}
        <div className="bg-white rounded-3xl p-5 shadow-sm">
          <div className="flex items-center gap-5">
            <div className="text-center flex-shrink-0">
              <M className="text-5xl font-black text-gray-900">{avg}</M>
              <StarRating value={Math.round(Number(avg))} size={16} />
              <p className="text-xs text-gray-400 mt-1">{reviews.length} avaliações</p>
            </div>
            <div className="flex-1 flex flex-col gap-2">
              {[5,4,3,2,1].map(s => {
                const count = reviews.filter(r => r.rating === s).length;
                const pct = Math.round((count/reviews.length)*100);
                return (
                  <div key={s} className="flex items-center gap-2">
                    <span className="text-xs text-gray-500 w-3 text-right">{s}</span>
                    <Star size={10} className="fill-[#FFA500] text-[#FFA500] flex-shrink-0" />
                    <div className="flex-1 h-2 bg-gray-100 rounded-full overflow-hidden">
                      <div className="h-full bg-[#FFA500] rounded-full transition-all" style={{ width:`${pct}%` }} />
                    </div>
                    <span className="text-[10px] text-gray-400 w-7">{count}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Write review */}
        {submitted && (
          <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-3 flex items-center gap-2">
            <CheckCircle size={16} className="text-emerald-600" />
            <p className="text-xs text-emerald-700 font-semibold">Obrigado! Sua avaliação foi publicada.</p>
          </div>
        )}
        {!showForm
          ? <Btn full variant="outline" onClick={() => setShowForm(true)}><Star size={14} />Escrever uma avaliação</Btn>
          : (
            <div className="bg-white rounded-3xl p-4 shadow-sm flex flex-col gap-3">
              <M className="font-bold text-sm text-gray-800">Sua avaliação</M>
              <div className="flex items-center gap-3">
                <span className="text-xs text-gray-500">Nota:</span>
                <StarRating value={myRating} onChange={setMyRating} size={22} />
                {myRating > 0 && <span className="text-xs font-semibold text-[#FFA500]">{["","Ruim","Regular","Bom","Ótimo","Excelente"][myRating]}</span>}
              </div>
              <textarea
                value={myComment}
                onChange={e => setMyComment(e.target.value)}
                placeholder="Conte sua experiência a bordo... (mín. 20 caracteres)"
                className="w-full border border-gray-200 rounded-2xl p-3 text-sm text-gray-700 placeholder-gray-400 outline-none focus:border-[#005BC5] focus:ring-2 focus:ring-[#005BC5]/15 resize-none"
                rows={4}
              />
              <div className="flex gap-2">
                <Btn variant="outline" full size="sm" onClick={() => { setShowForm(false); setMyRating(0); setMyComment(""); }}>Cancelar</Btn>
                <Btn full size="sm" disabled={!myRating || myComment.trim().length < 20} onClick={submit}>Publicar avaliação</Btn>
              </div>
            </div>
          )
        }

        {/* Sort */}
        <div className="flex gap-2">
          <span className="text-xs text-gray-500 self-center">Ordenar:</span>
          {(["recentes","uteis","nota"] as const).map(s => (
            <Chip key={s} active={sort===s} onClick={() => setSort(s)}>
              {s==="recentes"?"Mais recentes":s==="uteis"?"Mais úteis":"Melhor nota"}
            </Chip>
          ))}
        </div>

        {/* Reviews list */}
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          {reviews
            .slice()
            .sort((a,b) => sort==="nota" ? b.rating-a.rating : sort==="uteis" ? b.helpful-a.helpful : b.id-a.id)
            .map(r => <ReviewCard key={r.id} review={r} />)
          }
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 12 – PURCHASE
// ─────────────────────────────────────────────────────────────
const PurchaseScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [pass, setPass] = useState({ name:"", cpf:"" });
  const [errs, setErrs] = useState<Record<string,string>>({});
  const [depIdx, setDepIdx] = useState(0);
  const [arrIdx, setArrIdx] = useState(routeStops.length - 1);
  const validate = () => { const e:Record<string,string>={}; if(!pass.name) e.name="Nome obrigatório"; if(!pass.cpf||pass.cpf.replace(/\D/g,"").length<11) e.cpf="CPF inválido"; return e; };
  const fmtCPF = (v:string) => v.replace(/\D/g,"").replace(/(\d{3})(\d)/,"$1.$2").replace(/(\d{3})\.(\d{3})(\d)/,"$1.$2.$3").replace(/(\d{3})\.(\d{3})\.(\d{3})(\d)/,"$1.$2.$3-$4").slice(0,14);
  const trip = mockTrips[1];
  const dep = routeStops[depIdx];
  const arr = routeStops[arrIdx];
  const priceDiff = Math.max(0, arr.priceMult - dep.priceMult);
  const finalPrice = Math.round(trip.price * priceDiff) || Math.round(trip.price * 0.1);

  const StopButton = ({ idx, selected, type }: { idx:number; selected:boolean; type:"dep"|"arr" }) => {
    const s = routeStops[idx];
    const disabled = type==="arr" ? idx <= depIdx : type==="dep" ? idx >= arrIdx : false;
    return (
      <button
        onClick={() => { if(disabled) return; if(type==="dep"){setDepIdx(idx); if(arrIdx<=idx) setArrIdx(idx+1);} else setArrIdx(idx); }}
        className={cn("flex items-center gap-3 p-2.5 rounded-xl border-2 transition-all text-left", selected ? "border-[#005BC5] bg-[#005BC5]/5" : disabled ? "border-gray-100 opacity-40 cursor-not-allowed" : "border-gray-100 hover:border-[#005BC5]/40")}
      >
        <div className={cn("w-7 h-7 rounded-full border-2 flex items-center justify-center flex-shrink-0", selected ? "border-[#005BC5] bg-[#005BC5]" : "border-gray-300")}>
          {selected ? <Check size={12} className="text-white" /> : <span className="text-[9px] text-gray-400 font-bold">{idx}</span>}
        </div>
        <div className="flex-1">
          <p className="text-xs font-semibold text-gray-800">{s.name}</p>
          <p className="text-[10px] text-gray-500">{s.etaFrom !== "Partida" ? `${s.etaFrom} do início` : "Origem da rota"}</p>
        </div>
        {type==="arr" && !disabled && idx > depIdx && (
          <M className="text-xs font-bold text-[#005BC5]">R$ {Math.round(trip.price * Math.max(0, s.priceMult - dep.priceMult)) || "-"}</M>
        )}
      </button>
    );
  };

  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("results")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Dados da Viagem</M>
        </div>
        <div className="flex justify-between mt-3">{["Passageiro","Acomodação","Pagamento"].map((s,i) => <div key={s} className="flex flex-col items-center gap-1"><div className={cn("w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold", i===0 ? "bg-[#005BC5] text-white" : "bg-gray-100 text-gray-400")}>{i+1}</div><span className="text-[9px] text-gray-500">{s}</span></div>)}</div>
      </div>
      <div className="px-4 py-4 flex flex-col gap-4 pb-6">
        {/* Trip summary */}
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Resumo da Viagem</SectionTitle>
          <div className="bg-gradient-to-r from-[#005BC5]/8 to-[#0084FC]/5 rounded-2xl p-3 flex gap-3">
            <img src={trip.img} alt={trip.vessel} className="w-16 h-16 rounded-2xl object-cover" />
            <div className="flex-1">
              <M className="font-bold text-sm text-gray-800">{trip.vessel}</M>
              <p className="text-xs text-gray-500 mt-0.5">{trip.origin} → {trip.destination}</p>
              <p className="text-xs text-gray-500">{trip.date} · {trip.time}</p>
              <div className="flex items-center gap-2 mt-1.5">
                <span className="text-[10px] text-gray-500 bg-[#005BC5]/10 px-2 py-0.5 rounded-full font-medium">{dep.name}</span>
                <ArrowRight size={10} className="text-gray-400" />
                <span className="text-[10px] text-gray-500 bg-emerald-100 px-2 py-0.5 rounded-full font-medium">{arr.name}</span>
                <M className="text-[#005BC5] font-bold text-sm ml-auto">R$ {finalPrice}</M>
              </div>
            </div>
          </div>
        </div>

        {/* Embarkation + Disembarkation */}
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <div className="flex items-center gap-2 mb-1">
            <div className="w-5 h-5 rounded-full bg-[#005BC5] flex items-center justify-center flex-shrink-0"><MapPin size={11} className="text-white" /></div>
            <M className="font-bold text-sm text-gray-800">Ponto de Embarque</M>
          </div>
          <p className="text-xs text-gray-500 mb-3 ml-7">Onde você entra na embarcação</p>
          <div className="flex flex-col gap-1.5 mb-5">
            {routeStops.slice(0, -1).map((_,i) => <StopButton key={i} idx={i} selected={depIdx===i} type="dep" />)}
          </div>

          <div className="flex items-center gap-2 mb-1">
            <div className="w-5 h-5 rounded-full bg-emerald-500 flex items-center justify-center flex-shrink-0"><MapPin size={11} className="text-white" /></div>
            <M className="font-bold text-sm text-gray-800">Ponto de Desembarque</M>
          </div>
          <p className="text-xs text-gray-500 mb-3 ml-7">Onde você sai — apenas paradas após o embarque</p>
          <div className="flex flex-col gap-1.5">
            {routeStops.slice(1).map((_,i) => <StopButton key={i+1} idx={i+1} selected={arrIdx===i+1} type="arr" />)}
          </div>

          {dep.name !== "Manaus" || arr.name !== "Parintins" ? (
            <div className="mt-3 bg-[#FFA500]/10 border border-[#FFA500]/30 rounded-xl p-2.5 flex gap-2">
              <Info size={13} className="text-[#cc8400] flex-shrink-0 mt-0.5" />
              <p className="text-[10px] text-[#cc8400]">Trecho personalizado: <strong>{dep.name} → {arr.name}</strong>. O valor é proporcional à distância percorrida.</p>
            </div>
          ) : null}
        </div>

        {/* Passenger data */}
        <div className="bg-white rounded-3xl p-4 shadow-sm flex flex-col gap-3">
          <SectionTitle>Dados do Passageiro</SectionTitle>
          <Fld label="Nome Completo" placeholder="Como no documento" value={pass.name} onChange={e=>setPass(p=>({...p,name:e.target.value}))} error={errs.name} icon={<User size={16} />} />
          <Fld label="CPF" placeholder="000.000.000-00" value={pass.cpf} onChange={e=>setPass(p=>({...p,cpf:fmtCPF(e.target.value)}))} error={errs.cpf} icon={<FileText size={16} />} maxLength={14} />
        </div>
        <Btn full size="lg" onClick={() => { const e=validate(); if(Object.keys(e).length){setErrs(e);return;} nav("accommodation"); }}>Escolher Acomodação <ArrowRight size={18} /></Btn>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 13 – ACCOMMODATION SELECTION
// ─────────────────────────────────────────────────────────────
const accommodationTypes = [
  { id: "rede", label: "Rede", desc: "Rede confortável no convés. Ventilação natural e visão privilegiada do rio.", price: 0, extra: "+R$ 0", available: 28, icon: "🛏️" },
  { id: "camarote", label: "Camarote", desc: "Cabine privativa com cama, ar-condicionado e tomada USB. Máximo conforto.", price: 120, extra: "+R$ 120", available: 4, icon: "🚪" },
];

const AccommodationScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [selected, setSelected] = useState("rede");
  const acc = accommodationTypes.find(a => a.id === selected)!;
  const basePrice = 95;
  const total = basePrice + acc.price;
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("purchase")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Escolher Acomodação</M>
        </div>
        <div className="flex justify-between mt-3">{["Passageiro","Acomodação","Pagamento"].map((s,i) => <div key={s} className="flex flex-col items-center gap-1"><div className={cn("w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold", i===1 ? "bg-[#005BC5] text-white" : i<1 ? "bg-emerald-500 text-white" : "bg-gray-100 text-gray-400")}>{i<1?<Check size={12}/>:i+1}</div><span className="text-[9px] text-gray-500">{s}</span></div>)}</div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4">
        <div className="flex flex-col gap-3 mb-4">
          {accommodationTypes.map(a => (
            <button key={a.id} onClick={() => setSelected(a.id)} className={cn("bg-white rounded-3xl p-4 shadow-sm border-2 transition-all text-left", selected===a.id ? "border-[#005BC5]" : "border-transparent")}>
              <div className="flex items-start gap-3">
                <span className="text-3xl">{a.icon}</span>
                <div className="flex-1">
                  <div className="flex items-center justify-between mb-1">
                    <M className="font-bold text-base text-gray-900">{a.label}</M>
                    <div className="text-right">
                      <M className={cn("font-bold text-sm", a.price===0 ? "text-emerald-600" : "text-[#005BC5]")}>{a.price===0 ? "Incluso" : a.extra}</M>
                      <p className="text-[10px] text-gray-400">{a.available} disponíveis</p>
                    </div>
                  </div>
                  <p className="text-xs text-gray-500 leading-relaxed">{a.desc}</p>
                </div>
              </div>
              {selected===a.id && <div className="mt-3 bg-[#005BC5]/10 rounded-xl p-2 flex items-center gap-2"><Check size={14} className="text-[#005BC5]" /><span className="text-xs text-[#005BC5] font-semibold">{a.label} selecionado — Total: R$ {total}</span></div>}
            </button>
          ))}
        </div>
        <Btn full size="lg" onClick={() => nav("summary")}>Confirmar — R$ {total} <ArrowRight size={18} /></Btn>
      </div>
    </div>
  );
};

const SeatsScreen = ({ nav }: { nav:(s:Screen)=>void }) => <AccommodationScreen nav={nav} />;

// ─────────────────────────────────────────────────────────────
// SCREEN 14 – SUMMARY
// ─────────────────────────────────────────────────────────────
const SummaryScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const trip = mockTrips[0];
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("seats")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Resumo da Compra</M>
        </div>
      </div>
      <div className="px-4 py-4 flex flex-col gap-4 pb-6">
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Detalhes da Viagem</SectionTitle>
          <div className="flex flex-col gap-2.5">
            {[["Embarcação",trip.vessel],["Rota",`${trip.origin} → ${trip.destination}`],["Data",trip.date],["Horário",trip.time],["Duração",trip.duration],["Acomodação","Rede — Convés Principal"],["Desembarque","Parintins"]].map(([l,v]) => (
              <div key={l} className="flex justify-between items-center"><span className="text-xs text-gray-500">{l}</span><span className="text-xs font-semibold text-gray-800">{v}</span></div>
            ))}
          </div>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Passageiro</SectionTitle>
          {[["Nome","Ana Carolina Souza"],["CPF","***.***.***-45"]].map(([l,v]) => (
            <div key={l} className="flex justify-between items-center py-1"><span className="text-xs text-gray-500">{l}</span><span className="text-xs font-semibold text-gray-800">{v}</span></div>
          ))}
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Valores</SectionTitle>
          {[["Passagem","R$ 180,00"],["Taxa de serviço","R$ 5,00"]].map(([l,v]) => (
            <div key={l} className="flex justify-between items-center py-1"><span className="text-xs text-gray-500">{l}</span><span className="text-xs text-gray-700">{v}</span></div>
          ))}
          <div className="border-t border-gray-100 mt-2 pt-2 flex justify-between items-center"><span className="text-sm font-bold text-gray-800">Total</span><M className="text-base font-black text-[#005BC5]">R$ 185,00</M></div>
        </div>
        <Btn full size="lg" onClick={() => nav("payment")}>Ir para Pagamento <ArrowRight size={18} /></Btn>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 15 – PAYMENT METHOD
// ─────────────────────────────────────────────────────────────
const PaymentScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [method, setMethod] = useState("pix"); const [loading, setLoading] = useState(false);
  const methods = [["pix","PIX","Aprovação instantânea · Sem taxas",QrCode],["credit","Cartão de Crédito","Taxa de 2% sobre o valor total",CreditCard],["boleto","Boleto Bancário","Vencimento em 1 dia útil · Sem taxas",FileText]];
  const go = () => { setLoading(true); setTimeout(() => { setLoading(false); nav(method==="pix"?"pix":method==="credit"?"credit-card":"boleto"); }, 1000); };
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("summary")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Forma de Pagamento</M>
        </div>
        <div className="flex justify-between mt-3">{["Passageiro","Assento","Pagamento"].map((s,i) => <div key={s} className="flex flex-col items-center gap-1"><div className={cn("w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold", i===2 ? "bg-[#005BC5] text-white" : "bg-emerald-500 text-white")}>{i<2?<Check size={12}/>:3}</div><span className="text-[9px] text-gray-500">{s}</span></div>)}</div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4">
        <div className="bg-white rounded-3xl p-4 shadow-sm mb-4">
          <div className="flex justify-between items-center mb-4 pb-3 border-b border-gray-100"><span className="text-sm text-gray-500">Total a pagar</span><M className="text-xl font-black text-[#005BC5]">R$ 185,00</M></div>
          <SectionTitle>Selecione o método</SectionTitle>
          <div className="flex flex-col gap-2">
            {methods.map(([id,label,sub,Icon]) => (
              <button key={id} onClick={() => setMethod(id)} className={cn("flex items-center gap-3 p-3.5 rounded-2xl border-2 transition-all text-left", method===id ? "border-[#005BC5] bg-[#005BC5]/5" : "border-gray-100 bg-white hover:border-gray-200")}>
                <div className={cn("w-10 h-10 rounded-xl flex items-center justify-center", method===id ? "bg-[#005BC5]" : "bg-gray-100")}>
                  <Icon size={20} className={method===id ? "text-white" : "text-gray-500"} />
                </div>
                <div className="flex-1"><p className="text-sm font-semibold text-gray-800">{label}</p><p className="text-xs text-gray-500 mt-0.5">{sub}</p></div>
                <div className={cn("w-5 h-5 rounded-full border-2 flex items-center justify-center", method===id ? "border-[#005BC5]" : "border-gray-300")}>{method===id && <div className="w-2.5 h-2.5 rounded-full bg-[#005BC5]" />}</div>
              </button>
            ))}
          </div>
        </div>
        <Btn full size="lg" loading={loading} onClick={go}>{loading ? "Processando..." : "Confirmar Pagamento"}</Btn>
        <p className="text-center text-[10px] text-gray-400 mt-3 flex items-center justify-center gap-1"><Shield size={10} />Ambiente seguro — dados protegidos com SSL</p>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 16 – PIX
// ─────────────────────────────────────────────────────────────
const PixScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [sec, setSec] = useState(600); const [copied, setCopied] = useState(false);
  useEffect(() => { const t = setInterval(() => setSec(s => { if (s<=1) { clearInterval(t); return 0; } return s-1; }), 1000); return () => clearInterval(t); }, []);
  const mm = String(Math.floor(sec/60)).padStart(2,"0"); const ss = String(sec%60).padStart(2,"0");
  const pixCode = "00020126330014BR.GOV.BCB.PIX0111928376451520400005303986540518.505802BR5924PORTO CERTO VIAGENS S6009SAO PAULO62090505*3***6304D1A4";
  const expired = sec === 0;
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("payment")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Pagar com PIX</M>
        </div>
      </div>
      <div className="px-4 py-4 flex flex-col gap-4 pb-6">
        {expired ? (
          <div className="bg-white rounded-3xl p-6 shadow-sm flex flex-col items-center gap-4">
            <div className="w-16 h-16 rounded-full bg-red-100 flex items-center justify-center"><XCircle size={32} className="text-red-500" /></div>
            <M className="font-bold text-gray-800 text-lg">PIX Expirado</M>
            <p className="text-sm text-gray-500 text-center">O tempo para pagamento expirou. Gere um novo código para continuar.</p>
            <Btn full onClick={() => { setSec(600); }}>Gerar Novo PIX <RefreshCw size={16} /></Btn>
          </div>
        ) : (
          <>
            <div className="bg-white rounded-3xl p-5 shadow-sm flex flex-col items-center gap-4">
              <div className={cn("flex items-center gap-2 px-4 py-2 rounded-full font-bold text-sm", sec<=60?"bg-red-100 text-red-600":"bg-[#FFA500]/15 text-[#cc8400]")}>
                <Clock size={14} />{mm}:{ss}
              </div>
              <div className="bg-white border-2 border-gray-200 rounded-2xl p-3 shadow-inner">
                <svg viewBox="0 0 200 200" className="w-44 h-44">
                  {Array.from({length:20},(_,r) => Array.from({length:20},(_,c) => (Math.random()>0.5) && <rect key={`${r}-${c}`} x={c*10} y={r*10} width="9" height="9" fill="#005BC5" rx="1.5" opacity={0.7+Math.random()*0.3} />))}
                  <rect x="0" y="0" width="50" height="50" fill="none" stroke="#005BC5" strokeWidth="5" rx="4" />
                  <rect x="10" y="10" width="30" height="30" fill="#005BC5" rx="2" />
                  <rect x="150" y="0" width="50" height="50" fill="none" stroke="#005BC5" strokeWidth="5" rx="4" />
                  <rect x="160" y="10" width="30" height="30" fill="#005BC5" rx="2" />
                  <rect x="0" y="150" width="50" height="50" fill="none" stroke="#005BC5" strokeWidth="5" rx="4" />
                  <rect x="10" y="160" width="30" height="30" fill="#005BC5" rx="2" />
                </svg>
              </div>
              <M className="text-[#005BC5] font-bold text-xl">R$ 185,00</M>
              <p className="text-xs text-gray-500 text-center">Abra seu banco e escaneie o QR Code para pagar</p>
            </div>
            <div className="bg-white rounded-3xl p-4 shadow-sm">
              <p className="text-xs text-gray-500 mb-2 font-medium">Código Copia e Cola</p>
              <div className="bg-gray-50 rounded-2xl p-3 flex items-center gap-2">
                <p className="flex-1 text-[10px] text-gray-600 break-all font-mono leading-relaxed">{pixCode.slice(0,60)}...</p>
                <button onClick={() => { navigator.clipboard?.writeText(pixCode).catch(()=>{}); setCopied(true); setTimeout(()=>setCopied(false),2000); }} className="flex-shrink-0 flex items-center gap-1 bg-[#005BC5] text-white text-xs px-3 py-1.5 rounded-xl font-semibold">
                  {copied ? <><Check size={12}/>Copiado</> : <><Copy size={12}/>Copiar</>}
                </button>
              </div>
            </div>
            <div className="bg-amber-50 border border-amber-200 rounded-2xl p-3 flex gap-2">
              <AlertCircle size={14} className="text-amber-500 mt-0.5 flex-shrink-0" />
              <p className="text-xs text-amber-700">Após o pagamento, a confirmação é automática. Não feche este app.</p>
            </div>
            <Btn full variant="ghost" onClick={() => nav("approved")}>Simular Pagamento Aprovado</Btn>
          </>
        )}
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 17 – BOLETO
// ─────────────────────────────────────────────────────────────
const BoletoScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [copied, setCopied] = useState(false);
  const [simState, setSimState] = useState<"idle"|"processing"|"approved"|"expired">("idle");
  const barcode = "23793.38128 60007.827136 96000.063305 6 95660000018500";

  const simulate = (result: "approved"|"expired") => {
    setSimState("processing");
    setTimeout(() => setSimState(result), 1800);
  };

  if (simState === "processing") return (
    <div className="flex flex-col h-full bg-white items-center justify-center gap-4">
      <div className="w-20 h-20 rounded-full bg-[#005BC5]/10 flex items-center justify-center"><Loader2 size={40} className="text-[#005BC5] animate-spin" /></div>
      <M className="font-bold text-gray-800">Verificando pagamento...</M>
      <p className="text-xs text-gray-500">Consultando compensação bancária.</p>
    </div>
  );

  if (simState === "approved") return (
    <div className="flex flex-col h-full bg-white items-center justify-center px-6 gap-5">
      <div className="relative w-24 h-24"><div className="absolute inset-0 rounded-full bg-emerald-100 animate-ping opacity-30" /><div className="w-24 h-24 rounded-full bg-emerald-500 flex items-center justify-center relative"><CheckCircle size={48} className="text-white" /></div></div>
      <div className="text-center"><M className="font-black text-xl text-gray-900">Pagamento Confirmado!</M><p className="text-gray-500 text-sm mt-2">Boleto compensado com sucesso. Sua passagem foi confirmada.</p></div>
      <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 w-full">
        <div className="flex justify-between mb-2"><span className="text-xs text-gray-500">Código de reserva</span><M className="font-bold text-emerald-700 text-sm">#PCB-20260626-5831</M></div>
        <div className="flex justify-between"><span className="text-xs text-gray-500">Total pago</span><span className="text-sm font-bold text-gray-800">R$ 185,00</span></div>
      </div>
      <Btn full size="lg" onClick={() => nav("ticket")}>Ver Bilhete Digital <Ticket size={18} /></Btn>
      <Btn full variant="outline" onClick={() => nav("home")}>Voltar para Início</Btn>
    </div>
  );

  if (simState === "expired") return (
    <div className="flex flex-col h-full bg-white items-center justify-center px-6 gap-5">
      <div className="w-24 h-24 rounded-full bg-red-100 flex items-center justify-center"><XCircle size={48} className="text-red-500" /></div>
      <div className="text-center"><M className="font-black text-xl text-gray-900">Boleto Vencido</M><p className="text-gray-500 text-sm mt-2 leading-relaxed">O prazo de pagamento expirou e a reserva foi cancelada. Gere um novo boleto para continuar.</p></div>
      <Btn full onClick={() => setSimState("idle")} variant="outline">Gerar novo boleto <RefreshCw size={16} /></Btn>
      <Btn full variant="ghost" onClick={() => nav("payment")}>Escolher outro método</Btn>
    </div>
  );

  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("payment")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Boleto Bancário</M>
        </div>
      </div>
      <div className="px-4 py-4 flex flex-col gap-4 pb-6">
        <div className="bg-white rounded-3xl p-5 shadow-sm flex flex-col items-center gap-4">
          <M className="text-[#005BC5] font-bold text-xl">R$ 185,00</M>
          <p className="text-xs text-gray-500 flex items-center gap-1"><Calendar size={12} />Vencimento: <strong>26/06/2026</strong></p>
          <div className="w-full bg-gray-50 rounded-2xl p-4">
            <svg viewBox="0 0 280 60" className="w-full" style={{ height: 60 }}>
              {Array.from({length:80},(_,i)=><rect key={i} x={i*3.5} y={Math.random()>0.4?0:10} width={Math.random()>0.3?2:1} height={Math.random()>0.4?55:45} fill="#1a1a1a" />)}
            </svg>
            <p className="text-[10px] font-mono text-center text-gray-600 mt-2 break-all">{barcode}</p>
          </div>
          <div className="w-full flex gap-2">
            <button onClick={() => { navigator.clipboard?.writeText(barcode).catch(()=>{}); setCopied(true); setTimeout(()=>setCopied(false),2000); }} className="flex-1 flex items-center justify-center gap-2 bg-[#005BC5]/10 text-[#005BC5] font-semibold text-sm px-4 py-3 rounded-2xl">
              {copied ? <><Check size={14}/>Copiado</> : <><Copy size={14}/>Copiar código</>}
            </button>
            <button className="flex items-center justify-center gap-2 bg-[#008B8B]/10 text-[#008B8B] font-semibold text-sm px-4 py-3 rounded-2xl"><Download size={16} />PDF</button>
          </div>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm flex flex-col gap-2">
          {[["Beneficiário","Porto Certo Viagens LTDA"],["CNPJ","12.345.678/0001-90"],["Banco","Banco do Brasil"],["Agência","0001-9"],["Conta","12345-6"]].map(([l,v]) => (
            <div key={l} className="flex justify-between items-center py-1 border-b border-gray-50 last:border-0"><span className="text-xs text-gray-500">{l}</span><span className="text-xs font-semibold text-gray-800">{v}</span></div>
          ))}
        </div>
        <div className="bg-amber-50 border border-amber-200 rounded-2xl p-3 flex gap-2">
          <AlertCircle size={14} className="text-amber-500 mt-0.5 flex-shrink-0" />
          <p className="text-xs text-amber-700">O boleto vence em <strong>1 dia útil</strong>. Após o vencimento, a reserva é cancelada automaticamente.</p>
        </div>
        <div className="flex gap-2">
          <Btn full variant="ghost" onClick={() => simulate("approved")}>Simular Pagamento Aprovado</Btn>
          <Btn full variant="ghost" onClick={() => simulate("expired")}>Simular Vencimento</Btn>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 17b – CREDIT CARD
// ─────────────────────────────────────────────────────────────
const CreditCardScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [f, setF] = useState({ name:"", number:"", expiry:"", cvv:"" });
  const [state, setState] = useState<"form"|"processing"|"approved"|"declined"|"insufficient"|"invalid">("form");
  const [errs, setErrs] = useState<Record<string,string>>({});
  const fmtCard = (v:string) => v.replace(/\D/g,"").replace(/(\d{4})/g,"$1 ").trim().slice(0,19);
  const fmtExpiry = (v:string) => v.replace(/\D/g,"").replace(/(\d{2})(\d)/,"$1/$2").slice(0,5);
  const upd = (k:string) => (e:React.ChangeEvent<HTMLInputElement>) => setF(p=>({...p,[k]:e.target.value}));
  const submit = () => {
    const e:Record<string,string>={};
    if(!f.name) e.name="Nome obrigatório";
    if(f.number.replace(/\s/g,"").length<16) e.number="Número inválido";
    if(!f.expiry||f.expiry.length<5) e.expiry="Data inválida";
    if(f.cvv.length<3) e.cvv="CVV inválido";
    if(Object.keys(e).length){setErrs(e);return;}
    setErrs({});
    setState("processing");
    setTimeout(() => setState("approved"), 2000);
  };
  if(state==="processing") return (
    <div className="flex flex-col h-full bg-white items-center justify-center gap-4">
      <div className="w-20 h-20 rounded-full bg-[#005BC5]/10 flex items-center justify-center"><Loader2 size={40} className="text-[#005BC5] animate-spin" /></div>
      <M className="font-bold text-gray-800">Processando pagamento...</M>
      <p className="text-xs text-gray-500">Aguarde, estamos verificando seus dados.</p>
    </div>
  );
  if(state==="approved") return (
    <div className="flex flex-col h-full bg-white items-center justify-center px-6 gap-5">
      <div className="relative w-24 h-24"><div className="absolute inset-0 rounded-full bg-emerald-100 animate-ping opacity-30" /><div className="w-24 h-24 rounded-full bg-emerald-500 flex items-center justify-center relative"><CheckCircle size={48} className="text-white" /></div></div>
      <div className="text-center"><M className="font-black text-xl text-gray-900">Pagamento Aprovado!</M><p className="text-gray-500 text-sm mt-2">Sua passagem foi confirmada. Boa viagem!</p></div>
      <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 w-full">
        <div className="flex justify-between mb-2"><span className="text-xs text-gray-500">Código de reserva</span><M className="font-bold text-emerald-700 text-sm">#PCB-20260626-5831</M></div>
        <div className="flex justify-between"><span className="text-xs text-gray-500">Total pago</span><span className="text-sm font-bold text-gray-800">R$ 188,90</span></div>
      </div>
      <Btn full size="lg" onClick={() => nav("ticket")}>Ver Bilhete Digital <Ticket size={18} /></Btn>
      <Btn full variant="outline" onClick={() => nav("home")}>Voltar para Início</Btn>
    </div>
  );
  if(state==="declined") return (
    <div className="flex flex-col h-full bg-white items-center justify-center px-6 gap-5">
      <div className="w-24 h-24 rounded-full bg-red-100 flex items-center justify-center"><XCircle size={48} className="text-red-500" /></div>
      <div className="text-center"><M className="font-black text-xl text-gray-900">Cartão Recusado</M><p className="text-gray-500 text-sm mt-2">Seu cartão foi recusado pela operadora. Tente outro cartão ou forma de pagamento.</p></div>
      <Btn full onClick={() => setState("form")}>Tentar novamente</Btn>
      <Btn full variant="outline" onClick={() => nav("payment")}>Escolher outro método</Btn>
    </div>
  );
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("payment")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Cartão de Crédito</M>
        </div>
      </div>
      <div className="px-4 py-4 flex flex-col gap-4 pb-6">
        <div className="bg-gradient-to-br from-[#003a8c] to-[#005BC5] rounded-3xl p-5 text-white shadow-lg">
          <div className="flex justify-between items-start mb-6">
            <Waves size={24} className="text-white/80" />
            <CreditCard size={24} className="text-white/80" />
          </div>
          <p className="font-mono text-lg tracking-widest mb-3">{f.number || "•••• •••• •••• ••••"}</p>
          <div className="flex justify-between items-end">
            <div><p className="text-white/60 text-[10px] uppercase tracking-wide">Nome</p><p className="font-bold text-sm">{f.name || "NOME NO CARTÃO"}</p></div>
            <div><p className="text-white/60 text-[10px] uppercase tracking-wide">Validade</p><p className="font-bold text-sm">{f.expiry || "MM/AA"}</p></div>
          </div>
        </div>
        <div className="bg-amber-50 border border-amber-200 rounded-2xl p-3 flex gap-2">
          <AlertCircle size={14} className="text-amber-500 mt-0.5 flex-shrink-0" />
          <p className="text-xs text-amber-700">Taxa de <strong>2%</strong> aplicada para pagamentos via cartão. Total: <strong>R$ 188,90</strong></p>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm flex flex-col gap-3">
          <Fld label="Nome no Cartão" placeholder="Como está no cartão" value={f.name} onChange={upd("name")} error={errs.name} icon={<User size={16} />} />
          <Fld label="Número do Cartão" placeholder="0000 0000 0000 0000" value={f.number} onChange={e=>setF(p=>({...p,number:fmtCard(e.target.value)}))} error={errs.number} icon={<CreditCard size={16} />} maxLength={19} />
          <div className="grid grid-cols-2 gap-3">
            <Fld label="Validade" placeholder="MM/AA" value={f.expiry} onChange={e=>setF(p=>({...p,expiry:fmtExpiry(e.target.value)}))} error={errs.expiry} icon={<Calendar size={16} />} maxLength={5} />
            <Fld label="CVV" placeholder="•••" value={f.cvv} onChange={upd("cvv")} error={errs.cvv} icon={<Shield size={16} />} maxLength={4} type="password" />
          </div>
        </div>
        <Btn full size="lg" onClick={submit}>Pagar R$ 188,90 <ArrowRight size={18} /></Btn>
        <div className="flex gap-3">
          <Btn full variant="outline" size="sm" onClick={() => setState("declined")}>Simular Recusa</Btn>
        </div>
        <p className="text-center text-[10px] text-gray-400 flex items-center justify-center gap-1"><Shield size={10} />Ambiente seguro — SSL</p>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 18 – PAYMENT REJECTED
// ─────────────────────────────────────────────────────────────
const RejectedScreen = ({ nav }: { nav:(s:Screen)=>void }) => (
  <div className="flex flex-col h-full bg-white">
    <StatusBar />
    <div className="flex-1 flex flex-col items-center justify-center px-6 gap-5">
      <div className="w-24 h-24 rounded-full bg-red-100 flex items-center justify-center"><XCircle size={48} className="text-red-500" /></div>
      <div className="text-center"><M className="font-black text-xl text-gray-900">Pagamento Recusado</M><p className="text-gray-500 text-sm mt-2 leading-relaxed">Seu pagamento não foi processado. Verifique os dados do cartão ou escolha outra forma de pagamento.</p></div>
      <div className="bg-red-50 border border-red-200 rounded-2xl p-4 w-full">
        <p className="text-xs font-bold text-red-700 mb-2">Possíveis causas:</p>
        <ul className="text-xs text-red-600 space-y-1 list-disc list-inside">{["Saldo insuficiente","Dados do cartão incorretos","Limite diário atingido","Cartão bloqueado"].map(c=><li key={c}>{c}</li>)}</ul>
      </div>
      <Btn full size="lg" onClick={() => nav("payment")}>Tentar novamente</Btn>
      <Btn full variant="outline" onClick={() => nav("home")}>Voltar para Início</Btn>
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 19 – PAYMENT APPROVED
// ─────────────────────────────────────────────────────────────
const ApprovedScreen = ({ nav }: { nav:(s:Screen)=>void }) => (
  <div className="flex flex-col h-full bg-white">
    <StatusBar />
    <div className="flex-1 flex flex-col items-center justify-center px-6 gap-5">
      <div className="relative w-24 h-24">
        <div className="absolute inset-0 rounded-full bg-emerald-100 animate-ping opacity-30" />
        <div className="w-24 h-24 rounded-full bg-emerald-500 flex items-center justify-center relative"><CheckCircle size={48} className="text-white" /></div>
      </div>
      <div className="text-center"><M className="font-black text-xl text-gray-900">Pagamento Aprovado!</M><p className="text-gray-500 text-sm mt-2 leading-relaxed">Sua passagem foi confirmada. Boa viagem pela Amazônia!</p></div>
      <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 w-full">
        <div className="flex items-center justify-between mb-2"><span className="text-xs text-gray-500">Código de reserva</span><M className="font-bold text-emerald-700 text-sm">#PCB-20260625-4721</M></div>
        <div className="flex items-center justify-between"><span className="text-xs text-gray-500">Total pago</span><span className="text-sm font-bold text-gray-800">R$ 185,00</span></div>
      </div>
      <Btn full size="lg" onClick={() => nav("ticket")}>Ver Bilhete Digital <Ticket size={18} /></Btn>
      <Btn full variant="outline" onClick={() => nav("home")}>Voltar para Início</Btn>
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 20 – DIGITAL TICKET
// ─────────────────────────────────────────────────────────────
// Demo scenarios for cancel policy
type CancelScenario = "normal" | "late" | "boleto_pending" | "owner_cancel";
const cancelScenarios: Record<CancelScenario, { label:string; hoursUntil:number; payment:string; ownerCancel?:boolean; boletoPending?:boolean }> = {
  normal:         { label:">24h (reembolso total)",   hoursUntil:36,  payment:"PIX" },
  late:           { label:"<24h (multa de 20%)",      hoursUntil:10,  payment:"Cartão" },
  boleto_pending: { label:"Boleto não compensado",    hoursUntil:48,  payment:"Boleto", boletoPending:true },
  owner_cancel:   { label:"Cancelamento pelo proprietário",hoursUntil:30,  payment:"PIX", ownerCancel:true },
};

const TicketScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [cancelState, setCancelState] = useState<"idle"|"confirm"|"processing"|"cancelled">("idle");
  const [scenario, setScenario] = useState<CancelScenario>("normal");
  const sc = cancelScenarios[scenario];

  // Cancellation policy logic
  const isBeyond24h   = sc.hoursUntil > 24;
  const isBoletoPending = !!sc.boletoPending;
  const isOwnerCancel   = !!sc.ownerCancel;
  const canCancelFree   = isBeyond24h || isBoletoPending || isOwnerCancel;
  const retentionFee    = canCancelFree ? 0 : 20; // 20% multa se <24h
  const refundAmt       = canCancelFree ? "R$ 185,00" : "R$ 148,00";
  const refundDays      = isBoletoPending ? "imediato" : sc.payment === "Cartão" ? "7 a 14 dias úteis" : "até 5 dias úteis";

  const policyLabel = isOwnerCancel
    ? "Cancelamento originado pelo proprietário — reembolso integral automático"
    : isBoletoPending
    ? "Boleto ainda não compensado — cancelamento imediato sem ônus"
    : isBeyond24h
    ? "Solicitado com +24h de antecedência — reembolso integral"
    : "Solicitado com menos de 24h do embarque — multa de 20% aplicada";

  const policyColor = canCancelFree ? "text-emerald-700 bg-emerald-50 border-emerald-200" : "text-amber-700 bg-amber-50 border-amber-200";

  const doCancel = () => {
    setCancelState("processing");
    setTimeout(() => setCancelState("cancelled"), 2000);
  };

  // ── Cancelled state ──
  if (cancelState === "cancelled") return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("home")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Cancelamento Confirmado</M>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-6 flex flex-col gap-4 pb-6">
        <div className="flex flex-col items-center gap-3 py-4">
          <div className="w-20 h-20 rounded-full bg-emerald-100 flex items-center justify-center"><CheckCircle size={40} className="text-emerald-600" /></div>
          <M className="font-black text-xl text-gray-900 text-center">Reserva Cancelada</M>
          <p className="text-sm text-gray-500 text-center leading-relaxed">Seu cancelamento foi processado. O comprovante foi enviado para <strong>ana.carol@email.com</strong>.</p>
        </div>

        {/* Receipt */}
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <M className="font-bold text-sm text-gray-800 mb-3">Comprovante de Cancelamento</M>
          {[
            ["Protocolo","#CNC-20260626-8823"],
            ["Reserva","#PCB-20260625-4721"],
            ["Passageiro","Ana Carolina Souza"],
            ["Rota","Manaus → Santarém"],
            ["Data do cancelamento","26/06/2026 – 10:32"],
            ["Forma de pagamento original", sc.payment],
            ["Valor pago","R$ 185,00"],
            ["Retenção",retentionFee > 0 ? `${retentionFee}% (R$ 37,00)` : "Nenhuma"],
            ["Valor a estornar", refundAmt],
            ["Prazo do estorno", refundDays],
          ].map(([l,v]) => (
            <div key={l} className="flex justify-between items-start py-2 border-b border-gray-50 last:border-0">
              <span className="text-xs text-gray-500">{l}</span>
              <span className={cn("text-xs font-semibold text-right max-w-[55%]", l==="Valor a estornar" ? "text-emerald-600" : l==="Retenção" && retentionFee > 0 ? "text-amber-600" : "text-gray-800")}>{v}</span>
            </div>
          ))}
        </div>

        {/* Email notice */}
        <div className="bg-[#005BC5]/8 border border-[#005BC5]/20 rounded-2xl p-3 flex gap-2">
          <Mail size={14} className="text-[#005BC5] flex-shrink-0 mt-0.5" />
          <p className="text-xs text-[#005BC5]">Comprovante enviado para <strong>ana.carol@email.com</strong>. Verifique também sua caixa de spam.</p>
        </div>

        {/* Refund timeline */}
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <M className="font-bold text-sm text-gray-800 mb-3">Prazo do Estorno</M>
          <div className="flex items-start gap-3">
            <div className="flex flex-col items-center">
              <div className="w-8 h-8 rounded-full bg-emerald-500 flex items-center justify-center"><Check size={14} className="text-white" /></div>
              <div className="w-0.5 h-8 bg-gray-200 mt-1" />
              <div className={cn("w-8 h-8 rounded-full flex items-center justify-center", isBoletoPending ? "bg-emerald-500" : "bg-gray-200")}>
                {isBoletoPending ? <Check size={14} className="text-white" /> : <Clock size={14} className="text-gray-400" />}
              </div>
              {!isBoletoPending && <><div className="w-0.5 h-8 bg-gray-200 mt-1" /><div className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center"><CheckCircle size={14} className="text-gray-400" /></div></>}
            </div>
            <div className="flex-1 flex flex-col gap-5 pt-1">
              <div><M className="text-xs font-bold text-gray-800">Cancelamento registrado</M><p className="text-[10px] text-gray-500">Agora mesmo</p></div>
              <div><M className="text-xs font-bold text-gray-800">{isBoletoPending ? "Estorno imediato" : "Estorno em processamento"}</M><p className="text-[10px] text-gray-500">{isBoletoPending ? "Sem custos adicionais" : refundDays}</p></div>
              {!isBoletoPending && <div><M className="text-xs font-bold text-gray-500">Crédito na conta</M><p className="text-[10px] text-gray-400">Depende da instituição financeira</p></div>}
            </div>
          </div>
        </div>

        <Btn full onClick={() => nav("home")}>Voltar para Início</Btn>
        <Btn full variant="outline" onClick={() => nav("search")}>Buscar nova viagem <Search size={14} /></Btn>
      </div>
    </div>
  );

  return (
    <div className="flex flex-col h-full bg-[#F1F1F1] overflow-y-auto">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("home")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Bilhete Digital</M>
        </div>
      </div>

      {/* Confirmation modal overlay */}
      {cancelState === "confirm" && (
        <div className="absolute inset-0 z-50 bg-black/50 flex items-end">
          <div className="bg-white w-full rounded-t-3xl p-5 flex flex-col gap-4 pb-8">
            <div className="w-10 h-1 bg-gray-200 rounded-full mx-auto mb-1" />
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center flex-shrink-0"><AlertCircle size={24} className="text-red-500" /></div>
              <div>
                <M className="font-black text-base text-gray-900">Cancelar Reserva?</M>
                <p className="text-xs text-gray-500 mt-0.5">Esta ação não pode ser desfeita.</p>
              </div>
            </div>

            {/* Policy alert */}
            <div className={cn("border rounded-2xl p-3 flex gap-2", policyColor)}>
              <Info size={13} className="flex-shrink-0 mt-0.5" />
              <p className="text-xs leading-relaxed">{policyLabel}</p>
            </div>

            <div className="bg-gray-50 rounded-2xl p-3 flex flex-col gap-2">
              {[
                ["Reserva","#PCB-20260625-4721"],
                ["Valor pago","R$ 185,00"],
                ["Multa aplicada", retentionFee > 0 ? `${retentionFee}% — R$ 37,00` : "Nenhuma"],
                ["Você recebe", refundAmt],
                ["Prazo de estorno", refundDays],
              ].map(([l,v]) => (
                <div key={l} className="flex justify-between">
                  <span className="text-xs text-gray-500">{l}</span>
                  <span className={cn("text-xs font-bold", l==="Você recebe" ? "text-emerald-600" : l==="Multa aplicada" && retentionFee > 0 ? "text-red-500" : "text-gray-800")}>{v}</span>
                </div>
              ))}
            </div>

            {isOwnerCancel && (
              <div className="bg-blue-50 border border-blue-200 rounded-2xl p-3 flex gap-2">
                <Info size={13} className="text-blue-600 flex-shrink-0 mt-0.5" />
                <p className="text-xs text-blue-700">Cancelamento iniciado pelo proprietário. Você tem direito a <strong>reembolso integral (100%)</strong> automático, independente do prazo.</p>
              </div>
            )}

            <Btn full size="lg" variant="danger" loading={cancelState==="processing"} onClick={doCancel}>
              Confirmar Cancelamento
            </Btn>
            <Btn full variant="outline" onClick={() => setCancelState("idle")}>Manter minha reserva</Btn>
          </div>
        </div>
      )}

      {cancelState === "processing" && (
        <div className="absolute inset-0 z-50 bg-white/90 flex flex-col items-center justify-center gap-4">
          <Loader2 size={40} className="text-[#005BC5] animate-spin" />
          <M className="font-bold text-gray-700">Processando cancelamento...</M>
          <p className="text-xs text-gray-500">Aguarde, estamos registrando sua solicitação.</p>
        </div>
      )}

      <div className="px-4 py-4 flex flex-col gap-3 pb-6">
        {/* Owner-cancel notice banner */}
        {scenario === "owner_cancel" && (
          <div className="bg-red-50 border border-red-200 rounded-2xl p-3 flex gap-2">
            <AlertCircle size={14} className="text-red-500 flex-shrink-0 mt-0.5" />
            <div>
              <M className="text-xs font-bold text-red-700">Viagem cancelada pelo proprietário</M>
              <p className="text-[10px] text-red-600 mt-0.5">Você tem direito a reembolso integral (100%) automático. Cancele abaixo para iniciar o estorno.</p>
            </div>
          </div>
        )}

        {/* Ticket card */}
        <div className="bg-white rounded-3xl overflow-hidden shadow-lg">
          <div className="bg-gradient-to-r from-[#003a8c] to-[#005BC5] p-4 flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-white/20 flex items-center justify-center"><Waves size={20} className="text-white" /></div>
            <div><M className="text-white font-black text-sm">PORTO CERTO VIAGENS</M><p className="text-white/70 text-xs">Bilhete Eletrônico</p></div>
            <Badge c="orange">CONFIRMADO</Badge>
          </div>
          <div className="p-4">
            <div className="flex items-center gap-2 mb-4">
              <div className="flex-1 text-center"><M className="text-2xl font-black text-gray-900">MNS</M><p className="text-xs text-gray-500">Manaus</p></div>
              <div className="flex flex-col items-center gap-1"><div className="h-px w-12 bg-gray-300" /><Anchor size={16} className="text-[#005BC5]" /><div className="h-px w-12 bg-gray-300" /></div>
              <div className="flex-1 text-center"><M className="text-2xl font-black text-gray-900">STR</M><p className="text-xs text-gray-500">Santarém</p></div>
            </div>
            <div className="flex justify-between text-center mb-4">
              <div><p className="text-[10px] text-gray-500 uppercase tracking-wide">Data</p><M className="text-sm font-bold text-gray-800">25/06/2026</M></div>
              <div><p className="text-[10px] text-gray-500 uppercase tracking-wide">Embarque</p><M className="text-sm font-bold text-gray-800">06:00</M></div>
              <div><p className="text-[10px] text-gray-500 uppercase tracking-wide">Acomodação</p><M className="text-sm font-bold text-[#005BC5]">Rede</M></div>
            </div>
            <div className="border-t border-dashed border-gray-200 pt-3 mb-3">
              {[["Passageiro","Ana Carolina Souza"],["CPF","***.***.***-45"],["Embarcação","Barco Amazonas I"],["Reserva","#PCB-20260625-4721"],["Pagamento",sc.payment]].map(([l,v]) => (
                <div key={l} className="flex justify-between py-1"><span className="text-[11px] text-gray-500">{l}</span><span className="text-[11px] font-semibold text-gray-800">{v}</span></div>
              ))}
            </div>
            <div className="flex justify-center">
              <div className="bg-white border-2 border-gray-200 rounded-2xl p-3">
                <svg viewBox="0 0 120 120" className="w-28 h-28">
                  {Array.from({length:12},(_,r)=>Array.from({length:12},(_,c)=>(Math.random()>0.4)&&<rect key={`${r}-${c}`} x={c*10} y={r*10} width="9" height="9" fill="#005BC5" rx="1" />))}
                  <rect x="0" y="0" width="30" height="30" fill="none" stroke="#005BC5" strokeWidth="3" rx="2" /><rect x="5" y="5" width="20" height="20" fill="#005BC5" rx="1" />
                  <rect x="90" y="0" width="30" height="30" fill="none" stroke="#005BC5" strokeWidth="3" rx="2" /><rect x="95" y="5" width="20" height="20" fill="#005BC5" rx="1" />
                  <rect x="0" y="90" width="30" height="30" fill="none" stroke="#005BC5" strokeWidth="3" rx="2" /><rect x="5" y="95" width="20" height="20" fill="#005BC5" rx="1" />
                </svg>
              </div>
            </div>
            <p className="text-center text-[10px] text-gray-400 mt-2">Apresente este QR Code no embarque</p>
          </div>
        </div>

        {/* Cancellation deadline indicator */}
        <div className={cn("rounded-2xl p-3 flex gap-2 border", canCancelFree ? "bg-emerald-50 border-emerald-200" : "bg-amber-50 border-amber-200")}>
          <Clock size={14} className={cn("flex-shrink-0 mt-0.5", canCancelFree ? "text-emerald-600" : "text-amber-600")} />
          <div>
            <M className={cn("text-xs font-bold", canCancelFree ? "text-emerald-700" : "text-amber-700")}>
              {isOwnerCancel ? "Viagem cancelada pelo proprietário — estorno 100%"
                : isBoletoPending ? "Boleto não compensado — cancelamento gratuito"
                : isBeyond24h ? `${sc.hoursUntil}h até o embarque — cancelamento com reembolso integral`
                : `Atenção: apenas ${sc.hoursUntil}h até o embarque — multa de 20%`}
            </M>
            <p className={cn("text-[10px] mt-0.5", canCancelFree ? "text-emerald-600" : "text-amber-600")}>
              {canCancelFree ? `Estorno: ${refundAmt} (${refundDays})` : `Estorno: ${refundAmt} de R$ 185,00 pagos`}
            </p>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <Btn variant="outline" onClick={() => {}} full><Download size={14} />Baixar PDF</Btn>
          <Btn variant="teal" onClick={() => {}} full><Share2 size={14} />Compartilhar</Btn>
        </div>
        <Btn full variant="secondary" onClick={() => nav("tracking")}><Navigation size={16} />Rastrear Embarcação em Tempo Real</Btn>

        {/* Cancel button */}
        <Btn full variant="danger" onClick={() => setCancelState("confirm")}><XCircle size={16} />Cancelar Reserva</Btn>

        <div className="bg-[#005BC5]/8 rounded-2xl p-3 flex gap-2">
          <Wifi size={14} className="text-[#005BC5] mt-0.5 flex-shrink-0" />
          <p className="text-xs text-[#005BC5]">Bilhete disponível <strong>offline</strong>. Salvo automaticamente no seu dispositivo.</p>
        </div>

        {/* Demo scenario switcher */}
        <div className="bg-gray-100 rounded-2xl p-3">
          <p className="text-[10px] font-bold text-gray-500 uppercase tracking-wide mb-2">Demo — Simular cenário de cancelamento</p>
          <div className="flex flex-col gap-1.5">
            {(Object.entries(cancelScenarios) as [CancelScenario, typeof cancelScenarios[CancelScenario]][]).map(([key, val]) => (
              <button key={key} onClick={() => setScenario(key)} className={cn("text-left text-xs px-3 py-2 rounded-xl transition-all font-medium", scenario===key ? "bg-[#005BC5] text-white" : "bg-white text-gray-600 hover:bg-gray-50")}>
                {val.label}
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 20b – MY TRIPS (history + active)
// ─────────────────────────────────────────────────────────────
const myTripsData = [
  { id:"#PCB-20260625-4721", vessel:"Barco Amazonas I", route:"Manaus → Santarém", date:"25/06/2026", time:"06:00", status:"confirmada", price:185 },
  { id:"#PCB-20260510-3812", vessel:"Ana Beatriz", route:"Manaus → Parintins", date:"10/05/2026", time:"08:30", status:"concluida", price:95 },
  { id:"#PCB-20260320-2247", vessel:"Expresso Amazonas", route:"Manaus → Tefé", date:"20/03/2026", time:"05:00", status:"concluida", price:220 },
  { id:"#PCB-20260115-1094", vessel:"Rei Davi", route:"Santarém → Belém", date:"15/01/2026", time:"07:00", status:"cancelada", price:155 },
];

const TripStatusBadge = ({ s }: { s: string }) => {
  const map: Record<string, [string, string]> = {
    confirmada: ["bg-emerald-100 text-emerald-700", "Confirmada"],
    concluida:  ["bg-gray-100 text-gray-500", "Concluída"],
    cancelada:  ["bg-red-100 text-red-600", "Cancelada"],
  };
  const [cls, lbl] = map[s] ?? ["bg-gray-100 text-gray-500", s];
  return <span className={cn("text-[10px] font-bold px-2.5 py-1 rounded-full", cls)}>{lbl}</span>;
};

const MyTripsScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [tab, setTab] = useState<"ativas"|"historico">("ativas");
  const ativas = myTripsData.filter(t => t.status === "confirmada");
  const hist   = myTripsData.filter(t => t.status !== "confirmada");
  const list   = tab === "ativas" ? ativas : hist;
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("profile")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Minhas Viagens</M>
        </div>
        <div className="flex gap-2 mt-3">
          <Chip active={tab==="ativas"} onClick={() => setTab("ativas")}>Ativas ({ativas.length})</Chip>
          <Chip active={tab==="historico"} onClick={() => setTab("historico")}>Histórico ({hist.length})</Chip>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 flex flex-col gap-3 pb-6">
        {list.length === 0 ? (
          <div className="flex flex-col items-center justify-center h-48 gap-3 mt-8">
            <div className="w-16 h-16 rounded-full bg-[#005BC5]/10 flex items-center justify-center"><Ship size={28} className="text-[#005BC5]" /></div>
            <M className="font-bold text-gray-500">{tab==="ativas" ? "Nenhuma viagem ativa" : "Sem viagens no histórico"}</M>
            {tab==="ativas" && <Btn size="sm" onClick={() => nav("search")}>Buscar viagens <Search size={14} /></Btn>}
          </div>
        ) : list.map(t => (
          <div key={t.id} className="bg-white rounded-3xl p-4 shadow-sm">
            <div className="flex items-start justify-between mb-2">
              <div>
                <M className="font-bold text-sm text-gray-800">{t.vessel}</M>
                <p className="text-xs text-gray-500 mt-0.5">{t.route}</p>
              </div>
              <TripStatusBadge s={t.status} />
            </div>
            <div className="flex items-center gap-3 text-xs text-gray-500 mb-3">
              <span className="flex items-center gap-1"><Calendar size={10} />{t.date} · {t.time}</span>
            </div>
            <p className="text-[10px] font-mono text-gray-400 mb-3">{t.id}</p>
            <div className="flex items-center justify-between border-t border-gray-50 pt-3">
              <M className="font-bold text-[#005BC5]">R$ {t.price},00</M>
              <div className="flex gap-2">
                {t.status === "confirmada" && (
                  <>
                    <Btn size="sm" variant="outline" onClick={() => nav("tracking")}><Navigation size={12} />Rastrear</Btn>
                    <Btn size="sm" onClick={() => nav("ticket")}><Ticket size={12} />Bilhete</Btn>
                  </>
                )}
                {t.status === "concluida" && <Btn size="sm" variant="outline" onClick={() => nav("search")}>Comprar novamente</Btn>}
                {t.status === "cancelada" && <Badge c="red">Cancelada</Badge>}
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// GUIDE SCREENS – purchase/payment/accommodation tutorials
// ─────────────────────────────────────────────────────────────
const guideContent = {
  purchase: {
    title: "Como Comprar uma Passagem",
    steps: [
      { Icon: Search, title: "1. Busque a viagem", desc: "Na tela inicial toque em 'Buscar Viagem'. Informe origem, destino e data. Só é possível buscar datas futuras." },
      { Icon: Ship, title: "2. Escolha a embarcação", desc: "Compare preços, horários, avaliações e comodidades. Toque em 'Detalhes' para mais informações ou 'Comprar' para prosseguir." },
      { Icon: MapPin, title: "3. Ponto de desembarque", desc: "Selecione onde quer desembarcar ao longo do trajeto. O preço é ajustado automaticamente conforme a distância percorrida." },
      { Icon: User, title: "4. Dados do passageiro", desc: "Preencha nome completo e CPF. Esses dados serão verificados no embarque — use exatamente como no documento." },
      { Icon: Package, title: "5. Escolha a acomodação", desc: "Rede (inclusa) no convés aberto ou Camarote (+R$120) com cabine privativa, cama e ar-condicionado." },
      { Icon: CheckCircle, title: "6. Confirme e pague", desc: "Revise o resumo e escolha a forma de pagamento. PIX é instantâneo e sem taxas extras." },
    ],
  },
  payment: {
    title: "Guia de Pagamentos",
    steps: [
      { Icon: QrCode, title: "PIX — Recomendado", desc: "Pagamento instantâneo 24h, sem taxas adicionais. Escaneie o QR Code ou copie o código no seu banco. Confirmação em segundos." },
      { Icon: CreditCard, title: "Cartão de Crédito", desc: "Aceito Visa, Mastercard e Elo. Taxa de 2% sobre o total. Formulário seguro criptografado com SSL/TLS 1.3." },
      { Icon: FileText, title: "Boleto Bancário", desc: "Gere o boleto e pague em qualquer banco ou lotérica. Vencimento em 1 dia útil. Confirmação pode levar até 3h úteis." },
      { Icon: Shield, title: "Segurança", desc: "Todas as transações são protegidas por criptografia TLS 1.3 e AES-256. Seus dados de pagamento nunca são armazenados em nossos servidores." },
      { Icon: AlertCircle, title: "Cancelamento e Reembolso", desc: "Com +24h de antecedência: reembolso integral em até 5 dias úteis. Cancelamentos tardios podem ter multa contratual." },
    ],
  },
  accommodation: {
    title: "Tipos de Acomodação",
    steps: [
      { Icon: Globe, title: "Rede — Inclusa no bilhete", desc: "Padrão já incluído no preço da passagem. Você fica no convés da embarcação com ventilação natural e visão privilegiada do rio Amazonas." },
      { Icon: Package, title: "Camarote — +R$ 120", desc: "Cabine privativa com cama de casal, ar-condicionado, tomada USB e chave de segurança. Ideal para viagens acima de 12h ou quando prioridade é conforto." },
      { Icon: AlertCircle, title: "O que levar para a rede", desc: "Leve sua própria rede, pois alguns barcos não fornecem — verifique nas comodidades da embarcação antes de comprar." },
      { Icon: CheckCircle, title: "Franquia de bagagem", desc: "Cada passageiro tem direito a 30kg de bagagem sem custo adicional. Excedentes são cobrados pelo operador no embarque." },
    ],
  },
} as const;

type GuideTopic = keyof typeof guideContent;

const GuideScreen = ({ nav, topic }: { nav:(s:Screen)=>void; topic: GuideTopic }) => {
  const [step, setStep] = useState(0);
  const g = guideContent[topic];
  const steps = g.steps;
  const { Icon, title: stepTitle, desc } = steps[step];
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("help")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">{g.title}</M>
        </div>
      </div>
      <div className="flex-1 flex flex-col px-4 py-6">
        <div className="flex justify-center gap-1.5 mb-6">
          {steps.map((_,i) => <div key={i} className={cn("h-1.5 rounded-full transition-all", i===step ? "w-8 bg-[#005BC5]" : i<step ? "w-4 bg-[#005BC5]/40" : "w-4 bg-gray-200")} />)}
        </div>
        <div className="flex-1 flex flex-col gap-5">
          <div className="bg-white rounded-3xl p-6 shadow-sm flex flex-col items-center text-center gap-4 flex-1">
            <div className="w-16 h-16 rounded-2xl bg-[#005BC5]/10 flex items-center justify-center mt-4">
              <Icon size={32} className="text-[#005BC5]" />
            </div>
            <M className="font-black text-lg text-gray-900">{stepTitle}</M>
            <p className="text-sm text-gray-500 leading-relaxed">{desc}</p>
          </div>
          <div className="flex gap-3">
            {step > 0 && <Btn variant="outline" full onClick={() => setStep(step-1)}>Anterior</Btn>}
            {step < steps.length-1
              ? <Btn full onClick={() => setStep(step+1)}>Próximo <ArrowRight size={16} /></Btn>
              : <Btn full onClick={() => nav("help")}>Concluir <CheckCircle size={16} /></Btn>
            }
          </div>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 21 – FAVORITES (vessel-centric)
// ─────────────────────────────────────────────────────────────
const FavoritesScreen = ({ nav, favs, toggleFav }: { nav:(s:Screen)=>void; favs:number[]; toggleFav:(id:number)=>void }) => {
  const favVessels = mockTrips.filter(t => favs.includes(t.id));
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center justify-between mt-1">
          <M className="font-bold text-base text-gray-800">Embarcações Favoritas</M>
          <Badge c="blue">{favVessels.length}</Badge>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 pb-24 flex flex-col gap-4">
        {favVessels.length === 0
          ? <div className="flex flex-col items-center justify-center h-48 gap-3 mt-8"><div className="w-16 h-16 rounded-full bg-red-50 flex items-center justify-center"><Heart size={28} className="text-red-300" /></div><M className="font-bold text-gray-500">Nenhuma embarcação favorita</M><p className="text-xs text-gray-400 text-center px-6">Adicione embarcações aos favoritos tocando no <Heart size={11} className="inline" /> nos cards de viagem.</p></div>
          : favVessels.map(t => (
            <div key={t.id} className="bg-white rounded-3xl overflow-hidden shadow-sm border border-gray-100">
              <div className="relative h-36">
                <img src={t.img} alt={t.vessel} className="w-full h-full object-cover" />
                <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/10 to-transparent" />
                <div className="absolute bottom-3 left-3"><M className="text-white font-bold text-base">{t.vessel}</M></div>
                <div className="absolute top-2.5 right-2.5 flex items-center gap-1 bg-[#FFA500]/20 backdrop-blur-sm px-2 py-1 rounded-full"><Star size={11} fill="#FFA500" className="text-[#FFA500]" /><span className="text-white text-xs font-bold">{t.rating}</span></div>
              </div>
              <div className="p-4">
                <div className="flex flex-wrap gap-1.5 mb-3">
                  {t.amenities.map(a => <span key={a} className="text-[10px] font-semibold bg-[#005BC5]/10 text-[#005BC5] px-2 py-0.5 rounded-full">{a}</span>)}
                </div>
                <div className="border-t border-gray-50 pt-3 mb-3">
                  <p className="text-[10px] font-bold text-gray-500 uppercase tracking-wide mb-2">Próximas Viagens</p>
                  {mockTrips.filter(x=>x.id===t.id).map(x=>(
                    <div key={x.id} className="flex justify-between items-center py-1">
                      <span className="text-xs text-gray-600">{x.origin} → {x.destination} · {x.date} · {x.time}</span>
                      <M className="text-xs font-bold text-[#005BC5]">R$ {x.price}</M>
                    </div>
                  ))}
                </div>
                <div className="flex gap-2">
                  <Btn full variant="outline" size="sm" onClick={() => nav("vessel")}><Ship size={13} />Ver Perfil</Btn>
                  <Btn full variant="danger" size="sm" onClick={() => toggleFav(t.id)}><Heart size={13} />Remover</Btn>
                </div>
              </div>
            </div>
          ))}
      </div>
      <BottomNav active="favorites" nav={nav} />
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 22 – TRACKING
// ─────────────────────────────────────────────────────────────
const TrackingScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [gps, setGps] = useState(true); const [status, setStatus] = useState("em_viagem");
  const statuses = { em_viagem: { label: "Em Viagem", color: "teal", desc: "Navegando normalmente" }, nao_iniciada: { label: "Não Iniciada", color: "gray", desc: "Aguardando embarque" }, finalizada: { label: "Finalizada", color: "blue", desc: "Viagem concluída" } };
  const st = statuses[status as keyof typeof statuses];
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("home")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Rastreamento em Tempo Real</M>
        </div>
      </div>
      {!gps ? (
        <div className="flex-1 flex flex-col items-center justify-center gap-4 px-6">
          <WifiOff size={48} className="text-gray-300" />
          <M className="font-bold text-gray-600 text-lg">GPS Indisponível</M>
          <p className="text-sm text-gray-500 text-center">O GPS da embarcação está desligado ou com sinal instável. Tente novamente em alguns momentos.</p>
          <Btn onClick={() => setGps(true)}>Tentar novamente <RefreshCw size={14} /></Btn>
        </div>
      ) : (
        <div className="flex-1 flex flex-col">
          <div className="relative flex-1 bg-[#0f2a4a] overflow-hidden">
            <svg className="absolute inset-0 w-full h-full" viewBox="0 0 390 280" preserveAspectRatio="xMidYMid slice">
              {/* Grid */}
              {[0,1,2,3,4,5,6].map(i => <line key={`h${i}`} x1="0" y1={i*46} x2="390" y2={i*46} stroke="#1a3a5c" strokeWidth="1" />)}
              {[0,1,2,3,4,5,6,7,8].map(i => <line key={`v${i}`} x1={i*49} y1="0" x2={i*49} y2="280" stroke="#1a3a5c" strokeWidth="1" />)}
              {/* North bank */}
              <path d="M0 0 L390 0 L390 85 Q340 78 280 70 Q200 58 120 75 Q60 88 0 80Z" fill="#1e5230" />
              {/* South bank */}
              <path d="M0 185 Q60 172 130 188 Q210 205 280 185 Q330 170 390 180 L390 280 L0 280Z" fill="#1e5230" />
              {/* Tributary/island */}
              <ellipse cx="210" cy="138" rx="40" ry="14" fill="#1e5230" opacity="0.85" />
              <ellipse cx="305" cy="152" rx="22" ry="10" fill="#1e5230" opacity="0.85" />
              {/* River water */}
              <path d="M0 80 Q60 95 120 88 Q180 82 230 100 Q270 115 320 108 Q360 103 390 110 L390 180 Q360 170 310 165 Q270 160 230 155 Q180 148 130 162 Q80 175 0 165Z" fill="#1a5c8a" opacity="0.9" />
              {/* River shimmer */}
              <path d="M20 110 Q80 104 140 112 Q200 120 260 108 Q310 100 370 115" stroke="white" strokeWidth="0.5" fill="none" opacity="0.15" />
              <path d="M10 140 Q70 132 140 140 Q200 148 270 138 Q320 131 380 142" stroke="white" strokeWidth="0.5" fill="none" opacity="0.10" />
              {/* Route dashed path */}
              <path d="M35 122 Q90 112 150 108 Q210 104 262 118 Q300 128 355 120" stroke="#FFA500" strokeWidth="2.5" fill="none" strokeDasharray="9,5" opacity="0.95" />
              {/* Origin – Manaus */}
              <circle cx="35" cy="122" r="5" fill="#0084FC" />
              <circle cx="35" cy="122" r="9" fill="#0084FC" fillOpacity="0.25" />
              {/* Vessel current position */}
              <circle cx="185" cy="107" r="7" fill="#FFA500" />
              <circle cx="185" cy="107" r="13" fill="#FFA500" fillOpacity="0.3" />
              <circle cx="185" cy="107" r="20" fill="#FFA500" fillOpacity="0.12" />
              {/* Destination – Santarém */}
              <circle cx="355" cy="120" r="5" fill="#00c853" />
              <circle cx="355" cy="120" r="9" fill="#00c853" fillOpacity="0.25" />
              {/* Labels */}
              <text x="35" y="143" fill="white" fontSize="8.5" fontFamily="Roboto,sans-serif" textAnchor="middle" fontWeight="bold">Manaus</text>
              <text x="185" y="95" fill="#FFA500" fontSize="8" fontFamily="Roboto,sans-serif" textAnchor="middle" fontWeight="bold">⛴ Posição Atual</text>
              <text x="355" y="140" fill="white" fontSize="8.5" fontFamily="Roboto,sans-serif" textAnchor="middle" fontWeight="bold">Santarém</text>
              {/* Scale bar */}
              <line x1="20" y1="265" x2="100" y2="265" stroke="white" strokeWidth="1.5" opacity="0.5" />
              <line x1="20" y1="260" x2="20" y2="270" stroke="white" strokeWidth="1.5" opacity="0.5" />
              <line x1="100" y1="260" x2="100" y2="270" stroke="white" strokeWidth="1.5" opacity="0.5" />
              <text x="60" y="263" fill="white" fontSize="7" fontFamily="Roboto,sans-serif" textAnchor="middle" opacity="0.5">~200 km</text>
              {/* Compass rose */}
              <g transform="translate(358,28)">
                <circle cx="0" cy="0" r="16" fill="#0f2a4a" stroke="#2a4f7a" strokeWidth="1.5" />
                <text x="0" y="-6" fill="white" fontSize="6.5" textAnchor="middle" fontFamily="Roboto,sans-serif" fontWeight="bold">N</text>
                <path d="M0-11 L2.5-4 L0-6.5 L-2.5-4Z" fill="white" />
                <path d="M0 11 L-2.5 4 L0 6.5 L2.5 4Z" fill="#444" />
              </g>
            </svg>
            <div className="absolute top-3 right-3 bg-[#0f2a4a]/90 border border-white/15 rounded-2xl shadow-lg p-3 flex flex-col gap-1">
              <p className="text-[10px] text-white/60 font-medium">ETA Santarém</p>
              <M className="font-black text-[#FFA500] text-base">6h 32min</M>
              <p className="text-[9px] text-white/40">Chega ~12:32</p>
            </div>
            <button onClick={() => setGps(false)} className="absolute bottom-3 right-3 bg-[#0f2a4a]/80 border border-white/10 rounded-xl shadow p-2"><WifiOff size={14} className="text-white/60" /></button>
          </div>
          <div className="bg-white px-4 py-4 shadow-lg rounded-t-3xl -mt-4 relative z-10">
            <div className="flex items-center gap-3 mb-3">
              <div className="w-10 h-10 rounded-2xl bg-[#005BC5]/10 flex items-center justify-center"><Ship size={20} className="text-[#005BC5]" /></div>
              <div className="flex-1"><M className="font-bold text-sm text-gray-800">Barco Amazonas I</M><p className="text-xs text-gray-500">Manaus → Santarém</p></div>
              <Badge c={st.color as any}>{st.label}</Badge>
            </div>
            <div className="grid grid-cols-3 gap-2 mb-3">
              {[["Velocidade","19 km/h",Navigation],["Posição","Rio Amazonas",MapPin],["Atualizado","Agora",RefreshCw]].map(([l,v,Icon]) => (
                <div key={l} className="bg-[#F1F1F1] rounded-2xl p-2.5 text-center">
                  <Icon size={16} className="text-[#005BC5] mx-auto mb-1" />
                  <p className="text-[9px] text-gray-500">{l}</p>
                  <M className="text-xs font-bold text-gray-700">{v}</M>
                </div>
              ))}
            </div>
            <div className="bg-[#F1F1F1] rounded-2xl p-3">
              <div className="flex justify-between text-xs mb-1.5"><span className="text-gray-500">Manaus</span><span className="text-gray-500">Santarém</span></div>
              <div className="h-2 bg-gray-200 rounded-full overflow-hidden"><div className="h-full bg-gradient-to-r from-[#005BC5] to-[#0084FC] rounded-full" style={{ width: "53%" }} /></div>
              <p className="text-[10px] text-gray-400 mt-1.5 text-center">53% do trajeto concluído · 387 km restantes</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 22b – NOTIFICATIONS
// ─────────────────────────────────────────────────────────────
const notifData = [
  { id:1, type:"embarque", title:"Embarque em 2 horas", body:"Viagem Manaus → Parintins (Ana Beatriz) embarca às 08:30.", time:"08:10", date:"Hoje", read:false, icon:"⛴️" },
  { id:2, type:"atraso", title:"Atraso na embarcação", body:"A embarcação Comandante Freitas sofreu atraso de 30 minutos. Nova saída: 06:30.", time:"05:45", date:"Hoje", read:false, icon:"⏱️" },
  { id:3, type:"promocao", title:"Promoção especial!", body:"Manaus → Santarém com 20% de desconto. Apenas hoje!", time:"09:00", date:"Ontem", read:true, icon:"🎉" },
  { id:4, type:"confirmacao", title:"Reserva confirmada", body:"Sua reserva #PCB-20260625-4721 foi confirmada com sucesso.", time:"14:32", date:"24/06", read:true, icon:"✅" },
  { id:5, type:"rota", title:"Mudança de rota", body:"Por condições climáticas, a viagem Manaus → Tefé fará parada em Coari.", time:"11:00", date:"23/06", read:true, icon:"🔀" },
  { id:6, type:"cancelamento", title:"Cancelamento", body:"A viagem VG-008 (Solimões → Manaus) foi cancelada. Reembolso em 3 dias úteis.", time:"08:20", date:"22/06", read:true, icon:"❌" },
];

const NotificationsScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [notifs, setNotifs] = useState(notifData);
  const unread = notifs.filter(n=>!n.read).length;
  const markAll = () => setNotifs(p=>p.map(n=>({...n,read:true})));
  const byDate = notifs.reduce((acc,n) => { (acc[n.date]??=[]).push(n); return acc; }, {} as Record<string,typeof notifs>);
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center justify-between mt-1">
          <div className="flex items-center gap-3">
            <button onClick={() => nav("home")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
            <div className="flex items-center gap-2">
              <M className="font-bold text-base text-gray-800">Notificações</M>
              {unread>0 && <span className="bg-[#005BC5] text-white text-[10px] font-bold px-2 py-0.5 rounded-full">{unread}</span>}
            </div>
          </div>
          {unread>0 && <button onClick={markAll} className="text-xs text-[#005BC5] font-semibold">Marcar todas como lidas</button>}
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-3 pb-6">
        {Object.entries(byDate).map(([date, items]) => (
          <div key={date} className="mb-4">
            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-2 px-1">{date}</p>
            <div className="bg-white rounded-3xl shadow-sm overflow-hidden">
              {items.map((n, i) => (
                <button key={n.id} onClick={() => setNotifs(p=>p.map(x=>x.id===n.id?{...x,read:true}:x))} className={cn("flex gap-3 p-4 w-full text-left transition-colors hover:bg-gray-50", i>0&&"border-t border-gray-50", !n.read&&"bg-[#005BC5]/3")}>
                  <span className="text-2xl flex-shrink-0 mt-0.5">{n.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between gap-2 mb-0.5">
                      <M className={cn("text-sm font-bold truncate", n.read?"text-gray-700":"text-gray-900")}>{n.title}</M>
                      <span className="text-[10px] text-gray-400 flex-shrink-0">{n.time}</span>
                    </div>
                    <p className="text-xs text-gray-500 leading-relaxed">{n.body}</p>
                    {n.type==="embarque" && <button onClick={(e)=>{e.stopPropagation();nav("tracking");}} className="mt-2 text-xs text-[#005BC5] font-semibold flex items-center gap-1"><Navigation size={11} />Rastrear viagem</button>}
                    {n.type==="confirmacao" && <button onClick={(e)=>{e.stopPropagation();nav("ticket");}} className="mt-2 text-xs text-[#005BC5] font-semibold flex items-center gap-1"><Ticket size={11} />Ver bilhete</button>}
                  </div>
                  {!n.read && <div className="w-2 h-2 rounded-full bg-[#005BC5] flex-shrink-0 mt-1.5" />}
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 23 – PROFILE
// ─────────────────────────────────────────────────────────────
const ProfileScreen = ({ nav }: { nav:(s:Screen)=>void }) => (
  <div className="flex flex-col h-full bg-[#F1F1F1]">
    <div className="bg-gradient-to-b from-[#003a8c] to-[#005BC5] px-5 pt-3 pb-12">
      <StatusBar light />
      <div className="flex flex-col items-center gap-3 mt-2">
        <div className="relative">
          <img src="https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&h=200&fit=crop&face" alt="Foto de perfil" className="w-20 h-20 rounded-full border-4 border-white/40 object-cover" />
          <button onClick={() => {}} className="absolute bottom-0 right-0 w-6 h-6 rounded-full bg-[#FFA500] flex items-center justify-center shadow"><Edit size={11} className="text-white" /></button>
        </div>
        <div className="text-center"><M className="text-white font-bold text-base">Ana Carolina Souza</M><p className="text-white/70 text-xs">ana.carol@email.com</p></div>
        <div className="flex gap-6">
          {[["3","Viagens"],["2","Favoritos"]].map(([v,l]) => (
            <div key={l} className="flex flex-col items-center"><M className="text-white font-black text-lg">{v}</M><p className="text-white/60 text-[10px]">{l}</p></div>
          ))}
        </div>
      </div>
    </div>
    <div className="flex-1 overflow-y-auto -mt-6 px-4 pb-24">
      <div className="bg-white rounded-3xl p-4 shadow-sm mb-4">
        {([["Minhas Viagens",Ticket,"my-trips"],["Favoritos",Heart,"favorites"],["Rastreamento",Navigation,"tracking"],["Notificações",Bell,"notifications"],["Central de Ajuda",HelpCircle,"help"],["Acessibilidade",Accessibility,"accessibility"],["Configurações",Settings,"settings-screen"]] as [string, React.ElementType, Screen][]).map(([l,Icon,scr]) => (
          <button key={scr} onClick={() => nav(scr)} className="flex items-center gap-3 w-full py-3 border-b border-gray-50 last:border-0 hover:bg-gray-50 rounded-xl transition-all px-2">
            <div className="w-9 h-9 rounded-xl bg-[#005BC5]/8 flex items-center justify-center"><Icon size={18} className="text-[#005BC5]" /></div>
            <span className="flex-1 text-sm font-medium text-gray-700 text-left">{l}</span>
            <ChevronRight size={14} className="text-gray-400" />
          </button>
        ))}
      </div>
      <button onClick={() => nav("login")} className="w-full flex items-center gap-3 bg-white rounded-3xl p-4 shadow-sm text-red-500 hover:bg-red-50 transition-colors">
        <div className="w-9 h-9 rounded-xl bg-red-50 flex items-center justify-center"><LogOut size={18} className="text-red-500" /></div>
        <span className="text-sm font-semibold">Sair da conta</span>
        <ChevronRight size={14} className="text-red-300 ml-auto" />
      </button>
    </div>
    <BottomNav active="profile" nav={nav} />
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 24 – SETTINGS
// ─────────────────────────────────────────────────────────────
const SettingsScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [notif, setNotif] = useState(true); const [gps, setGps] = useState(true); const [biom, setBiom] = useState(false);
  const Toggle = ({ on, set }: { on:boolean; set:(v:boolean)=>void }) => (
    <button onClick={() => set(!on)} className={cn("w-12 h-6 rounded-full transition-all relative", on ? "bg-[#005BC5]" : "bg-gray-300")}>
      <div className={cn("w-5 h-5 bg-white rounded-full shadow absolute top-0.5 transition-all", on ? "left-6" : "left-0.5")} />
    </button>
  );
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("profile")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Configurações</M>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 pb-6 flex flex-col gap-4">
        {[
          { title: "Notificações", items: [["Notificações push", notif, setNotif],["SMS de confirmação", true, ()=>{}]] },
          { title: "Privacidade", items: [["Rastreamento GPS", gps, setGps],["Biometria", biom, setBiom]] },
        ].map(({ title, items }) => (
          <div key={title} className="bg-white rounded-3xl p-4 shadow-sm">
            <SectionTitle>{title}</SectionTitle>
            {items.map(([l,v,s]) => (
              <div key={l} className="flex items-center justify-between py-3 border-b border-gray-50 last:border-0">
                <span className="text-sm text-gray-700">{l}</span>
                <Toggle on={v as boolean} set={s as (v:boolean)=>void} />
              </div>
            ))}
          </div>
        ))}
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Conta</SectionTitle>
          {([["Alterar senha",Lock,"change-password"],["Termos de Uso",FileText,"terms"],["Política de Privacidade",Shield,"privacy"],["Acessibilidade",Accessibility,"accessibility"]] as [string, React.ElementType, Screen][]).map(([l,Icon,scr]) => (
            <button key={scr} onClick={() => nav(scr as Screen)} className="flex items-center gap-3 w-full py-3 border-b border-gray-50 last:border-0">
              <Icon size={16} className="text-gray-500" />
              <span className="flex-1 text-sm text-gray-700 text-left">{l}</span>
              <ChevronRight size={14} className="text-gray-400" />
            </button>
          ))}
        </div>
        <div className="text-center pt-2"><p className="text-xs text-gray-400">Porto Certo Viagens v2.4.1</p><p className="text-[10px] text-gray-300 mt-0.5">© 2026 Porto Certo Viagens LTDA</p></div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// CHANGE PASSWORD SCREEN
// ─────────────────────────────────────────────────────────────
const ChangePasswordScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [f, setF] = useState({ current:"", newP:"", confirm:"" });
  const [errs, setErrs] = useState<Record<string,string>>({});
  const [state, setState] = useState<"form"|"success">("form");
  const [show, setShow] = useState({ current:false, newP:false, confirm:false });
  const upd = (k:string) => (e:React.ChangeEvent<HTMLInputElement>) => setF(p=>({...p,[k]:e.target.value}));
  const submit = () => {
    const e:Record<string,string>={};
    if(!f.current) e.current="Senha atual obrigatória";
    if(f.current==="wrong") e.current="Senha atual incorreta";
    if(f.newP.length<8) e.newP="A senha deve ter no mínimo 8 caracteres";
    if(!/[A-Z]/.test(f.newP)&&f.newP.length>=8) e.newP="Use ao menos uma letra maiúscula";
    if(f.newP!==f.confirm) e.confirm="As senhas não coincidem";
    if(Object.keys(e).length){setErrs(e);return;}
    setState("success");
  };
  if(state==="success") return (
    <div className="flex flex-col h-full bg-white items-center justify-center px-6 gap-5">
      <div className="w-20 h-20 rounded-full bg-emerald-100 flex items-center justify-center"><CheckCircle size={40} className="text-emerald-600" /></div>
      <div className="text-center"><M className="font-bold text-lg text-gray-800">Senha alterada!</M><p className="text-gray-500 text-sm mt-1">Sua senha foi atualizada com sucesso.</p></div>
      <Btn full onClick={() => nav("settings-screen")}>Voltar às Configurações</Btn>
    </div>
  );
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("settings-screen")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Alterar Senha</M>
        </div>
      </div>
      <div className="px-4 py-5 flex flex-col gap-4">
        <div className="bg-white rounded-3xl p-5 shadow-sm flex flex-col gap-4">
          <Fld label="Senha Atual" type={show.current?"text":"password"} placeholder="Sua senha atual" value={f.current} onChange={upd("current")} error={errs.current} icon={<Lock size={16} />} right={<button type="button" onClick={()=>setShow(s=>({...s,current:!s.current}))} className="text-gray-400">{show.current?<EyeOff size={16}/>:<Eye size={16}/>}</button>} />
          <Fld label="Nova Senha" type={show.newP?"text":"password"} placeholder="Mín. 8 caracteres + maiúscula" value={f.newP} onChange={upd("newP")} error={errs.newP} icon={<Lock size={16} />} right={<button type="button" onClick={()=>setShow(s=>({...s,newP:!s.newP}))} className="text-gray-400">{show.newP?<EyeOff size={16}/>:<Eye size={16}/>}</button>} />
          <Fld label="Confirmar Nova Senha" type={show.confirm?"text":"password"} placeholder="Repita a nova senha" value={f.confirm} onChange={upd("confirm")} error={errs.confirm} icon={<Lock size={16} />} right={<button type="button" onClick={()=>setShow(s=>({...s,confirm:!s.confirm}))} className="text-gray-400">{show.confirm?<EyeOff size={16}/>:<Eye size={16}/>}</button>} />
          {f.newP.length>0 && (
            <div className="bg-gray-50 rounded-2xl p-3">
              <p className="text-xs font-bold text-gray-500 mb-2">Força da senha:</p>
              <div className="flex gap-1 mb-1">
                {[f.newP.length>=8, /[A-Z]/.test(f.newP), /[0-9]/.test(f.newP), /[^A-Za-z0-9]/.test(f.newP)].map((ok,i) => (
                  <div key={i} className={cn("h-1.5 flex-1 rounded-full", ok ? (f.newP.length>=12?"bg-emerald-500":"bg-[#FFA500]") : "bg-gray-200")} />
                ))}
              </div>
              <p className="text-[10px] text-gray-400">{f.newP.length>=12?"Forte":f.newP.length>=8?"Média":"Fraca"}</p>
            </div>
          )}
        </div>
        <div className="bg-amber-50 border border-amber-200 rounded-2xl p-3 flex gap-2">
          <AlertCircle size={14} className="text-amber-500 mt-0.5 flex-shrink-0" />
          <p className="text-xs text-amber-700">Dica: use "wrong" como senha atual para simular senha incorreta.</p>
        </div>
        <Btn full size="lg" onClick={submit}>Salvar Nova Senha</Btn>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 25 – ACCESSIBILITY
// ─────────────────────────────────────────────────────────────
const AccessibilityScreen = ({ nav, hc, setHc }: { nav:(s:Screen)=>void; hc:boolean; setHc:(v:boolean)=>void }) => {
  const [fontSize, setFontSize] = useState(16); const [screenReader, setScreenReader] = useState(false); const [assistiveNav, setAssistiveNav] = useState(false);
  const Toggle = ({ on, set }: { on:boolean; set:(v:boolean)=>void }) => (
    <button onClick={() => set(!on)} className={cn("w-12 h-6 rounded-full transition-all relative", on ? "bg-[#005BC5]" : "bg-gray-300")} aria-checked={on} role="switch">
      <div className={cn("w-5 h-5 bg-white rounded-full shadow absolute top-0.5 transition-all", on ? "left-6" : "left-0.5")} />
    </button>
  );
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("settings-screen")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Acessibilidade</M>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 pb-6 flex flex-col gap-4">
        <div className="bg-white rounded-3xl p-4 shadow-sm flex flex-col gap-3">
          <SectionTitle>Visual</SectionTitle>
          <div className="flex items-center justify-between py-2 border-b border-gray-50">
            <div><p className="text-sm font-medium text-gray-700">Alto Contraste</p><p className="text-xs text-gray-500">Aumenta o contraste para melhor visibilidade</p></div>
            <Toggle on={hc} set={(v) => { setHc(v); if(v) nav("high-contrast"); }} />
          </div>
          <div className="py-2 border-b border-gray-50">
            <div className="flex items-center justify-between mb-3">
              <div><p className="text-sm font-medium text-gray-700">Tamanho da Fonte</p><p className="text-xs text-gray-500">Atual: {fontSize}px</p></div>
              <Type size={18} className="text-gray-500" />
            </div>
            <div className="flex items-center gap-3">
              <button onClick={() => setFontSize(Math.max(14,fontSize-2))} className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center font-bold text-gray-600">-</button>
              <div className="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden"><div className="h-full bg-[#005BC5] rounded-full transition-all" style={{ width: `${((fontSize-14)/(24-14))*100}%` }} /></div>
              <button onClick={() => setFontSize(Math.min(24,fontSize+2))} className="w-8 h-8 rounded-full bg-gray-100 flex items-center justify-center font-bold text-gray-600">+</button>
            </div>
            <p className="text-center mt-2" style={{ fontSize: `${fontSize}px` }}>Texto de exemplo</p>
          </div>
          <div className="flex items-center justify-between py-2">
            <div><p className="text-sm font-medium text-gray-700">Leitor de Tela</p><p className="text-xs text-gray-500">Compatível com TalkBack e VoiceOver</p></div>
            <Toggle on={screenReader} set={setScreenReader} />
          </div>
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm flex flex-col gap-3">
          <SectionTitle>Navegação</SectionTitle>
          <div className="flex items-center justify-between py-2">
            <div><p className="text-sm font-medium text-gray-700">Navegação Assistiva</p><p className="text-xs text-gray-500">Foco de teclado e atalhos aprimorados</p></div>
            <Toggle on={assistiveNav} set={setAssistiveNav} />
          </div>
        </div>
        <div className="bg-[#005BC5]/8 rounded-2xl p-3 flex gap-2">
          <Info size={14} className="text-[#005BC5] mt-0.5 flex-shrink-0" />
          <p className="text-xs text-[#005BC5]">Este app segue as diretrizes <strong>WCAG 2.1 Nível AA</strong> e é compatível com tecnologias assistivas.</p>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 26 – HIGH CONTRAST
// ─────────────────────────────────────────────────────────────
const HighContrastScreen = ({ nav, setHc }: { nav:(s:Screen)=>void; setHc:(v:boolean)=>void }) => (
  <div className="flex flex-col h-full bg-black">
    <div className="bg-black border-b-2 border-yellow-400 px-5 pt-3 pb-4">
      <div className="flex justify-between items-center text-yellow-400 text-[11px] font-bold py-2">
        <span>9:41</span><div className="flex gap-2"><Wifi size={12} /><span>100%</span></div>
      </div>
      <div className="flex items-center gap-3 mt-1">
        <button onClick={() => nav("accessibility")} className="w-8 h-8 flex items-center justify-center rounded-full border-2 border-yellow-400"><ChevronLeft size={20} className="text-yellow-400" /></button>
        <span className="font-bold text-base text-yellow-400" style={{ fontFamily: "Montserrat, sans-serif" }}>Alto Contraste Ativado</span>
      </div>
    </div>
    <div className="flex-1 overflow-y-auto px-4 py-4 flex flex-col gap-4">
      <div className="bg-black border-2 border-yellow-400 rounded-2xl p-4">
        <p className="text-yellow-400 font-bold text-sm mb-3" style={{ fontFamily: "Montserrat, sans-serif" }}>Viagens Disponíveis</p>
        {mockTrips.slice(0,2).map(t => (
          <div key={t.id} className="border border-white/30 rounded-xl p-3 mb-2">
            <p className="text-white font-bold text-sm">{t.vessel}</p>
            <p className="text-white/80 text-xs mt-0.5">{t.origin} → {t.destination} · {t.date} · {t.time}</p>
            <div className="flex justify-between items-center mt-2">
              <span className="text-yellow-400 font-bold">R$ {t.price}</span>
              <button className="bg-yellow-400 text-black text-xs font-bold px-3 py-1.5 rounded-lg">COMPRAR</button>
            </div>
          </div>
        ))}
      </div>
      <div className="bg-black border-2 border-yellow-400 rounded-2xl p-4">
        <p className="text-yellow-400 font-bold text-sm mb-3" style={{ fontFamily: "Montserrat, sans-serif" }}>Menu Principal</p>
        {[["🔍 Buscar Viagem","search"],["❤️ Favoritos","favorites"],["📍 Rastrear","tracking"],["👤 Perfil","profile"]].map(([l,s]) => (
          <button key={s} onClick={() => nav(s as Screen)} className="w-full text-left py-3 border-b border-white/20 last:border-0 text-white font-medium text-sm flex justify-between items-center">
            {l}<span className="text-yellow-400">›</span>
          </button>
        ))}
      </div>
      <button onClick={() => { setHc(false); nav("accessibility"); }} className="w-full border-2 border-white text-white font-bold text-sm py-3 rounded-xl">
        Desativar Alto Contraste
      </button>
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 27 – HELP CENTER
// ─────────────────────────────────────────────────────────────
const HelpScreen = ({ nav }: { nav:(s:Screen)=>void }) => {
  const [open, setOpen] = useState<number|null>(null);
  const [search, setSearch] = useState("");
  const faqs = [
    ["Como compro uma passagem?","Acesse Buscar, informe origem, destino e data. Escolha a viagem, preencha os dados do passageiro, escolha a acomodação e conclua o pagamento."],
    ["Como cancelo minha reserva?","Acesse Minhas Viagens no Perfil, selecione a viagem e toque em Cancelar. O reembolso ocorre em até 5 dias úteis."],
    ["O bilhete digital funciona offline?","Sim! O bilhete é salvo automaticamente no dispositivo após a compra e fica disponível sem internet."],
    ["Como rastrear minha embarcação?","No Bilhete Digital, toque em Rastrear Embarcação. Você verá a posição em tempo real e o ETA atualizado."],
    ["Posso viajar com bagagem?","Cada passageiro tem direito a 30kg de bagagem. Excedentes são cobrados diretamente na embarcação."],
    ["Quais formas de pagamento são aceitas?","Aceitamos PIX (sem taxa), Cartão de Crédito (taxa de 2%) e Boleto Bancário (vencimento em 1 dia útil)."],
    ["Como escolho o ponto de desembarque?","Durante a compra, você pode escolher entre as paradas da rota. O valor e ETA são atualizados automaticamente."],
    ["Qual a diferença entre Rede e Camarote?","Rede é inclusa no bilhete e fica no convés, com ventilação natural e vista do rio. Camarote custa +R$120 e é uma cabine privativa com cama, ar-condicionado e tomada USB."],
  ];
  const filtered = faqs.filter(([q]) => !search || q.toLowerCase().includes(search.toLowerCase()));
  return (
    <div className="flex flex-col h-full bg-[#F1F1F1]">
      <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
        <StatusBar />
        <div className="flex items-center gap-3 mt-1">
          <button onClick={() => nav("profile")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
          <M className="font-bold text-base text-gray-800">Central de Ajuda</M>
        </div>
      </div>
      <div className="flex-1 overflow-y-auto px-4 py-4 flex flex-col gap-4 pb-6">
        <div className="relative"><Search size={14} className="absolute left-3.5 top-1/2 -translate-y-1/2 text-gray-400" /><input value={search} onChange={e=>setSearch(e.target.value)} placeholder="Buscar dúvidas..." className="w-full pl-10 pr-4 py-2.5 text-sm border border-gray-200 rounded-2xl bg-white outline-none focus:border-[#005BC5] focus:ring-2 focus:ring-[#005BC5]/15" /></div>
        <div className="grid grid-cols-2 gap-3">
          {([["Chat ao Vivo",MessageSquare,"teal",()=>{}],["Ligar Agora",Phone,"blue",()=>{}],["Bilhete Digital",Ticket,"orange",()=>nav("ticket")],["Rastreamento",Navigation,"green",()=>nav("tracking")]] as [string, React.ElementType, string, ()=>void][]).map(([l,Icon,c,action]) => (
            <button key={l} onClick={action} className={cn("bg-white rounded-2xl p-4 flex flex-col items-center gap-2 shadow-sm border transition-all hover:shadow-md", c==="teal"?"border-[#008B8B]/20 hover:border-[#008B8B]/40":c==="blue"?"border-[#005BC5]/20 hover:border-[#005BC5]/40":c==="orange"?"border-[#FFA500]/20 hover:border-[#FFA500]/40":"border-emerald-200 hover:border-emerald-400")}>
              <Icon size={22} className={c==="teal"?"text-[#008B8B]":c==="blue"?"text-[#005BC5]":c==="orange"?"text-[#FFA500]":"text-emerald-600"} />
              <span className="text-xs font-semibold text-gray-700">{l}</span>
            </button>
          ))}
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Orientações de Compra</SectionTitle>
          {([["Como comprar passagens",Ticket,"guide-purchase"],["Guia de Pagamentos",CreditCard,"guide-payment"],["Tipos de Acomodação",Package,"guide-accommodation"]] as [string, React.ElementType, Screen][]).map(([l,Icon,scr]) => (
            <button key={l} onClick={()=>nav(scr)} className="flex items-center gap-3 w-full py-3 border-b border-gray-50 last:border-0 hover:bg-gray-50 rounded-xl px-2 transition-all">
              <div className="w-8 h-8 rounded-xl bg-[#005BC5]/10 flex items-center justify-center"><Icon size={15} className="text-[#005BC5]" /></div>
              <span className="flex-1 text-sm text-gray-700 text-left">{l}</span>
              <ChevronRight size={14} className="text-gray-400" />
            </button>
          ))}
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Perguntas Frequentes</SectionTitle>
          {filtered.length===0 ? <p className="text-xs text-gray-400 py-4 text-center">Nenhum resultado para "{search}"</p> : filtered.map(([q,a],i) => (
            <div key={i} className="border-b border-gray-50 last:border-0">
              <button onClick={() => setOpen(open===i?null:i)} className="flex items-center justify-between w-full py-3 text-left gap-3">
                <span className="text-sm font-medium text-gray-700">{q}</span>
                <ChevronDown size={14} className={cn("text-gray-400 transition-transform flex-shrink-0", open===i && "rotate-180")} />
              </button>
              {open===i && <p className="text-xs text-gray-500 pb-3 leading-relaxed">{a}</p>}
            </div>
          ))}
        </div>
        <div className="bg-white rounded-3xl p-4 shadow-sm">
          <SectionTitle>Contato e Suporte</SectionTitle>
          <div className="flex flex-col gap-2">
            {[["Email","suporte@portocerto.com.br",Mail],["Telefone","(92) 3000-0000",Phone],["WhatsApp","(92) 99999-9999",MessageSquare]].map(([l,v,Icon]) => (
              <div key={l} className="flex items-center gap-3 py-2 border-b border-gray-50 last:border-0">
                <Icon size={16} className="text-gray-400" />
                <div><p className="text-[10px] text-gray-400 uppercase tracking-wide">{l}</p><p className="text-sm font-medium text-gray-700">{v}</p></div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN 28 – TERMS OF USE
// ─────────────────────────────────────────────────────────────
const TermsScreen = ({ nav }: { nav:(s:Screen)=>void }) => (
  <div className="flex flex-col h-full bg-[#F1F1F1]">
    <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
      <StatusBar />
      <div className="flex items-center gap-3 mt-1">
        <button onClick={() => nav("login")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
        <M className="font-bold text-base text-gray-800">Termos de Uso</M>
      </div>
    </div>
    <div className="flex-1 overflow-y-auto px-4 py-4 pb-6">
      <div className="bg-white rounded-3xl p-4 shadow-sm">
        <p className="text-xs text-gray-400 mb-4">Última atualização: 01/06/2026</p>
        {[
          ["1. Aceitação dos Termos","Ao utilizar o aplicativo Porto Certo Viagens, você concorda integralmente com estes Termos de Uso. Caso não concorde, não utilize nossos serviços."],
          ["2. Uso do Serviço","O aplicativo destina-se exclusivamente à compra de passagens fluviais, consulta de itinerários e rastreamento de embarcações na região amazônica."],
          ["3. Cadastro e Responsabilidades","O usuário é responsável pela veracidade das informações fornecidas no cadastro. Dados incorretos podem resultar no cancelamento da reserva sem reembolso."],
          ["4. Pagamentos e Cancelamentos","Cancelamentos solicitados com mais de 24h de antecedência têm reembolso integral. Cancelamentos tardios estão sujeitos à multa contratual."],
          ["5. Limitação de Responsabilidade","A Porto Certo Viagens não se responsabiliza por atrasos causados por fenômenos naturais, condições climáticas adversas ou situações fora do controle dos operadores."],
          ["6. Privacidade","Seus dados pessoais são tratados conforme nossa Política de Privacidade, em conformidade com a LGPD (Lei 13.709/2018)."],
          ["7. Contato","dúvidas: suporte@portocerto.com.br · (92) 3000-0000"],
        ].map(([t,c]) => (
          <div key={t} className="mb-4">
            <M className="font-bold text-sm text-gray-800 mb-1">{t}</M>
            <p className="text-xs text-gray-500 leading-relaxed">{c}</p>
          </div>
        ))}
      </div>
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────
// SCREEN 29 – PRIVACY POLICY
// ─────────────────────────────────────────────────────────────
const PrivacyScreen = ({ nav }: { nav:(s:Screen)=>void }) => (
  <div className="flex flex-col h-full bg-[#F1F1F1]">
    <div className="bg-white px-5 pt-3 pb-4 border-b border-gray-100">
      <StatusBar />
      <div className="flex items-center gap-3 mt-1">
        <button onClick={() => nav("login")} className="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100"><ChevronLeft size={20} className="text-gray-700" /></button>
        <M className="font-bold text-base text-gray-800">Política de Privacidade</M>
      </div>
    </div>
    <div className="flex-1 overflow-y-auto px-4 py-4 pb-6">
      <div className="bg-white rounded-3xl p-4 shadow-sm">
        <p className="text-xs text-gray-400 mb-4">Última atualização: 01/06/2026 · LGPD Conforme</p>
        {[
          ["1. Dados Coletados","Coletamos nome, CPF, email, telefone, dados de pagamento (em forma tokenizada), localização GPS (apenas durante o uso) e histórico de viagens."],
          ["2. Finalidade do Tratamento","Seus dados são usados para: processar reservas, emitir bilhetes, oferecer rastreamento em tempo real, personalizar recomendações e cumprir obrigações legais."],
          ["3. Compartilhamento","Seus dados podem ser compartilhados com operadores de embarcações parceiros, processadores de pagamento certificados PCI-DSS e autoridades quando exigido por lei."],
          ["4. Seus Direitos (LGPD)","Você tem direito a: acessar seus dados, corrigir informações incorretas, solicitar exclusão da conta, revogar consentimentos e receber seus dados em formato portável."],
          ["5. Segurança","Utilizamos criptografia AES-256, TLS 1.3 em todas as comunicações e autenticação multifator para proteger seus dados."],
          ["6. Cookies","Utilizamos cookies essenciais para funcionamento do app e cookies analíticos para melhorar a experiência. Você pode gerenciar preferências nas Configurações."],
          ["7. DPO","Encarregado de Dados: privacidade@portocerto.com.br"],
        ].map(([t,c]) => (
          <div key={t} className="mb-4">
            <M className="font-bold text-sm text-gray-800 mb-1">{t}</M>
            <p className="text-xs text-gray-500 leading-relaxed">{c}</p>
          </div>
        ))}
      </div>
    </div>
  </div>
);

// ─────────────────────────────────────────────────────────────
// TUTORIAL OVERLAY
// ─────────────────────────────────────────────────────────────
const tutorialSteps: { screen: Screen; tip: string }[] = [
  { screen: "home", tip: "Busque sua próxima viagem aqui. Toque na barra de busca para começar." },
  { screen: "search", tip: "Escolha origem, destino e data. Datas passadas são bloqueadas automaticamente." },
  { screen: "payment", tip: "Escolha a forma de pagamento. PIX é instantâneo e sem taxas." },
  { screen: "profile", tip: "Gerencie suas informações pessoais, favoritos e configurações aqui." },
];

const TutorialOverlay = ({ screen, onNext, onSkip, step, total }: { screen: Screen; onNext:()=>void; onSkip:()=>void; step:number; total:number }) => {
  const current = tutorialSteps.find(t => t.screen === screen);
  if(!current) return null;
  return (
    <div className="absolute inset-0 z-50 pointer-events-none">
      <div className="absolute bottom-20 left-3 right-3 pointer-events-auto">
        <div className="bg-[#003a8c] rounded-3xl p-4 shadow-2xl border border-[#0084FC]/30">
          <div className="flex items-start gap-3 mb-3">
            <div className="w-8 h-8 rounded-full bg-[#0084FC] flex items-center justify-center flex-shrink-0"><Info size={14} className="text-white" /></div>
            <p className="text-white text-sm leading-relaxed flex-1">{current.tip}</p>
          </div>
          <div className="flex items-center justify-between">
            <div className="flex gap-1">{Array.from({length:total}).map((_,i)=><div key={i} className={cn("h-1 rounded-full transition-all",i===step?"w-5 bg-[#FFA500]":"w-1.5 bg-white/30")} />)}</div>
            <div className="flex gap-2">
              <button onClick={onSkip} className="text-white/60 text-xs font-medium px-3 py-1.5 rounded-xl hover:text-white">Pular</button>
              <button onClick={onNext} className="bg-[#FFA500] text-black text-xs font-bold px-4 py-1.5 rounded-xl">{step===total-1?"Concluir":"Próximo"}</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// PHONE FRAME
// ─────────────────────────────────────────────────────────────
const PhoneFrame = ({ children, hc }: { children: React.ReactNode; hc: boolean }) => (
  <div className="relative flex-shrink-0" style={{ width: 390, height: 780 }}>
    <div className="absolute inset-0 rounded-[52px] bg-gray-900 shadow-2xl shadow-black/60 overflow-hidden border-4 border-gray-800">
      <div className="absolute top-0 left-1/2 -translate-x-1/2 w-28 h-7 bg-gray-900 rounded-b-3xl z-50 flex items-center justify-center gap-2">
        <div className="w-12 h-1.5 bg-gray-800 rounded-full" />
        <div className="w-3 h-3 rounded-full bg-gray-800 border border-gray-700" />
      </div>
      <div className={cn("absolute inset-0 overflow-hidden rounded-[48px]", hc ? "bg-black" : "bg-[#F1F1F1]")} style={{ fontFamily: "Roboto, sans-serif" }}>
        {children}
      </div>
    </div>
    <div className="absolute -left-1.5 top-28 w-1 h-12 bg-gray-800 rounded-l-full" />
    <div className="absolute -left-1.5 top-44 w-1 h-8 bg-gray-800 rounded-l-full" />
    <div className="absolute -right-1.5 top-36 w-1 h-14 bg-gray-800 rounded-r-full" />
  </div>
);

// ─────────────────────────────────────────────────────────────
// OWNER PANEL
// ─────────────────────────────────────────────────────────────
const OwnerSidebar = ({ active, set }: { active: OwnerTab; set:(t:OwnerTab)=>void }) => {
  const items: [OwnerTab, React.ElementType, string][] = [
    ["dashboard", LayoutDashboard, "Dashboard"],
    ["trips", Ship, "Viagens"],
    ["vessels", Anchor, "Embarcações"],
    ["revenue", DollarSign, "Receitas"],
    ["customers", Users, "Passageiros"],
    ["settings", Settings, "Configurações"],
  ];
  return (
    <aside className="w-56 bg-[#001a4a] flex flex-col flex-shrink-0 h-full">
      <div className="p-5 border-b border-white/10">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-white/15 flex items-center justify-center"><Waves size={20} className="text-white" /></div>
          <div><M className="text-white font-black text-sm leading-tight">PORTO CERTO</M><p className="text-white/50 text-[10px]">Painel do Proprietário</p></div>
        </div>
      </div>
      <nav className="flex-1 p-3">
        {items.map(([key, Icon, label]) => (
          <button key={key} onClick={() => set(key)} className={cn("flex items-center gap-3 w-full px-3 py-2.5 rounded-xl mb-1 transition-all text-left", active===key ? "bg-[#0084FC] text-white" : "text-white/60 hover:text-white hover:bg-white/8")}>
            <Icon size={18} />
            <span className="text-sm font-medium">{label}</span>
            {key==="trips" && <span className="ml-auto bg-[#FFA500] text-black text-[10px] font-bold px-1.5 py-0.5 rounded-full">5</span>}
          </button>
        ))}
      </nav>
      <div className="p-4 border-t border-white/10">
        <div className="flex items-center gap-3">
          <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop" alt="Owner" className="w-9 h-9 rounded-full object-cover" />
          <div className="flex-1 min-w-0"><M className="text-white text-xs font-semibold truncate">Carlos Mendes</M><p className="text-white/50 text-[10px]">Proprietário</p></div>
          <LogOut size={14} className="text-white/40" />
        </div>
      </div>
    </aside>
  );
};

const KPI = ({ label, value, sub, icon: Icon, color, trend }: { label:string; value:string; sub:string; icon:React.ElementType; color:string; trend?:number }) => (
  <div className="bg-white rounded-2xl p-4 shadow-sm flex flex-col gap-3">
    <div className="flex items-center justify-between">
      <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">{label}</p>
      <div className="w-9 h-9 rounded-xl flex items-center justify-center" style={{ background: `${color}15` }}><Icon size={18} style={{ color }} /></div>
    </div>
    <div><M className="text-2xl font-black text-gray-900">{value}</M><p className="text-xs text-gray-500 mt-0.5">{sub}</p></div>
    {trend !== undefined && <div className={cn("flex items-center gap-1 text-xs font-semibold", trend>=0?"text-emerald-600":"text-red-500")}><TrendingUp size={12} className={trend<0?"rotate-180":""} />{trend>=0?"+":""}{trend}% vs. mês anterior</div>}
  </div>
);

const StatusDot = ({ s }: { s:string }) => {
  const m:Record<string,[string,string]> = { confirmada:["bg-emerald-500","Confirmada"], embarcando:["bg-[#FFA500]","Embarcando"], pendente:["bg-gray-300","Pendente"], aberta:["bg-[#005BC5]","Aberta"] };
  const [cls, lbl] = m[s] || ["bg-gray-300",s];
  return <span className="flex items-center gap-1.5 text-xs font-medium text-gray-700"><span className={cn("w-2 h-2 rounded-full",cls)} />{lbl}</span>;
};

const OwnerDashboard = () => (
  <div className="flex-1 overflow-y-auto p-6 bg-[#F1F1F1]">
    <div className="flex items-center justify-between mb-6">
      <div><M className="font-black text-xl text-gray-900">Dashboard</M><p className="text-sm text-gray-500">Bem-vindo, Carlos. Aqui está o resumo de hoje.</p></div>
      <div className="flex gap-2">
        <button className="flex items-center gap-2 bg-white border border-gray-200 text-gray-600 text-sm px-4 py-2 rounded-xl hover:border-[#005BC5] transition-all"><Calendar size={14} />Junho 2026</button>
        <Btn size="sm"><Plus size={14} />Nova Viagem</Btn>
      </div>
    </div>
    <div className="grid grid-cols-4 gap-4 mb-6">
      <KPI label="Receita Mensal" value="R$ 58.400" sub="↑ vs. R$ 47.000 (mai)" icon={DollarSign} color="#005BC5" trend={24} />
      <KPI label="Passageiros" value="445" sub="este mês" icon={Users} color="#0084FC" trend={18} />
      <KPI label="Viagens Realizadas" value="62" sub="em junho" icon={Ship} color="#008B8B" trend={8} />
      <KPI label="Taxa de Ocupação" value="87%" sub="média da frota" icon={Package} color="#FFA500" trend={5} />
    </div>
    <div className="grid grid-cols-3 gap-4 mb-4">
      <div className="col-span-2 bg-white rounded-2xl p-4 shadow-sm">
        <div className="flex justify-between items-center mb-4"><M className="font-bold text-sm text-gray-800">Receita Mensal (R$)</M><Badge c="blue">2026</Badge></div>
        <ResponsiveContainer width="100%" height={180}>
          <AreaChart data={revenueData}>
            <defs><linearGradient id="rev" x1="0" y1="0" x2="0" y2="1"><stop offset="5%" stopColor="#005BC5" stopOpacity={0.3}/><stop offset="95%" stopColor="#005BC5" stopOpacity={0}/></linearGradient></defs>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="mes" tick={{ fontSize:11 }} />
            <YAxis tick={{ fontSize:11 }} tickFormatter={v=>`${(v/1000).toFixed(0)}k`} />
            <Tooltip formatter={(v:number) => [`R$ ${v.toLocaleString("pt-BR")}`, "Receita"]} />
            <Area type="monotone" dataKey="receita" stroke="#005BC5" fill="url(#rev)" strokeWidth={2.5} dot={{ r:4, fill:"#005BC5" }} />
          </AreaChart>
        </ResponsiveContainer>
      </div>
      <div className="bg-white rounded-2xl p-4 shadow-sm">
        <M className="font-bold text-sm text-gray-800 mb-4">Formas de Pagamento</M>
        <ResponsiveContainer width="100%" height={140}>
          <PieChart><Pie data={pieData} cx="50%" cy="50%" innerRadius={40} outerRadius={65} dataKey="value" label={({ name, value }) => `${name}: ${value}%`} labelLine={false} fontSize={10}>{pieData.map((d,i) => <Cell key={`cell-${d.name}`} fill={PIE_COLORS[i]} />)}</Pie></PieChart>
        </ResponsiveContainer>
        <div className="flex flex-col gap-1.5 mt-2">{pieData.map((d,i) => <div key={d.name} className="flex items-center gap-2 text-xs"><div className="w-2.5 h-2.5 rounded-sm flex-shrink-0" style={{ background:PIE_COLORS[i] }} /><span className="text-gray-600">{d.name}</span><span className="ml-auto font-bold text-gray-800">{d.value}%</span></div>)}</div>
      </div>
    </div>
    <div className="bg-white rounded-2xl p-4 shadow-sm">
      <div className="flex justify-between items-center mb-4"><M className="font-bold text-sm text-gray-800">Próximas Viagens</M><button className="text-xs text-[#005BC5] font-semibold">Ver todas</button></div>
      <table className="w-full text-sm">
        <thead><tr className="border-b border-gray-100">{["ID","Rota","Embarcação","Data","Passageiros","Status","Receita"].map(h=><th key={h} className="text-left text-[11px] font-bold text-gray-500 uppercase tracking-wide pb-2 pr-3">{h}</th>)}</tr></thead>
        <tbody>{ownerTrips.map(t=><tr key={t.id} className="border-b border-gray-50 last:border-0 hover:bg-gray-50 transition-colors">
          <td className="py-3 pr-3"><M className="text-xs font-bold text-[#005BC5]">{t.id}</M></td>
          <td className="py-3 pr-3"><span className="text-xs text-gray-700">{t.route}</span></td>
          <td className="py-3 pr-3"><span className="text-xs text-gray-600">{t.vessel}</span></td>
          <td className="py-3 pr-3"><span className="text-xs text-gray-600">{t.date}</span></td>
          <td className="py-3 pr-3"><div className="flex items-center gap-1.5"><span className="text-xs font-bold text-gray-800">{t.passengers}/{t.capacity}</span><div className="w-16 h-1.5 bg-gray-100 rounded-full overflow-hidden"><div className="h-full rounded-full bg-[#005BC5]" style={{ width:`${(t.passengers/t.capacity)*100}%` }} /></div></div></td>
          <td className="py-3 pr-3"><StatusDot s={t.status} /></td>
          <td className="py-3"><span className="text-xs font-bold text-gray-800">R$ {t.revenue.toLocaleString("pt-BR")}</span></td>
        </tr>)}</tbody>
      </table>
    </div>
  </div>
);

const OwnerTrips = () => (
  <div className="flex-1 overflow-y-auto p-6 bg-[#F1F1F1]">
    <div className="flex items-center justify-between mb-6">
      <div><M className="font-black text-xl text-gray-900">Viagens</M><p className="text-sm text-gray-500">Gerencie todas as viagens da frota</p></div>
      <Btn size="sm"><Plus size={14} />Nova Viagem</Btn>
    </div>
    <div className="bg-white rounded-2xl shadow-sm overflow-hidden">
      <div className="p-4 border-b border-gray-100 flex gap-3">
        <div className="relative flex-1 max-w-xs"><Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" /><input placeholder="Buscar viagens..." className="w-full pl-9 pr-4 py-2 text-sm border border-gray-200 rounded-xl bg-gray-50 outline-none focus:border-[#005BC5]" /></div>
        <button className="flex items-center gap-2 border border-gray-200 bg-white text-gray-600 text-sm px-3 py-2 rounded-xl hover:border-[#005BC5] transition-all"><Filter size={14} />Filtrar</button>
        <div className="flex gap-1">{["Todas","Confirmadas","Pendentes","Abertas"].map(f=><Chip key={f}>{f}</Chip>)}</div>
      </div>
      <table className="w-full text-sm">
        <thead className="bg-gray-50"><tr>{["ID","Rota","Embarcação","Data","Hora","Passageiros","Status","Receita","Ações"].map(h=><th key={h} className="text-left text-[11px] font-bold text-gray-500 uppercase tracking-wide py-3 px-4">{h}</th>)}</tr></thead>
        <tbody>{ownerTrips.map(t=><tr key={t.id} className="border-t border-gray-50 hover:bg-blue-50/30 transition-colors">
          <td className="py-3 px-4"><M className="text-xs font-bold text-[#005BC5]">{t.id}</M></td>
          <td className="py-3 px-4 text-xs text-gray-700">{t.route}</td>
          <td className="py-3 px-4 text-xs text-gray-600">{t.vessel}</td>
          <td className="py-3 px-4 text-xs text-gray-600">{t.date}/2026</td>
          <td className="py-3 px-4 text-xs text-gray-600">06:00</td>
          <td className="py-3 px-4"><div className="flex items-center gap-1.5 text-xs"><span className="font-bold">{t.passengers}</span><span className="text-gray-400">/{t.capacity}</span></div></td>
          <td className="py-3 px-4"><StatusDot s={t.status} /></td>
          <td className="py-3 px-4 text-xs font-bold text-gray-800">R$ {t.revenue.toLocaleString("pt-BR")}</td>
          <td className="py-3 px-4"><div className="flex gap-1"><button className="p-1.5 rounded-lg hover:bg-[#005BC5]/10 text-gray-500 hover:text-[#005BC5] transition-all"><Edit size={13} /></button><button className="p-1.5 rounded-lg hover:bg-red-50 text-gray-500 hover:text-red-500 transition-all"><Trash2 size={13} /></button></div></td>
        </tr>)}</tbody>
      </table>
    </div>
  </div>
);

const OwnerVessels = () => (
  <div className="flex-1 overflow-y-auto p-6 bg-[#F1F1F1]">
    <div className="flex items-center justify-between mb-6">
      <div><M className="font-black text-xl text-gray-900">Embarcações</M><p className="text-sm text-gray-500">Gerencie sua frota</p></div>
      <Btn size="sm"><Plus size={14} />Cadastrar Embarcação</Btn>
    </div>
    <div className="grid grid-cols-2 gap-4">
      {mockTrips.map(t => (
        <div key={t.id} className="bg-white rounded-2xl overflow-hidden shadow-sm">
          <div className="relative h-32"><img src={t.img} alt={t.vessel} className="w-full h-full object-cover" /><div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" /><div className="absolute bottom-3 left-3"><M className="text-white font-black text-sm">{t.vessel}</M></div><div className="absolute top-3 right-3"><Badge c={t.seats>0?"teal":"red"}>{t.seats>0?"Ativa":"Esgotada"}</Badge></div></div>
          <div className="p-4">
            <div className="grid grid-cols-2 gap-2 mb-3">
              {[["Registro",t.reg],["Capacidade",`${t.capacity} pass.`],["Velocidade",t.speed],["Avaliação",`${t.rating} ⭐`]].map(([l,v]) => <div key={l}><p className="text-[10px] text-gray-500 uppercase tracking-wide">{l}</p><p className="text-xs font-bold text-gray-800">{v}</p></div>)}
            </div>
            <div className="flex gap-2"><Btn full variant="outline" size="sm"><Edit size={12} />Editar</Btn><Btn full size="sm"><BarChart3 size={12} />Análise</Btn></div>
          </div>
        </div>
      ))}
    </div>
  </div>
);

const OwnerRevenue = () => (
  <div className="flex-1 overflow-y-auto p-6 bg-[#F1F1F1]">
    <div className="flex items-center justify-between mb-6">
      <div><M className="font-black text-xl text-gray-900">Receitas</M><p className="text-sm text-gray-500">Análise financeira detalhada</p></div>
      <button className="flex items-center gap-2 bg-white border border-gray-200 text-gray-600 text-sm px-4 py-2 rounded-xl hover:border-[#005BC5] transition-all"><Download size={14} />Exportar Relatório</button>
    </div>
    <div className="grid grid-cols-3 gap-4 mb-6">
      <KPI label="Receita Total" value="R$ 299.500" sub="jan–jun 2026" icon={DollarSign} color="#005BC5" trend={21} />
      <KPI label="Ticket Médio" value="R$ 164" sub="por passageiro" icon={TrendingUp} color="#0084FC" trend={6} />
      <KPI label="Passageiros" value="1.825" sub="no semestre" icon={Users} color="#008B8B" trend={15} />
    </div>
    <div className="grid grid-cols-2 gap-4">
      <div className="bg-white rounded-2xl p-4 shadow-sm">
        <M className="font-bold text-sm text-gray-800 mb-4">Receita e Passageiros Mensais</M>
        <ResponsiveContainer width="100%" height={220}>
          <BarChart data={revenueData}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
            <XAxis dataKey="mes" tick={{ fontSize:11 }} />
            <YAxis yAxisId="left" tick={{ fontSize:11 }} tickFormatter={v=>`${(v/1000).toFixed(0)}k`} />
            <YAxis yAxisId="right" orientation="right" tick={{ fontSize:11 }} />
            <Tooltip />
            <Legend />
            <Bar yAxisId="left" dataKey="receita" fill="#005BC5" radius={[4,4,0,0]} name="Receita (R$)" />
            <Bar yAxisId="right" dataKey="passageiros" fill="#0084FC" radius={[4,4,0,0]} name="Passageiros" opacity={0.7} />
          </BarChart>
        </ResponsiveContainer>
      </div>
      <div className="bg-white rounded-2xl p-4 shadow-sm">
        <M className="font-bold text-sm text-gray-800 mb-4">Receita por Rota</M>
        <div className="flex flex-col gap-3">
          {[["Manaus → Santarém",42,125000],["Manaus → Parintins",28,78000],["Manaus → Tefé",18,64000],["Santarém → Belém",12,32500]].map(([r,p,v]) => (
            <div key={r}>
              <div className="flex justify-between text-xs mb-1"><span className="text-gray-700 font-medium">{r}</span><span className="font-bold text-gray-800">R$ {(v as number).toLocaleString("pt-BR")}</span></div>
              <div className="h-2 bg-gray-100 rounded-full overflow-hidden"><div className="h-full bg-gradient-to-r from-[#005BC5] to-[#0084FC] rounded-full" style={{ width:`${p}%` }} /></div>
              <p className="text-[10px] text-gray-400 mt-0.5">{p}% da receita total</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  </div>
);

const OwnerCustomers = () => (
  <div className="flex-1 overflow-y-auto p-6 bg-[#F1F1F1]">
    <div className="flex items-center justify-between mb-6">
      <div><M className="font-black text-xl text-gray-900">Passageiros</M><p className="text-sm text-gray-500">Base de 1.825 passageiros cadastrados</p></div>
      <button className="flex items-center gap-2 bg-white border border-gray-200 text-gray-600 text-sm px-4 py-2 rounded-xl hover:border-[#005BC5] transition-all"><Download size={14} />Exportar CSV</button>
    </div>
    <div className="bg-white rounded-2xl shadow-sm overflow-hidden">
      <div className="p-4 border-b border-gray-100 flex gap-3">
        <div className="relative flex-1 max-w-sm"><Search size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" /><input placeholder="Buscar passageiro..." className="w-full pl-9 pr-4 py-2 text-sm border border-gray-200 rounded-xl bg-gray-50 outline-none focus:border-[#005BC5]" /></div>
        <button className="flex items-center gap-2 border border-gray-200 bg-white text-gray-600 text-sm px-3 py-2 rounded-xl hover:border-[#005BC5] transition-all"><Filter size={14} />Filtrar</button>
      </div>
      <table className="w-full text-sm">
        <thead className="bg-gray-50"><tr>{["Passageiro","CPF","Email","Viagens","Gasto Total","Status"].map(h=><th key={h} className="text-left text-[11px] font-bold text-gray-500 uppercase tracking-wide py-3 px-4">{h}</th>)}</tr></thead>
        <tbody>{[
          ["Ana Carolina Souza","***.***.***-45","ana.carol@email.com",3,"R$ 555","Ativo"],
          ["Pedro Henrique Lima","***.***.***-78","pedro.lima@gmail.com",7,"R$ 1.330","Ativo"],
          ["Juliana Ferreira","***.***.***-12","ju.ferreira@hotmail.com",2,"R$ 390","Ativo"],
          ["Roberto Costa","***.***.***-90","roberto.c@empresa.com",1,"R$ 220","Inativo"],
          ["Mariana Alves","***.***.***-33","mari.alves@email.com",5,"R$ 900","Ativo"],
        ].map(([name,cpf,email,trips,spent,status]) => (
          <tr key={name} className="border-t border-gray-50 hover:bg-blue-50/30 transition-colors">
            <td className="py-3 px-4"><div className="flex items-center gap-2"><div className="w-8 h-8 rounded-full bg-[#005BC5]/10 flex items-center justify-center text-[#005BC5] font-bold text-xs">{(name as string)[0]}</div><span className="text-xs font-semibold text-gray-800">{name}</span></div></td>
            <td className="py-3 px-4 text-xs text-gray-500 font-mono">{cpf}</td>
            <td className="py-3 px-4 text-xs text-gray-600">{email}</td>
            <td className="py-3 px-4 text-xs font-bold text-gray-800">{trips}</td>
            <td className="py-3 px-4 text-xs font-bold text-[#005BC5]">{spent}</td>
            <td className="py-3 px-4"><Badge c={status==="Ativo"?"teal":"gray"}>{status}</Badge></td>
          </tr>
        ))}</tbody>
      </table>
    </div>
  </div>
);

const OwnerSettings = () => {
  const Toggle = ({ on }: { on:boolean }) => <div className={cn("w-10 h-5 rounded-full relative cursor-pointer", on?"bg-[#005BC5]":"bg-gray-300")}><div className={cn("w-4 h-4 bg-white rounded-full shadow absolute top-0.5 transition-all", on?"left-5":"left-0.5")} /></div>;
  return (
    <div className="flex-1 overflow-y-auto p-6 bg-[#F1F1F1]">
      <M className="font-black text-xl text-gray-900 mb-6">Configurações da Conta</M>
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white rounded-2xl p-5 shadow-sm">
          <M className="font-bold text-sm text-gray-800 mb-4">Dados da Empresa</M>
          <div className="flex flex-col gap-3">
            <Fld label="Nome da Empresa" defaultValue="Porto Certo Viagens LTDA" />
            <Fld label="CNPJ" defaultValue="12.345.678/0001-90" />
            <Fld label="Email Comercial" defaultValue="contato@portocerto.com.br" />
            <Fld label="Telefone" defaultValue="(92) 3000-0000" />
            <Btn>Salvar Alterações</Btn>
          </div>
        </div>
        <div className="bg-white rounded-2xl p-5 shadow-sm">
          <M className="font-bold text-sm text-gray-800 mb-4">Notificações</M>
          {[["Nova reserva confirmada",true],["Cancelamento de reserva",true],["Relatório diário",false],["Alerta de capacidade mínima",true]].map(([l,v]) => (
            <div key={l} className="flex items-center justify-between py-2.5 border-b border-gray-50 last:border-0">
              <span className="text-sm text-gray-600">{l}</span>
              <Toggle on={v as boolean} />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// SCREEN MAP
// ─────────────────────────────────────────────────────────────
const screenList: { id: Screen; label: string }[] = [
  { id:"splash", label:"1. Splash" }, { id:"onboarding", label:"2. Onboarding" }, { id:"assistant", label:"3. Assistente" },
  { id:"login", label:"4. Login" }, { id:"register", label:"5. Cadastro" }, { id:"forgot", label:"6. Recuperar Senha" },
  { id:"home", label:"7. Home" }, { id:"search", label:"8. Busca" }, { id:"results", label:"9. Resultados" },
  { id:"vessel", label:"10. Perfil Embarcação" }, { id:"vessel-trips", label:"11. Próximas Viagens" }, { id:"vessel-reviews", label:"11b. Avaliações" }, { id:"purchase", label:"12. Compra" },
  { id:"accommodation", label:"13. Acomodação" }, { id:"summary", label:"14. Resumo" }, { id:"payment", label:"15. Pagamento" },
  { id:"pix", label:"16. PIX" }, { id:"boleto", label:"17. Boleto" }, { id:"credit-card", label:"17b. Cartão de Crédito" },
  { id:"rejected", label:"18. Recusado" }, { id:"approved", label:"19. Aprovado" }, { id:"ticket", label:"20. Bilhete" },
  { id:"favorites", label:"21. Favoritos" }, { id:"tracking", label:"22. Rastreamento" }, { id:"notifications", label:"22b. Notificações" },
  { id:"profile", label:"23. Perfil" }, { id:"settings-screen", label:"24. Configurações" }, { id:"change-password", label:"24b. Alterar Senha" },
  { id:"accessibility", label:"25. Acessibilidade" }, { id:"high-contrast", label:"26. Alto Contraste" }, { id:"help", label:"27. Ajuda" },
  { id:"terms", label:"28. Termos de Uso" }, { id:"privacy", label:"29. Privacidade" },
  { id:"my-trips", label:"30. Minhas Viagens" },
  { id:"guide-purchase", label:"31. Tutorial: Compra" }, { id:"guide-payment", label:"32. Tutorial: Pagamento" }, { id:"guide-accommodation", label:"33. Tutorial: Acomodação" },
];

// ─────────────────────────────────────────────────────────────
// MAIN APP
// ─────────────────────────────────────────────────────────────
export default function App() {
  const [mode, setMode] = useState<"mobile" | "owner">("mobile");
  const [screen, setScreen] = useState<Screen>("splash");
  const [ownerTab, setOwnerTab] = useState<OwnerTab>("dashboard");
  const [hc, setHc] = useState(false);
  const [favs, setFavs] = useState<number[]>([1]);
  const [tutorialStep, setTutorialStep] = useState(0);
  const [tutorialDone, setTutorialDone] = useState(false);
  const nav = (s: Screen) => setScreen(s);
  const toggleFav = (id: number) => setFavs(p => p.includes(id) ? p.filter(x=>x!==id) : [...p,id]);
  const showTutorial = !tutorialDone && tutorialSteps.some(t => t.screen === screen) && ["home","search","payment","profile"].includes(screen);
  const tutorialIdx = tutorialSteps.findIndex(t => t.screen === screen);
  const handleTutorialNext = () => { if(tutorialStep >= tutorialSteps.length-1) { setTutorialDone(true); } else { setTutorialStep(tutorialStep+1); const nextScr = tutorialSteps[tutorialStep+1].screen; nav(nextScr); } };
  const handleTutorialSkip = () => setTutorialDone(true);

  const renderScreen = () => {
    switch(screen) {
      case "splash": return <SplashScreen nav={nav} />;
      case "onboarding": return <OnboardingScreen nav={nav} />;
      case "assistant": return <AssistantScreen nav={nav} />;
      case "login": return <LoginScreen nav={nav} />;
      case "register": return <RegisterScreen nav={nav} />;
      case "forgot": return <ForgotScreen nav={nav} />;
      case "home": return <HomeScreen nav={nav} favs={favs} toggleFav={toggleFav} />;
      case "search": return <SearchScreen nav={nav} />;
      case "results": return <ResultsScreen nav={nav} favs={favs} toggleFav={toggleFav} />;
      case "vessel": return <VesselScreen nav={nav} />;
      case "vessel-trips": return <VesselTripsScreen nav={nav} />;
      case "vessel-reviews": return <VesselReviewsScreen nav={nav} />;
      case "purchase": return <PurchaseScreen nav={nav} />;
      case "seats": return <AccommodationScreen nav={nav} />;
      case "accommodation": return <AccommodationScreen nav={nav} />;
      case "summary": return <SummaryScreen nav={nav} />;
      case "payment": return <PaymentScreen nav={nav} />;
      case "pix": return <PixScreen nav={nav} />;
      case "boleto": return <BoletoScreen nav={nav} />;
      case "credit-card": return <CreditCardScreen nav={nav} />;
      case "notifications": return <NotificationsScreen nav={nav} />;
      case "change-password": return <ChangePasswordScreen nav={nav} />;
      case "rejected": return <RejectedScreen nav={nav} />;
      case "approved": return <ApprovedScreen nav={nav} />;
      case "ticket": return <TicketScreen nav={nav} />;
      case "my-trips": return <MyTripsScreen nav={nav} />;
      case "guide-purchase": return <GuideScreen nav={nav} topic="purchase" />;
      case "guide-payment": return <GuideScreen nav={nav} topic="payment" />;
      case "guide-accommodation": return <GuideScreen nav={nav} topic="accommodation" />;
      case "favorites": return <FavoritesScreen nav={nav} favs={favs} toggleFav={toggleFav} />;
      case "tracking": return <TrackingScreen nav={nav} />;
      case "profile": return <ProfileScreen nav={nav} />;
      case "settings-screen": return <SettingsScreen nav={nav} />;
      case "accessibility": return <AccessibilityScreen nav={nav} hc={hc} setHc={setHc} />;
      case "high-contrast": return <HighContrastScreen nav={nav} setHc={setHc} />;
      case "help": return <HelpScreen nav={nav} />;
      case "terms": return <TermsScreen nav={nav} />;
      case "privacy": return <PrivacyScreen nav={nav} />;
      default: return <HomeScreen nav={nav} favs={favs} toggleFav={toggleFav} />;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#001a4a] via-[#003a8c] to-[#005BC5] flex flex-col" style={{ fontFamily: "Roboto, sans-serif" }}>
      {/* Header */}
      <div className="flex items-center justify-between px-6 py-3 bg-black/20 backdrop-blur-sm border-b border-white/10 flex-shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-full bg-white/15 flex items-center justify-center"><Waves size={16} className="text-white" /></div>
          <M className="text-white font-black text-base">PORTO CERTO VIAGENS</M>
          <span className="text-white/40 text-xs">|</span>
          <span className="text-white/60 text-xs">Sistema de Design Completo</span>
        </div>
        <div className="flex items-center gap-2">
          <div className="flex bg-white/10 rounded-xl p-1 gap-1">
            <button onClick={() => setMode("mobile")} className={cn("text-xs font-bold px-3 py-1.5 rounded-lg transition-all flex items-center gap-1.5", mode==="mobile" ? "bg-white text-[#005BC5]" : "text-white/60 hover:text-white")}>
              <svg viewBox="0 0 16 24" className="w-3 h-4" fill="none" stroke="currentColor" strokeWidth="2"><rect x="2" y="1" width="12" height="22" rx="2"/><circle cx="8" cy="19" r="1" fill="currentColor" /></svg>App Viajante
            </button>
            <button onClick={() => setMode("owner")} className={cn("text-xs font-bold px-3 py-1.5 rounded-lg transition-all flex items-center gap-1.5", mode==="owner" ? "bg-white text-[#005BC5]" : "text-white/60 hover:text-white")}>
              <LayoutDashboard size={13} />Painel Proprietário
            </button>
          </div>
        </div>
      </div>

      {mode === "mobile" ? (
        <div className="flex flex-1 overflow-hidden">
          {/* Screen Navigator */}
          <div className="w-52 flex-shrink-0 bg-black/30 backdrop-blur-sm border-r border-white/10 overflow-y-auto py-4">
            <p className="text-white/40 text-[10px] font-bold uppercase tracking-widest px-4 mb-3">37 Telas</p>
            {screenList.map(({ id, label }) => (
              <button key={id} onClick={() => nav(id)} className={cn("w-full text-left text-xs px-4 py-2 transition-all rounded-lg mx-1", screen===id ? "text-white font-bold bg-white/15" : "text-white/50 hover:text-white hover:bg-white/8")}>
                {label}
              </button>
            ))}
          </div>

          {/* Phone + Context */}
          <div className="flex-1 flex flex-col items-center justify-center gap-6 p-8 overflow-auto">
            <div className="flex items-start gap-8">
              <PhoneFrame hc={hc}>
                {hc && screen !== "high-contrast" && (
                  <style>{`[data-hc-wrap] img { filter: invert(1) hue-rotate(180deg) !important; }`}</style>
                )}
                <div className="relative w-full h-full" data-hc-wrap={hc && screen !== "high-contrast" ? "" : undefined} style={hc && screen !== "high-contrast" ? { filter: "invert(1) hue-rotate(180deg)" } : {}}>
                  {renderScreen()}
                  {showTutorial && tutorialIdx === tutorialStep && (
                    <TutorialOverlay screen={screen} onNext={handleTutorialNext} onSkip={handleTutorialSkip} step={tutorialStep} total={tutorialSteps.length} />
                  )}
                </div>
              </PhoneFrame>
              {/* Annotations */}
              <div className="w-64 flex-shrink-0 flex flex-col gap-3 mt-8">
                <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-4 border border-white/15">
                  <M className="text-white font-bold text-xs mb-2">Tela Atual</M>
                  <p className="text-white/80 text-sm font-semibold">{screenList.find(s=>s.id===screen)?.label}</p>
                  {hc && <div className="mt-2 bg-yellow-400/20 rounded-lg px-2 py-1"><p className="text-yellow-400 text-[10px] font-bold">⚡ ALTO CONTRASTE ATIVO</p></div>}
                </div>
                <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-4 border border-white/15">
                  <M className="text-white font-bold text-xs mb-2">Design System</M>
                  <div className="grid grid-cols-4 gap-1.5 mb-2">
                    {[["#005BC5","Primário"],["#0084FC","Sec."],["#008B8B","Água"],["#FFA500","Destaque"]].map(([c,l]) => (
                      <div key={c} className="flex flex-col items-center gap-1"><div className="w-7 h-7 rounded-lg border border-white/20" style={{ background:c }} /><span className="text-white/50 text-[8px]">{l}</span></div>
                    ))}
                  </div>
                  <div className="flex flex-col gap-0.5">
                    <p className="text-white/40 text-[9px]">Montserrat — Títulos</p>
                    <p className="text-white/40 text-[9px]">Roboto — Corpo</p>
                  </div>
                </div>
                <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-4 border border-white/15">
                  <M className="text-white font-bold text-xs mb-2">UX & Acessibilidade</M>
                  <div className="flex flex-col gap-1">{["WCAG 2.1 AA","10 Heurísticas Nielsen","Feedback Visual Imediato","Compatível TalkBack/VoiceOver","Contraste 4.5:1+"].map(t=><p key={t} className="text-white/60 text-[10px] flex items-center gap-1.5"><Check size={9} className="text-[#FFA500]" />{t}</p>)}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      ) : (
        <div className="flex flex-1 overflow-hidden bg-[#F1F1F1]">
          <OwnerSidebar active={ownerTab} set={setOwnerTab} />
          {ownerTab==="dashboard" && <OwnerDashboard />}
          {ownerTab==="trips" && <OwnerTrips />}
          {ownerTab==="vessels" && <OwnerVessels />}
          {ownerTab==="revenue" && <OwnerRevenue />}
          {ownerTab==="customers" && <OwnerCustomers />}
          {ownerTab==="settings" && <OwnerSettings />}
        </div>
      )}
    </div>
  );
}
