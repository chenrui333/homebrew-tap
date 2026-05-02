class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "df43bc19d39821dfb9a938010d1e2f0344d3dfab078bd109f9f64b426c80a48a"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "8aff58685b265f5bc19c43ef15c3aed81c54ae2d32fe0b84d4725f4d59c473a0"
    sha256                               arm64_sequoia: "df1c44e65483493ec7e79a03d96b4ca51a760aa2c7cf210560e1501e9b8b77eb"
    sha256                               arm64_sonoma:  "289b4e92cfb939d202982414e1fbc201e21597e23e9c03089369f3dfacf50104"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03754204f1b1ab724433e09c3d406e5aef99845b78ceac44b2c96022e644443d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a3169541f4c9e63d18dcd34b2db147668a493d80c5c6a97a168cf86e9b8364"
  end

  depends_on "pkgconf" => :build
  depends_on "node"
  depends_on "vips"

  def install
    # Use Homebrew's Node headers instead of letting node-gyp fetch them during builds.
    ENV["npm_config_nodedir"] = Formula["node"].opt_prefix
    ENV["SHARP_FORCE_GLOBAL_LIBVIPS"] = "1"

    system "npm", "install", "--include=dev", *std_npm_args(prefix: false, ignore_scripts: false)
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
