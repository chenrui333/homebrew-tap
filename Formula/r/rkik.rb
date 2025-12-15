class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "480b977ae8259b025ae6f3dba4ab4894d69e1dd897adf08ab66f675df714d306"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "466782eee734064b6666e9217567d356dbff148cb778d2fc42d4eb1f107a3037"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2633327280338903cdf9a6115e83b52e59baad5d579e386ef7b356b64254adb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7577e4722e3dcc246127d5b12d5457a357475c73e0b04fb721f041e6216199c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9feb90701c3027a4f233cf2fe255fed805817af0a47c44f14d3804985dacfd96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53182137fe5e1dcaf06c75e9ea9af698d913283bab355f8152428d52dd5aa66"
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
