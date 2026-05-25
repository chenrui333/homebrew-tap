class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "248e65872ef3897ae2277e342576ffa4333c939453205f90241034782c5c5516"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afff53e48bce7af98f810d4889c24c0f9b0bf4aaf8845968e90f06a8da1647d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afff53e48bce7af98f810d4889c24c0f9b0bf4aaf8845968e90f06a8da1647d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afff53e48bce7af98f810d4889c24c0f9b0bf4aaf8845968e90f06a8da1647d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbe1247bc9b1695bb495d562f0711eb58784b72171b44e16e2ff0eb145f177bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ba3bcb396fda6e12b6bcdcc4c199c9a877891957aac31a3c4a7557bfecaeda"
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
