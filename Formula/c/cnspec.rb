class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.29.0.tar.gz"
  sha256 "b74f16cb3dcd9f3f0b1fc9af0ec9fe025da1b722b1f41a4b716f5cc517a14733"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bceaa287f3268d21cb51145c6b3fb8c6861d122f6a13d03b4648171b6aaeeb65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54e8992da7819e13ecac14e9cf05fad3b7b0c7489c599bbf442a556cd80f3a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1a47bfa8ae977e23a94ed87b05dfad42153fbb4ae4c2a70c7ce8e4bafdff7d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8bdba9a93853cc65157ed47b09c60f9fc81987a7f2afc1e0778e4c6c01b3e04"
    sha256 cellar: :any,                 x86_64_linux:  "b61e78e08f6baf871cf83292ae5d0b99e1340a206eb5664e19213ad9689b1cc5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
