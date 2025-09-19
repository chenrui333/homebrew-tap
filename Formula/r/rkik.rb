class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "e7af24e0849c1ac1b59f369b1b598b84e219f70a89809cbd2fa447350bc3634b"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a0a68dc9fb388e436ef367e66d94cfe9823756ea787a5b21b3a0397b8a8bcd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f6ec23b832d168a77a5415b2a6181309974618cbf5058abb5f2385d999af69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4c8780a729a0aabcc015e462d2d16a00fa3af3781a4bb7340b3bff3228b9db1"
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
