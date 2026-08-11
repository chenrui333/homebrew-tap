class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.33.0.tar.gz"
  sha256 "c1fe6f9189907b24e63f943ece189b2e3973415e6c7c5010516faf27a6851a1f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "285eae52e297a9e32499743a863cb34570dcf0c5bc4e2e20486aeacff3640b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8518b2a8a1ed2f4e789cfc99cefc1a2e3910f8e2068611b8872bc0fafd011739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d6429b3bd9d5bb373b74043221b2b12f9b6d48cb67db12c4ec12742dc29ccaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d09512cdf59237dd59609ac990c14252e3caafbcd62a147ed2ae6db5dfa8f4e"
    sha256 cellar: :any,                 x86_64_linux:  "f46ad07b5eb60e0cda54be66f1b0f19e53590da8693fbc2f9babd89193880800"
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
