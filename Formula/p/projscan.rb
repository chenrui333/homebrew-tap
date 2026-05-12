class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "88ffd5a650b5add7d0364da18b311eefa092370bbeedfb52cb6d1093e7c778e6"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "da3c1bbfd9665ff36b6cfff15184e716a419b6165ccc494f21e2338be04b5864"
    sha256                               arm64_sequoia: "ae332c3d0bfb7e4c21c29de3b71fdd26f837600877c7c5474f180d0fc2ac9647"
    sha256                               arm64_sonoma:  "42c3726df291ea49d1937621a28b6736b209bc89ad0f34b7417a46052753c7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e23a20ac56eade468513fc9f166182c0c1a6c9fd70e3c08d690467a390d0465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35a5e4aecdc0faeaf607d892cd61253f38451bbf0755de89e8cb89296fc1ceb"
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
