class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1ef135164e1bc9c04fa78f02a898ba0bec63e3fb3aa98f4e7a35dc98cc435b18"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fcb097cd427c2f83055c0398b67823d3b29c230b4e1f1e3ecb501257aca9555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fcb097cd427c2f83055c0398b67823d3b29c230b4e1f1e3ecb501257aca9555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fcb097cd427c2f83055c0398b67823d3b29c230b4e1f1e3ecb501257aca9555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ca174dcf682f3b34e5b8a600fe7cff36c4b8d0a0df8451004f68738a2f73a6b"
    sha256 cellar: :any,                 x86_64_linux:  "e47b5036bcec04560fd8dfcea5a63e803ac85b12a731fc2ec61dd09f8de200e9"
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
