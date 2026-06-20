class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v4.9.3.tar.gz"
  sha256 "4da634e59feed25463113e68da1038046e453f4f4185f3c22da6f3b7ef8453c6"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26f82f6e7a1a0d16056bc248585918f1786f150dce68f4f6dad847cff53d7ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151e2ab555f273b35ee9fd514afedc6e93b31d700a079975dcbd1ff18f16ec6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87b9857a46e0aac1ac5b39604d564caa8b15e6bfe54950fff3f6b6f10284f4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dfd5605b17def3503be7929fcfeb8f91677e539e8bd8dd084f58dec254657e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd8d1ed0c26e2cb869bbf1de3e78d866ba9fc1fcfc5ab548e379c59c7725ed72"
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
