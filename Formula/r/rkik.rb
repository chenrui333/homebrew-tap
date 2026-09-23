class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "fa48a3872fd8a1ee0c3bcc7c1983e706750da54a984a8920b28d5742cfe599bc"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62bf46c39053bdde9e799c3fe028c6cf38be7744e5263e8a0936f3dc99c34133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c8fdd9a23208de1fcbf769f81820f7d5ff5dc83a69ec05aad4d9008b308332f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3064d01275b62dbf664165c75046249a4e95a78f33048e033d19bf096d21a425"
    sha256 cellar: :any,                 arm64_linux:   "b5cb6c0721487254b72f87a60082c6a79c41d580ecc92f5c7d263a79e3349006"
    sha256 cellar: :any,                 x86_64_linux:  "a22484c00bdbdaf73d0581a1aa3a2ddd0b98fc420a2c986ede62c8971714b25d"
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
