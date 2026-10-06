class Oracle < Formula
  desc "Ask GPT-5 Pro with custom context and files"
  homepage "https://askoracle.dev"
  url "https://github.com/steipete/oracle/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "90b976087e2632aa0da82db75a1d1dae8a986ff449917c731153355e9f05ad22"
  license "MIT"
  head "https://github.com/steipete/oracle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ded9b026c0fbbd884485899d621b09e2e9fb54f8cd0b3f2e200d6f8d6dca8d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eacaba84095126710996d297a2d01ac7cfbbad7a65d939eabb3f76e0cdc2391e"
    sha256 cellar: :any,                 arm64_linux:   "1941e349e05f04fbfbc5f50c43b18057519fa1d09ddaa621519377e0eaae2bd0"
    sha256 cellar: :any,                 x86_64_linux:  "dbae7313df1d6593f89daa6e96baf6836a2f08f869cf7a3975b0a7323196d418"
  end

  depends_on "pkgconf" => :build
  # pnpm 11+ ignores the `pnpm` field in package.json (overrides, onlyBuiltDependencies),
  # so the frozen lockfile no longer matches.
  depends_on "pnpm@10" => :build
  depends_on "node"

  on_macos do
    depends_on "terminal-notifier"
  end

  on_linux do
    # node-gyp 8 imports distutils while building sqlite3.
    depends_on "python-setuptools" => :build
    depends_on "glib"
    depends_on "libsecret"
  end

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_bin("pnpm@10")
    # Native modules are built from source in install, not via prebuilt downloads here.
    system "pnpm", "fetch", "--ignore-scripts", "--store-dir", buildpath/".pnpm-store"
    rm_r "node_modules"
  end

  def install
    ENV["npm_config_build_from_source"] = "true"
    # Build native modules against Homebrew's Node headers instead of downloading them.
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    # Apply to every pnpm command: `pnpm prune` has no --offline/--store-dir flags and
    # would otherwise recreate node_modules from the registry.
    ENV["npm_config_store_dir"] = (buildpath/".pnpm-store").to_s
    ENV["npm_config_offline"] = "true"

    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "run", "build"
    system "pnpm", "prune", "--prod", "--ignore-scripts"

    toasted_notifier = Dir["node_modules/.pnpm/toasted-notifier@*/node_modules/toasted-notifier"].first
    if OS.mac?
      bundled_notifier = "path.join( __dirname, '../vendor/mac.noindex/" \
                         "terminal-notifier.app/Contents/MacOS/terminal-notifier' )"
      inreplace "#{toasted_notifier}/notifiers/notificationcenter.js",
                bundled_notifier,
                "'#{formula_opt_bin("terminal-notifier")/"terminal-notifier"}'"
    end
    rm_r "#{toasted_notifier}/vendor"

    libexec.install "assets-oracle-icon.png", "dist", "node_modules", "package.json"
    chmod 0755, libexec/"dist/bin/oracle-cli.js"
    chmod 0755, libexec/"dist/bin/oracle-mcp.js"

    bin.install_symlink libexec/"dist/bin/oracle-cli.js" => "oracle"
    bin.install_symlink libexec/"dist/bin/oracle-mcp.js" => "oracle-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oracle --version")

    oracle_home = testpath/".oracle"
    output = with_env(ORACLE_HOME_DIR: oracle_home.to_s) do
      shell_output("#{bin}/oracle --prompt 'Homebrew smoke' --dry-run summary")
    end

    assert_match "[preview] Oracle (#{version})", output
    assert_match "No files attached", output
    refute_path_exists oracle_home/"sessions"
  end
end
