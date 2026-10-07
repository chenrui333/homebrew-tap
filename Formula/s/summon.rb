class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "0561f2523ce61cd05d1921dd9536083c2587fb68205817bfc652b627a2bc943e"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c8881f1a9dd7b25e75266849aa8f119a298fb4fbeb0b07c49b650b87247c139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c8881f1a9dd7b25e75266849aa8f119a298fb4fbeb0b07c49b650b87247c139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c3001aef1b5fc50e52fce10b7dd589681f231f05a19adb77eacc966799e83a5"
    sha256 cellar: :any,                 x86_64_linux:  "b7f908e46fc48f2c55ccc0acf7636298abed89b3e62476cada725a1e4be3ea3d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "tidy"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/cyberark/summon/pkg/version.Tag=#{tap.user}
      -X github.com/cyberark/summon/pkg/version.Version=#{version}
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
