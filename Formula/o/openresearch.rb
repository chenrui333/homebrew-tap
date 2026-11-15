class Openresearch < Formula
  desc "Local-first workspace for research agents"
  homepage "https://openresearch.sh/"
  url "https://github.com/alphaXiv/OpenResearch/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "9fdfca88e25d55e33e673d54707096c063200b3cf706799f8219f558ac0bf8c1"
  license "MIT"
  head "https://github.com/alphaXiv/OpenResearch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4653c18e868ba2b890c1464bdef8be30e3c4e1fed24b9352ac6bf5953df1fcbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70844256ff2a3d1cb462ebdb28c719187ceca2eb2559d9134a961e1a2850ac9f"
    sha256 cellar: :any,                 arm64_linux:   "7d561617a7993aee44ec242bd05e31f1a72d21cbc716285289b63bfba816c049"
    sha256 cellar: :any,                 x86_64_linux:  "e266bad89b4dc1a32780108d96c4565b4f7c8dc87633dac948b2c06279f9f479"
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
