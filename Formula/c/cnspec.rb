class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.32.1.tar.gz"
  sha256 "21e1f7688f72551ea02f714d2de9c8297c9afe7fdc0bd6d1da509bfc9fd5a9cb"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e346a6031e4ee5970faf5a46a9db97ad13f5a01a643ba0661c85446b707cea5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffceb16b0adfd8f8a2ec91ddb4438f098123333dec1e7516dd497eb7dc9d19c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a1582d7f1a6627bdd21472f12bf43f288cb8fbdf6488fd4395350856de87276"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49adc84a02924ff24a785072b93534091e4e33e4f3224788246d25213aa05d43"
    sha256 cellar: :any,                 x86_64_linux:  "99725e56fdd351d28f1ad5e2dd5a7c987f321fd95a6bb6a7aa52a6fb8ebdd5b3"
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
