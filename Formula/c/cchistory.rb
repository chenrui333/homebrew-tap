class Cchistory < Formula
  desc "Like the shell history command but for your Claude Code sessions"
  homepage "https://github.com/eckardt/cchistory"
  url "https://registry.npmjs.org/cchistory/-/cchistory-0.2.0.tgz"
  sha256 "151b7194d3643b5a321b0650d31a73912fbae02c382707c61650da7194ec6611"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26485e36610c4c162283f9b72e909272e1134960efe28054c6f6c00c43dfd3eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901e379587e91ec33b24a119b8b753b644f46672257abd9ee78ee96cee497241"
    sha256 cellar: :any_skip_relocation, ventura:       "576aa04fc0f7c719ba131fc15fb8af17ba2b7eb3e07d71ac352559749b15cb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09949f3157b260213aaa19a797f06d080fc80035bc52c693db18d95d64e64b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cchistory --version")
    output = shell_output("#{bin}/cchistory --list-projects 2>&1", 1)
    assert_match "Cannot access Claude projects directory", output
  end
end
