class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e220cda0c52aa00030e5b8105b726b5cba17979120a359d5808619203190cfc3"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5f7c033d020e6f67464b83f946f18bd94790384baf3eca1bc3969c21f5aea25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f7c033d020e6f67464b83f946f18bd94790384baf3eca1bc3969c21f5aea25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f7c033d020e6f67464b83f946f18bd94790384baf3eca1bc3969c21f5aea25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b9914ea3a39c7829187056c6873f0b30b814ee0ec0c1502c9706303b69eab3"
    sha256 cellar: :any,                 x86_64_linux:  "1ab84a696ada13b7228bb89fdfb037d18f44b57043d585399c95d9edf37691d2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
