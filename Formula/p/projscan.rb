class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "39a3fd388b91d4e330c2751cce011b59a4e49ff02abfbc08c4c23a1f062ad58b"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f8c0413669ef5ed510754797fb62e49c9c238b5de38c6c153fa5f1c65d5adda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba7a3db93ef1538d02b3d65f102e1d2fd11b1f171e93d1d3cc883e55638ad4af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b41fbb76419670f9d21f815a2712713242c8941e436bda431f080e98a830e25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa6308dc2a011a7cf8efdd44fb017de4fd4fb45d5cff76a02febcb1964afee2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312c056fbb7055ccbac211ead1aa111064a503aa112f4c020ab367df1741f704"
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
