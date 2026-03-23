class Sls < Formula
  desc "Fuzzy CLI selector for SSH config hosts"
  homepage "https://github.com/JinmuGo/sls"
  url "https://github.com/JinmuGo/sls/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4f47b7d4934aecde5f415c4273898ebe1bebae9401129a16d65f9a259fe32882"
  license "MIT"

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
