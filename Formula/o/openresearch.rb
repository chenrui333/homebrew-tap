class Openresearch < Formula
  desc "Local-first workspace for research agents"
  homepage "https://openresearch.sh/"
  url "https://github.com/alphaXiv/OpenResearch/archive/refs/tags/v0.2.26.tar.gz"
  sha256 "d4941a70b2dc8678bc20d1aa62f1fb5ff90867f49ea863924e78151ab5736ed9"
  license "MIT"
  head "https://github.com/alphaXiv/OpenResearch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc97122e161e2aea8d6b2e9ef1fe20c07b5db59b90cb41679b7c85ded01d6934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6d15168cff71154eda4994df6baf97e986432b5dd405e89427102a87ef33c77"
    sha256 cellar: :any,                 arm64_linux:   "e06301111980d94c5089982209ca33099f63d2a1987392fb76ca20343b6744de"
    sha256 cellar: :any,                 x86_64_linux:  "ea52def4391dcc9346502f9540900d934a75b7a80c4f3f96cc2a9000787b0f5d"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "bash"
  depends_on "coreutils"
  depends_on "openssh"

  on_linux do
    depends_on "procps"
  end

  resource "plugin-message-format" do
    url "https://registry.npmjs.org/@inlang/plugin-message-format/-/plugin-message-format-4.5.5.tgz"
    sha256 "fc2be29f585bfeda24d3769f9eb096122900c406f01ba2b0898521d02134827d"
  end

  resource "plugin-m-function-matcher" do
    url "https://registry.npmjs.org/@inlang/plugin-m-function-matcher/-/plugin-m-function-matcher-2.3.4.tgz"
    sha256 "3a193d08dd26cb82835430f463573cc9b955ae12e4a9b1cd80771d5ee1573c50"
  end

  # Cargo and pnpm fetch locked source dependencies while compiling the CLI and UI.
  allow_network_access! :build

  def install
    resources.each do |r|
      r.stage { (buildpath/"ui/project.inlang/plugins").install "dist/index.js" => "#{r.name}.js" }
    end
    inreplace "ui/project.inlang/settings.json" do |s|
      s.gsub! "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js",
              "./project.inlang/plugins/plugin-message-format.js"
      s.gsub! "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js",
              "./project.inlang/plugins/plugin-m-function-matcher.js"
    end
    cd "ui" do
      system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
      system "pnpm", "build"
    end
    system "cargo", "install", *std_cargo_args
    pkgshare.install "SKILL.md"
  end

  service do
    run [opt_bin/"orx", "up", "--no-browser"]
    keep_alive true
    working_dir var
    log_path var/"log/openresearch.log"
    error_log_path var/"log/openresearch.log"
  end

  test do
    ENV["ORX_NO_UPDATE_CHECK"] = "1"
    ENV["OPENRESEARCH_CLI_DISABLE_UPDATE"] = "1"
    assert_match version.to_s, shell_output("#{bin}/orx --version")
    catalog = testpath/"catalog"
    catalog.mkpath
    ENV["ORX_DATA_DIR"] = catalog.to_s
    (catalog/"orx.db").write "not a SQLite database\n"
    assert_match "file is not a database", shell_output("#{bin}/orx projects --json 2>&1", 1)
  end
end
