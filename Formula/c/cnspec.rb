class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.12.0.tar.gz"
  sha256 "f84b1fa5f601ebc1a9f93364bebaed998ccb7eefcfcdc4f55afba1ea6c8b85d5"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "686b1fea9ddc41e9f2957eb982aa0b0420a38e54fe1b0a30d08b86b23c524d01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c005db7d4e41624dcd30e3e84ed69a463fd36bb5de85910f3af5a552555f3743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f96525893a1285f6fce7f19df881b3850c829eb7f28ad909c9b946db18da1b9c"
    sha256 cellar: :any,                 x86_64_linux:  "449b1b93fd72a392ff62c670de38e1a0f95417dc3118cd99b3cff330055e73f9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec --auto-update=false version")

    output = shell_output("#{bin}/cnspec --auto-update=false policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
