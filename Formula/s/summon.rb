class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "3cdebb25162efa71113676c008dc9beec054641506b2e784e61f3472dd2e904e"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9dea63cb293440d95fd29d45a8f8108518469def0c006e01f2671c72f0b41ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7979e84e4dfc8d0f7f07fb622a93d4b1f73cad852578a2e40dc3c330767eb92"
    sha256 cellar: :any_skip_relocation, ventura:       "195aeb1de55341c08741620d0b564f5f87dd72b5650225a0c0e46e6596f32ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9e5d20974e8593b32bfcfd19339c8f140f0cd22a16ef192aa0f402558ae1138"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cyberark/summon/pkg/summon.Tag=#{tap.user}
      -X github.com/cyberark/summon/pkg/summon.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/summon --version")

    # Create dedicated provider directory
    provider_dir = testpath/"providers"
    provider_dir.mkpath

    # Mock summon-env provider, returns fixed secret
    (provider_dir/"summon-env").write <<~SHELL
      #!/bin/bash
      echo -n "my_secret_value"
    SHELL
    chmod 0755, provider_dir/"summon-env"

    ENV["SUMMON_PROVIDER_PATH"] = provider_dir

    # Create secrets.yaml referencing mock provider
    (testpath/"secrets.yml").write <<~EOS
      MY_SECRET: !var secret/path
    EOS

    # Run summon to check secret injection into environment
    output = shell_output("#{bin}/summon -f secrets.yml -- /bin/sh -c 'echo \"$MY_SECRET\"'")
    assert_equal "my_secret_value", output.chomp
  end
end
