class T3code < Formula
  desc "Standalone T3 coding-agent server and browser interface"
  homepage "https://t3.codes"
  url "https://github.com/pingdotgg/t3code/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "3cebef4166dab372d731731c99c3f10668eb32e9829f9c495b91da59f4e6124b"
  license "MIT"
  head "https://github.com/pingdotgg/t3code.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "node"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v1.3.0.tar.gz"
    sha256 "349be987e7582e6aa26763b2de96c4cbbd0d3cfba2417d9733524589fdbc275f"
  end

  resource "fff" do
    url "https://github.com/dmtrKovalenko/fff/archive/refs/tags/v0.11.0.tar.gz"
    sha256 "6451acd63168af029e3afc28faf534a9389b941d01467027a0e5e7bac180b26d"
  end

  resource "ffi-rs" do
    url "https://github.com/zhangyuang/node-ffi-rs/archive/9c5ba3452d8cedbb0b30c7ce4dd0138135bd06ea.tar.gz"
    sha256 "ab4aef41104c3278646b475a4629fa0d0d7c461c36694d5c24f7cc440602212a"
  end

  # Build tools acquire source dependencies; the test serves a loopback fixture.
  allow_network_access! [:build, :test]

  def install
    ENV["npm_config_build_from_source"] = "true"
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    ENV["PYTHON"] = formula_opt_bin("python@3.14")/"python3.14"
    ENV["ELECTRON_SKIP_BINARY_DOWNLOAD"] = "1"
    ENV["PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD"] = "1"
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    package = JSON.parse((buildpath/"apps/server/package.json").read)
    package["version"] = version.to_s
    (buildpath/"apps/server/package.json").atomic_write(JSON.generate(package))
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    native_platform = OS.mac? ? platform : "#{platform}-gnu"
    cd (buildpath/"apps/server/node_modules/node-pty").realpath do
      system "node", formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js",
             "rebuild"
      rm_r "prebuilds" if Pathname("prebuilds").exist?
    end
    resource("keyring").stage do
      # The library archive omits Cargo.lock; generate one before the locked source build.
      system "cargo", "generate-lockfile" unless Pathname("Cargo.lock").exist?
      system "cargo", "build", "--lib", "--release", "--locked"
      native = OS.mac? ? "target/release/libnapi_keyring.dylib" : "target/release/libnapi_keyring.so"
      package_dir = buildpath.glob("node_modules/.pnpm/@napi-rs+keyring-#{native_platform}@1.3.0*").fetch(0)
      target = package_dir/"node_modules/@napi-rs/keyring-#{native_platform}"
      cp native, target/"keyring.#{native_platform}.node"
    end
    resource("ffi-rs").stage do
      system "cargo", "build", "--lib", "--release", "--locked"
      native = OS.mac? ? "target/release/libffi_rs.dylib" : "target/release/libffi_rs.so"
      package_dir = buildpath.glob("node_modules/.pnpm/@yuuang+ffi-rs-#{native_platform}@1.3.2*").fetch(0)
      target = package_dir/"node_modules/@yuuang/ffi-rs-#{native_platform}"
      cp native, target/"ffi-rs.#{native_platform}.node"
    end
    resource("fff").stage do
      system "cargo", "build", "--lib", "--release", "--locked", "--manifest-path", "crates/fff-c/Cargo.toml"
      name = OS.mac? ? "libfff_c.dylib" : "libfff_c.so"
      package_dir = buildpath.glob("node_modules/.pnpm/@ff-labs+fff-bin-#{native_platform}@0.11.0*").fetch(0)
      target = package_dir/"node_modules/@ff-labs/fff-bin-#{native_platform}"
      cp "target/release/#{name}", target/name
    end
    system "cargo", "install", *std_cargo_args(path: "native/resource-monitor", root: libexec/"native")
    system "pnpm", "--filter", "@t3tools/web", "run", "build"
    cd "apps/server" do
      system "pnpm", "exec", "node", "scripts/cli.ts", "build"
    end
    # Match upstream's standalone archive boundary instead of shipping development/native compiler trees.
    (libexec/"apps/server").install "apps/server/dist"
    (libexec/"apps/web").install "apps/web/dist"
    system "node", "--input-type=module", "--eval", <<~JS
      import { cpSync, existsSync, mkdirSync, readFileSync, realpathSync, rmSync } from 'node:fs';
      import { createRequire } from 'node:module';
      import { dirname, join, sep } from 'node:path';
      import { selectCliRuntimeExternalDependencies } from './scripts/lib/cli-external-packages.ts';
      const manifest = directory => JSON.parse(readFileSync(join(directory, 'package.json'), 'utf8'));
      const locate = (directory, name) => {
        for (const root of createRequire(join(directory, 'package.json')).resolve.paths(name) ?? []) {
          const candidate = join(root, name);
          if (existsSync(join(candidate, 'package.json'))) return realpathSync(candidate);
        }
      };
      const server = #{(buildpath/"apps/server").to_s.to_json};
      const runtime = #{libexec.to_s.to_json};
      const queue = [[server, runtime]];
      const visited = new Set();
      while (queue.length) {
        const [source, destination] = queue.shift();
        const key = source + '\\0' + destination;
        if (visited.has(key)) continue;
        visited.add(key);
        const pkg = manifest(source);
        const dependencies = source === server
          ? selectCliRuntimeExternalDependencies(pkg.dependencies)
          : { ...pkg.dependencies, ...pkg.optionalDependencies };
        for (const name of Object.keys(dependencies).sort()) {
          // This optional provider's proprietary executables are configured separately, never repackaged.
          if (name.startsWith('@cursor/sdk-')) continue;
          const optional = name in (pkg.optionalDependencies ?? {});
          // ffi-rs 1.3.2 incorrectly declares its musl optional package as glibc.
          if (optional && process.platform === 'linux' &&
              name === `@yuuang/ffi-rs-linux-${process.arch}-musl`) continue;
          const dependency = locate(source, name);
          if (!dependency) {
            if (optional) continue;
            throw new Error(`Missing installed runtime dependency ${name} from ${source}`);
          }
          const required = manifest(dependency);
          if (optional && ['os', 'cpu', 'libc'].some(field => {
            const value = field === 'os' ? process.platform : field === 'cpu' ? process.arch : 'glibc';
            const choices = required[field] ?? [];
            return choices.includes('!' + value) ||
              (choices.some(choice => !choice.startsWith('!')) && !choices.includes(value));
          })) continue;
          let target = locate(destination, name);
          if (!target || manifest(target).version !== required.version) {
            const hoisted = join(runtime, 'node_modules', name);
            target = existsSync(join(hoisted, 'package.json')) ? join(destination, 'node_modules', name) : hoisted;
            rmSync(target, { recursive: true, force: true });
            mkdirSync(dirname(target), { recursive: true });
            const nested = join(dependency, 'node_modules');
            cpSync(dependency, target, {
              recursive: true, dereference: true,
              filter: path => path !== nested && !path.startsWith(nested + sep),
            });
          }
          queue.push([dependency, target]);
        }
      }
    JS
    (bin/"t3").write <<~SH
      #!/bin/bash
      export T3CODE_RESOURCE_MONITOR_PATH="#{opt_libexec}/native/bin/t3-resource-monitor"
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/apps/server/dist/bin.mjs" "$@"
    SH
    chmod 0755, bin/"t3"
  end

  def caveats
    <<~EOS
      This is the standalone t3 server and browser UI, not the Electron desktop app.
      Configure agent-provider CLIs and credentials separately. The optional Cursor
      SDK provider's proprietary native executables are not bundled in this source formula.
      Local terminal, file search, keyring and resource-monitor companions are built from source.
    EOS
  end

  service do
    run [opt_bin/"t3"]
    environment_variables T3CODE_HOST: "127.0.0.1", T3CODE_NO_BROWSER: "true"
    log_path var/"log/t3code.log"
    error_log_path var/"log/t3code.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/t3 --version")
    ENV["T3CODE_HOME"] = (testpath/"data").to_s
    ENV["T3CODE_HOST"] = "127.0.0.1"
    ENV["T3CODE_NO_BROWSER"] = "true"
    ENV["T3CODE_PORT"] = free_port.to_s
    pid = spawn bin/"t3", out: (testpath/"server.log").to_s, err: (testpath/"server.log").to_s
    begin
      sleep 1
      html = shell_output("curl --silent --show-error --retry 30 --retry-connrefused --retry-delay 1 " \
                          "http://127.0.0.1:#{ENV.fetch("T3CODE_PORT")}/")
      assert_match "<html", html
      assert_match "assets/", html
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
