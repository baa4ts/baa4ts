import type { JSX } from 'react';

interface Props {
  src?: string;
  name?: string;
  filter?: boolean;
}

export const SkillCard = ({ src, name, filter = true }: Props): JSX.Element => {
  const style = filter ? 'h-12 w-12 object-contain filter brightness-0 invert' : 'h-12 w-12 object-contain';

  return (
    <article
      className="flex items-center gap-4 bg-white/10 rounded-lg shadow-md p-3 cursor-pointer select-none
                       transition-transform duration-300 transform hover:scale-105 hover:bg-pink-punchy-pink"
    >
      <img className={style} src={src} alt={name} loading="lazy" />
      <p className="font-poppins text-white text-lg font-semibold">{name}</p>
    </article>
  );
};
