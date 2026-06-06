import * as React from 'react'
import { Outlet, createRootRoute } from '@tanstack/react-router'
import { TanStackRouterDevtools } from '@tanstack/react-router-devtools'

export const Route = createRootRoute({
    component: RootComponent,
})

function RootComponent() {
    return (
        <React.Fragment>
            <section className="mx-auto flex w-full flex-col gap-4 px-4 py-8 sm:px-6 md:w-[70%] lg:w-[50%]">
                <Outlet />
            </section>

            {/* Dev */}
            <TanStackRouterDevtools />
        </React.Fragment>
    )
}
