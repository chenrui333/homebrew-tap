class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "e7af24e0849c1ac1b59f369b1b598b84e219f70a89809cbd2fa447350bc3634b"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77e756accb32852b477278f4e6e30a6d4cde538766fdaaa4a09e889b21efbca8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2622426e4c062268f941c488d4a665382abdcb3f003c607d1cb47d235dae1932"
    sha256 cellar: :any_skip_relocation, ventura:       "de099f3ccf1520e62e314c252a49982fe0137023b73c37f3cfef17280c43ac71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e786266857d46b63bf83000bc973784f83dba06f97f8ac458a3140233ce4dbd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Error querying server 'time.google.com':
    # Input/output error: Resource temporarily unavailable (os error 35)
    return if OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match <<~EOS, shell_output("#{bin}/rkik --server time.google.com --verbose")
      Stratum: 1
      Reference ID: GOOG
    EOS
  end
end
