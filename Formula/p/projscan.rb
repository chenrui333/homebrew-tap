class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "96819f543485b4049c31adbe89639711526f8aa613747fb5c568c370725876fa"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "964a7ba33a2b04c6dc9e6fc1ffd318018ae7232b2505d93d01b39f17404739f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b398ee523beab12fec242b4deba1b6b9408ca30e7a0ed2a7a0981c3a3f441be0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672683ba7e09f488a07baf77d8589394fe5942aa4216630fa976c9e3e1cddcba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b812ed1e7ce37cbc3f1be55cd687a7463ffce7b915e482e68aaab0a7d8f7d917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd0cb6f7e9ecca2d5188e1352ff4c7cca6f08c507ec9774ffed4247a3ff8211"
  end

  depends_on "pkgconf" => :build
  depends_on "tree-sitter-cli" => :build
  depends_on "node"
  depends_on "vips"

  def install
    # Use Homebrew's Node headers instead of letting node-gyp fetch them during builds.
    ENV["npm_config_nodedir"] = Formula["node"].opt_prefix
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "pkg", "delete", "scripts.prepare"
    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)

    tree_sitter_cli = buildpath/"node_modules/tree-sitter-cli/tree-sitter"
    rm tree_sitter_cli
    ln_sf Formula["tree-sitter-cli"].opt_bin/"tree-sitter", tree_sitter_cli

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
