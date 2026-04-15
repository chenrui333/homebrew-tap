class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4032ddc4f9eab99b9bf176e707b56c531bf558438f96903ae9530151031fdc32"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e4d936cf883a3ed95b4f2c569cee301535e1bbdc74735f82377c21706a87e26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4d936cf883a3ed95b4f2c569cee301535e1bbdc74735f82377c21706a87e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4d936cf883a3ed95b4f2c569cee301535e1bbdc74735f82377c21706a87e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d22c525245340d2fa491d305ccf0fee159d0a296f5e1cc297c2b86e4bba446a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeaf9d51142296e7c3ab38a4e5edfbdbbcc4d21c894b32462f6e3c84d0735d4c"
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
