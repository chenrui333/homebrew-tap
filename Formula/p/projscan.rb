class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "943893097b74ceb6b7653a625773482607af61176816e33018248bd1a8056508"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b50d8fd215314ff2fda8a9dd7a4c17da4cc4c8710ce2dcd19f6da42f2b4e41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb86c2f894be4b6718b669c34c5c2ff7a79b756dfe1ece79776b6f025d94bbe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e56b5929960725361e0635cee079b9cdb60e77f86e9573401d59417ae08f715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7855a85a204dadf379c4d5e55d42b98b678c41ba1e417c025eac151d24589188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fe7298af21a0bb5a2c9ed1ef754bbd8f1ef6d8517bf772b9d806323dfda6d5e"
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
