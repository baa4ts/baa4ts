import { Github, Goal } from 'lucide-react';

const Hero = () => {
  return (
    <section className="w-full md:w-4/5 lg:w-3/5 mt-10 md:mt-24 gap-2 text-white flex flex-col md:flex-row justify-center items-stretch p-5 md:p-0">
      {/* Imagen de perfil */}
      <article className="md:w-2/5 h-64 md:h-72">
        <img
          className="w-full h-full object-cover"
          src="https://i.pinimg.com/1200x/44/c4/83/44c4837d944315f8f4bcb7f9e65e63ad.jpg"
          alt="baa4ts, desarrollador backend"
          loading="lazy"
        />
      </article>

      {/* Card bio */}
      <article
        className="md:w-3/5 flex flex-col justify-center 
        bg-[#060913]
        shadow-lg p-6 md:p-4 md:h-72"
      >
        <h1 className="text-3xl font-Samsung font-extrabold">baa4ts</h1>
        <p className="text-slate-300 md:text-slate-200 mt-3 leading-relaxed font-mono">
          Soy Carlos (baa4ts), estudiante de tecnicatura en Redes y Software, especializado en desarrollo backend. Actualmente estoy aprendiendo React junto a
          TanStack, disfrutando del proceso y creando proyectos que combinan logica, curiosidad y practica constante.
        </p>
        <div className="flex flex-col md:gap justify-center gap-2 md:flex-row mt-5">
          <button className="flex flex-row gap-2 cursor-pointer md:hover:scale-102 md:transition-transform  items-center justify-center font-mono bg-blue-600 text-white w-full md:w-44 rounded h-10 md:h-8 hover:bg-blue-600/70 transition-colors">
            Looking for job <Goal color="white" size={20} />
          </button>

          <a
            href="https://github.com/baa4ts"
            className="flex flex-row gap-2 cursor-pointer md:hover:scale-102 md:transition-transform  items-center justify-center font-mono bg-blue-600 text-white w-full md:w-44 rounded h-10 md:h-8 hover:bg-blue-600/70 transition-colors"
          >
            Github <Github color="white" size={20} />
          </a>
        </div>
      </article>
    </section>
  );
};

export default Hero;