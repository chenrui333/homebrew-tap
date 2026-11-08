class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.10.0.tgz"
  sha256 "3ad1459f7ef944431826ec1d38387286df218dba1ff652460f0e23fa39bd6e27"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "eb2e79d8ee3fedf2df4434a761172d3c628a999f25a7666a6f53f149e63a780a"
    sha256 cellar: :any,                 arm64_sequoia: "eb2e79d8ee3fedf2df4434a761172d3c628a999f25a7666a6f53f149e63a780a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e710379aa636e21b04fb00c4295217888de636b33441c46f2ab435b0fab0aede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ada856260da9f687042dc2caa55458a315fccbd84ed17d19db9f0e35475c5a"
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
