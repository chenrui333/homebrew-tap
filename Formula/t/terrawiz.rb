class Terrawiz < Formula
  desc "Discover Terraform & Terragrunt modules on GitHub, GitLab, and local files"
  homepage "https://github.com/efemaer/terrawiz"
  url "https://registry.npmjs.org/terrawiz/-/terrawiz-0.5.0.tgz"
  sha256 "d705b00918e3f60ec2368e5da7c60d63f595a5c4f742bd0831c1f8a63d2ca972"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "dfb15b41c4d8a3e96c84b4afbbb4b7a58252698aab5d785a0a34e0be27d63971"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terrawiz --version")

    output = shell_output("#{bin}/terrawiz scan local:#{testpath}")
    assert_match "[LocalFilesystemScanner] No IaC files found in #{testpath}", output
  end
end
