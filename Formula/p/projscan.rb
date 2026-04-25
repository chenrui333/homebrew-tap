class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "b4a046d24028709fda216c0f98e20524866c7a7f52e4eca619eeea4baa7c83e9"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ea6e332ded61f3a97c64486a410972af228cfb2a9b4f9e7057d5303ddb1ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ea6e332ded61f3a97c64486a410972af228cfb2a9b4f9e7057d5303ddb1ebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ea6e332ded61f3a97c64486a410972af228cfb2a9b4f9e7057d5303ddb1ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bd038a2219fe33721ab7dd0e68fec26bfd4ed34f3e187faf463dff38d8dcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c0421537a132e25ac175c42e3e2af1c3be651203c854f894409327fb1e60f20"
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
