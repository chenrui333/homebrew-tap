class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "f271e8782b95e0050a57ceb0222f30e66550a49cf9b0d7162dd7d4eb7875ded2"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e77d6ebcd98db2e29a1af493f04643a75dd18d13b630643bf1b65e0036bc5fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e77d6ebcd98db2e29a1af493f04643a75dd18d13b630643bf1b65e0036bc5fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e77d6ebcd98db2e29a1af493f04643a75dd18d13b630643bf1b65e0036bc5fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e41f692d929955214e490a4dfc3a46585b7e37259fd751acda8ab5553b49edd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52bbc47c6de92b2efcd3b24e9b0368a3b23b7fdaa4568b817848dd3281a2d1f9"
  end

  depends_on "go" => :build

  def install
    Dir.chdir("library") do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli"
    end

    generate_completions_from_executable(bin/"gitsocial", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
