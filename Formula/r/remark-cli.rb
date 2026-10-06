class RemarkCli < Formula
  desc "CLI to inspect and change markdown files with remark"
  homepage "https://remark.js.org/"
  url "https://registry.npmjs.org/remark-cli/-/remark-cli-12.0.1.tgz"
  sha256 "e100dfaffa5b3a50312313391fe493d2d51693f337c4035f6edd4f7090c64815"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6fcf25d90af84a37ac43b17605bada3c63013cc5430e3e375d30b9927d9beac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fcf25d90af84a37ac43b17605bada3c63013cc5430e3e375d30b9927d9beac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95fec31b12e2abb5c2ef0718da18fcc542f7bb0f199fb981bde7149d9a0d1170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95fec31b12e2abb5c2ef0718da18fcc542f7bb0f199fb981bde7149d9a0d1170"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
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
