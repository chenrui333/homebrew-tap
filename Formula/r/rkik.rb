class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "480b977ae8259b025ae6f3dba4ab4894d69e1dd897adf08ab66f675df714d306"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "633551382abd4e28ed6f6657110ed06141cc7475a8c2670cb30b038db89bf374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "743e3605f48c229515205cc637228b805acd62641ffe6cd8f62270660690d114"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "347372bf33fdc9e6ed976c9021643911773b57fd04c6906c6278fbcfefa2b062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff762f5bb69cd9c02b352f2ec9c0f4963cfa8fd76551d7fce34c0afa026509a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70af7e2dd2afe48e598da74fb917c3886a7fbd60cef4ef45ffe37865d9664db6"
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
