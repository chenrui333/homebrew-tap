class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "9db7355963573092142b121e053005174bc7bb36be965fcfb2d8b6bd6b0817c2"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

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
