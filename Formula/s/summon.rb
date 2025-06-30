class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "3cdebb25162efa71113676c008dc9beec054641506b2e784e61f3472dd2e904e"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "354221da60f984913676c68f1fe5e64fd3fb3c486fd45ac0b9612e5ce3dfe796"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5beb375c05df6aacb7e913074626f2aa92393eb713f50b609dcde69899062b5"
    sha256 cellar: :any_skip_relocation, ventura:       "4700e327f3de4992dc78617779bb0672e3c51e474a81a1e8700038e432b1808f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2873b683bd51d03ff38903abbf2ec5f25440a634b6ba2205433ad9d4a124bc1"
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
