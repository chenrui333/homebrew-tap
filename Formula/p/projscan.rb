class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "7b4a8b0a2b9fafdeb9d5b8b2ce5c6891fb0b4676f243616e0fa419ce8fa3551f"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "5652c93a2257d126f2a137b512417f04b149db0f8ae11f9e560e99aa4ea5247c"
    sha256                               arm64_sequoia: "c3a8980162ab36cb58e7e3f4ef90514c0dadd84feb5f6ed932ec98d72180e1f7"
    sha256                               arm64_sonoma:  "6b394e28023e39ad3e3973973717e4f4193106fbb911954f32b99bf410e2ba15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88980c3bb9c5dd84495ccdeb92e7ab6dac8da8762e2f36888fa0b2bbe993422f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06f58532cf3cd1959ee5458ba4e4130c358467c1b8ed174399b6155706874f9f"
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
