class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "d27977db1b154b78be6726d4f1951d61eb1727b9f2c4640b99739827e624fdf0"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f2cb5e3fe8147537db829af8e2178947911d80c8ad1c9aa57d4e455af7ef71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f2cb5e3fe8147537db829af8e2178947911d80c8ad1c9aa57d4e455af7ef71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11f2cb5e3fe8147537db829af8e2178947911d80c8ad1c9aa57d4e455af7ef71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77ee439567ac72a1e1164b4df951efca1e45da776d741476b79317302702c1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce775c7369523fdab263f3ce900826dba0da803fe45a3d3c3752c61fbc9effdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/omnictl"

    generate_completions_from_executable(bin/"omnictl", shell_parameter_format: :cobra)
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/omnictl --version")
    system bin/"omnictl", "--version"

    system bin/"omnictl", "config", "new"
    assert_match "Current context: default", shell_output("#{bin}/omnictl config info")

    output = shell_output("#{bin}/omnictl cluster status test 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
