class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "89483211b74ec79e35c1156d0d3504fa71b8b9ac3eea2a03933f37679ad06de1"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c74775f0b00a4d7bc5ec3bc686d1e28e0af40e033193060cd8ae590454e8b80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c74775f0b00a4d7bc5ec3bc686d1e28e0af40e033193060cd8ae590454e8b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c74775f0b00a4d7bc5ec3bc686d1e28e0af40e033193060cd8ae590454e8b80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd48f836f776f131dcaae9445bd8482ce8ef4ec72bb2020edb7fff80b117e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5470d917e542adc0e44fd0c11ae7c1b94636485209d1a77ce86c86b7f916800b"
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
