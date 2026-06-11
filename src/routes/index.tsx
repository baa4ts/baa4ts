import { createFileRoute } from '@tanstack/react-router'
import { Hero } from '../components/portfolio/Hero'
import { Skills } from '../components/portfolio/Skills'
import { Proyectos } from '../components/portfolio/Proyectos'

export const Route = createFileRoute('/')({
    component: RouteComponent,
})

function RouteComponent() {
    return (
        <>
            <Hero />
            <Skills />
        </>
    )
}
