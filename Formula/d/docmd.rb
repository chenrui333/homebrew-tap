class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.2.tgz"
  sha256 "834d60c439d0a99aca07488217990ca4053e8518d9c29284de2cc353ed0da89f"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4d767f441c8a3a3f42754894be0dbee4714b33291524c49f2224704ea4b5972"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b3c6185b34d39b31ae45e9d64165fd35a0e4f58ed23cb6c388f0808b2dc1ca"
    sha256 cellar: :any_skip_relocation, ventura:       "6c18b3483c857da3fb9f0dca84b9a8a95c3449b8c55e4b2255f2389b2269cdfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e2e67ceb81fb1360cb3e1efe7cc95294ae38501546ea5a17abec993204f5800"
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
