class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "85fb6cdb36fdcf0efb8e389efc8fd18fd2b78a65da9f4e163313680b88e15929"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f03dec3dae55def31f95b060b952b3e0885f107334306ba0d76fcb9fd3df18f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bec7bb1aae0410773715f56f3978ee855ce61eea04f1a7e55824926b0fdb906"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6a72008779718c6c4a3b7e0658b306bf54e5900954e6f908d5b36e21a962d5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75327f4ac47e4c4038eccdab3a1c77d764ef6287db3c026e64a3ea3b2fa5d5a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee36a089b51f3dcfd74894574f40a35df346c0f011e28a5e84f33e69e571360b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
