class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.0.tgz"
  sha256 "b7848dbfd15de6d86234874517322e01993895b921321d901a043918693d4a3b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f95d81445b68e838284e85ee9c4cd408c830e0e8dcce4cac3b4b6bd4347c8138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cccce85af5493353c041f5d4d544fb00a3148ab35774fa394b19bc26bcf9f492"
    sha256 cellar: :any_skip_relocation, ventura:       "3407e577740f828a7c0854cb68247d7898e6dca936f618c88d622eef8e453022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a12e547cc7c64bfaf9da245d3be563a345dd7da00193d43f11e1a0b5d3f7cf3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docmd --version")

    system bin/"docmd", "init"
    assert_path_exists testpath/"config.js"
    assert_match "title: \"Welcome\"", (testpath/"docs/index.md").read
  end
end
