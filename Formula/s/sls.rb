class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "3bfbb5598e69bacaeb0af7319dbe5f621815038641294f26df70dfc961fa36f1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12219506b2d6b7a01efbaf5b5d40065ce4a1e09aac49b938f2e36101663ce835"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12219506b2d6b7a01efbaf5b5d40065ce4a1e09aac49b938f2e36101663ce835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12219506b2d6b7a01efbaf5b5d40065ce4a1e09aac49b938f2e36101663ce835"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "014f66e4235ed1b8ec4060db44056f4c0869359fefe92ffed99525c527bc1d0d"
    sha256 cellar: :any,                 x86_64_linux:  "e792ab8c540da9030fa97de5f514a63600f9eb704914d8d28dc230c6f0b1f481"
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
