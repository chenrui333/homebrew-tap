class DoryCli < Formula
  desc "Lightweight static site generator for technical documentation"
  homepage "https://github.com/clidey/dory"
  url "https://registry.npmjs.org/@clidey/dory/-/dory-1.15.0.tgz"
  sha256 "2ff31c3fe8619cd57f699afeb95ee2de86b7a7207741e8ca40a75b2c13eed907"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7467aaf51e9390c9718fd72ac3db0fb4a335dffb71d2d460d69f2b64f65289d9"
    sha256 cellar: :any,                 arm64_sequoia: "7467aaf51e9390c9718fd72ac3db0fb4a335dffb71d2d460d69f2b64f65289d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c257ca632bb4b397a70e40a49aa5bfde16c46d1c727c0e2b2e0a66168e0c610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf638f299fba7ccf9fb0be5be97f68e3a848ed84a8df3e9421f0a55334f16511"
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
