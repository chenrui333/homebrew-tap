class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "eab6ec15d85a82b1c849029f0ff7c2df64346cbe6dfe849dc0fa8db5f7f2265e"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "149fb1b59f483e39dade4336e26edd2306c3ae52bec6e30e9b852cfebba10e65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "149fb1b59f483e39dade4336e26edd2306c3ae52bec6e30e9b852cfebba10e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "149fb1b59f483e39dade4336e26edd2306c3ae52bec6e30e9b852cfebba10e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9322b82e1f961ca0de3e53d1e53341bd3a049555eb08c5a5adb47cc05ba059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebdfb8da1566d9c9dbc9b51675189c975f6abf250d901c27174dca3e71fbe4e"
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
