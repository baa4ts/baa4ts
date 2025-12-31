import { type ReactNode, useState } from 'react';

interface CustomIconsProps {
  svg: ReactNode;
  texto: string;
}

export function CustomIcons({ svg, texto }: CustomIconsProps) {
  const [show, setShow] = useState(false);

  const toggle = () => setShow(!show);

  return (
    <div className="relative inline-block select-none" onMouseEnter={() => setShow(true)} onMouseLeave={() => setShow(false)} onClick={toggle}>
      <div className="w-10 h-10 flex items-center justify-center">{svg}</div>

      {show && (
        <div className="absolute bottom-full left-1/2 -translate-x-1/2 font-Samsung font-thin mb-3 px-3 py-2 bg-white text-black text-sm rounded-lg shadow-lg whitespace-nowrap z-10 min-w-[110px] text-center">
          {texto}
        </div>
      )}
    </div>
  );
}