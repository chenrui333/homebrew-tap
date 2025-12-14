class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.13.1.tar.gz"
  sha256 "3a9ccf09c92eb3341e51c866acdf439da24e88e7069444884dd6a3b74a74470f"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ec7760f7c3d69fbed8472d9c5be57f0bf44840321f2f574f530ca799e42439"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6fad293497529836572d66dcb3e0e326ac99ed2a54865e5a0fe34651886c9ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a671ffc1c3bc3656c5a6b62a2c986e58f15e4418f4e5a9afa1a622e2a98b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9254da37cc18c5c1578a6aee48fbdb5efcfdd8c58deee7fee3e81e0741ff6a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "692312f165487fed8ea2de427d1e5a00c37e5839a40d9eb3556c9354e71697c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
