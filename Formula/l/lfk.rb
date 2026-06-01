class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "ad3df25b7e2c2addb063ff19f536ea4167f636aec1637d38a38bdf9f39620bc2"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23ce8e46b2018948b7733b1a40c18f3d855faae504ea44fe960920c0a5b45580"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23ce8e46b2018948b7733b1a40c18f3d855faae504ea44fe960920c0a5b45580"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23ce8e46b2018948b7733b1a40c18f3d855faae504ea44fe960920c0a5b45580"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09ec71ee4fde840149728a6cd7f40a94ac1cb503748a10a1479187c20125a505"
    sha256 cellar: :any,                 x86_64_linux:  "d3c006eab9ef4de24d73c036b33eae19b7e8b07bf32befcfb765f1bd5a14f87c"
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
