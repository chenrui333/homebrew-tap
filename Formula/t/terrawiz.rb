class Terrawiz < Formula
  desc "Discover Terraform & Terragrunt modules on GitHub, GitLab, and local files"
  homepage "https://github.com/efemaer/terrawiz"
  url "https://registry.npmjs.org/terrawiz/-/terrawiz-1.0.0.tgz"
  sha256 "34ff788efe924d5f6444d61e06fe7e9306f7641bdcb808fc6c1a61b001faf0b3"
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
