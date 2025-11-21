class Summon < Formula
  desc "Provides on-demand secrets access for common DevOps tools"
  homepage "https://cyberark.github.io/summon/"
  url "https://github.com/cyberark/summon/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "367bea4540266a6cd7053ea2a1cc2bfa575b6ebf72e7b0849ee5aaae839fa7f1"
  license "MIT"
  head "https://github.com/cyberark/summon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8c1983988a46914ad92aaf0439ac5625f7bdfe18372c7d85ddc6fde1264fde7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c1983988a46914ad92aaf0439ac5625f7bdfe18372c7d85ddc6fde1264fde7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c1983988a46914ad92aaf0439ac5625f7bdfe18372c7d85ddc6fde1264fde7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c933b6f021097c0554d8b8b18716b97961fc7c4907a2f4a33fc6275f32e2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea9d88873a2f247955131b93e352f5e4751880220277060e71d661053c9efade"
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
