class Openresearch < Formula
  desc "Local-first workspace for research agents"
  homepage "https://openresearch.sh/"
  url "https://github.com/alphaXiv/OpenResearch/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "23721fcf94c44a0be44a10916896942748bfbc0068a0c4f68985b455d5384c35"
  license "MIT"
  head "https://github.com/alphaXiv/OpenResearch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "4b7e336223371ee449e862cabb94803b5d82b66b7ae46b6ef3bf15a3f58b954b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51924f89bf99a382a99d6685599644c022f7f83d5ab57f64c92499dfb3c1ffcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31cafbf5c45a5dea442343f2666b0eb211779fd3957fd300532916698feb09ba"
    sha256 cellar: :any,                 arm64_linux:   "b94f4dcae67c7a5216424379cd2882b24c1e4fb4a4857bd734be9fc1fbdacc72"
    sha256 cellar: :any,                 x86_64_linux:  "4adffa2e0db3dcb4284edb15d7f423ca528b1d8a2c3d8dc92169fb8948f88680"
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
