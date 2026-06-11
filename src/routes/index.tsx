import { createFileRoute } from '@tanstack/react-router'
import { Hero } from '../components/portfolio/Hero'
import { Skills } from '../components/portfolio/Skills'

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
