class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v4.9.2.tar.gz"
  sha256 "e49b193685e4ac6da481c19cd328fc36c8c57784a07716c355381c9d850184b4"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ea2c50c0571555c7057d2931c724973af147e00ce6fd6d6fd1aa921c9a836ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ada640b56629fe4e5d5fd178e01431577aff6dcfb5a0e7fe43b314309a47355e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95e151e13fab13b2430e85174d1d4fd94bfefebe05d26e2a45d9f94ba537e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e830acb2c0c7d59b2893b8126b86785acb942e40cbb716d3df6596528b4811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc11c8aa9780068b821aa9492d380aab81d8c38a8a51279aacc14f30104cd55d"
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
