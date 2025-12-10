class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "0caab33e6924d058936f9e01ec8db90ef95ef400c46c15ede62638e694ca765e"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c55495f8a4b0bdd93d1908ce7d13165eaef08338073023dbbfe4663add36ed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c55495f8a4b0bdd93d1908ce7d13165eaef08338073023dbbfe4663add36ed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c55495f8a4b0bdd93d1908ce7d13165eaef08338073023dbbfe4663add36ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffcdfa46ef0b0292d86ffeee68671012cb47ba2a8bdfdc36e27894cb8b13c81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dcb3224db706c05b450ebc23f5e2bae7210d8119d135d25a812420f8fdab59a"
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
