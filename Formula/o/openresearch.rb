class Openresearch < Formula
  desc "Local-first workspace for research agents"
  homepage "https://openresearch.sh/"
  url "https://github.com/alphaXiv/OpenResearch/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "dce6b28702ae1308716986d7b97239f58a1875d798f589c9fe1dacf85e22db12"
  license "MIT"
  head "https://github.com/alphaXiv/OpenResearch.git", branch: "main"

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
