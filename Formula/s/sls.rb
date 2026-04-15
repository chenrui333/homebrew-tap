class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "cfb5a06aaa7f591f90318ccf57b9236bbafc7bad650622d0e7f6361485cb3f1d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e88feca8cdf016579b198f0caff2cfa13a5419434ff4f4da7b4dacc77aa921d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e88feca8cdf016579b198f0caff2cfa13a5419434ff4f4da7b4dacc77aa921d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e88feca8cdf016579b198f0caff2cfa13a5419434ff4f4da7b4dacc77aa921d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24aae60cf684625493b12e5e2acc254ca1cd86fd1668fe90d33f3f3523f7d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6e75beb66500508e45ae85aa51c6cf725f0874d4ab16defba30482cc434974"
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
    with_env(PULSE_DISABLED: "1") do
      generate_completions_from_executable(bin/"sls", shell_parameter_format: :cobra)
    end
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

    with_env(PULSE_DISABLED: "1") do
      assert_equal "demo", shell_output("#{bin}/sls config list").strip
      assert_match version.to_s, shell_output("#{bin}/sls version")
    end
  end
end
