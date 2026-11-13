class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.13.0.tgz"
  sha256 "cb67f7f220e59be0df61f89e8ba1b99b8ee3a2e40141b95940dc88cfab27d0b2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "5d948a3e1715d1ea5b05b525c9ffc3b51774f7260629e186a913c82df10e47d3"
    sha256 cellar: :any,                 arm64_sequoia: "5d948a3e1715d1ea5b05b525c9ffc3b51774f7260629e186a913c82df10e47d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba1233b50eaafa0ffee8a7c90c5ea1d59154018a4662a5299230175d0864680d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fdf4c6d9f640749d1473773e43c4cb3658746f9be5ccb61089c6b7d7d93aa39"
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
