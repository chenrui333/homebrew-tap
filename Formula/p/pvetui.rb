class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "5860aef8b99ea2d540a6b8830e1605a07c83f69f4e9f617de9d60e36562e0ed3"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71d02474b5623ce5301df34fdd92912bcfdbbfc55e7c898d8534b3020f7910a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71d02474b5623ce5301df34fdd92912bcfdbbfc55e7c898d8534b3020f7910a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d02474b5623ce5301df34fdd92912bcfdbbfc55e7c898d8534b3020f7910a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bcc6e890e3a8890e20f251b09e54f2c2d5ce0a1c35e7dd3c9631207fbab367a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac6e23fb6c8fc6ce1ff7789adece4c9b6ddb4ebb01f2e6c9afea7b813bb0dfbf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end
