class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "63d7aaf150bf357c5231c96382c551b3922dd0f0273515729f4d82c1a4c87c2b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c89eb4af9917ea09d2e67176f42010f7b8c7491ae85286cb56212208c009fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c89eb4af9917ea09d2e67176f42010f7b8c7491ae85286cb56212208c009fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c89eb4af9917ea09d2e67176f42010f7b8c7491ae85286cb56212208c009fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6349b01f0c9abb1eda6d0e12681f05d74e971f55a26fb4e8ae7df14b980c606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4708080f9a107597d4f04ddad4977103566a76425eafd7d77ad8a220ca8746c"
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
