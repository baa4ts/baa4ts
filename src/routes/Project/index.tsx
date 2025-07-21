import { createFileRoute } from '@tanstack/react-router'

export const Route = createFileRoute('/Project/')({
  component: RouteComponent,
})

function RouteComponent() {
  return <div>Hello "/Project/"!</div>
}
