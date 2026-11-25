class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.16.0.tgz"
  sha256 "ace4ceb706e17e0668cf940c7864dbdab98f59a85bf23c1496a523973e10e1eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "ae4c6764601ed520577a0d29254b9d5cf9bc8fa7856e8b9800e14e341d003a49"
    sha256 cellar: :any,                 arm64_sequoia: "ae4c6764601ed520577a0d29254b9d5cf9bc8fa7856e8b9800e14e341d003a49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "994dbfcfb5c390d3c8c54e7b7c129d3cc0dce8e2b1d7607b64d6a649e495a1ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ff49f4b1a45e69fe87f9d4159f9b5ba20308c741e1b8c2e86c0fbf365bf6ac"
  end

  depends_on "node"

  deny_network_access!

  def prepare_package_json
    # Use the source-built JavaScript implementation instead of sass-embedded's prebuilt Dart binary.
    package_json = JSON.parse((buildpath/"package.json").read)
    dependencies = package_json.fetch("dependencies")
    dependencies["sass"] = dependencies.delete("sass-embedded") if dependencies.key?("sass-embedded")
    (buildpath/"package.json").atomic_write(JSON.pretty_generate(package_json))
  end

  def fetch
    prepare_package_json
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    prepare_package_json
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"dory", "init"
    assert_path_exists testpath/"dory.json"
    assert_match "Documentation ready in", shell_output("#{bin}/dory build 2>&1")
    assert_match "Start writing your documentation here.", (testpath/"dist/introduction/index.html").read
  end
end
