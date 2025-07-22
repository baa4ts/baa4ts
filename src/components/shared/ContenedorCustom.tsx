import type { JSX, ReactNode } from "react"

interface Props {
    children: ReactNode
    className?: string
    defaultView?: boolean
}

export const Contenedor = ({ children, className, defaultView }: Props): JSX.Element => {
    const style = [className, (defaultView && "w-screen md:w-5/6 lg:w-4/6")].join(" ")
    return (
        <section className={style}>
            {children}
        </section>
    )
}