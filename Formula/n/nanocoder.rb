class Nanocoder < Formula
  desc "Local-first AI coding agent for the terminal"
  homepage "https://github.com/Nano-Collective/nanocoder"
  url "https://registry.npmjs.org/@nanocollective/nanocoder/-/nanocoder-1.31.0.tgz"
  sha256 "92ca54f0e165ff262f6a39f0fac6b5dd774d7fb72a84f7f13adab8f7306c1b44"
  license "MIT"
  head "https://github.com/Nano-Collective/nanocoder.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1ab091b5dec7275840796a9de2a8fb7430611e581e22461a506d83b9b71b07d9"
    sha256 cellar: :any,                 arm64_sequoia: "1ab091b5dec7275840796a9de2a8fb7430611e581e22461a506d83b9b71b07d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f6fde94c65ecf757b33d937306df7836f5771690d96210483c8124865ffabac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be935152f6993e368d128bb97ab631dc14eb7ddd20739fce6a2a352e0b14cbe"
  end

  depends_on "node"
  depends_on "ripgrep"

  on_linux do
    depends_on "xsel"
  end

  deny_network_access!

  def prepare_package_json
    package_json = JSON.parse((buildpath/"package.json").read)
    package_json.delete("devDependencies")
    # Use Homebrew's ripgrep instead of the dependency's binary downloader.
    package_json.fetch("dependencies").delete("@vscode/ripgrep")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    prepare_package_json
    rm_r buildpath/"npm-fetch" if (buildpath/"npm-fetch").exist?
    inreplace "dist/utils/ripgrep-path.js",
              "const { rgPath } = await import('@vscode/ripgrep');",
              "const rgPath = '#{formula_opt_bin("ripgrep")}/rg';"
    system "npm", "install", "--offline", *std_npm_args

    node_modules = libexec/"lib/node_modules/@nanocollective/nanocoder/node_modules"
    node_modules.glob("**/clipboardy/fallbacks").each do |fallbacks|
      rm_r fallbacks
      next unless OS.linux?

      (fallbacks/"linux").mkpath
      ln_s formula_opt_bin("xsel")/"xsel", fallbacks/"linux/xsel"
    end

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    native = "#{os}-#{arch}#{"-gnu" if OS.linux?}"
    node_modules.glob("**/@napi-rs/canvas-*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "canvas-#{native}"
    end

    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"nanocoder", "completion")
  end

  def caveats
    <<~EOS
      The service runs the foreground skill daemon in #{var}/nanocoder.
      Configure its provider and trusted project skills in that directory before
      starting the service. For per-project daemons, use `nanocoder daemon start`
      from a project you have explicitly trusted instead.
    EOS
  end

  service do
    run [formula_opt_bin("node")/"node",
         opt_libexec/"lib/node_modules/@nanocollective/nanocoder/dist/daemon/entry.js"]
    working_dir var/"nanocoder"
    log_path var/"log/nanocoder.log"
    error_log_path var/"log/nanocoder.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanocoder --version")

    (testpath/"package.json").write '{"name":"homebrew-nanocoder-test","version":"1.0.0"}'
    assert_match "Nanocoder project initialized successfully.", shell_output("#{bin}/nanocoder init")
    assert_path_exists testpath/"AGENTS.md"
    assert_match "Not running.", shell_output("#{bin}/nanocoder daemon status")
  end
end
