class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "eff04137c1a73c0ae33c3a1eb8d2275005b202826557ed40cedaaec1828d73e8"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b02382e26d09de33095ecdef0846224afec08215f4a756ebc51a9c7d82ea17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa6c54532b15ebcc319ad1ac30fd3e1d06d5bcdb735ec833c735ea432565880b"
    sha256 cellar: :any_skip_relocation, ventura:       "b6e87049a086b7fe384fd14266fcbd7d9fe21c8b42001eacf5de8d066f331cf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f67afd79e68cd861d5725cd0adee2397ccd92490ac6ae1237754f86e495cd40"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omnictl --version")

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
