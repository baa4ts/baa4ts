import { CustomIcons } from './Skills/CustomIcons';
import { Expressjs, JavaScript, Prisma, ReactLogo, TanStack, TypeScript, Vercel } from './svg';

const Skills = () => {
  return (
    <section className="w-full flex flex-col mt-2 items-center p-5 md:p-0">
      <article className="bg-[#060913] w-full md:w-4/5 lg:w-3/5">
        <header className="pt-5 px-5 mb-2">
          <h2 className="text-white text-3xl font-Samsung font-bold">Skills</h2>
        </header>

        <section className="flex flex-wrap gap-5 px-5 pb-5 justify-center md:justify-start">
          <CustomIcons svg={<ReactLogo className="w-8 md:w-12 h-8 md:h-12" />} texto="React" />
          <CustomIcons svg={<TanStack className="w-8 md:w-12 h-8 md:h-12" />} texto="TanStack" />
          <CustomIcons svg={<TypeScript className="w-8 md:w-12 h-8 md:h-12" />} texto="TypeScript" />
          <CustomIcons svg={<JavaScript className="w-8 md:w-12 h-8 md:h-12" />} texto="JavaScript" />
          <CustomIcons svg={<Expressjs className="w-8 md:w-12 h-8 md:h-12" />} texto="Express" />
          <CustomIcons svg={<Prisma className="w-8 md:w-12 h-8 md:h-12" />} texto="Prisma" />
          <CustomIcons svg={<Vercel className="w-8 md:w-12 h-8 md:h-12" />} texto="Vercel" />
        </section>
      </article>
    </section>
  );
};

export default Skills;
