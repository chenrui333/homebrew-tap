class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "5c7fa04d9852b98a748335be52ad9b4222be2750b6e1bb04be698d62ea904630"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f816cac65324c20e51fe035cb766e3b0581b188a09b060d08a0dae3681a0dfbb"
    sha256                               arm64_sequoia: "4e9a11984556ab40d02402aff45994e43b4bbd8c5e934decb5b6e6c98f65b33b"
    sha256                               arm64_sonoma:  "c1eca6a17ff3482cde7ce965b30346c8a600cffa7cae27b74785293cae73e4c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b218d41843bb9411b3d1984dfbde164da5b7ac52addf7be166e4806a0d7b3cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "783407fc701f33eb1e96ee71006fa620ad83ab5c0632c9401a21d3d3c0ba5cb1"
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
