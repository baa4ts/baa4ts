import { Github } from 'lucide-react';
import { MemoCSS, MemoHTML5, MemoJavaScript } from './svg';
import { CustomIcons } from './custom/CustomIcons';

const Proyectos = () => {
    return (
        <section className="w-full flex flex-col items-center mt-2 p-5 md:p-0">
            <article className="bg-[#060913] w-full md:w-4/5 lg:w-3/5 overflow-hidden shadow-lg">
                <header className="px-5 pt-5 mb-3">
                    <h2 className="text-white text-3xl md:text-4xl font-Samsung font-bold">Proyectos</h2>
                </header>

                <section className="flex flex-col gap-5 px-5 pb-5 md:flex-row md:gap-8">
                    <article className="flex flex-col md:flex-row border border-white overflow-hidden w-full">
                        <img
                            className="w-full md:w-80 h-auto object-cover"
                            src="https://raw.githubusercontent.com/baa4ts/catbox-helper/refs/heads/main/asset/1.PNG"
                            alt="catbox-helper screenshot"
                        />
                        <div className="flex flex-col p-4 md:p-5 justify-between">
                            <div>
                                <h2 className="text-2xl md:text-3xl text-white font-Samsung mb-2">catbox-helper</h2>
                                <p className="text-white/80 text-sm md:text-base">
                                    Extension para Chrome/Chromium que extrae automaticamente los enlaces de archivos subidos a Catbox.moe y permite exportarlos en TXT, JSON o
                                    CSV.
                                </p>
                            </div>

                            <div className="flex flex-wrap gap-4 mt-4">
                                <CustomIcons svg={<MemoHTML5 className="w-8 h-8 md:w-12 md:h-12" />} texto="HTML5" />
                                <CustomIcons svg={<MemoJavaScript className="w-8 h-8 md:w-12 md:h-12" />} texto="JavaScript" />
                                <CustomIcons svg={<MemoCSS className="w-8 h-8 md:w-12 md:h-12" />} texto="CSS3" />
                            </div>

                            <div className="mt-4 md:mt-6 flex justify-center md:justify-start">
                                <a
                                    href="https://github.com/baa4ts/catbox-helper"
                                    className="flex items-center justify-center gap-2 w-full md:w-44 h-10 rounded bg-blue-600 text-white font-mono hover:bg-blue-600/70 transition-colors duration-200"
                                >
                                    Source code <Github color="white" size={20} />
                                </a>
                            </div>
                        </div>
                    </article>
                </section>
            </article>
        </section>
    );
};

export default Proyectos;