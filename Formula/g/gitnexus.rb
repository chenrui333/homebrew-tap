class Gitnexus < Formula
  desc "Graph-powered code intelligence for AI agents"
  homepage "https://github.com/abhigyanpatwari/GitNexus"
  url "https://github.com/abhigyanpatwari/GitNexus/archive/refs/tags/v1.6.12.tar.gz"
  sha256 "a1bf55683b16b63888dbbdd7041a418d03a052b41adb07b01345693f57d879fd"
  license "PolyForm-Noncommercial-1.0.0"
  head "https://github.com/abhigyanpatwari/GitNexus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "23a03f7d9d6c0aa6b880b5befe5eabf0f406f3207a3f9881b8464b02325e4b3b"
    sha256 cellar: :any, arm64_sequoia: "cadc6dd4df424d65c3335805cdf04d49236e2c0cd12153304c2d1c7a884f8e35"
    sha256 cellar: :any, arm64_linux:   "7a31f16514bd03e6ed73d2764749b5f4db1c47a1e2536fc3146cdf251971d89c"
    sha256 cellar: :any, x86_64_linux:  "291eee5b0bdf8758f0a83dd2204b135a665122ddceb816dba78d7c7678277ab0"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "node"
  depends_on "onnxruntime"
  depends_on "openssl@4"
  depends_on "vips"

  resource "sharp-node-addon-api" do
    url "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.9.2.tgz"
    sha256 "4cd65698541b19a33f798f1dc25c02c6ed1c9d7749b8824b1a1ccecdd197c8ea"
  end

  resource "ladybug-source" do
    url "https://github.com/LadybugDB/ladybug/archive/refs/tags/v0.18.3.tar.gz"
    sha256 "296af5505a35c0cdb488e05314ad1e2824907c10a239841042e42a1279c0f739"
  end

  resource "ladybug-node-source" do
    url "https://github.com/LadybugDB/ladybug-nodejs/archive/1356ebbad75bf69c152dfe1188fad285b5f85b6e.tar.gz"
    sha256 "eb276ca5c1e057270dd670b40b796799f49f83f9c501dd473600dd4ac0c5a6ac"
  end

  resource "onnx-node-source" do
    url "https://github.com/microsoft/onnxruntime/archive/refs/tags/v1.26.0.tar.gz"
    sha256 "2a90eb9a306c1eeb29213f5b165a55008ac5cb7d27e0935c4458c51a49ef091d"
  end

  # npm and CMake fetch source dependencies for the CLI, web UI and graph bindings.
  allow_network_access! :build

  def install
    ENV["npm_config_build_from_source"] = "true"
    ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = ENV.make_jobs.to_s
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"
    ENV["ONNXRUNTIME_NODE_INSTALL"] = "skip"
    cd "gitnexus" do
      system "npm", "ci", "--ignore-scripts"
      rm_r Dir["node_modules/@ladybugdb/core-*", "node_modules/onnxruntime-node/bin"]
      # Node 26's V8 headers require C++20, including in the older parser bindings.
      Dir["node_modules/tree-sitter*/binding.gyp", "vendor/tree-sitter-*/binding.gyp"].each do |gyp|
        inreplace gyp, "c++17", "c++20" if File.read(gyp).include?("c++17")
      end
      # All parsers, including the seven vendored grammars, compile their C/C++ sources.
      grammars = Dir["node_modules/tree-sitter*"]
                 .select { |path| File.exist?("#{path}/binding.gyp") }
                 .map { |path| File.basename(path) }
      system "npm", "rebuild", "--build-from-source", *grammars
      # Sharp 0.35 removed its install lifecycle; retain the real native image integration.
      resource("sharp-node-addon-api").stage(buildpath/"sharp-node-addon-api")
      (pkgshare/"licenses/node-addon-api").install buildpath/"sharp-node-addon-api/LICENSE.md"
      sharp_pkg = Pathname.pwd/"node_modules/sharp"
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
      Dir["vendor/tree-sitter-*/binding.gyp"].each do |gyp|
        cd File.dirname(gyp) do
          rm_r "prebuilds" if File.directory?("prebuilds")
          system "npm", "exec", "--", "node-gyp", "rebuild"
        end
      end
    end
    resource("ladybug-source").stage do
      ladybug_root = Pathname.pwd
      resource("ladybug-node-source").stage do
        (ladybug_root/"tools/nodejs_api").install Dir["*"]
      end
      cd "tools/nodejs_api" do
        system "npm", "ci", "--ignore-scripts"
      end
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_NODEJS=ON",
             "-DBUILD_SHELL=OFF", "-DBUILD_TESTS=OFF"
      system "cmake", "--build", "build", "--target", "lbugjs"
      (buildpath/"gitnexus/node_modules/@ladybugdb/core").install "tools/nodejs_api/build/lbugjs.node"
    end
    resource("onnx-node-source").stage do
      cd "js" do
        system "npm", "ci", "--ignore-scripts"
      end
      cd "js/node" do
        system "npm", "ci", "--ignore-scripts"
        # Use Homebrew's source-built runtime and its stable library path rather
        # than copying the npm prebuild or requiring an exact dylib filename.
        inreplace "CMakeLists.txt",
                  "PRIVATE libonnxruntime.${ort_version}.dylib", "PRIVATE onnxruntime"
        inreplace "CMakeLists.txt", 'INSTALL_RPATH "@loader_path"',
                  "INSTALL_RPATH \"#{formula_opt_lib("onnxruntime")}\""
        inreplace "CMakeLists.txt", 'INSTALL_RPATH "$ORIGIN/"',
                  "INSTALL_RPATH \"#{formula_opt_lib("onnxruntime")}\""
        system "npm", "exec", "--", "tsc", "--build", "script"
        system "node", "script/build", "--config=Release",
               "--onnxruntime-build-dir=#{formula_opt_lib("onnxruntime")}"
        binding = Dir["bin/napi-v6/*/*/onnxruntime_binding.node"].fetch(0)
        dest = buildpath/"gitnexus/node_modules/onnxruntime-node"/File.dirname(binding)
        dest.install binding
      end
    end
    cd "gitnexus-web" do
      system "npm", "ci"
    end
    cd "gitnexus" do
      system "npm", "run", "build", "--", "--web"
      # Remove replaced native prebuilds, not Sharp's interpreted @img/colour dependency.
      rm_r Dir["node_modules/**/prebuilds", "node_modules/@img/sharp-*"]
      if OS.linux?
        # The installed Vite development closure also carries musl-only optional bindings.
        # Keep their same-version GNU packages and ordinary loaders on Homebrew's glibc host.
        arch = Hardware::CPU.arm? ? "arm64" : "x64"
        rm_r Dir["node_modules/@rolldown/binding-linux-#{arch}-musl",
                 "node_modules/lightningcss-linux-#{arch}-musl"]
      end
      libexec.install "dist", "web", "hooks", "scripts", "skills", "vendor", "node_modules", "package.json"
    end
    (bin/"gitnexus").write_env_script libexec/"dist/cli/index.js",
                                    PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitnexus --version")
    (testpath/"native-image.cjs").write <<~JS
      const { createRequire } = require("node:module");
      const sharp = createRequire("#{libexec}/package.json")("sharp");
      sharp({ create: { width: 1, height: 1, channels: 3, background: "white" } })
        .png().toBuffer()
        .then((data) => console.log(data.subarray(0, 8).toString("hex")))
        .catch((error) => { console.error(error); process.exitCode = 1; });
    JS
    assert_match "89504e470d0a1a0a", shell_output("#{formula_opt_bin("node")}/node native-image.cjs")
    system "git", "init"
    system "git", "config", "user.name", "Homebrew"
    system "git", "config", "user.email", "brew@example.com"
    (testpath/"hello.py").write <<~PYTHON
      def brew_coffee():
          return "platypus"
    PYTHON
    system "git", "add", "hello.py"
    system "git", "commit", "-m", "fixture"
    system bin/"gitnexus", "analyze"
    assert_match "brew_coffee", shell_output("#{bin}/gitnexus cypher 'MATCH (f:Function) RETURN f.name'")
  end
end
