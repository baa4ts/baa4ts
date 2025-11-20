import { CustomIcons } from './Skills/CustomIcons';
import { Expressjs, JavaScript, Prisma, ReactLogo, TypeScript, Vercel } from './svg';

const Skills = () => {
  return (
    <section className="w-full flex flex-col mt-4 items-center p-5 md:p-0">
      <article className="bg-[#060913] w-full md:w-4/5 lg:w-3/5">
        <header className="m-5 border-b border-white">
          <h2 className="text-white text-2xl font-Samsung font-bold">Skills</h2>
        </header>

        <section className="flex flex-wrap gap-5 p-5 justify-center md:justify-start">
          <CustomIcons svg={<TypeScript className="w-8 md:w-12 h-8 md:h-12" />} texto="TypeScript" />
          <CustomIcons svg={<JavaScript className="w-8 md:w-12 h-8 md:h-12" />} texto="JavaScript" />
          <CustomIcons svg={<ReactLogo className="w-8 md:w-12 h-8 md:h-12" />} texto="React" />
          <CustomIcons svg={<Expressjs className="w-8 md:w-12 h-8 md:h-12" />} texto="Express" />
          <CustomIcons svg={<Prisma className="w-8 md:w-12 h-8 md:h-12" />} texto="Prisma" />
          <CustomIcons svg={<Vercel className="w-8 md:w-12 h-8 md:h-12" />} texto="Vercel" />
        </section>
      </article>
    </section>
  );
};

export default Skills;
