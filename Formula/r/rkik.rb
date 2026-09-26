class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "fa48a3872fd8a1ee0c3bcc7c1983e706750da54a984a8920b28d5742cfe599bc"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac21a5731ac75413ba67e417f0f20bafa4abdafcf28c7bcf88043b9fbfa3798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e5cde023e05b9aeac2d29a67229faa7d0d54dcc66ec66a1f6e733b3e6f1efa"
    sha256 cellar: :any,                 arm64_linux:   "d42e74f990016c17ca5c017f298b947ee11e6ed40c1e1fc106c063be7b1d1f33"
    sha256 cellar: :any,                 x86_64_linux:  "2cd7180d706778b74085aeb37e637d9557bc0f1ff068154af89234760abd5ca8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rkik --version")

    ENV["RKIK_CONFIG_DIR"] = testpath
    system bin/"rkik", "preset", "add", "test", "--", "ntp", "pool.ntp.org"
    assert_match "test: ntp pool.ntp.org", shell_output("#{bin}/rkik preset list")
  end
end
