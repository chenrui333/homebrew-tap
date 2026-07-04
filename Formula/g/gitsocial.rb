class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9d48bd84d08e41c8a81d6b73f32c1fbae46cdcaa4a3ecd6ebc13de6b18711009"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9d45692f0959ee66854502c4701c3a378ffef9bf451c40c345352f4841335ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9d45692f0959ee66854502c4701c3a378ffef9bf451c40c345352f4841335ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9d45692f0959ee66854502c4701c3a378ffef9bf451c40c345352f4841335ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4dc99f0385508fd92d88c15e9f6ba6f0ce777e0ca49c9d7d55384a2e65690b4"
    sha256 cellar: :any,                 x86_64_linux:  "da67f123b1b3aa0a5a7b01b63ddb7da15455b3f98e2000f9a689c7e17a68d88b"
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
