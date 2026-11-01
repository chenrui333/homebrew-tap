class Gno < Formula
  desc "Local knowledge engine with hybrid search and MCP integration"
  homepage "https://gno.sh"
  url "https://github.com/gmickel/gno/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "ec0cffd55b5fc186edb42f863ce934f54c840e709cb6c8002259da24e6228540"
  license "MIT"
  head "https://github.com/gmickel/gno.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "bun"
  depends_on "gettext"
  depends_on "glib"
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  on_macos do
    # The source-built llama.cpp CPU backend links this runtime directly on macOS.
    depends_on "libomp"
  end

  on_linux do
    depends_on "shaderc" => :build
    depends_on "spirv-headers" => :build
    depends_on "vulkan-headers" => :build
    depends_on "vulkan-loader"
  end

  resource "sharp-node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "sqlite-vec-source" do
    url "https://github.com/asg017/sqlite-vec/archive/refs/tags/v0.1.9.tar.gz"
    sha256 "9823e737d9934dcbe85dff75d3fca81018a9beee803d70fa77b16faab5d61dc9"
  end

  resource "fts5-snowball-source" do
    url "https://github.com/abiliojr/fts5-snowball.git",
        revision: "f2a5450af5ce810cc3f981ff1ea8de2b4ff82a67"
  end

  # Bun and native toolchains fetch dependencies for source compilation.
  allow_network_access! :build

  def install
    ENV["npm_config_build_from_source"] = "true"
    ENV["NODE_LLAMA_CPP_SKIP_DOWNLOAD"] = "true"
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    # The dev npm Bun launcher is intentionally unbootstrapped; use the declared source-built runtime.
    rm buildpath/"node_modules/.bin/bun"
    ln_s formula_opt_bin("bun")/"bun", buildpath/"node_modules/.bin/bun"
    # Sharp 0.35 has no install lifecycle: explicitly compile its published C++ source target.
    resource("sharp-node-addon-api").stage(buildpath/"sharp-node-addon-api")
    (pkgshare/"licenses/node-addon-api").install buildpath/"sharp-node-addon-api/LICENSE.md"
    sharp_pkg = (buildpath/"node_modules/sharp").realpath
    if sharp_pkg.relative_path_from(buildpath.realpath).to_s.start_with?("../")
      odie "Sharp resolved outside the isolated build tree"
    end
    addon_api = sharp_pkg/"node_modules/node-addon-api"
    addon_api.dirname.mkpath
    rm_r addon_api if addon_api.exist? || addon_api.symlink?
    ln_s buildpath/"sharp-node-addon-api", addon_api
    node_gyp = formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js"
    cd sharp_pkg do
      system formula_opt_bin("node")/"node", node_gyp, "rebuild", "--directory=src",
             "--nodedir=#{formula_opt_prefix("node")}", "--jobs=#{ENV.make_jobs}"
    end
    rm addon_api
    resource("sqlite-vec-source").stage do
      system "make", "loadable", "OMIT_SIMD=1"
      (libexec/"native").install Dir["dist/vec0.{dylib,so}"]
    end
    # Resolve the locally compiled extension, not npm's native platform packages.
    Dir["node_modules/sqlite-vec/index.{cjs,mjs}"].each do |file|
      inreplace file, /  const loadablePath = .*;/,
                     "  const loadablePath = '#{libexec}/native/vec0.#{OS.mac? ? "dylib" : "so"}';"
    end
    # Keep Sharp's interpreted @img/colour dependency when pruning replaced native platform packages.
    rm_r Dir["node_modules/sqlite-vec-*", "node_modules/@node-llama-cpp",
             "node_modules/.bun/sqlite-vec-*", "node_modules/.bun/@node-llama-cpp*",
             "node_modules/@img/sharp-*", "node_modules/.bun/@img+sharp-*"]
    rm_r "node_modules/node-llama-cpp/bins"
    # node-llama-cpp otherwise ignores Homebrew's job limit and uses every CPU.
    inreplace "node_modules/node-llama-cpp/dist/bindings/utils/compileLLamaCpp.js",
              "const cpuCount = os.cpus().length;", "const cpuCount = #{ENV.make_jobs};"
    # The package's pinned git source bundle is compiled; no engine binary is downloaded.
    system "node", "node_modules/node-llama-cpp/dist/cli/cli.js", "source", "download",
           "--skipBuild", "--noUsageExample"
    system "node", "node_modules/node-llama-cpp/dist/cli/cli.js", "source", "build",
           "--gpu", OS.mac? ? "metal" : "vulkan", "--noUsageExample"
    native_build = "node_modules/**/node-llama-cpp/llama/localBuilds"
    buildpath.glob("#{native_build}/**/{CMakeFiles,CMakeCache.txt,compile_commands.json,build.ninja}",
                   File::FNM_DOTMATCH).each { |path| rm_r path if path.exist? }
    rm_r "vendor/fts5-snowball"
    platform = "#{OS.mac? ? "darwin" : "linux"}-#{Hardware::CPU.arm? ? "arm64" : "x64"}"
    resource("fts5-snowball-source").stage do
      system "make", "-C", "snowball", "CFLAGS=-fPIC"
      system ENV.cc, "-fPIC", "-shared", "-O3", "-I#{formula_opt_include("sqlite")}",
             "-Isnowball/include", "-Isqlite", "src/fts5stemmer.c", "snowball/libstemmer.o",
             "-L#{formula_opt_lib("sqlite")}", "-lsqlite3", "-o", "fts5stemmer.#{OS.mac? ? "dylib" : "so"}"
      (buildpath/"vendor/fts5-snowball"/platform).install Dir["fts5stemmer.{dylib,so}"]
      (buildpath/"vendor/fts5-snowball").install Dir["LICENSE*", "COPYING*"]
    end
    inreplace "src/store/sqlite/fts5-snowball.ts",
              'if (os === "linux" && archName === "x64")', 'if (os === "linux")'
    inreplace "src/store/sqlite/fts5-snowball.ts", 'return "linux-x64";', "return `linux-${archName}`;"
    system "bun", "run", "build:spa"
    system "bun", "run", "package:clipper"
    # Keep the actual host/glibc Tailwind binding, not unused foreign architecture/libc variants.
    keep = ["tailwindcss-oxide.#{platform}.node", "tailwindcss-oxide.#{platform}-gnu.node"]
    pattern = "**/node_modules/bun-plugin-tailwind/tailwindcss-oxide.*.node"
    buildpath.glob(pattern, File::FNM_DOTMATCH).each do |file|
      next if keep.include?(file.basename.to_s)

      rm file if file.exist?
    end
    if OS.linux?
      # These separately packaged musl variants cannot load on Homebrew's glibc host.
      # Retain GNU canvas/PDF, CSS, watcher and other native counterparts at every nesting level.
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      bun_arch = Hardware::CPU.arm? ? "aarch64" : "x64"
      %W[
        @napi-rs/canvas-linux-#{arch}-musl
        @oven/bun-linux-#{bun_arch}-musl
        @oxfmt/linux-#{arch}-musl
        @oxlint/linux-#{arch}-musl
        @parcel/watcher-linux-#{arch}-musl
        @reflink/reflink-linux-#{arch}-musl
        @rolldown/binding-linux-#{arch}-musl
        @tailwindcss/oxide-linux-#{arch}-musl
        lightningcss-linux-#{arch}-musl
      ].each do |package|
        buildpath.glob("**/node_modules/#{package}", File::FNM_DOTMATCH).each { |path| rm_r path }
      end
    end
    libexec.install "src", "vendor", "assets", "browser-extension", "spec", "node_modules",
                    "package.json", "bunfig.toml", "THIRD_PARTY_NOTICES.md"
    (bin/"gno").write <<~SH
      #!/bin/bash
      export DYLD_LIBRARY_PATH="#{formula_opt_lib("sqlite")}${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"
      exec "#{formula_opt_bin("bun")}/bun" "#{libexec}/src/index.ts" "$@"
    SH
    chmod 0755, bin/"gno"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gno --version")
    (testpath/"native-image.cjs").write <<~JS
      const { createRequire } = require("node:module");
      const sharp = createRequire("#{libexec}/package.json")("sharp");
      sharp({ create: { width: 1, height: 1, channels: 3, background: "white" } })
        .png().toBuffer()
        .then((data) => console.log(data.subarray(0, 8).toString("hex")))
        .catch((error) => { console.error(error); process.exitCode = 1; });
    JS
    assert_match "89504e470d0a1a0a", shell_output("#{formula_opt_bin("bun")}/bun native-image.cjs")
    (testpath/"docs").mkpath
    (testpath/"docs/brew.md").write <<~MARKDOWN
      # Brewing
      The platypus enjoys brewing coffee.
    MARKDOWN
    system bin/"gno", "init", testpath/"docs", "--name", "brew"
    system bin/"gno", "update"
    assert_match "platypus", shell_output("#{bin}/gno search platypus")
  end
end
