import type { JSX, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  className?: string;
}

export const ContenedorCustom = ({ children, className }: Props): JSX.Element => {
  const style = className ? ['w-full md:w-[70%] mx-auto', className].join(' ') : 'w-full md:w-[70%] mx-auto';

  return <section className={style}>{children}</section>;
};
