class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.0.8.tgz"
  sha256 "71712593604b0a56710a75b38d504a9187dd34f2d9564e74c7a2bd836d01998d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "399e244640dc47ae2ea6d2efc5bffde63b958f69fcfba816f5b5c4b525a872f2"
    sha256 cellar: :any,                 arm64_sequoia: "399e244640dc47ae2ea6d2efc5bffde63b958f69fcfba816f5b5c4b525a872f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3807b2ce08b4bed8a5dd7995baf5c28f6e77b444843dc73c517d540f7758b9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d2ca6631dd2f8fdfea3d3b69cdb662be419b8dff2f0ebd2b0fa4026ab8487d"
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
    output = shell_output("#{bin}/dory build 2>&1", 1)
    assert_match "Dory is ready to build your docs", output
  end
end
