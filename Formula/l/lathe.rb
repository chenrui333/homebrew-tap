class Lathe < Formula
  desc "Generate hands-on, multi-part technical tutorials on demand"
  homepage "https://github.com/devenjarvis/lathe"
  url "https://github.com/devenjarvis/lathe/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "989cade99ddddfaa53a97359a3c62a5695f107227874564336869cf16c2ec444"
  license "MIT"
  head "https://github.com/devenjarvis/lathe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b61bf0176424bd26fa5dffdda3010b28247eb6c85a337d1ae008274e03112609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b61bf0176424bd26fa5dffdda3010b28247eb6c85a337d1ae008274e03112609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dae21ddc818f5cac58a340d1edbb8ca6d4273bad1cedc88f3f67640f6452d66"
    sha256 cellar: :any,                 x86_64_linux:  "b8f8991e25d4fcc42d8e7ff5fbfd211cc724fbed3fe770c4866be40b4693b851"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
