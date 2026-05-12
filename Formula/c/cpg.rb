class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "86d72e76a193fbf4019d81d231528a4b412ad7b800f0dbda3a640c60cbd68465"
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
