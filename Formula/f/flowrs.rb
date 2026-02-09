class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "5de2810cf4415bc038aad355be5f0038517ed61bdcefa2d47e0da33540f67728"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82da6b434ca30e333dfcb535eec433d75982e2f4f8dad9939d36311f81855803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e4b1b4d65ef7ef4127090ac919adf0608eae84281330afa48fb03b73392e1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4951e7c44b87e149131eccaa2bb5457c05015a0232b54102e7dbfa9316679fbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "514260101eb2a4f534ab7e6242692b4a655f585ee926ba99d45dbcf74384af9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07b35a1edcf6980ebbae284eef3eee0d1fa42d17f56acca29874403acfda2f4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
