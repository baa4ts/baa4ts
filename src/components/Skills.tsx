import { CustomIcons } from "./custom/CustomIcons";
import {
  MemoExpressjs,
  MemoHono,
  MemoJavaScript,
  MemoReact,
  MemoTanStack,
  MemoTypeScript,
} from "./svg";

const Skills = () => {
  const skillGroups = [
    {
      title: "Front-end",
      skills: [
        { icon: <MemoReact className="w-8 md:w-12 h-8 md:h-12" />, text: "React" },
        { icon: <MemoTanStack className="w-8 md:w-12 h-8 md:h-12" />, text: "TanStack" },
      ],
    },
    {
      title: "Lenguajes",
      skills: [
        { icon: <MemoTypeScript className="w-8 md:w-12 h-8 md:h-12" />, text: "TypeScript" },
        { icon: <MemoJavaScript className="w-8 md:w-12 h-8 md:h-12" />, text: "JavaScript" },
      ],
    },
    {
      title: "Back-end",
      skills: [
        { icon: <MemoExpressjs className="w-8 md:w-12 h-8 md:h-12" />, text: "Express" },
        { icon: <MemoHono className="w-8 md:w-12 h-8 md:h-12" />, text: "Hono.js" },
      ],
    },
  ];

  return (
    <section className="w-full flex flex-col mt-2 items-center p-5 md:p-0">
      <article className="bg-[#060913] w-full md:w-4/5 lg:w-3/5">
        <header className="pt-5 px-5 mb-2">
          <h2 className="text-white text-3xl font-Samsung font-bold text-center md:text-left">
            Skills
          </h2>
        </header>

        <section className="flex flex-wrap gap-5 px-5 mt-5 pb-5 justify-evenly md:justify-start">
          {skillGroups.map((group, index) => (
            <div key={index} className="flex gap-5 flex-col text-center">
              <h3 className="text-white font-mono">{group.title}</h3>
              <div className="flex gap-2 justify-center">
                {group.skills.map((skill, skillIndex) => (
                  <CustomIcons key={skillIndex} svg={skill.icon} texto={skill.text} />
                ))}
              </div>
            </div>
          ))}
        </section>
      </article>
    </section>
  );
};

export default Skills;