import type { JSX, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  className?: string;
  defaultSize?: boolean;
}

export const CustomContenedor = ({ children, className = '', defaultSize = false }: Props): JSX.Element => {
  const classes = [defaultSize ? 'w-6/6 md:w-5/6' : '', className].filter(Boolean).join(' ');
  return <section className={classes}>{children}</section>;
};
