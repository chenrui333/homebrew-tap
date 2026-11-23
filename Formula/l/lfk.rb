class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.19.tar.gz"
  sha256 "ebaf94ae81f0946ec76b375be589c95ec4dab60b001caec4f7d6c0239488c01a"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba2ba702d7c6bd9895cf5918a340424e202edf5d2e9c5028a5e80ce6af9a28d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba2ba702d7c6bd9895cf5918a340424e202edf5d2e9c5028a5e80ce6af9a28d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "337a6580d239cd936bb1739dd449db4416b6227cc349963c2b188b4032530ad4"
    sha256 cellar: :any,                 x86_64_linux:  "905e15d431d48288e676680ef6d8f118e16c60fcff8adb6414faa8323d2989df"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
