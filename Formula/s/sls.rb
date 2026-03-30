class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1f34c2c2eb54acc941156cbad87fca24c43778cb00032d050d03bceed5473a72"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dc4702210f02751a832dea137064de6f195a525defa8a7b4b30a77fce2be3df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dc4702210f02751a832dea137064de6f195a525defa8a7b4b30a77fce2be3df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dc4702210f02751a832dea137064de6f195a525defa8a7b4b30a77fce2be3df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c83b9b47ed1f0be9080e788826426459c43b9e428b1cec25c273947ed0c5e9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec55c65de48029881db12a673daa21133aa4c16692881d296054277de214425e"
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
