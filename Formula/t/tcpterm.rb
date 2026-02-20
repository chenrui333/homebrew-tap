class Tcpterm < Formula
  desc "Terminal-based TCP dump viewer"
  homepage "https://github.com/sachaos/tcpterm"
  url "https://github.com/sachaos/tcpterm/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b513d95083e245abf156aa39b5ea1093e6340646a8423bf30a4514670b18dbc1"
  license "MIT"
  head "https://github.com/sachaos/tcpterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2fe5104cf28bfb888bbd8152e29413725d3fef27d2d767752eefda8553986f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1062b12e748f181284b5b83a96078b183a062bf226d7ccc620da2cbefbceb080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e492c4c3fadfebd031b89a88b7f74c39605380c03b8acc51ca28f2c31c2f9f00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e45f936852cdeeb3a8b5259048b8fa13c8d551a797936e0cff7bb12184fc04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f824744d3d602983711498ca42e24d575b153474237d376f4c238722547e0eab"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libpcap"
  end

  def install
    if OS.linux?
      ENV.append "CGO_CFLAGS", "-I#{Formula["libpcap"].opt_include}"
      ENV.append "CGO_LDFLAGS", "-L#{Formula["libpcap"].opt_lib} -lpcap"
    end

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"tcpterm", "--version"
  end
end
