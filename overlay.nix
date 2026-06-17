final: prev:
let
  lib = final.lib;

  demoClients = [
    "clickdot"
    "cliptest"
    "color"
    "constraints"
    "content_protection"
    "dnd"
    "editor"
    "eventdemo"
    "flower"
    "fullscreen"
    "image"
    "multi-resource"
    "presentation-shm"
    "resizor"
    "scaler"
    "smoke"
    "stacking"
    "subsurfaces"
    "tablet"
    "transformed"
  ];
  simpleClients = [
    "simple-damage"
    "simple-dmabuf-feedback"
    "simple-dmabuf-v4l"
    "simple-dmabuf-egl"
    "simple-egl"
    "simple-shm"
    "simple-touch"
    "simple-im"
    "simple-vulkan"
    "simple-dmabuf-vulkan"
  ];
  tools = [
    "calibrator"
    "debug"
    "terminal"
    "touch-calibrator"
  ];

  clientNames = map (n: "weston-${n}") (demoClients ++ simpleClients ++ tools);
in
{
  weston-demos =
    (prev.weston.override {
      rdpSupport = false;
      vncSupport = false;
      pipewireSupport = false;
      remotingSupport = false;
      xwaylandSupport = false;
      lcmsSupport = false;
      luaSupport = false;
    }).overrideAttrs
      (old: {
        pname = "weston-demos";

        mesonFlags =
          (lib.filter (
            f:
            !(lib.hasPrefix "-Dsimple-clients=" f)
            && !(lib.hasPrefix "-Ddemo-clients=" f)
            && !(lib.hasPrefix "-Dtools=" f)
          ) old.mesonFlags)
          ++ [
            (lib.mesonBool "demo-clients" true)
            (lib.mesonOption "simple-clients" "all")
            (lib.mesonOption "tools" "calibrator,debug,terminal,touch-calibrator")
          ];

        # Keep only the demo/example clients and the data files they load; drop the
        # compositor, its shell/backend plugins, libweston and the dev files.
        postInstall = (old.postInstall or "") + ''
          mkdir -p "$out/.clients"
          for n in ${lib.concatStringsSep " " clientNames}; do
            if   [ -e "$out/bin/$n" ];     then mv "$out/bin/$n"     "$out/.clients/";
            elif [ -e "$out/libexec/$n" ]; then mv "$out/libexec/$n" "$out/.clients/";
            else echo "weston-demos: warning: $n was not built, skipping" >&2; fi
          done
          rm -rf "$out/bin" "$out/libexec" "$out/lib" "$out/include" "$out/etc"
          mv "$out/.clients" "$out/bin"
          # Keep share/weston (icons, cursors, decorations); drop everything else.
          find "$out/share" -mindepth 1 -maxdepth 1 ! -name weston -exec rm -rf {} +
        '';

        passthru = { inherit clientNames; };

        meta = old.meta // {
          description = "Weston example/demo Wayland clients";
          mainProgram = "weston-flower";
        };
      });
}
