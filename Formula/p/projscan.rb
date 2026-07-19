class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "39a3fd388b91d4e330c2751cce011b59a4e49ff02abfbc08c4c23a1f062ad58b"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88f751168ae71c173e1e3886aeb0ae89decf3426742e7ebbd8d300886b07d5af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dbc494ca5c9a2c367241a3e627d6ae94551683f1b3a2fad9d8ce4d2a56bfb4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c010a8e97f69a91b055e34b802f64324eee0c8932db132dffd4eb3800e0c5e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f2093fafb98329023e1da80f515c7a8c625d3ac651e60ebafc6809b7d0467c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86959b5dcff05a99ea04f025952256aab965819a7dfc82de4dea235c5e1762d0"
  end

  depends_on "pkgconf" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "node"
  depends_on "vips"

  def install
    # Use Homebrew's Node headers instead of letting node-gyp fetch them during builds.
    ENV["npm_config_nodedir"] = formula_opt_prefix("node")
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "pkg", "delete", "scripts.prepare"
    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)

    tree_sitter_cli = buildpath/"node_modules/tree-sitter-cli/tree-sitter"
    rm tree_sitter_cli
    ln_sf formula_opt_bin("tree-sitter-cli")/"tree-sitter", tree_sitter_cli

    system "npm", "run", "build"
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/projscan/node_modules"
    cd libexec/"lib/node_modules/projscan" do
      system "npm", "rebuild", "tree-sitter-go", "tree-sitter-java",
             "tree-sitter-python", "tree-sitter-ruby", "--build-from-source"
    end
    rm_r node_modules.glob("tree-sitter-*/prebuilds")

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/projscan --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "projscan-test",
        "version": "1.0.0"
      }
    JSON
    (testpath/"src").mkpath
    (testpath/"src/index.js").write "console.log('hello');\n"

    output = shell_output("cd #{testpath} && #{bin}/projscan doctor --format json")
    assert_match "\"health\"", output
    assert_match "\"score\"", output
  end
end
