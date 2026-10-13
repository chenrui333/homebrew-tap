class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.6.0.tar.gz"
  sha256 "6097622754c644f0997a8200f57078829a8a9cba2734f30f7d16aa08415954b4"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55994a1cfcbe335e85f30430ae380beb9390022382b88f26ac6d374aa3b605c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fac6f2445493379f0e757f08be28ed40f84f15f4864f35514cefb9658625ec9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89091187c32a6d0574d2ee5cf72f14d1c7f416c3ff1cfe6d0418ea85f29cad66"
    sha256 cellar: :any,                 x86_64_linux:  "ece580b1f3b73ef989921076b1c460f4a301b25aa0a6afd2dfed65388d438475"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
