class Vento < Formula
  desc "Lightweight CLI Tool for File Transfer"
  homepage "https://github.com/kyotalab/vento"
  url "https://github.com/kyotalab/vento/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "493ca4d72c756ecc0773cfc2fca1731b03d4a3781107b2e32c2586c5c3600488"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac64cb3f666298c3496e14435f18d7c5c3c7514513c9328c57f5f56aa35132d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8de926a926bcc677ab5b26b5fb5cd83a834938816879dc1266e0bff0474e7fa"
    sha256 cellar: :any,                 arm64_linux:   "d632f7b184b10b124de4eaf0fb0e3adf7c2150a15f79c81f58ccd0510ff4c739"
    sha256 cellar: :any,                 x86_64_linux:  "eb92f3d8df95eb4bd4e898f5a7f83fcc32c3f09d96fd59717763eb875cbde049"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vento --version")

    output = shell_output("#{bin}/vento admin 2>&1", 1)
    assert_match "Error: Failed to load default application configuration", output
  end
end
