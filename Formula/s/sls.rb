class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4032ddc4f9eab99b9bf176e707b56c531bf558438f96903ae9530151031fdc32"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33cf26a7085e85f5bb6ab7de7ae1f37d7c4a0aca61ac7ed69f671ec964767bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33cf26a7085e85f5bb6ab7de7ae1f37d7c4a0aca61ac7ed69f671ec964767bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33cf26a7085e85f5bb6ab7de7ae1f37d7c4a0aca61ac7ed69f671ec964767bdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4619f739505db07dd1b7a3f79e5dd742f27a6e8313594e69e9631def2ddb7813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a858e69958eba33b663ef7d2768d702bbdabfbc3552ac42740bd47d10731104"
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
