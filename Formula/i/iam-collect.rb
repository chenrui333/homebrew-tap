class IamCollect < Formula
  desc "Collect IAM information from all your AWS organization, accounts, and resources"
  homepage "https://github.com/cloud-copilot/iam-collect"
  url "https://registry.npmjs.org/@cloud-copilot/iam-collect/-/iam-collect-0.1.168.tgz"
  sha256 "f8c5cbb8198407a92b19fef0c22611d6e483a0a1583b22bb509b15a6322df865"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0552ca1720fe456df33379c08cd0b979bc4a6332519e7c6b36f408202acbe0a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iam-collect --version")

    system bin/"iam-collect", "init"
    assert_path_exists testpath/"iam-collect.jsonc"

    assert_match "Could not load credentials from any providers", shell_output("#{bin}/iam-collect download 2>&1", 1)
  end
end
