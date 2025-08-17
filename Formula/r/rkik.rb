class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "af76028b6e8689206fcd85592411c58f8498baedcb3966a53bddddb23ab1c679"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1019bae5fe9d05ca5b180f560f666e794d0c2eb6323cc72d599a0ce34e66188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14a4abff7aa6c0603c4bed5234312411a0e883f5d97f7c41979d2ec92a49044e"
    sha256 cellar: :any_skip_relocation, ventura:       "32822f5c91354e884e9eb1770b5b753c84bd55da38ba829312a58ae5be977266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c541449db2df61fdebea81ebf9215c91e03ce727fd6e414b5e0b1b41a814375"
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
