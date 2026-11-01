class Qmd < Formula
  desc "Local hybrid search engine for documents and knowledge bases"
  homepage "https://github.com/tobi/qmd"
  url "https://github.com/tobi/qmd/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "851b060ef90526be6eab55384ebefabbf0573e854875256d9db9fcd53686516f"
  license "MIT"
  head "https://github.com/tobi/qmd.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "db3bbc81d1006b014680ef96801165609f45c866821614a7812db051a40fc91d"
    sha256 cellar: :any, arm64_sequoia: "a123ef9461178caae174d6089d80908c99687b921d646307fd2aa5eb1d67c6ad"
    sha256               arm64_linux:   "97d2be9266e8c9f9752591266ff51a16817523d7ca6bedf0f82a2828972a1801"
    sha256               x86_64_linux:  "451975b27402f52e3ea0c09b80e8338e7f27f01f61130b8fd7fbe49929b67283"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "bun"
  depends_on "node"
  depends_on "sqlite"

  on_linux do
    depends_on "shaderc" => :build
    depends_on "spirv-headers" => :build
    depends_on "vulkan-headers" => :build
    depends_on "vulkan-loader"
  end

  resource "sqlite-vec-source" do
    url "https://github.com/asg017/sqlite-vec/archive/refs/tags/v0.1.9.tar.gz"
    sha256 "9823e737d9934dcbe85dff75d3fca81018a9beee803d70fa77b16faab5d61dc9"
  end

  # pnpm and the native engine toolchains fetch source dependencies for compilation.
  allow_network_access! :build

  def install
    ENV["npm_config_build_from_source"] = "true"
    ENV["NODE_LLAMA_CPP_SKIP_DOWNLOAD"] = "true"
    # This tag's pnpm lock is stale; its Bun lock matches every current manifest dependency.
    system formula_opt_bin("bun")/"bun", "install", "--frozen-lockfile", "--ignore-scripts"
    node_gyp = formula_opt_libexec("node")/"lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js"
    %w[better-sqlite3 tree-sitter-go tree-sitter-python tree-sitter-rust tree-sitter-typescript].each do |addon|
      cd "node_modules/#{addon}" do
        inreplace "binding.gyp", "c++17", "c++20" if File.read("binding.gyp").include?("c++17")
        system formula_opt_bin("node")/"node", node_gyp, "rebuild", "--release",
               "--nodedir=#{formula_opt_prefix("node")}", "--jobs=#{ENV.make_jobs}"
      end
    end
    resource("sqlite-vec-source").stage do
      system "make", "loadable", "OMIT_SIMD=1"
      (libexec/"native").install Dir["dist/vec0.{dylib,so}"]
    end
    # Resolve the locally compiled extension, not npm's native platform packages.
    Dir["node_modules/sqlite-vec/index.{cjs,mjs}"].each do |file|
      inreplace file, /  const loadablePath = .*;/,
                     "  const loadablePath = '#{libexec}/native/vec0.#{OS.mac? ? "dylib" : "so"}';"
    end
    rm_r Dir["node_modules/sqlite-vec-*", "node_modules/@node-llama-cpp"]
    rm_r buildpath.glob("node_modules/.bun/{sqlite-vec-*,@node-llama-cpp+*}")
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
    system "npm", "run", "build"
    buildpath.glob("node_modules/**/prebuilds", File::FNM_DOTMATCH).each { |path| rm_r path if path.exist? }
    if OS.linux?
      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      # Homebrew's glibc hosts use the retained GNU bindings and package metadata.
      rm_r buildpath.glob("node_modules/{@reflink/reflink,@rollup/rollup}-linux-#{arch}-musl")
    end
    libexec.install "bin", "dist", "node_modules", "package.json", "bun.lock"
    pkgshare.install "skills"
    (bin/"qmd").write_env_script libexec/"bin/qmd", PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qmd --version")
    (testpath/"docs").mkpath
    (testpath/"docs/brew.md").write <<~MARKDOWN
      # Brewing
      A platypus brews excellent coffee.
    MARKDOWN
    system bin/"qmd", "collection", "add", testpath/"docs", "--name", "brew"
    assert_match "platypus", shell_output("#{bin}/qmd search platypus")
  end
end
