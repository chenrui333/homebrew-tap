class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "02233cb51bf1c50a96bd665dc6611ce0fe9c86700c91a9a2e15b4c3a556f2758"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faee62a164d04e3539462869404a0308886fa055be22ce956c737abb4a406a8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd71c876423ed853c9a01eb63854089bbbe501b15d67a1be5c551f8f8cfe688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66604b5c62995721b6eb841011d87ba373b8c58ee3fcdb7f5e2a77b552e946fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c747f5752c0815baf6e9c2ea799b854ec5af81b15df3ad9a738a3effd7d97087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dd2df9ce4560ee5b54101d6118f590ea1bca7ac3b40b36021865f27d386f196"
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
