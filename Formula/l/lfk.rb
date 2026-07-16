class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.9.tar.gz"
  sha256 "1201387c1c044df5f37920cb2ed98b90bf0a616c9703c68a9c51a094cf82bf48"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b0947f150ae5e495dff8a8de9bcb74da563dd36078126b5aa1a8123d1a7c9fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0947f150ae5e495dff8a8de9bcb74da563dd36078126b5aa1a8123d1a7c9fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0947f150ae5e495dff8a8de9bcb74da563dd36078126b5aa1a8123d1a7c9fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa89fc30f8566c62b6e100dbe811c0233866ac720d76d1123bb1f029f50a26ff"
    sha256 cellar: :any,                 x86_64_linux:  "b546b31258e8ba0c8503094e4982dd71c01b89c741acae15cef7c564c3bc21f3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
