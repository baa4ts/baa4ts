import { useState } from 'react';
import type { SVGProps } from 'react';

const Vercel = (props: SVGProps<SVGSVGElement>) => {
  const [show, setShow] = useState(false);

  const toggle = () => setShow(!show);

  return (
    <div
      className="relative inline-block select-none"
      onMouseEnter={() => setShow(true)}
      onMouseLeave={() => setShow(false)}
      onClick={toggle} // para moviles (tocar)
    >
      <svg {...props} viewBox="0 0 256 222" preserveAspectRatio="xMidYMid" className="w-12 h-12">
        <path fill="#fff" d="m128 0 128 221.705H0z" />
      </svg>

      {show && (
        <div className="absolute bottom-full left-1/2 -translate-x-1/2 mb-3 px-3 py-2 bg-black text-white text-sm rounded-lg shadow-lg whitespace-nowrap z-10 min-w-[110px] text-center">
          Logo de Vercel
        </div>
      )}
    </div>
  );
};

export { Vercel };
