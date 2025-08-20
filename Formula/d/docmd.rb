class Docmd < Formula
  desc "Minimal Markdown documentation generator"
  homepage "https://docmd.mgks.dev/"
  url "https://registry.npmjs.org/@mgks/docmd/-/docmd-0.2.3.tgz"
  sha256 "077552478e744df361ffc403ae0edc0b52c0181d19d0b09ccb0c4a6a74318c01"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fffb0e86fae4fb6000438cd556354eaef511912da65501bb4e8bc55f6a89232d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49d795e2ba9b8ca6471307bdbaf236c5a36bac3a84162ae061f9171d514b553b"
    sha256 cellar: :any_skip_relocation, ventura:       "457443517deb565082081dc88b962a70d4999632f045f7f8ab2c8985815fbd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "229ca4665ced56c95bd554b36864cf50fab2bbe5b0f57606f58844e29908ba42"
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
