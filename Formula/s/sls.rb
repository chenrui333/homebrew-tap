class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "09b962e191533222e1691581d732e7aa95a668c150ea506e091ac09705e0461b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba3136fafde6f7fd07c9225790cc7afef14d8200f3a2761924048033f6747ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba3136fafde6f7fd07c9225790cc7afef14d8200f3a2761924048033f6747ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ba3136fafde6f7fd07c9225790cc7afef14d8200f3a2761924048033f6747ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5442bdadda549829a60df7a10256a74fdfb1f1430eb094694c151a3d451acc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee6f9b04af7fa2ac32990beb24fd5cce623b8f89b2fc8840da9006fe9ce84e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/jinmugo/sls/cmd.version=#{version}
      -X github.com/jinmugo/sls/cmd.commit=Homebrew
      -X github.com/jinmugo/sls/cmd.date=unknown
      -X github.com/jinmugo/sls/cmd.builtBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"sls")
    generate_completions_from_executable(bin/"sls", shell_parameter_format: :cobra)
  end

  test do
    ssh_dir = testpath/".ssh"
    ssh_dir.mkpath
    (ssh_dir/"config").write <<~CONFIG
      Host demo
          HostName example.com
          User alice
          Port 2222
    CONFIG

    assert_equal "demo", shell_output("#{bin}/sls config list").strip
    assert_match version.to_s, shell_output("#{bin}/sls version")
  end
end
