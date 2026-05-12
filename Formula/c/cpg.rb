class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "4087d87ff7f313deb6d4da5e82ee5be063693228cee1dfa7d67b796e6cb0faf0"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
