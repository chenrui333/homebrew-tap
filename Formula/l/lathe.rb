class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "989cade99ddddfaa53a97359a3c62a5695f107227874564336869cf16c2ec444"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04566e25d06a7098211db9e41524dc890960fbdd71ecd7eac3e3b9075b97d9ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04566e25d06a7098211db9e41524dc890960fbdd71ecd7eac3e3b9075b97d9ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04566e25d06a7098211db9e41524dc890960fbdd71ecd7eac3e3b9075b97d9ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1008d1914ce4cd00ddafbf7d657610c5ca121706d3ec28d8e402d30c1419a7f0"
    sha256 cellar: :any,                 x86_64_linux:  "87f6ed0530951db0abcd9b6d54571d9be00592474f155fda580a3fb6fbbc004d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devenjarvis/lathe/internal/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lathe", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lathe version")
    output = shell_output("#{bin}/lathe not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
