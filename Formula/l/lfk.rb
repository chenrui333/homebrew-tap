class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.4.tar.gz"
  sha256 "04ca531b029bbb9e6429f78a8dc6a82e4e8858a739514ec4e8ea82a99fd0a858"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ad3d33dfc0f86cdc20aeef73ef13824f1ccebf7a977bc97a2f1a73df575fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ad3d33dfc0f86cdc20aeef73ef13824f1ccebf7a977bc97a2f1a73df575fd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1ad3d33dfc0f86cdc20aeef73ef13824f1ccebf7a977bc97a2f1a73df575fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f3c25e20d9f37fcf0cfea6c3514dedb4a400be9370d7cc10852adce57abe09d"
    sha256 cellar: :any,                 x86_64_linux:  "62644a0e8fac0e23f1c354fcecb233cc11fdcc1eb0a1718e29e4fef98eb22fb0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
