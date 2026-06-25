class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.17.tar.gz"
  sha256 "0ead17736bf2d9cea5c785985735f980004b93878c2ac2c149948a78e93a5ffd"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f7855dd9e100a216bf47f00521d1ce656ef01669c50f69d6f656913df485a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f7855dd9e100a216bf47f00521d1ce656ef01669c50f69d6f656913df485a5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7855dd9e100a216bf47f00521d1ce656ef01669c50f69d6f656913df485a5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6da4e0175adc4f135be8faab9b643755feb38b2a250b32c6b13089521cfb3e"
    sha256 cellar: :any,                 x86_64_linux:  "18aa6621825588524f439e6335707a9ad95ac9f0c3193ac559dc87203b5045c4"
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
