class Tcpterm < Formula
  desc "Terminal-based TCP dump viewer"
  homepage "https://github.com/sachaos/tcpterm"
  url "https://github.com/sachaos/tcpterm/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "c4c0c536ddd12509f1fa2607d84a1e2a002a5a82269ade98a9da4933bc8bd020"
  license "MIT"
  head "https://github.com/sachaos/tcpterm.git", branch: "main"

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
