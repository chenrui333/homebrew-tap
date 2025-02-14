class RemarkCli < Formula
  desc "CLI to inspect and change markdown files with remark"
  homepage "https://remark.js.org/"
  url "https://registry.npmjs.org/remark-cli/-/remark-cli-12.0.1.tgz"
  sha256 "e100dfaffa5b3a50312313391fe493d2d51693f337c4035f6edd4f7090c64815"
  license "MIT"

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
