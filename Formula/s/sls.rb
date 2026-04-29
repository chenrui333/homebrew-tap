class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "63d7aaf150bf357c5231c96382c551b3922dd0f0273515729f4d82c1a4c87c2b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39ad18e93e607d62297a3ad509c72f58e8dc94a337d47903893d3469e836c124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39ad18e93e607d62297a3ad509c72f58e8dc94a337d47903893d3469e836c124"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ad18e93e607d62297a3ad509c72f58e8dc94a337d47903893d3469e836c124"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a4c851a0544f64178f5c684869d98e6e0f8025ea410adb61b08bc8bea22f35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879e6bc90a131e2a7f598faf2ac5db6d11950b59fc3ac7bf101a7203e25b9abf"
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
