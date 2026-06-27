class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v4.17.0.tar.gz"
  sha256 "a9ebf9e7eed5cb48a130dc38fc48231d3cc3ae2e574602d36256d73b68e23f22"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15a5324345c5c132a5377ece91fab2ee38ba8b02fd330aa980cd75e2984f3a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5155eb0e67154a088bccf2b8f5841d4768c58dcf9230c0b657bfb8117948c4dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98bb59768f3b5c8fc7a768631e36ddcfaac5fa12d4b5e853dff94ec93f4a08b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce5aa1b85bae181a4f13dfc0d31a776cfa2883479141b69d232645e1d0d5a2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56afc805280a555b40541d1fb1a523952e23ac7c3401ceed64ebb994cd4adbbd"
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
