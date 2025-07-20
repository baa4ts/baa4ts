import { type JSX } from 'react';
import { CustomContenedor } from '../shared/customContenedor';
import { SkillCard } from '../shared/skillCard';
import { iconResourceSkills, iconResourceStudy } from '../../resource/iconsMap';

export const SkillsCompo = (): JSX.Element => {
  return (
    <CustomContenedor defaultSize className="mt-20 flex flex-col">
      <section className="mb-6 rounded-2xl border-2 border-white-cream-vanill p-4">
        <header className="mb-10 flex h-24 items-center justify-center rounded-2xl bg-white">
          <h2 className="font-poppins text-4xl font-black uppercase tracking-wide text-black">Tech stack</h2>
        </header>

        <div className="flex flex-col gap-12 text-white-cream-vanill md:flex-row">
          {/* Skills List */}
          <div className="flex flex-col md:w-1/2">
            <h3 className="mb-6 text-center font-poppins text-2xl font-semibold tracking-tight text-white">
              Skills
            </h3>
            <section className="mb-5 flex flex-wrap gap-2">
              {iconResourceSkills.map((iconInfo) => (
                <SkillCard key={iconInfo.name} src={iconInfo.path} name={iconInfo.name} />
              ))}
            </section>
          </div>

          {/* Studying Section */}
          <div className="flex flex-col md:w-1/2">
            <h3 className="mb-6 text-center font-poppins text-2xl font-semibold tracking-tight text-white">
              Studing
            </h3>
            <section className="mb-5 flex flex-wrap gap-2">
              {iconResourceStudy.map((iconInfo) => (
                <SkillCard key={iconInfo.name} src={iconInfo.path} name={iconInfo.name} />
              ))}
            </section>
          </div>
        </div>
      </section>
    </CustomContenedor>
  );
};
