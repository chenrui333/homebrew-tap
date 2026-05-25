class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "057c230e399f474cb632a713ce7c158a3b9fb41c5c705afa95ceee0c9647b0e0"
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
