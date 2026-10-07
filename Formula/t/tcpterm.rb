class Tcpterm < Formula
  desc "Terminal-based TCP dump viewer"
  homepage "https://github.com/sachaos/tcpterm"
  url "https://github.com/sachaos/tcpterm/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b513d95083e245abf156aa39b5ea1093e6340646a8423bf30a4514670b18dbc1"
  license "MIT"
  head "https://github.com/sachaos/tcpterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2addf5000b1497b17c6e81f19b4ef1f583d06d4902f3e5874a57278073333909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab5d51e615477686a3e626fd9ba5607419629497439893efc419b6e8150341a9"
    sha256 cellar: :any,                 arm64_linux:   "6d406f55d20ed80eae6d4cac4e4edca783d56d2ff3c7a3711bc4b79c6678fb5d"
    sha256 cellar: :any,                 x86_64_linux:  "0e4eebca2e9c899752fefab5646092810cf326613769c4170fdc7d24dcf282c3"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libpcap"
  end

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    if OS.linux?
      ENV.append "CGO_CFLAGS", "-I#{formula_opt_include("libpcap")}"
      ENV.append "CGO_LDFLAGS", "-L#{formula_opt_lib("libpcap")} -lpcap"
    end

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"tcpterm", "--version"
  end
end
