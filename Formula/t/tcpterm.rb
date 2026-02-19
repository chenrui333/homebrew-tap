class Tcpterm < Formula
  desc "Terminal-based TCP dump viewer"
  homepage "https://github.com/sachaos/tcpterm"
  url "https://github.com/sachaos/tcpterm/archive/refs/tags/v0.0.2.tar.gz"
  sha256 "c4c0c536ddd12509f1fa2607d84a1e2a002a5a82269ade98a9da4933bc8bd020"
  license "MIT"
  head "https://github.com/sachaos/tcpterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "156ff207029c2589c961169b9215f046cf293bd42c8937ddcfc01a8228814760"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1936aca1be1448fc8d0cdac9413fc33023fbd50c43274b95df422edc2196639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10044ad4a933725fda80fd693fd2e900fcb5206dc22e0d13a84f7073fc9fa47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38dd0a17fa68633b61c1314d5e2d8745c12d16f3dea0f17efdfe93ea74248715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d3baca88abcdd1f3f0e7b322ab0c98d117157f48910181f892ea17f0c65181"
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
