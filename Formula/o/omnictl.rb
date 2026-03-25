class Omnictl < Formula
  desc "CLI for the Sidero Omni Kubernetes management platform"
  homepage "https://omni.siderolabs.com/"
  url "https://github.com/siderolabs/omni/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "32e08364908e3ad40989ef651b37e567a79a6a27ec33bbd100e924be01189424"
  # license "BSL-1.1"
  head "https://github.com/siderolabs/omni.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33bc8a65789b7be0d2c49b295051e9ef06d695c7a7a729c264c682dadf553125"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33bc8a65789b7be0d2c49b295051e9ef06d695c7a7a729c264c682dadf553125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33bc8a65789b7be0d2c49b295051e9ef06d695c7a7a729c264c682dadf553125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9acc011d161e5b9c4d35b8ee2123497d3537ceb5ea5ddf25de74ec37e636100d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5351475d7e6c560299a1723fcf44966bf05228200cdf8834469a76a2830e9ae5"
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
