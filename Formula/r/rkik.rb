class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "58e6d91a1a0f2ac2038e5b07e192e57dba6841434ad5835995345e56212a8ea4"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ea2ed6bedf1b98b821661fec5567e6b568398b5a4d440d5bde47a745fac2e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85341b4a1a063e9cf049f848d1587a55615bea6675cf7c6d8f74072a7f2be7fb"
    sha256 cellar: :any_skip_relocation, ventura:       "3f589270bfc7b4f0d138bb8029fa0e03b65ebcc97f8508565cba0a3b7c801504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0019f3c5d0ddb2b25877febd1247846fa8eaa52a0e31bfdb427c765b776f4651"
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
