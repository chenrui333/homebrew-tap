class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "3bfbb5598e69bacaeb0af7319dbe5f621815038641294f26df70dfc961fa36f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a151270b462bc003d295073e39b41e1aa341aab78bb59e33fcdf6abe652e9bde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a151270b462bc003d295073e39b41e1aa341aab78bb59e33fcdf6abe652e9bde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a55ae0c250557f58b9c111e7b5525344415b5192d01289ffc1a5ba7c355cfa87"
    sha256 cellar: :any,                 x86_64_linux:  "11d4a5ed55a1453c20310095b4d9084806d160d9331dec654ca0c3ba74e5691a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
