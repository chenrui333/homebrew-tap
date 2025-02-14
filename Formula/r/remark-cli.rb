class RemarkCli < Formula
  desc "CLI to inspect and change markdown files with remark"
  homepage "https://remark.js.org/"
  url "https://registry.npmjs.org/remark-cli/-/remark-cli-12.0.1.tgz"
  sha256 "e100dfaffa5b3a50312313391fe493d2d51693f337c4035f6edd4f7090c64815"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e6b3e99175230241fa58cc0c2daa684ebb83633d849fa88cf53157148faf1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb35085f98c82c869accfa74748d89592dda1ab8f0e5e714bffffd58c4ff88ac"
    sha256 cellar: :any_skip_relocation, ventura:       "ec35a1e1d97ec837bb744f6a78127b320f800cbed9bca2db629c4ad1761cbf73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9f590233222ed32b89476a10b627117d6bb2ae2eb544e4d01d0508ccf69027e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/remark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/remark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/remark test.md -o formatted.md 2>&1")
    assert_match "test.md > formatted.md: written", output.gsub(/\e\[\d+m/, "")

    expected_content = <<~MARKDOWN
      # Hello World
    MARKDOWN

    assert_equal expected_content, (testpath/"formatted.md").read
  end
end
