class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "0561f2523ce61cd05d1921dd9536083c2587fb68205817bfc652b627a2bc943e"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31e0e7d8524a475a7f3a7147d1f1bf668fcd95fa46bbe61c58e581aec2e0c95c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e0e7d8524a475a7f3a7147d1f1bf668fcd95fa46bbe61c58e581aec2e0c95c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d1fde29144f1aa4d7519ab30a841af1a6b5c5f419e4f90ede1403578165391d"
    sha256 cellar: :any,                 x86_64_linux:  "12801ceae1e49501a6a2838a374a1de198980a2a25889e4b2b2a6a2d18d95f04"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cyberark/summon/pkg/version.Tag=#{tap.user}
      -X github.com/cyberark/summon/pkg/version.Version=#{version}
    ]

    system "go", "build", "-mod=mod", *std_go_args(ldflags:), "./cmd"
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
