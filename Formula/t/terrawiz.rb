class Terrawiz < Formula
  desc "Discover Terraform & Terragrunt modules on GitHub, GitLab, and local files"
  homepage "https://github.com/efemaer/terrawiz"
  url "https://registry.npmjs.org/terrawiz/-/terrawiz-1.0.0.tgz"
  sha256 "34ff788efe924d5f6444d61e06fe7e9306f7641bdcb808fc6c1a61b001faf0b3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9abf24aab0dc2dc0186829a47e350e8cbbc9ade02aa820abf60cd3df94f7c5bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9abf24aab0dc2dc0186829a47e350e8cbbc9ade02aa820abf60cd3df94f7c5bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38a20ccf839750390969ada4a69155df87a06ce782a7ea794a2ce5ea030dd6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a20ccf839750390969ada4a69155df87a06ce782a7ea794a2ce5ea030dd6be"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terrawiz --version")

    output = shell_output("#{bin}/terrawiz scan local:#{testpath}")
    assert_match "[LocalFilesystemScanner] No IaC files found in #{testpath}", output
  end
end
