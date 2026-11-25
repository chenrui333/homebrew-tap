class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.16.0.tgz"
  sha256 "ace4ceb706e17e0668cf940c7864dbdab98f59a85bf23c1496a523973e10e1eb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "a37fa767701cf18f0e0f928fb50fa8f8251de25e926906154b7011845fb03515"
    sha256 cellar: :any,                 arm64_tahoe:   "f920697f03f1d34bd49dceee907de9b4bc594a5863ae967bc6222cf295262a21"
    sha256 cellar: :any,                 arm64_sequoia: "f920697f03f1d34bd49dceee907de9b4bc594a5863ae967bc6222cf295262a21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e219a1da64410e394986eafe9074c6796a2c90edbc6998a07da0621631a742f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50416cd3b24f7b291c325c930d19058c8755805effe483f3cf15cdcae2ea672f"
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
