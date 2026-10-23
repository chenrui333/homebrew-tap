class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.0.8.tgz"
  sha256 "71712593604b0a56710a75b38d504a9187dd34f2d9564e74c7a2bd836d01998d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "b06d4b46c3e3051e544750dc31d4a4a8b3ead1081ffa133d608e6174d8091f98"
    sha256 cellar: :any,                 arm64_sequoia: "b06d4b46c3e3051e544750dc31d4a4a8b3ead1081ffa133d608e6174d8091f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c159bd3340febf696849d5361e8b2d5977d7e4e9cc28597641ab9fa39918b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b422820b894161e9ddc36c7c0c95dd1938371eabc495460c24c6b31cb559a235"
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
