import { Line, Path, Rect, Svg } from '@react-pdf/renderer'

// ---------- Iconos SVG ----------
export const PhoneIcon = () => (
  <Svg width="12" height="12" viewBox="0 0 24 24">
    <Path
      d="M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.5.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1C10.1 21 3 13.9 3 5c0-.6.4-1 1-1h3.4c.6 0 1 .4 1 1 0 1.2.2 2.4.6 3.5.1.4 0 .8-.2 1l-2.2 2.3z"
      fill="#3355D8"
    />
  </Svg>
)

export const MailIcon = () => (
  <Svg width="12" height="12" viewBox="0 0 24 24">
    <Rect
      x="2.5"
      y="4.5"
      width="19"
      height="15"
      rx="1.5"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.6"
    />
    <Path
      d="M3.5 6 L12 13 L20.5 6"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.6"
    />
  </Svg>
)

export const BriefcaseIcon = () => (
  <Svg width="12" height="12" viewBox="0 0 24 24">
    <Path
      d="M9 4h6a1.5 1.5 0 0 1 1.5 1.5V8h-9V5.5A1.5 1.5 0 0 1 9 4z"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.7"
    />
    <Rect
      x="2.5"
      y="8"
      width="19"
      height="11.5"
      rx="2"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.7"
    />
    <Line
      x1="2.5"
      y1="13"
      x2="21.5"
      y2="13"
      stroke="#3355D8"
      strokeWidth="1.7"
    />
  </Svg>
)

export const GradCapIcon = () => (
  <Svg width="14" height="14" viewBox="0 0 24 24">
    <Path d="M12 3 1 8l11 5 9-4.1V16h1.8V8L12 3z" fill="#3355D8" />
    <Path
      d="M5 10.6v3.9c0 1.6 3 3.6 7 3.6s7-2 7-3.6v-3.9l-7 3.2-7-3.2z"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.4"
    />
  </Svg>
)

export const GithubIcon = () => (
  <Svg width="12" height="12" viewBox="0 0 24 24">
    <Path
      d="M12 2C6.48 2 2 6.58 2 12.25c0 4.53 2.87 8.37 6.84 9.73.5.1.68-.22.68-.5 0-.24-.01-1.04-.01-1.89-2.78.62-3.37-1.22-3.37-1.22-.45-1.18-1.11-1.5-1.11-1.5-.9-.63.07-.62.07-.62 1 .07 1.53 1.06 1.53 1.06.89 1.56 2.34 1.11 2.91.85.09-.66.35-1.11.63-1.37-2.22-.26-4.56-1.14-4.56-5.07 0-1.12.39-2.03 1.03-2.75-.1-.26-.45-1.31.1-2.73 0 0 .84-.28 2.75 1.05a9.3 9.3 0 0 1 2.5-.35c.85 0 1.7.12 2.5.35 1.91-1.33 2.75-1.05 2.75-1.05.55 1.42.2 2.47.1 2.73.64.72 1.03 1.63 1.03 2.75 0 3.94-2.34 4.8-4.57 5.06.36.32.68.95.68 1.92 0 1.39-.01 2.5-.01 2.85 0 .28.18.6.69.5A10.26 10.26 0 0 0 22 12.25C22 6.58 17.52 2 12 2z"
      fill="#3355D8"
      fillRule="evenodd"
    />
  </Svg>
)

export const WebIcon = () => (
  <Svg width="12" height="12" viewBox="0 0 24 24">
    <Path
      d="M12 2a10 10 0 1 0 0 20 10 10 0 0 0 0-20z"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.6"
    />
    <Path
      d="M2 12h20M12 2c2.5 2.7 3.8 6.2 3.8 10S14.5 19.3 12 22c-2.5-2.7-3.8-6.2-3.8-10S9.5 4.7 12 2z"
      fill="none"
      stroke="#3355D8"
      strokeWidth="1.6"
    />
  </Svg>
)

// Versión rellena (sólida)
export const NpmIcon = () => (
  <Svg width="12" height="12" viewBox="0 0 24 24">
    <Path
      d="M2 2 H22 V22 H2 Z M6 6 V18 H12 V10 H14 V18 H18 V6 Z"
      fill="#3355D8"
      fillRule="evenodd"
    />
  </Svg>
)
