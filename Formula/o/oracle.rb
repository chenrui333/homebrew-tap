class Oracle < Formula
  desc "Ask GPT-5 Pro with custom context and files"
  homepage "https://askoracle.dev"
  url "https://github.com/steipete/oracle/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "90b976087e2632aa0da82db75a1d1dae8a986ff449917c731153355e9f05ad22"
  license "MIT"
  head "https://github.com/steipete/oracle.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5b5e1de5656e94294e6794fba935d8873333e5370987052c6b88b5fa91ce336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8150a56e0a061ad75108e1dd9e5202078a72191e1ff4fe20eed27a77058479ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7c3f427840321ad5a4a6bd25e2535a899121cae05d5b3fa795d811f0cee00bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d4363bd711cd2f3a3b6cae8a528d7921bea077876ff582f52f92a27ec784d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9a1fd734c422fbdcf62124ef39653823df6b71b182edc54dd09f825a0a24eba"
  end

  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
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

  def install
    ENV["npm_config_build_from_source"] = "true"

    system "pnpm", "install", "--frozen-lockfile"
    system "pnpm", "run", "build"
    system "pnpm", "prune", "--prod", "--ignore-scripts"

    toasted_notifier = Dir["node_modules/.pnpm/toasted-notifier@*/node_modules/toasted-notifier"].first
    if OS.mac?
      bundled_notifier = "path.join( __dirname, '../vendor/mac.noindex/" \
                         "terminal-notifier.app/Contents/MacOS/terminal-notifier' )"
      inreplace "#{toasted_notifier}/notifiers/notificationcenter.js",
                bundled_notifier,
                "'#{Formula["terminal-notifier"].opt_bin/"terminal-notifier"}'"
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
