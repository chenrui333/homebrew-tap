class Openresearch < Formula
  desc "Local-first workspace for research agents"
  homepage "https://openresearch.sh/"
  url "https://github.com/alphaXiv/OpenResearch/archive/refs/tags/v0.2.28.tar.gz"
  sha256 "1876ca77bccb96682276cd571935410dcf0bd1a308e7c11267fd218746b15301"
  license "MIT"
  head "https://github.com/alphaXiv/OpenResearch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f958733badded30f3e8ba330dbe172361cdded7f46db269860a1cb621967b0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5ca3e22f4aea87b46c51c1c73b591465f7fbad9edb9b7b024414727b4f108fe"
    sha256 cellar: :any,                 arm64_linux:   "bfd0bfbfd5313bd4f72a1ed6a14791b43f47ca15623f73c925a75a3259642f4f"
    sha256 cellar: :any,                 x86_64_linux:  "99809fd7cf82b4e0682a0e46a7b860fb9a47f9f9fd6298df8e19bc03c02811ce"
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
