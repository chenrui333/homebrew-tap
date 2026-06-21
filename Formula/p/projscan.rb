class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "d2ab63bdef718b1340ba6fba6d4f69b7341f4d5dce42c50b9cbb8b0d171d77a5"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2a533bed819e3abb9ba39abf5eee33065584a441321528e0bedcc7d23e15622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb04a1f2add123195013b3c00aee468746ddb00790a4ac0bee7ab71b9e42843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0804fea4a9956ccd0160ae3b3500bd765862605b8c127a46a37fa6741e0206ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2004673b7ecfa85a98f6a10864c6464fdfa0b1e1da9ef2b5a590253f91ec0c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce2b2ea66ed5c284d50fbe40a6e727e1cf342892fa90dbae924038add9295ef3"
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
