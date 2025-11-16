import { ArrowDown } from 'lucide-react';

const Hero = () => {
  return (
    <section className="h-screen w-screen">
      <section className="flex h-5/6 w-full flex-col items-center justify-end md:h-5/6 md:flex-row md:items-end md:justify-center">
        <span className="font-bre-bold text-9xl text-black dark:text-stone-200 md:text-[12rem] lg:text-[15rem]">BA</span>
        <span className="font-bre-bold text-9xl text-black dark:text-stone-200 md:text-[12rem] lg:text-[15rem]">A4</span>
        <span className="font-bre-bold text-9xl text-black dark:text-stone-200 md:text-[12rem] lg:text-[15rem]">TS</span>
      </section>

      <section className="flex h-1/6 w-full items-center justify-center">
        <ArrowDown size={48} className="text-slate-400 animate-bounce hover:cursor-pointer" />
      </section>
    </section>
  );
};

export default Hero;
