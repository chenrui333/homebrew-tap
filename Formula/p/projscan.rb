class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "943893097b74ceb6b7653a625773482607af61176816e33018248bd1a8056508"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0bb56bca6ffea21a85fe09dffee03c701127844035cac8797f61a90c6150e1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa6d86fbfb7f2fa758ff5615bc4a4c3ed623ae1265c3a84e4f995796dab4d580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9904396583e08722f8e1f2965d8ea5ea10b650a439911d9eab4e115aa408f87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55641fab867c8eb08856b4b6cd20f1e445bec3b64089fa95dc7dd849dd763635"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dbfa26f921d85a5ff10a4b612df988ded0605fc2e468aa0820deedcffef001c"
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
