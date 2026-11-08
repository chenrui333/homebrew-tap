class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.10.0.tgz"
  sha256 "3ad1459f7ef944431826ec1d38387286df218dba1ff652460f0e23fa39bd6e27"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "37d2c7deeb1647c1a6beb522ccb82bb637ae2beef6cfc4970ea320edc2c16142"
    sha256 cellar: :any,                 arm64_sequoia: "37d2c7deeb1647c1a6beb522ccb82bb637ae2beef6cfc4970ea320edc2c16142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eae29d815b831af06e1e20e7095367afc3bbf7dd5336260a31e30fe5feff1f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0a1371bcfd30d524eaa8e5873deb9797dc3b3876a54f13418c84645c50cf86"
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
