import { Outlet, createRootRoute } from "@tanstack/react-router";
import type { JSX } from "react";
import React from "react";

export const Route = createRootRoute({
  component: RootComponent,
});

function RootComponent(): JSX.Element {
  return (
    <React.Fragment>
      <Outlet />
    </React.Fragment>
  );
}
