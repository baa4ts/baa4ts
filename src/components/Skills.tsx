import { CustomIcons } from "./custom/CustomIcons";
import { MemoCloudflareWorkers, MemoExpressjs, MemoHono, MemoJavaScript, MemoMySQL, MemoPrisma, MemoReact, MemoTanStack, MemoTurso, MemoTypeScript, MemoVercel } from "./svg";


const Skills = () => {
    return (
        <section className="w-full flex flex-col mt-2 items-center p-5 md:p-0">
            <article className="bg-[#060913] w-full md:w-4/5 lg:w-3/5">
                <header className="pt-5 px-5 mb-2">
                    <h2 className="text-white text-3xl font-Samsung font-bold text-center md:text-left">Skills</h2>
                </header>

                <section className="flex flex-wrap gap-5 px-5 mt-5 pb-5 justify-center md:justify-start">
                    <span className="flex gap-5">
                        <CustomIcons svg={<MemoReact className="w-8 md:w-12 h-8 md:h-12" />} texto="React" />
                        <CustomIcons svg={<MemoTanStack className="w-8 md:w-12 h-8 md:h-12" />} texto="TanStack" />
                    </span>
                    <span className="flex gap-5">
                        <CustomIcons svg={<MemoTypeScript className="w-8 md:w-12 h-8 md:h-12" />} texto="TypeScript" />
                        <CustomIcons svg={<MemoJavaScript className="w-8 md:w-12 h-8 md:h-12" />} texto="JavaScript" />
                    </span>
                    <span className="flex gap-5">
                        <CustomIcons svg={<MemoExpressjs className="w-8 md:w-12 h-8 md:h-12" />} texto="Express" />
                        <CustomIcons svg={<MemoHono className="w-8 md:w-12 h-8 md:h-12" />} texto="Hono.js" />
                    </span>
                    <span className="flex gap-5">
                        <CustomIcons svg={<MemoMySQL className="w-8 md:w-12 h-8 md:h-12" />} texto="MySql" />
                        <CustomIcons svg={<MemoTurso className="w-8 md:w-12 h-8 md:h-12" />} texto="Turso Sqlite" />
                        <CustomIcons svg={<MemoPrisma className="w-8 md:w-12 h-8 md:h-12" />} texto="Prisma" />
                    </span>
                    <span className="flex gap-5">
                        <CustomIcons svg={<MemoVercel className="w-8 md:w-12 h-8 md:h-12" />} texto="Vercel" />
                        <CustomIcons svg={<MemoCloudflareWorkers className="w-8 md:w-12 h-8 md:h-12" />} texto="Cloudflare Workers" />
                    </span>
                </section>
            </article>
        </section>
    );
};

export default Skills;