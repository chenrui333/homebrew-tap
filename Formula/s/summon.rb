class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "c552c633320d805fa21c6794feb5edd60bd877a93193c81f0c32888255ed4957"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a96ec4fdea5fa39ab46dc7d17a919a2c5d1db66bf304cc4a35739ff6b194c4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a96ec4fdea5fa39ab46dc7d17a919a2c5d1db66bf304cc4a35739ff6b194c4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17364652be36029a7d6ec4070064e6cd9e4ddcf37794b072c9e9c9752ae4ef6c"
    sha256 cellar: :any,                 x86_64_linux:  "f5f698fbff552349aa4274817feb87a6c17e265e19d58670fd0dec40739af954"
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
