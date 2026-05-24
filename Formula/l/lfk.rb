class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "c41b5f90acd68e95fac31b408c3f56d958295136ce7c470164c4c033e8c46a5c"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b1a7022f402a61ee368be7fb358ca2b6202b57fe163f95dc5b3260ebe63703e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b1a7022f402a61ee368be7fb358ca2b6202b57fe163f95dc5b3260ebe63703e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1a7022f402a61ee368be7fb358ca2b6202b57fe163f95dc5b3260ebe63703e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca17cb97136bc2a0e95d55afadd01caa9eeb82cd7bf26ed2638fa22c00b07398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4bdf87f812553b7fdc9c7cdadaf5a2796b050c3d84fa5c1cb785ddcd30df33"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
