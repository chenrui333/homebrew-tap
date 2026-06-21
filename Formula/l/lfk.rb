class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.13.tar.gz"
  sha256 "21d531620a61cc2a4bcc93ea72baf6f76a115df60c24d0d5b643eee96d48a464"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab32b0b7ab3ac69c52514f13d8210c641e2c6dc9274e8f35e6f48f3107db6b6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab32b0b7ab3ac69c52514f13d8210c641e2c6dc9274e8f35e6f48f3107db6b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab32b0b7ab3ac69c52514f13d8210c641e2c6dc9274e8f35e6f48f3107db6b6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47e35585c5024afe0258e25ee94ffb3e7e5699087fa232a5ed8ccf1fff3ae966"
    sha256 cellar: :any,                 x86_64_linux:  "3f1d07529824316fda2f53dc2a4e2e483eeff591444da3fe6a2edf45ae3a3c39"
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
