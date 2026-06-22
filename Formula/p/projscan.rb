class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v4.11.1.tar.gz"
  sha256 "3bd6a93aa8eb9376ad8e1bdcd1388252b157e8ba15824bc41034adb91fcfeb43"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6cecf29edd7cce647fa448f277e1494f38ef14637540545d78256f5a076d2cd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62ffc412c0d93e4c6deeeb21c98aecc13fff8dd528c570a723fb5b2ad8d18811"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "880eb5d4cf94821c4cacba0eaee252f8cbf0d1a6bfb3fc748e85aa7f7a383194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429547d61f92defd183495705a52539513c62527c706b8a7f0cbafde8396f00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a6a58d95985f24064434d11bc8ea10d81636d344ec5a9bbf975c7c8ada66a35"
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
