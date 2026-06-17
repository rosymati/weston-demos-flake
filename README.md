# weston-demos

A Nix flake that builds the
[Weston](https://gitlab.freedesktop.org/wayland/weston) example clients and
bundles them into a single package.

nixpkgs ships `weston` with `simple-clients` and the accessory tools turned off,
so you only get the toytoolkit demos. This flake enables all of them without
including the compositor.

It's useful if you're testing or building a compositor and need the Weston
clients and tools, but have no reason to install Weston itself.

## How to use it

Run one without installing:

```sh
nix run github:rosymati/weston-demos-flake#weston-flower
```

Drop all of them into a shell:

```sh
nix shell github:rosymati/weston-demos-flake
weston-terminal
```

Add them to a NixOS config through the overlay:

```nix
{
  nixpkgs.overlays = [ weston-demos.overlays.default ];
  environment.systemPackages = [ pkgs.weston-demos ]; # or home.packages
}
```

## What's included

- Demo clients: `weston-flower`, `weston-image`, `weston-dnd`, `weston-editor`,
  `weston-smoke`, `weston-terminal`, and the rest of the toytoolkit set.
- Simple clients: `weston-simple-shm`, `weston-simple-egl`,
  `weston-simple-touch`, the dmabuf and vulkan variants, and so on.
- Tools: `weston-debug`, `weston-calibrator`, `weston-touch-calibrator`.

## License

This project is licensed under the
[Apache-2.0 License](http://www.apache.org/licenses/LICENSE-2.0). For more
information, please see the [LICENSE](LICENSE) file.
