class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "47e99a41c68c92acc81900ee74905e35f9ee97e3dbce4b7f93fd8d56f42d34c3"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b8158b6ae7363292cff2d20390d6a984d1a1d6caa9d83478eb22be2b669828f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b8158b6ae7363292cff2d20390d6a984d1a1d6caa9d83478eb22be2b669828f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b8158b6ae7363292cff2d20390d6a984d1a1d6caa9d83478eb22be2b669828f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf0eac6a153925c07fb1de458b5ec5e82b048130304384f3d8072ce5504cdedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a348e2af6560e727683cd6ea0e03db17461eec39929125da5e2c1979f6004cc1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match "bash completion V2", shell_output("#{bin}/lazymake completion bash")
    output = shell_output("#{bin}/lazymake __complete - 2>&1")
    assert_match "--file", output
    assert_match "ShellCompDirectiveNoFileComp", output
  end
end
