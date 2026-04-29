class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "6f387fd2a3becdaa2578e0bcf5be49817bbbe2724bdac46cfb0df5b24b35367a"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a710b3df7cd33b6389846a2eafa1ae219dc8e76395b01670cc0b48ba78c71f83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "387b358630dbbb69789a5fb1fc90e809a3a2d8c039ff91bf39d6af254de4001f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74f23814f131d43819b889de924f234e746fa5b60afa3e486e479148ab144ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aff7bd71655970d664a0ba33fa09749918545d9496b5a749f185570c9629a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "736268488c4901021246a23a48d3a34a48aef942efaa80ce8803222338a76c63"
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
