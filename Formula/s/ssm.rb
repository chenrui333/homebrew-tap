class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/2.6.0.tar.gz"
  sha256 "342d3359d80d979858b48b0df1047bc93331c229ad1dbe8cb43dc511ab004007"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "330170ed30c4cff1ebc3561cd7ee249c3752f81cfa8846b2cbe63f907909dd62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591ef37657d54619740c17814e12864ab40f3b3c9e8da970fd689d3a41d56ad7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657ddb12322ca0d09874e3448471a870f7a514d50e53fd84f1a34e2494a6a566"
    sha256 cellar: :any,                 x86_64_linux:  "882e62a65a68e30488976d57417dd89a65fa6cd596bbab65149a5eeabb908f5a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")

    # The SSH config is parsed before the TUI starts; without a TTY ssm stops there
    ssh_config = testpath/"ssh_config"
    ssh_config.write <<~EOS
      Host demo
        HostName 192.0.2.1
        User alice
    EOS
    chmod 0600, ssh_config
    output = shell_output("#{bin}/ssm --config #{ssh_config} 2>&1 </dev/null", 1)
    assert_match "not an interactive terminal", output

    output = shell_output("#{bin}/ssm --config #{testpath}/missing_config 2>&1 </dev/null", 1)
    assert_match "missing_config: no such file or directory", output
  end
end
