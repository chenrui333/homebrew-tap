class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v0.48.3.tar.gz"
  sha256 "95abf6098e0966511da748cddd4bb15077f6e30988a6d9fba45c084c468deeb5"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a799f5763a901c4b48fb59821ef587e948cb2d57f9d57cbbead561b8742833"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c948d068ee83ec25feba4279937dde86ee8212d4eca89df1bc3d27550401f9"
    sha256 cellar: :any_skip_relocation, ventura:       "6fd4535ff10e159c4b3f33de47f26030de57393d968d7b193aef8fd235894d7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10991865f8ebc17b9935eef7bf7c1770a949d582d345fcdf200f9edf2175745"
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
