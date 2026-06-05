class Projscan < Formula
  desc "Instant codebase insights for any repository"
  homepage "https://github.com/abhiyoheswaran1/projscan"
  url "https://github.com/abhiyoheswaran1/projscan/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "bc49169a51f7c32338b5f5232bff29f057ca7fde75a4a2e65d265e082b01a7ee"
  license "MIT"
  head "https://github.com/abhiyoheswaran1/projscan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "fc0512ee3ec59ac8ea999e7b3ab4f2565f9a73a20b27afb91b6aa868143a330f"
    sha256               arm64_sequoia: "5ba50a8cb535c9858a1ac1cd42878ecdf029e5ffc086f2878a7f5a9a6baaee69"
    sha256               arm64_sonoma:  "4d0afa906ec3a79bf777878d4d94c7bddc5896634117253f7a26f42f6489a02b"
    sha256 cellar: :any, arm64_linux:   "e9815199da5cd7b4c39b4f7963efac1c0c5ecb1fec5b23bb10bf8df35630e5f4"
    sha256 cellar: :any, x86_64_linux:  "f8377935e726bed10e110a1904528ffcf09baedb5b08aeeded3b6a5139d801ab"
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
