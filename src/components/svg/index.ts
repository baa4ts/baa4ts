import { memo } from 'react';
import { HTML5 } from './Html5';
import { JavaScript } from './JavaScript';
import { CSS } from './Css';
import { Expressjs } from './Express';
import { Hono } from './Hono';
import { Prisma } from './Prisma';
import { React as ReactLogo } from './React';
import { TypeScript } from './TypeScript';
import { Vercel } from './Vercel';
import { MySQL } from "./MySQL"
import { Turso } from "./Turso"
import { CloudflareWorkers } from "./CloudflareWorkers"
import { TanStack } from "./TanStack"

export const MemoHTML5 = memo(HTML5);
export const MemoJavaScript = memo(JavaScript);
export const MemoCSS = memo(CSS);
export const MemoExpressjs = memo(Expressjs);
export const MemoHono = memo(Hono);
export const MemoPrisma = memo(Prisma);
export const MemoReact = memo(ReactLogo);
export const MemoTypeScript = memo(TypeScript);
export const MemoVercel = memo(Vercel);
export const MemoMySQL = memo(MySQL);
export const MemoTurso = memo(Turso)
export const MemoCloudflareWorkers = memo(CloudflareWorkers)
export const MemoTanStack = memo(TanStack)